import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/work_portfolio_constants.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../core/utils/work_portfolio_upload_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/repository_providers.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/technician_work_portfolio_grid.dart';
import '../../widgets/technician/upload_progress_overlay.dart';
import 'technician_document_viewer_screen.dart';

class TechnicianWorkPortfolioScreen extends ConsumerStatefulWidget {
  const TechnicianWorkPortfolioScreen({super.key});

  @override
  ConsumerState<TechnicianWorkPortfolioScreen> createState() =>
      _TechnicianWorkPortfolioScreenState();
}

class _TechnicianWorkPortfolioScreenState
    extends ConsumerState<TechnicianWorkPortfolioScreen> {
  final List<String> _existingUrls = [];
  final List<File> _newPhotos = [];
  bool _initialized = false;
  bool _saving = false;
  bool _dirty = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;
  String _saveStatus = '';

  int get _totalPhotos => _existingUrls.length + _newPhotos.length;

  bool get _isWithinAllowedRange =>
      _totalPhotos >= WorkPortfolioConstants.minPhotos &&
      _totalPhotos <= WorkPortfolioConstants.maxPhotos;

  bool _canRemovePhoto() =>
      _totalPhotos > WorkPortfolioConstants.minPhotos;

  bool _canEdit(TechnicianApplicationModel profile) =>
      profile.canEditProfile && profile.profileType == 'independiente';

  void _showCannotRemoveMessage() {
    showErrorSnackBar(
      context,
      'Debes mantener al menos ${WorkPortfolioConstants.minPhotos} fotos. '
      'Toca una foto y elige Reemplazar para cambiarla.',
    );
  }

  Future<void> _replaceExistingPhoto(int index) async {
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;

    setState(() => _saving = true);
    try {
      final url = await _uploadPhoto(file);
      if (!mounted) return;
      setState(() {
        _existingUrls[index] = url;
        _dirty = true;
      });
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showExistingPhotoActions(int index, String url) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('Ver foto'),
              onTap: () => Navigator.pop(context, 'view'),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded),
              title: const Text('Reemplazar foto'),
              onTap: () => Navigator.pop(context, 'replace'),
            ),
            if (_canRemovePhoto())
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Eliminar foto'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;

    switch (action) {
      case 'view':
        _openPreview(title: 'Trabajo realizado', url: url);
      case 'replace':
        await _replaceExistingPhoto(index);
      case 'remove':
        if (!_canRemovePhoto()) {
          _showCannotRemoveMessage();
          return;
        }
        setState(() {
          _existingUrls.removeAt(index);
          _dirty = true;
        });
    }
  }

  void _syncFromProfile(TechnicianApplicationModel profile) {
    if (_initialized && _dirty) return;
    _existingUrls
      ..clear()
      ..addAll(
        profile.workPhotos
            .map((photo) => photo.imageUrl.trim())
            .where((url) => url.isNotEmpty),
      );
    _newPhotos.clear();
    _initialized = true;
  }

  Future<void> _addPhotos() async {
    final remaining = WorkPortfolioConstants.maxPhotos - _totalPhotos;
    if (remaining <= 0) {
      showErrorSnackBar(
        context,
        'Máximo ${WorkPortfolioConstants.maxPhotos} fotos en el portafolio',
      );
      return;
    }

    final files = await ImagePickerUtils.pickMultiplePublicCatalogImages(context);
    if (files.isEmpty || !mounted) return;

    final accepted = files.take(remaining).toList();
    if (accepted.length < files.length && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solo se agregaron $remaining foto${remaining == 1 ? '' : 's'} (máximo ${WorkPortfolioConstants.maxPhotos})',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    setState(() {
      _newPhotos.addAll(accepted);
      _dirty = true;
    });
  }

  Future<String> _uploadPhoto(File file) async {
    final uploaded = await ref.read(uploadsRepositoryProvider).uploadTechnicianFile(
          category: UploadCategory.workPhoto,
          file: file,
        );
    return WorkPortfolioUploadUtils.resolveReference(uploaded.file);
  }

  Future<void> _save(TechnicianApplicationModel profile) async {
    if (!_canEdit(profile)) return;

    if (_totalPhotos < WorkPortfolioConstants.minPhotos) {
      showErrorSnackBar(
        context,
        'Necesitas al menos ${WorkPortfolioConstants.minPhotos} fotos de trabajos',
      );
      return;
    }

    if (_totalPhotos > WorkPortfolioConstants.maxPhotos) {
      showErrorSnackBar(
        context,
        'Máximo ${WorkPortfolioConstants.maxPhotos} fotos en el portafolio',
      );
      return;
    }

    setState(() {
      _saving = true;
      _uploadCompleted = 0;
      _uploadTotal = _newPhotos.length;
      _saveStatus =
          _newPhotos.isEmpty ? 'Guardando portafolio...' : 'Subiendo fotos...';
    });

    try {
      final workPhotos = <WorkPhotoInputModel>[
        for (final url in _existingUrls)
          if (WorkPortfolioUploadUtils.normalizeUploadReference(url) case final normalized?)
            WorkPhotoInputModel(imageUrl: normalized),
      ];

      if (_newPhotos.isNotEmpty) {
        final uploadsRepo = ref.read(uploadsRepositoryProvider);
        final uploadedUrls = await MediaUploadUtils.uploadTechnicianReferences(
          repository: uploadsRepo,
          category: UploadCategory.workPhoto,
          files: _newPhotos,
          onProgress: (completed, total) {
            if (!mounted) return;
            setState(() {
              _uploadCompleted = completed;
              _uploadTotal = total;
            });
          },
        );
        workPhotos.addAll(
          uploadedUrls.map((url) => WorkPhotoInputModel(imageUrl: url)),
        );
      }

      if (!mounted) return;
      setState(() => _saveStatus = 'Guardando portafolio...');

      if (workPhotos.length < WorkPortfolioConstants.minPhotos) {
        showErrorSnackBar(
          context,
          'Debes tener al menos ${WorkPortfolioConstants.minPhotos} fotos válidas para guardar',
        );
        return;
      }

      final updated = await ref
          .read(myTechnicianProfileProvider.notifier)
          .updateProfile(UpdateTechnicianProfileRequest(workPhotos: workPhotos));

      if (!mounted) return;
      setState(() {
        _existingUrls
          ..clear()
          ..addAll(
            updated.workPhotos
                .map((photo) => photo.imageUrl.trim())
                .where((url) => url.isNotEmpty),
          );
        _newPhotos.clear();
        _dirty = false;
        _initialized = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Portafolio actualizado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _uploadCompleted = 0;
          _uploadTotal = 0;
          _saveStatus = '';
        });
      }
    }
  }

  void _openPreview({required String title, required String url}) {
    final resolved = MediaUrlUtils.resolve(url);
    if (resolved == null || resolved.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TechnicianDocumentViewerScreen(
          title: title,
          url: resolved,
        ),
      ),
    );
  }

  void _openLocalPreview(File file) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Vista previa'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(file, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myTechnicianProfileProvider);

    return profile.when(
      loading: () => const TechnicianPanelScaffold(
        title: 'Portafolio de trabajos',
        body: LoadingView(message: 'Cargando portafolio...'),
      ),
      error: (error, _) => TechnicianPanelScaffold(
        title: 'Portafolio de trabajos',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(myTechnicianProfileProvider),
        ),
      ),
      data: (data) {
        _syncFromProfile(data);
        final canEdit = _canEdit(data);
        final remaining = WorkPortfolioConstants.minPhotos - _totalPhotos;

        return Stack(
          children: [
            TechnicianPanelScaffold(
          title: 'Portafolio de trabajos',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _saving ? null : () => context.pop(),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              TechnicianPanelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trabajos realizados',
                      style: TechnicianPanelTheme.title,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.profileType == 'empresa'
                          ? 'El portafolio fotográfico aplica para perfiles independientes.'
                          : 'Muestra entre ${WorkPortfolioConstants.minPhotos} y ${WorkPortfolioConstants.maxPhotos} fotos de trabajos reales. Los clientes las verán en tu perfil público.',
                      style: TechnicianPanelTheme.subtitle,
                    ),
                    const SizedBox(height: 10),
                    TechnicianPanelChip(
                      label: '$_totalPhotos / ${WorkPortfolioConstants.maxPhotos} fotos',
                      icon: Icons.photo_library_outlined,
                      tint: TechnicianPanelColors.primarySoft,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (data.profileType != 'independiente')
                TechnicianPanelCard(
                  color: TechnicianPanelColors.primarySoft,
                  child: Text(
                    'Tu perfil es de empresa. Este portafolio no aplica para tu tipo de cuenta.',
                    style: TechnicianPanelTheme.subtitle,
                  ),
                )
              else ...[
                if (canEdit && remaining > 0)
                  TechnicianPanelCard(
                    color: TechnicianPanelColors.primarySoft,
                    child: Text(
                      'Te faltan $remaining foto${remaining == 1 ? '' : 's'} para el mínimo requerido.',
                      style: TechnicianPanelTheme.subtitle,
                    ),
                  ),
                if (canEdit && remaining > 0) const SizedBox(height: 12),
                TechnicianPanelSection(
                  title: 'Galería',
                  subtitle: canEdit
                      ? 'Toca una foto para verla o reemplazarla.'
                      : 'Vista de solo lectura',
                  child: TechnicianWorkPortfolioGrid(
                    existingUrls: _existingUrls,
                    newPhotos: _newPhotos,
                    enabled: canEdit && !_saving,
                    onAdd: _totalPhotos < WorkPortfolioConstants.maxPhotos
                        ? _addPhotos
                        : null,
                    onRemoveExisting: canEdit && _canRemovePhoto()
                        ? (index) => setState(() {
                              _existingUrls.removeAt(index);
                              _dirty = true;
                            })
                        : null,
                    onRemoveNew: canEdit && _canRemovePhoto()
                        ? (index) => setState(() {
                              _newPhotos.removeAt(index);
                              _dirty = true;
                            })
                        : null,
                    onTapExisting: canEdit
                        ? (index, url) => _showExistingPhotoActions(index, url)
                        : (_, url) =>
                            _openPreview(title: 'Trabajo realizado', url: url),
                    onTapNew: (_, file) => _openLocalPreview(file),
                  ),
                ),
                if (canEdit) ...[
                  const SizedBox(height: 20),
                  TechnicianPanelPrimaryButton(
                    label: _saving
                        ? (_uploadTotal > 0
                            ? 'Subiendo $_uploadCompleted/$_uploadTotal...'
                            : 'Guardando...')
                        : 'Guardar portafolio',
                    onPressed: _saving || !_dirty || !_isWithinAllowedRange
                        ? null
                        : () => _save(data),
                  ),
                ],
              ],
            ],
          ),
        ),
            if (_saving)
              UploadProgressOverlay(
                completed: _uploadCompleted,
                total: _uploadTotal,
                statusMessage:
                    _saveStatus == 'Guardando portafolio...' ? _saveStatus : null,
              ),
          ],
        );
      },
    );
  }
}
