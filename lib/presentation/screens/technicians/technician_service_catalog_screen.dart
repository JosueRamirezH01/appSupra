import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/work_portfolio_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/contact_metric_utils.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../core/utils/work_portfolio_upload_utils.dart';
import '../../../data/models/technicians/contact_lead_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../utils/technician_pricing_utils.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/media/authenticated_network_image.dart';
import '../../widgets/technician/technician_work_cases_editor.dart';
import '../../widgets/technician/upload_progress_overlay.dart';

/// Gestión del catálogo de casos de un servicio (máx. 5), estilo carrusel.
class TechnicianServiceCatalogScreen extends ConsumerStatefulWidget {
  const TechnicianServiceCatalogScreen({
    super.key,
    required this.userId,
    required this.subSubCategoryId,
  });

  final int userId;
  final int subSubCategoryId;

  @override
  ConsumerState<TechnicianServiceCatalogScreen> createState() => _TechnicianServiceCatalogScreenState();
}

class _TechnicianServiceCatalogScreenState extends ConsumerState<TechnicianServiceCatalogScreen> {
  final List<WorkCaseDraft> _cases = [];
  bool _initialized = false;
  bool _dirty = false;
  bool _saving = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;
  String _serviceName = 'Portafolio';
  ContactMetricType _contactMetricType = ContactMetricType.none;
  static const double _tileWidth = 148;
  static const double _tileImageHeight = 132;
  static const double _carouselHeight = 228;

  int get _max => WorkPortfolioConstants.maxServiceCatalogCases;
  int get _total => _cases.length;
  bool get _canAdd => _total < _max && !_saving;

  WorkCaseDraft _draftFromPhoto(TechnicianWorkPhotoModel photo) {
    return WorkCaseDraft(
      existingUrl: photo.imageUrl.trim(),
      caption: photo.caption?.trim() ?? '',
      estimatedCostMinText: _formatCost(
        photo.estimatedCostMin ?? photo.estimatedCost,
      ),
      estimatedCostMaxText: _formatCost(
        photo.estimatedCostMax ?? photo.estimatedCostMin ?? photo.estimatedCost,
      ),
      estimatePricingType: ProfilePriceDisplay.fromJson(
        photo.estimatePricingType,
      ),
    );
  }

  String _formatCost(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final serviceAsync = ref.watch(myTechnicianServiceProvider(widget.subSubCategoryId),);

    serviceAsync.whenData((service) {
      if (_initialized) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _initialized) return;
        setState(() {
          _serviceName = service.name;
          _contactMetricType =
              ContactMetricType.fromJson(service.contactMetricType);
          _cases
            ..clear()
            ..addAll(
              service.workPhotos
                  .where((photo) => photo.imageUrl.trim().isNotEmpty)
                  .map(
                    (photo) => _draftFromPhoto(photo),
                  ),
            );
          _initialized = true;
          _dirty = false;
        });
      });
    });

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppBrandColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _onBack(context),
        ),
        title: Text(
          'Portafolio',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '$_total/$_max',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
      body: serviceAsync.when(
        loading: () => const LoadingView(message: 'Cargando catálogo...'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(myTechnicianServiceProvider(widget.subSubCategoryId)),
        ),
        data: (_) => Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _serviceName,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppBrandColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hasta $_max casos. Cada uno con foto, descripción y estimación (desde / hasta).',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.4,
                          color: AppBrandColors.textMuted,
                        ),
                      ),

                      if (_total > _max) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Tienes más de $_max casos. Quita algunos para poder guardar.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (_total == 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      'Empieza con tu mejor trabajo. Los clientes lo verán al tocar el servicio.',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        height: 1.4,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                  ),
                SizedBox(
                  height: _carouselHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _total + (_canAdd ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index >= _total) {
                        return _AddCatalogTile(
                          width: _tileWidth,
                          imageHeight: _tileImageHeight,
                          remaining: _max - _total,
                          onTap: _addCase,
                        );
                      }
                      return _CatalogCaseTile(
                        draft: _cases[index],
                        contactMetricType: _contactMetricType,
                        width: _tileWidth,
                        imageHeight: _tileImageHeight,
                        enabled: !_saving,
                        onTap: () => _showCaseActions(index),
                      );
                    },
                  ),
                ),
                const Spacer(),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: FilledButton(
                      onPressed: !_dirty || _saving || _total > _max
                          ? null
                          : _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppBrandColors.primaryGreen,
                        disabledBackgroundColor: const Color(0xFFE5E7EB),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _saving ? 'Guardando...' : 'Guardar catálogo',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: !_dirty || _saving || _total > _max
                              ? AppBrandColors.textMuted
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_saving && _uploadTotal > 0)
              UploadProgressOverlay(
                completed: _uploadCompleted,
                total: _uploadTotal,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onBack(BuildContext context) async {
    if (!_dirty) {
      context.pop();
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Cambios sin guardar',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Si sales, se perderán los cambios del catálogo.',
          style: GoogleFonts.poppins(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Seguir editando'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (discard == true && context.mounted) context.pop();
  }

  Future<void> _addCase() async {
    if (!_canAdd) return;
    HapticFeedback.selectionClick();
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;

    final drafted = await showWorkCaseEditorSheet(
      context: context,
      draft: WorkCaseDraft(newFile: file),
      contactMetricType: _contactMetricType,
    );
    if (drafted == null || !mounted) return;
    setState(() {
      _cases.add(drafted);
      _dirty = true;
    });
  }

  Future<void> _showCaseActions(int index) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(
                  'Editar caso',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(ctx, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: Text(
                  'Cambiar foto',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(ctx, 'replace'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
                title: Text(
                  'Quitar caso',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted || action == null) return;
    if (action == 'edit') await _editCase(index);
    if (action == 'replace') await _replaceImage(index);
    if (action == 'remove') {
      setState(() {
        _cases.removeAt(index);
        _dirty = true;
      });
    }
  }

  Future<void> _editCase(int index) async {
    final current = _cases[index];
    final updated = await showWorkCaseEditorSheet(
      context: context,
      draft: WorkCaseDraft(
        existingUrl: current.existingUrl,
        newFile: current.newFile,
        caption: current.caption,
        estimatedCostMinText: current.estimatedCostMinText,
        estimatedCostMaxText: current.estimatedCostMaxText,
        estimatePricingType: current.estimatePricingType,
      ),
      contactMetricType: _contactMetricType,
    );
    if (updated == null || !mounted) return;
    setState(() {
      _cases[index] = updated;
      _dirty = true;
    });
  }

  Future<void> _replaceImage(int index) async {
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;
    final current = _cases[index];
    setState(() {
      _cases[index] = WorkCaseDraft(
        existingUrl: null,
        newFile: file,
        caption: current.caption,
        estimatedCostMinText: current.estimatedCostMinText,
        estimatedCostMaxText: current.estimatedCostMaxText,
        estimatePricingType: current.estimatePricingType,
      );
      _dirty = true;
    });
  }

  Future<void> _save() async {
    if (_saving || !_dirty) return;
    if (_total > _max) {
      showErrorSnackBar(
        context,
        'Máximo $_max casos por servicio',
      );
      return;
    }

    for (var i = 0; i < _cases.length; i++) {
      final draft = _cases[i];
      if (draft.caption.trim().length < WorkPortfolioConstants.minCaptionLength) {
        showErrorSnackBar(context, 'Completa la descripción del caso #${i + 1}');
        return;
      }
      final rangeError = validateWorkCaseEstimateInputs(
        minText: draft.estimatedCostMinText,
        maxText: draft.estimatedCostMaxText,
      );
      if (rangeError != null) {
        showErrorSnackBar(
          context,
          '${rangeError.replaceFirst(RegExp(r'\.$'), '')} (caso #${i + 1})',
        );
        return;
      }
    }

    setState(() {
      _saving = true;
      _uploadCompleted = 0;
      _uploadTotal = 0;
    });

    try {
      final newFiles =
          _cases.where((item) => item.newFile != null).map((item) => item.newFile!).toList();
      final uploadedByFile = <File, String>{};

      if (newFiles.isNotEmpty) {
        setState(() => _uploadTotal = newFiles.length);
        final uploadedUrls = await MediaUploadUtils.uploadTechnicianReferences(
          repository: ref.read(uploadsRepositoryProvider),
          category: UploadCategory.workPhoto,
          files: newFiles,
          onProgress: (completed, total) {
            if (!mounted) return;
            setState(() {
              _uploadCompleted = completed;
              _uploadTotal = total;
            });
          },
        );
        for (var i = 0; i < newFiles.length; i++) {
          uploadedByFile[newFiles[i]] = uploadedUrls[i];
        }
      }

      final workPhotos = <WorkPhotoInputModel>[];
      for (final draft in _cases) {
        final range = resolveWorkCaseEstimateRange(
          minText: draft.estimatedCostMinText,
          maxText: draft.estimatedCostMaxText,
        )!;
        String? imageUrl;
        if (draft.newFile != null) {
          imageUrl = uploadedByFile[draft.newFile!];
        } else if (draft.existingUrl != null) {
          imageUrl = WorkPortfolioUploadUtils.normalizeUploadReference(
            draft.existingUrl!,
          );
        }
        if (imageUrl == null || imageUrl.isEmpty) continue;
        workPhotos.add(
          WorkPhotoInputModel(
            imageUrl: imageUrl,
            caption: draft.caption.trim(),
            estimatedCost: range.min,
            estimatedCostMin: range.min,
            estimatedCostMax: range.max,
            estimatePricingType: draft.estimatePricingType.apiValue,
          ),
        );
      }

      final updated = await ref
          .read(myTechnicianServiceProvider(widget.subSubCategoryId).notifier)
          .updateService(
            UpdateTechnicianServiceRequest(workPhotos: workPhotos),
          );

      ref.invalidate(technicianDetailProvider(widget.userId));

      if (!mounted) return;
      setState(() {
        _cases
          ..clear()
          ..addAll(
            updated.workPhotos
                .where((photo) => photo.imageUrl.trim().isNotEmpty)
                .map((photo) => _draftFromPhoto(photo)),
          );
        _dirty = false;
      });

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Catálogo guardado',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _uploadCompleted = 0;
          _uploadTotal = 0;
        });
      }
    }
  }
}

class _CatalogCaseTile extends StatelessWidget {
  const _CatalogCaseTile({
    required this.draft,
    required this.contactMetricType,
    required this.width,
    required this.imageHeight,
    required this.enabled,
    required this.onTap,
  });

  final WorkCaseDraft draft;
  final ContactMetricType contactMetricType;
  final double width;
  final double imageHeight;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final modeLabel = ContactMetricUtils.workCaseEstimateModeLabel(
      estimatePricingType: draft.estimatePricingType.apiValue,
      contactMetricType: contactMetricType,
    );

    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                height: imageHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (draft.newFile != null)
                        Image.file(draft.newFile!, fit: BoxFit.cover)
                      else if (draft.existingUrl != null &&
                          draft.existingUrl!.trim().isNotEmpty)
                        AuthenticatedNetworkImage(
                          url: draft.existingUrl!.trim(),
                          fit: BoxFit.cover,
                        )
                      else
                        const ColoredBox(color: Color(0xFFE8EAED)),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00000000), Color(0x66000000)],
                            stops: [0.5, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                draft.caption.trim().isEmpty
                    ? 'Sin descripción'
                    : draft.caption.trim(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: AppBrandColors.textDark,
                ),
              ),
              if (draft.estimatedRangeLabel.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  modeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                Text(
                  draft.estimatedRangeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.primaryGreen,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCatalogTile extends StatelessWidget {
  const _AddCatalogTile({
    required this.width,
    required this.imageHeight,
    required this.remaining,
    required this.onTap,
  });

  final double width;
  final double imageHeight;
  final int remaining;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                height: imageHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppBrandColors.primaryGreen.withValues(alpha: 0.35),
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppBrandColors.primaryGreen.withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppBrandColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Agregar\ncaso',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppBrandColors.primaryGreen,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$remaining disponibles',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppBrandColors.primaryGreen.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
