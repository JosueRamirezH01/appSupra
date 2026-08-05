import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/featured_projects_constants.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/repository_providers.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_portfolio_utils.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/upload_progress_overlay.dart';

/// CRUD de proyectos destacados (máx. 5) del técnico.
class TechnicianFeaturedProjectsManageScreen extends ConsumerStatefulWidget {
  const TechnicianFeaturedProjectsManageScreen({super.key});

  @override
  ConsumerState<TechnicianFeaturedProjectsManageScreen> createState() =>
      _TechnicianFeaturedProjectsManageScreenState();
}

class _DraftProject {
  _DraftProject({
    this.id,
    required this.location,
    this.description = '',
    List<String>? existingUrls,
    List<File>? newFiles,
  })  : existingUrls = existingUrls ?? [],
        newFiles = newFiles ?? [];

  final int? id;
  String location;
  String description;
  final List<String> existingUrls;
  final List<File> newFiles;

  int get photoCount => existingUrls.length + newFiles.length;
}

class _TechnicianFeaturedProjectsManageScreenState
    extends ConsumerState<TechnicianFeaturedProjectsManageScreen> {
  final List<_DraftProject> _projects = [];
  bool _initialized = false;
  bool _saving = false;
  bool _dirty = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;

  void _syncFromProfile(TechnicianApplicationModel profile) {
    if (_initialized && _dirty) return;
    _projects
      ..clear()
      ..addAll(
        profile.portfolio.map(
          (item) => _DraftProject(
            id: item.id,
            location: item.displayLocation,
            description: item.description?.trim() ?? '',
            existingUrls: item.galleryUrls,
          ),
        ),
      );
    _initialized = true;
  }

  Future<void> _editProject(_DraftProject? existing, {int? index}) async {
    if (existing == null &&
        _projects.length >= FeaturedProjectsConstants.maxProjects) {
      showErrorSnackBar(
        context,
        'Máximo ${FeaturedProjectsConstants.maxProjects} proyectos destacados',
      );
      return;
    }

    final result = await showModalBottomSheet<_DraftProject>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => _ProjectEditorSheet(
        initial: existing,
      ),
    );

    if (result == null || !mounted) return;
    setState(() {
      if (index != null) {
        _projects[index] = result;
      } else {
        _projects.add(result);
      }
      _dirty = true;
    });
  }

  Future<void> _save(TechnicianApplicationModel profile) async {
    for (final project in _projects) {
      if (project.location.trim().length < 2) {
        showErrorSnackBar(context, 'Cada proyecto necesita un lugar');
        return;
      }
      if (project.photoCount < FeaturedProjectsConstants.minImagesPerProject) {
        showErrorSnackBar(
          context,
          'Cada proyecto necesita al menos una foto',
        );
        return;
      }
      if (project.photoCount > FeaturedProjectsConstants.maxImagesPerProject) {
        showErrorSnackBar(
          context,
          'Máximo ${FeaturedProjectsConstants.maxImagesPerProject} fotos por proyecto',
        );
        return;
      }
    }

    setState(() {
      _saving = true;
      _uploadCompleted = 0;
      _uploadTotal = _projects.fold<int>(
        0,
        (sum, project) => sum + project.newFiles.length,
      );
    });

    try {
      final payload = <PortfolioItemInputModel>[];
      final uploadsRepo = ref.read(uploadsRepositoryProvider);

      for (final project in _projects) {
        final urls = <String>[...project.existingUrls];
        if (project.newFiles.isNotEmpty) {
          final uploaded = await MediaUploadUtils.uploadTechnicianReferences(
            repository: uploadsRepo,
            category: UploadCategory.portfolio,
            files: project.newFiles,
            onProgress: (completed, total) {
              if (!mounted) return;
              setState(() {
                _uploadCompleted = completed;
                _uploadTotal = total;
              });
            },
          );
          urls.addAll(uploaded);
        }

        payload.add(
          PortfolioItemInputModel(
            title: project.location.trim(),
            location: project.location.trim(),
            description: project.description.trim().isEmpty
                ? null
                : project.description.trim(),
            images: urls
                .map((url) => PortfolioImageInputModel(imageUrl: url))
                .toList(),
          ),
        );
      }

      await ref.read(myTechnicianProfileProvider.notifier).updateProfile(UpdateTechnicianProfileRequest(portfolio: payload));
      ref.invalidate(technicianDetailProvider(profile.id));

      if (!mounted) return;
      setState(() {
        _dirty = false;
        _initialized = false;
      });
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proyectos destacados guardados')),
      );
      context.pop();
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myTechnicianProfileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: LoadingView(message: 'Cargando...'),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(myTechnicianProfileProvider),
        ),
      ),
      data: (profile) {
        _syncFromProfile(profile);
        final canEdit = profile.canEditProfile;

        return Scaffold(
          backgroundColor: AppBrandColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AppBrandColors.scaffoldBackground,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Proyectos destacados',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            actions: [
              if (canEdit)
                TextButton(
                  onPressed: _saving
                      ? null
                      : () => _editProject(null),
                  child: Text(
                    'Agregar',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                children: [
                  Text(
                    'Hasta ${FeaturedProjectsConstants.maxProjects} proyectos. '
                    'Cada uno: lugar, descripción y hasta '
                    '${FeaturedProjectsConstants.maxImagesPerProject} fotos.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppBrandColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_projects.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE8EAED)),
                      ),
                      child: Text(
                        'Aún no tienes proyectos destacados.',
                        style: GoogleFonts.poppins(
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    )
                  else
                    ...List.generate(_projects.length, (index) {
                      final project = _projects[index];
                      final cover = project.existingUrls.isNotEmpty
                          ? project.existingUrls.first
                          : null;
                      final provider = MediaUrlUtils.networkImage(cover);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: provider == null
                                    ? ColoredBox(
                                        color: AppBrandColors.fieldFill,
                                        child: const Icon(Icons.photo_outlined),
                                      )
                                    : Image(
                                        image: provider,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            title: Text(
                              project.location,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              '${project.photoCount} foto${project.photoCount == 1 ? '' : 's'}',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            trailing: canEdit
                                ? PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        await _editProject(
                                          project,
                                          index: index,
                                        );
                                      } else if (value == 'delete') {
                                        setState(() {
                                          _projects.removeAt(index);
                                          _dirty = true;
                                        });
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Editar'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Eliminar'),
                                      ),
                                    ],
                                  )
                                : null,
                            onTap: canEdit
                                ? () => _editProject(project, index: index)
                                : null,
                          ),
                        ),
                      );
                    }),
                ],
              ),
              if (canEdit)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16 + MediaQuery.paddingOf(context).bottom,
                  child: FilledButton(
                    onPressed: _saving || !_dirty
                        ? null
                        : () => _save(profile),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppBrandColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _saving ? 'Guardando...' : 'Guardar cambios',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              if (_saving)
                UploadProgressOverlay(
                  completed: _uploadCompleted,
                  total: _uploadTotal,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProjectEditorSheet extends StatefulWidget {
  const _ProjectEditorSheet({this.initial});

  final _DraftProject? initial;

  @override
  State<_ProjectEditorSheet> createState() => _ProjectEditorSheetState();
}

class _ProjectEditorSheetState extends State<_ProjectEditorSheet> {
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final List<String> _existingUrls;
  late final List<File> _newFiles;

  int get _photoCount => _existingUrls.length + _newFiles.length;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _locationController = TextEditingController(text: initial?.location ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _existingUrls = [...(initial?.existingUrls ?? const <String>[])];
    _newFiles = [...(initial?.newFiles ?? const <File>[])];
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    if (_photoCount >= FeaturedProjectsConstants.maxImagesPerProject) {
      showErrorSnackBar(
        context,
        'Máximo ${FeaturedProjectsConstants.maxImagesPerProject} fotos',
      );
      return;
    }
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;
    setState(() => _newFiles.add(file));
  }

  void _submit() {
    final location = _locationController.text.trim();
    if (location.length < 2) {
      showErrorSnackBar(context, 'Indica el lugar del proyecto');
      return;
    }
    if (_photoCount < FeaturedProjectsConstants.minImagesPerProject) {
      showErrorSnackBar(context, 'Agrega al menos una foto');
      return;
    }
    Navigator.pop(
      context,
      _DraftProject(
        id: widget.initial?.id,
        location: location,
        description: _descriptionController.text.trim(),
        existingUrls: _existingUrls,
        newFiles: _newFiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + keyboardInset),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.initial == null ? 'Nuevo proyecto' : 'Editar proyecto',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              AuthRoundedField(
                controller: _locationController,
                label: 'Lugar *',
              ),
              const SizedBox(height: 12),
              AuthRoundedField(
                controller: _descriptionController,
                label: 'Descripción',
                maxLines: 4,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Fotos ($_photoCount/${FeaturedProjectsConstants.maxImagesPerProject})',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _addPhoto,
                    icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                    label: const Text('Agregar'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 88,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < _existingUrls.length; i++)
                      _PhotoThumb(
                        provider: MediaUrlUtils.networkImage(_existingUrls[i]),
                        onRemove: () =>
                            setState(() => _existingUrls.removeAt(i)),
                      ),
                    for (var i = 0; i < _newFiles.length; i++)
                      _PhotoThumb(
                        provider: FileImage(_newFiles[i]),
                        onRemove: () => setState(() => _newFiles.removeAt(i)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppBrandColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Listo',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({
    required this.provider,
    required this.onRemove,
  });

  final ImageProvider? provider;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 88,
              height: 88,
              child: provider == null
                  ? const ColoredBox(
                      color: Color(0xFFF3F4F6),
                      child: Icon(Icons.broken_image_outlined),
                    )
                  : Image(image: provider!, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
