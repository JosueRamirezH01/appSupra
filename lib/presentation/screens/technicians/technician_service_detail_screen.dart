import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/work_portfolio_constants.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../core/utils/work_portfolio_upload_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../models/client_technician_profile_ui_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_display_name.dart';
import '../../utils/technician_pricing_utils.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/technician_contact_bottom_bar.dart';
import '../../widgets/technician/technician_work_cases_carousel.dart';
import '../../widgets/technician/technician_work_cases_editor.dart';
import '../../widgets/technician/upload_progress_overlay.dart';

/// Detalle/edición del portafolio de un servicio del técnico.
///
/// Solo lectura para clientes; editable para el propio técnico.
class TechnicianServiceDetailScreen extends ConsumerWidget {
  const TechnicianServiceDetailScreen({
    super.key,
    required this.userId,
    required this.subSubCategoryId,
  });

  final int userId;
  final int subSubCategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authNotifierProvider).valueOrNull;
    final isOwner = authUser?.id == userId;

    if (isOwner) {
      return _OwnerServiceDetailView(
        userId: userId,
        subSubCategoryId: subSubCategoryId,
      );
    }

    final serviceAsync = ref.watch(
      publicTechnicianServiceProvider(userId, subSubCategoryId),
    );
    final technicianAsync = ref.watch(technicianDetailProvider(userId));

    return serviceAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: _buildPlainAppBar(context, title: 'Servicio'),
        body: const LoadingView(message: 'Cargando servicio...'),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: _buildPlainAppBar(context, title: 'Servicio'),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(
            publicTechnicianServiceProvider(userId, subSubCategoryId),
          ),
        ),
      ),
      data: (service) {
        final technician = technicianAsync.valueOrNull;
        return _ReadOnlyServiceDetailView(
          technicianUserId: userId,
          technicianName: technician?.publicDisplayName ?? 'Técnico',
          technicianPhone: technician?.phone,
          profileType: technician?.profileType ?? 'independiente',
          service: service,
        );
      },
    );
  }
}

AppBar _buildPlainAppBar(BuildContext context, {required String title}) {
  return AppBar(
    backgroundColor: AppBrandColors.scaffoldBackground,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: AppBrandColors.textDark,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => context.pop(),
    ),
    title: Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppBrandColors.textDark,
      ),
    ),
  );
}

class _ReadOnlyServiceDetailView extends StatelessWidget {
  const _ReadOnlyServiceDetailView({
    required this.technicianUserId,
    required this.technicianName,
    required this.technicianPhone,
    required this.profileType,
    required this.service,
    this.isPreview = false,
  });

  final int technicianUserId;
  final String technicianName;
  final String? technicianPhone;
  final String profileType;
  final TechnicianSubSubCategoryModel service;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final photos = service.workPhotos;
    final description = service.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final theme = ClientTechnicianProfileTheme.fromProfileType(profileType);
    final priceLabels = servicePricingChipLabels(service);
    final metaParts = <String>[
      if (service.subcategoryName.isNotEmpty) service.subcategoryName,
      if (service.experienceYears != null)
        '${service.experienceYears} año${service.experienceYears == 1 ? '' : 's'} de experiencia',
    ];

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppBrandColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          isPreview ? 'Vista previa' : '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
          ),
        ),
      ),
      body: Column(
        children: [
          if (isPreview)
            Material(
              color: const Color(0xFFEFF6FF),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Color(0xFF1D4ED8),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Así lo ve el cliente. Los cambios sin guardar también aparecen aquí.',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          height: 1.35,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Text(
                  service.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
                if (metaParts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    metaParts.join(' · '),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.35,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ],
                if (priceLabels.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  for (var i = 0; i < priceLabels.length; i++) ...[
                    if (i > 0) const SizedBox(height: 6),
                    Text(
                      priceLabels[i],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: AppBrandColors.primaryGreen,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'Precios referenciales. La cotización final puede variar.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.35,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                _SectionTitle(
                  title: 'Catalogo',
                  trailing: photos.isEmpty
                      ? null
                      : '${photos.length} caso${photos.length == 1 ? '' : 's'}',
                ),
                const SizedBox(height: 12),
                if (photos.isEmpty)
                  Text(
                    'Aún no hay trabajos publicados en este servicio.',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      height: 1.4,
                      color: AppBrandColors.textMuted,
                    ),
                  )
                else
                  TechnicianWorkCasesCarousel(
                    photos: photos,
                    onTap: (photo, _) => showWorkCaseDetailSheet(
                      context: context,
                      photo: photo,
                    ),
                  ),
                if (hasDescription) ...[
                  const SizedBox(height: 28),
                  const _SectionTitle(
                    title: 'Qué incluye',
                    trailing: null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      height: 1.55,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isPreview)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppBrandColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Cerrar vista previa',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            )
          else
            TechnicianContactBottomBar(
              technicianUserId: technicianUserId,
              technicianName: technicianName,
              phone: technicianPhone,
              theme: theme,
              subcategoryId: service.subcategoryId,
              availableServices: [service],
              contextSubSubCategoryId: service.id,
              lockToService: true,
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppBrandColors.textDark,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppBrandColors.textMuted,
            ),
          ),
      ],
    );
  }
}

class _OwnerServiceDetailView extends ConsumerStatefulWidget {
  const _OwnerServiceDetailView({
    required this.userId,
    required this.subSubCategoryId,
  });

  final int userId;
  final int subSubCategoryId;

  @override
  ConsumerState<_OwnerServiceDetailView> createState() => _OwnerServiceDetailViewState();
}

class _OwnerServiceDetailViewState extends ConsumerState<_OwnerServiceDetailView> {
  final _descriptionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _laborPriceMinController = TextEditingController();
  final _laborPriceMaxController = TextEditingController();
  final _turnkeyPriceMinController = TextEditingController();
  final _turnkeyPriceMaxController = TextEditingController();
  ProfilePriceDisplay _profilePriceDisplay = ProfilePriceDisplay.labor;
  final List<WorkCaseDraft> _cases = [];

  bool _initialized = false;
  bool _dirty = false;
  bool _saving = false;
  bool _syncingFields = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;

  int get _totalPhotos => _cases.length;

  static String _formatCostText(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_onFieldChanged);
    _experienceController.addListener(_onFieldChanged);
    _laborPriceMinController.addListener(_onFieldChanged);
    _laborPriceMaxController.addListener(_onFieldChanged);
    _turnkeyPriceMinController.addListener(_onFieldChanged);
    _turnkeyPriceMaxController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _descriptionController
      ..removeListener(_onFieldChanged)
      ..dispose();
    _experienceController
      ..removeListener(_onFieldChanged)
      ..dispose();
    _laborPriceMinController
      ..removeListener(_onFieldChanged)
      ..dispose();
    _laborPriceMaxController
      ..removeListener(_onFieldChanged)
      ..dispose();
    _turnkeyPriceMinController
      ..removeListener(_onFieldChanged)
      ..dispose();
    _turnkeyPriceMaxController
      ..removeListener(_onFieldChanged)
      ..dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (_syncingFields || !_initialized || _dirty) return;
    setState(() => _dirty = true);
  }

  void _syncFromService(TechnicianSubSubCategoryModel service) {
    if (_initialized && _dirty) return;
    _syncingFields = true;
    _descriptionController.text = service.description ?? '';
    _experienceController.text = service.experienceYears?.toString() ?? '';
    _laborPriceMinController.text =
        service.effectiveLaborMin?.toString() ?? '';
    _laborPriceMaxController.text =
        service.effectiveLaborMax?.toString() ?? '';
    _turnkeyPriceMinController.text =
        service.turnkeyPriceMin?.toString() ?? '';
    _turnkeyPriceMaxController.text =
        service.turnkeyPriceMax?.toString() ?? '';
    _profilePriceDisplay = service.resolvedProfilePriceDisplay;
    _syncingFields = false;
    _cases
      ..clear()
      ..addAll(
        service.workPhotos
            .where((photo) => photo.imageUrl.trim().isNotEmpty)
            .map(
              (photo) => WorkCaseDraft(
                existingUrl: photo.imageUrl.trim(),
                caption: photo.caption?.trim() ?? '',
                estimatedCostText: _formatCostText(photo.estimatedCost),
              ),
            ),
      );
    _initialized = true;
  }

  Future<bool> _confirmDiscardIfNeeded() async {
    if (!_dirty || _saving) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Salir sin guardar?',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Tienes cambios sin guardar en este servicio.',
          style: GoogleFonts.poppins(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626).withValues(alpha: 0.8),
            ),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Seguir editando'),
          ),
        ],
      ),
    );
    return discard == true;
  }

  Future<void> _addPhotos() async {
    final remaining = WorkPortfolioConstants.maxPhotos - _totalPhotos;
    if (remaining <= 0) {
      showErrorSnackBar(
        context,
        'Máximo ${WorkPortfolioConstants.maxPhotos} trabajos por servicio',
      );
      return;
    }

    final files = await ImagePickerUtils.pickMultiplePublicCatalogImages(
      context,
    );
    if (files.isEmpty || !mounted) return;

    final accepted = files.take(remaining).toList();
    if (accepted.length < files.length && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solo se agregaron $remaining caso${remaining == 1 ? '' : 's'} '
            '(máximo ${WorkPortfolioConstants.maxPhotos})',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    for (final file in accepted) {
      if (!mounted) return;
      final drafted = await showWorkCaseEditorSheet(
        context: context,
        draft: WorkCaseDraft(newFile: file),
      );
      if (drafted == null || !mounted) continue;
      setState(() {
        _cases.add(drafted);
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
        estimatedCostText: current.estimatedCostText,
      ),
    );
    if (updated == null || !mounted) return;
    setState(() {
      _cases[index] = updated;
      _dirty = true;
    });
  }

  Future<void> _replaceCaseImage(int index) async {
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;

    final current = _cases[index];
    setState(() {
      _cases[index] = WorkCaseDraft(
        existingUrl: null,
        newFile: file,
        caption: current.caption,
        estimatedCostText: current.estimatedCostText,
      );
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
      builder: (context) => SafeArea(
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
                  'Editar descripción y estimado',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(context, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz_rounded),
                title: Text(
                  'Cambiar foto',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(context, 'replace'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFDC2626),
                ),
                title: Text(
                  'Eliminar caso',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted || action == null) return;

    switch (action) {
      case 'edit':
        await _editCase(index);
      case 'replace':
        await _replaceCaseImage(index);
      case 'remove':
        setState(() {
          _cases.removeAt(index);
          _dirty = true;
        });
    }
  }

  int? _parseExperienceYears() {
    final raw = _experienceController.text.trim();
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  Future<void> _save(TechnicianSubSubCategoryModel service) async {
    final experienceYears = _parseExperienceYears();
    if (_experienceController.text.trim().isNotEmpty &&
        (experienceYears == null ||
            experienceYears < 0 ||
            experienceYears > 60)) {
      showErrorSnackBar(
        context,
        'Los años de experiencia deben estar entre 0 y 60',
      );
      return;
    }

    final mode = service.resolvedPricingMode;
    double? laborMin;
    double? laborMax;
    double? turnkeyMin;
    double? turnkeyMax;

    if (mode.allowsLabor) {
      final laborError = validatePriceRangeInputs(
        minText: _laborPriceMinController.text,
        maxText: _laborPriceMaxController.text,
        required: true,
        emptyMessage: 'El precio de mano de obra es obligatorio',
        partialMessage: 'Ingresa mínimo y máximo de mano de obra',
      );
      if (laborError != null) {
        showErrorSnackBar(context, laborError);
        return;
      }
      final laborRange = parsePriceRangeInputs(
        minText: _laborPriceMinController.text,
        maxText: _laborPriceMaxController.text,
      );
      laborMin = laborRange.priceMin;
      laborMax = laborRange.priceMax;
    }

    if (mode.allowsTurnkey) {
      final turnkeyError = validatePriceRangeInputs(
        minText: _turnkeyPriceMinController.text,
        maxText: _turnkeyPriceMaxController.text,
        required: true,
        emptyMessage: 'El precio todo incluido es obligatorio',
        partialMessage: 'Ingresa mínimo y máximo de todo incluido',
      );
      if (turnkeyError != null) {
        showErrorSnackBar(context, turnkeyError);
        return;
      }
      final turnkeyRange = parsePriceRangeInputs(
        minText: _turnkeyPriceMinController.text,
        maxText: _turnkeyPriceMaxController.text,
      );
      turnkeyMin = turnkeyRange.priceMin;
      turnkeyMax = turnkeyRange.priceMax;
    }

    for (var i = 0; i < _cases.length; i++) {
      final draft = _cases[i];
      final caption = draft.caption.trim();
      final cost = double.tryParse(
        draft.estimatedCostText.trim().replaceAll(',', '.'),
      );
      if (caption.length < WorkPortfolioConstants.minCaptionLength) {
        showErrorSnackBar(
          context,
          'Completa la descripción del trabajo #${i + 1}',
        );
        return;
      }
      if (cost == null || cost <= 0) {
        showErrorSnackBar(
          context,
          'Completa la estimación del trabajo #${i + 1}',
        );
        return;
      }
    }

    final newFiles = _cases.where((item) => item.newFile != null).map((item) => item.newFile!).toList();

    setState(() {
      _saving = true;
      _uploadCompleted = 0;
      _uploadTotal = newFiles.length;
    });

    try {
      final uploadedByFile = <File, String>{};
      if (newFiles.isNotEmpty) {
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
        final cost = double.parse(
          draft.estimatedCostText.trim().replaceAll(',', '.'),
        );
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
            estimatedCost: cost,
          ),
        );
      }

      final description = _descriptionController.text.trim();
      final updated = await ref.read(myTechnicianServiceProvider(widget.subSubCategoryId).notifier).updateService(
            UpdateTechnicianServiceRequest(
              description: description.isEmpty ? null : description,
              experienceYears: experienceYears,
              priceMin: laborMin,
              priceMax: laborMax,
              laborPriceMin: laborMin,
              laborPriceMax: laborMax,
              turnkeyPriceMin: mode.allowsTurnkey ? turnkeyMin : null,
              turnkeyPriceMax: mode.allowsTurnkey ? turnkeyMax : null,
              profilePriceDisplay: mode == ServicePricingMode.both ? _profilePriceDisplay.apiValue : null,
              workPhotos: workPhotos,
            ),
          );

      ref.invalidate(technicianDetailProvider(widget.userId));

      if (!mounted) return;
      setState(() {
        _cases
          ..clear()
          ..addAll(
            updated.workPhotos
                .where((photo) => photo.imageUrl.trim().isNotEmpty)
                .map(
                  (photo) => WorkCaseDraft(
                    existingUrl: photo.imageUrl.trim(),
                    caption: photo.caption?.trim() ?? '',
                    estimatedCostText: _formatCostText(photo.estimatedCost),
                  ),
                ),
          );
        _dirty = false;
        _initialized = true;
      });

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Servicio actualizado',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppBrandColors.primaryGreen,
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
        });
      }
    }
  }

  void _openClientPreview(TechnicianSubSubCategoryModel service) {
    final application = ref.read(myTechnicianApplicationProvider).valueOrNull;
    final previewService = _buildPreviewService(service);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ReadOnlyServiceDetailView(
          technicianUserId: widget.userId,
          technicianName: application?.publicDisplayName ?? 'Técnico',
          technicianPhone: application?.phone,
          profileType: application?.profileType ?? 'independiente',
          service: previewService,
          isPreview: true,
        ),
      ),
    );
  }

  TechnicianSubSubCategoryModel _buildPreviewService(TechnicianSubSubCategoryModel base) {
    final description = _descriptionController.text.trim();
    final experienceYears = _parseExperienceYears();
    final mode = base.resolvedPricingMode;

    double? laborMin;
    double? laborMax;
    double? turnkeyMin;
    double? turnkeyMax;

    if (mode.allowsLabor) {
      final labor = parsePriceRangeInputs(
        minText: _laborPriceMinController.text,
        maxText: _laborPriceMaxController.text,
      );
      laborMin = labor.priceMin;
      laborMax = labor.priceMax;
    }
    if (mode.allowsTurnkey) {
      final turnkey = parsePriceRangeInputs(
        minText: _turnkeyPriceMinController.text,
        maxText: _turnkeyPriceMaxController.text,
      );
      turnkeyMin = turnkey.priceMin;
      turnkeyMax = turnkey.priceMax;
    }

    final workPhotos = <TechnicianWorkPhotoModel>[];
    for (var i = 0; i < _cases.length; i++) {
      final draft = _cases[i];
      final cost = double.tryParse(
        draft.estimatedCostText.trim().replaceAll(',', '.'),
      );
      final imageUrl = draft.newFile != null
          ? '$kWorkCaseLocalFilePrefix${draft.newFile!.path}'
          : draft.existingUrl?.trim();
      if (imageUrl == null || imageUrl.isEmpty) continue;
      workPhotos.add(
        TechnicianWorkPhotoModel(
          id: -(i + 1),
          imageUrl: imageUrl,
          caption: draft.caption.trim().isEmpty ? null : draft.caption.trim(),
          estimatedCost: cost != null && cost > 0 ? cost : null,
          sortOrder: i,
        ),
      );
    }

    return base.copyWith(
      description: description.isEmpty ? null : description,
      experienceYears: experienceYears,
      priceMin: laborMin,
      priceMax: laborMax,
      laborPriceMin: laborMin,
      laborPriceMax: laborMax,
      turnkeyPriceMin: turnkeyMin,
      turnkeyPriceMax: turnkeyMax,
      profilePriceDisplay: mode == ServicePricingMode.both
          ? _profilePriceDisplay.apiValue
          : base.profilePriceDisplay,
      workPhotos: workPhotos,
      hasPortfolio: workPhotos.isNotEmpty,
      previewImageUrl:
          workPhotos.isNotEmpty ? workPhotos.first.imageUrl : base.previewImageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceAsync = ref.watch(myTechnicianServiceProvider(widget.subSubCategoryId));

    return serviceAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: _buildPlainAppBar(context, title: 'Servicio'),
        body: const LoadingView(message: 'Cargando servicio...'),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: _buildPlainAppBar(context, title: 'Servicio'),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(
            myTechnicianServiceProvider(widget.subSubCategoryId),
          ),
        ),
      ),
      data: (service) {
        _syncFromService(service);
        final bottomInset = MediaQuery.paddingOf(context).bottom;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: PopScope(
            canPop: !_dirty || _saving,
            onPopInvokedWithResult: (didPop, _) async {
              if (didPop) return;
              final shouldLeave = await _confirmDiscardIfNeeded();
              if (shouldLeave && context.mounted) context.pop();
            },
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: AppBrandColors.scaffoldBackground,
                  appBar: AppBar(
                    backgroundColor: AppBrandColors.scaffoldBackground,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      tooltip: 'Volver',
                      onPressed: () async {
                        final shouldLeave = await _confirmDiscardIfNeeded();
                        if (shouldLeave && context.mounted) context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    actions: [
                      Row(
                        children: [
                          Text('Ver como cliente', style: GoogleFonts.poppins(fontSize: 14, color: AppBrandColors.primaryGreen)),
                          IconButton(
                            tooltip: 'Ver como cliente',
                            onPressed: _saving
                                ? null
                                : () => _openClientPreview(service),
                            icon: const Icon(Icons.visibility_outlined, color: AppBrandColors.primaryGreen),
                          ),
                        ],
                      ),
                      if (_dirty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: const Color(0xFFFDBA74),
                                ),
                              ),
                              child: Text(
                                'Sin guardar',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB45309),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(16, 4, 16, _dirty ? 24 : 36),
                          children: [
                            Text(
                              service.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                letterSpacing: -0.3,
                                color: AppBrandColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Completa la información como la verá el cliente: '
                              'oferta, trabajos y qué incluye.',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                height: 1.45,
                                color: AppBrandColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _EditorSection(
                              title: 'Experiencia',
                              helper: 'Opcional · entre 0 y 60 años',
                              child: AuthRoundedField(
                                controller: _experienceController,
                                label: 'Años en este servicio',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(height: 14),
                            if (service.resolvedPricingMode.allowsLabor) ...[
                              _EditorSection(
                                title: 'Precio de mano de obra',
                                helper:
                                    'Solo tu trabajo · rango referencial en soles. '
                                    'No es cotización final.',
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AuthRoundedField(
                                        controller: _laborPriceMinController,
                                        label: 'Desde (S/)',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AuthRoundedField(
                                        controller: _laborPriceMaxController,
                                        label: 'Hasta (S/)',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            if (service.resolvedPricingMode.allowsTurnkey) ...[
                              _EditorSection(
                                title: 'Precio todo incluido',
                                helper:
                                    'Incluye materiales y mano de obra · '
                                    'rango referencial en soles.',
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AuthRoundedField(
                                        controller: _turnkeyPriceMinController,
                                        label: 'Desde (S/)',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AuthRoundedField(
                                        controller: _turnkeyPriceMaxController,
                                        label: 'Hasta (S/)',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            if (service.resolvedPricingMode ==
                                ServicePricingMode.both) ...[
                              _EditorSection(
                                title: 'Precio en tu tarjeta del perfil',
                                helper:
                                    'Elige el precio que verán en el carrusel. '
                                    'Al abrir el servicio verán ambos.',
                                child: _ProfilePriceDisplayPicker(
                                  value: _profilePriceDisplay,
                                  enabled: !_saving,
                                  onChanged: (value) {
                                    setState(() {
                                      _profilePriceDisplay = value;
                                      _dirty = true;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            _EditorSection(
                              title: 'Catalogos',
                              helper:
                                  'Hasta ${WorkPortfolioConstants.maxPhotos} casos. '
                                  'Cada uno con foto, descripción y estimación referencial.',
                              trailing: Text(
                                '$_totalPhotos/${WorkPortfolioConstants.maxPhotos}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppBrandColors.textMuted,
                                ),
                              ),
                              child: _totalPhotos == 0
                                  ? _AddPhotosEmptyState(
                                      onAdd: _saving ? null : _addPhotos,
                                    )
                                  : TechnicianWorkCasesEditor(
                                      cases: _cases,
                                      enabled: !_saving,
                                      onAdd: _totalPhotos <
                                              WorkPortfolioConstants.maxPhotos
                                          ? _addPhotos
                                          : null,
                                      onRemove: (index) => setState(() {
                                        _cases.removeAt(index);
                                        _dirty = true;
                                      }),
                                      onEdit: _showCaseActions,
                                    ),
                            ),
                            const SizedBox(height: 14),
                            _EditorSection(
                              title: 'Qué incluye',
                              helper:
                                  'Explica qué incluye, materiales o cómo trabajas.',
                              child: AuthRoundedField(
                                controller: _descriptionController,
                                label: 'Describe este servicio',
                                minLines: 4,
                                maxLines: 8,
                                maxLength: 1000,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_dirty)
                        _StickySaveBar(
                          saving: _saving,
                          uploadCompleted: _uploadCompleted,
                          uploadTotal: _uploadTotal,
                          bottomInset: bottomInset,
                          onSave: () => _save(service),
                        ),
                    ],
                  ),
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
      },
    );
  }
}

class _ProfilePriceDisplayPicker extends StatelessWidget {
  const _ProfilePriceDisplayPicker({
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final ProfilePriceDisplay value;
  final ValueChanged<ProfilePriceDisplay> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ProfilePriceOption(
            label: 'Mano de obra',
            selected: value == ProfilePriceDisplay.labor,
            enabled: enabled,
            onTap: () => onChanged(ProfilePriceDisplay.labor),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ProfilePriceOption(
            label: 'Todo incluido',
            selected: value == ProfilePriceDisplay.turnkey,
            enabled: enabled,
            onTap: () => onChanged(ProfilePriceDisplay.turnkey),
          ),
        ),
      ],
    );
  }
}

class _ProfilePriceOption extends StatelessWidget {
  const _ProfilePriceOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppBrandColors.primaryGreen
        : AppBrandColors.textMuted;
    final background = selected
        ? AppBrandColors.primaryGreen.withValues(alpha: 0.08)
        : const Color(0xFFF7F8FA);
    final border = selected
        ? AppBrandColors.primaryGreen.withValues(alpha: 0.45)
        : const Color(0xFFE8EAED);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 18,
                color: foreground,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: foreground,
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

class _EditorSection extends StatelessWidget {
  const _EditorSection({
    required this.title,
    required this.child,
    this.helper,
    this.trailing,
  });

  final String title;
  final String? helper;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EAED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          if (helper != null) ...[
            const SizedBox(height: 4),
            Text(
              helper!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                height: 1.35,
                color: AppBrandColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StickySaveBar extends StatelessWidget {
  const _StickySaveBar({
    required this.saving,
    required this.uploadCompleted,
    required this.uploadTotal,
    required this.bottomInset,
    required this.onSave,
  });

  final bool saving;
  final int uploadCompleted;
  final int uploadTotal;
  final double bottomInset;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final label = saving
        ? (uploadTotal > 0
              ? 'Subiendo $uploadCompleted/$uploadTotal...'
              : 'Guardando...')
        : 'Guardar cambios';

    return Material(
      elevation: 12,
      shadowColor: const Color(0x33000000),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
        child: AuthPrimaryButton(
          label: label,
          isLoading: saving,
          onPressed: saving ? null : onSave,
        ),
      ),
    );
  }
}

class _AddPhotosEmptyState extends StatelessWidget {
  const _AddPhotosEmptyState({required this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          decoration: BoxDecoration(
            color: AppBrandColors.fieldFill.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.22),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppBrandColors.primaryGreen,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Agrega casos con foto, descripción y estimado',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Así los clientes entienden qué hiciste y una referencia de costo.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  height: 1.4,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  'Agregar trabajo',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppBrandColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
