import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../core/utils/navigation_utils.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../widgets/sellers/seller_location_form.dart';
import '../../widgets/sellers/seller_panel_widgets.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/upload_progress_overlay.dart';

class SellerVerificationScreen extends ConsumerStatefulWidget {
  const SellerVerificationScreen({super.key, this.onboarding = false});

  final bool onboarding;

  @override
  ConsumerState<SellerVerificationScreen> createState() =>
      _SellerVerificationScreenState();
}

class _SellerVerificationScreenState
    extends ConsumerState<SellerVerificationScreen> {
  final _locationFormKey = GlobalKey<SellerLocationFormState>();

  bool _locationDraftReady = false;

  File? _rucDocument;
  File? _logo;

  bool _loading = true;
  bool _submitting = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;
  SellerApplicationModel? _application;

  @override
  void initState() {
    super.initState();
    _loadApplication();
  }

  Future<void> _loadApplication() async {
    try {
      final application =
          await ref.read(sellersRepositoryProvider).getMyApplication();
      if (!mounted) return;
      setState(() {
        _application = application;
        _loading = false;
        _locationDraftReady = application.hasLocation;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showErrorSnackBar(context, e);
    }
  }

  void _goBack() {
    if (widget.onboarding) {
      context.go(RoutePaths.sellerOnboarding);
      return;
    }
    goToSellerHome(context, ref);
  }

  Future<void> _pickRucDocument() async {
    final file = await ImagePickerUtils.pickImageOrPdf(context);
    if (file != null) setState(() => _rucDocument = file);
  }

  Future<void> _pickLogo() async {
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file != null) setState(() => _logo = file);
  }

  bool _validateBeforeSubmit(SellerApplicationModel application) {
    final location = _locationFormKey.currentState?.buildData();
    if (location == null) {
      showErrorSnackBar(
        context,
        'Indica la ubicación de tu negocio (GPS o mapa)',
      );
      return false;
    }

    if (_rucDocument == null &&
        (application.rucDocumentUrl == null ||
            application.rucDocumentUrl!.isEmpty)) {
      showErrorSnackBar(context, 'Sube la ficha RUC de tu negocio');
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    final application = _application;
    if (application == null || !application.canSubmitVerification) return;
    if (!_validateBeforeSubmit(application)) return;

    final location = _locationFormKey.currentState!.buildData()!;

    final uploadTasks = <MediaUploadTaskItem>[];
    if (_rucDocument != null) {
      uploadTasks.add(
        MediaUploadTaskItem(
          file: _rucDocument!,
          category: UploadCategory.document,
        ),
      );
    }
    if (_logo != null) {
      uploadTasks.add(
        MediaUploadTaskItem(
          file: _logo!,
          category: UploadCategory.companyLogo,
        ),
      );
    }

    setState(() {
      _submitting = true;
      _uploadCompleted = 0;
      _uploadTotal = uploadTasks.length;
    });

    try {
      final uploadsRepo = ref.read(uploadsRepositoryProvider);
      final sellersRepo = ref.read(sellersRepositoryProvider);

      await sellersRepo.updateProfile(
        UpdateSellerProfileRequest(
          locationAddress: location.address,
          locationLat: location.lat,
          locationLng: location.lng,
        ),
      );

      final uploadedUrls = uploadTasks.isEmpty
          ? <String>[]
          : await MediaUploadUtils.uploadMixedReferences(
              repository: uploadsRepo,
              tasks: uploadTasks,
              onProgress: (completed, total) {
                if (!mounted) return;
                setState(() {
                  _uploadCompleted = completed;
                  _uploadTotal = total;
                });
              },
            );

      var index = 0;
      await sellersRepo.submitVerification(
        SubmitSellerVerificationRequest(
          rucDocumentUrl: _rucDocument != null
              ? uploadedUrls[index++]
              : application.rucDocumentUrl!,
          logoUrl: _logo != null
              ? uploadedUrls[index++]
              : application.logoUrl,
        ),
      );

      await ref.read(authNotifierProvider.notifier).refreshProfile();
      ref.invalidate(mySellerApplicationProvider);

      if (!mounted) return;
      if (widget.onboarding) {
        ref.read(activeAppViewProvider.notifier).preferSeller();
        context.go('${RoutePaths.panel}?sellerVerificationSubmitted=1');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Documentos enviados. Tu negocio está pendiente de verificación.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: TechnicianPanelColors.primary,
          ),
        );
        goToSellerHome(context, ref);
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
          _uploadCompleted = 0;
          _uploadTotal = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        body: Center(
          child: CircularProgressIndicator(color: TechnicianPanelColors.primary),
        ),
      );
    }

    final application = _application;
    if (application == null) {
      return TechnicianPanelScaffold(
        title: 'Verificación',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),
        body: const Center(child: Text('No se pudo cargar tu negocio')),
      );
    }

    if (!application.canSubmitVerification) {
      return TechnicianPanelScaffold(
        title: 'Verificación del negocio',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SellerPanelStatusBanner.fromVerification(
              status: application.verificationStatus,
              verified: application.verified,
              rejectionReason: application.rejectionReason,
            ),
            const SizedBox(height: 24),
            TechnicianPanelPrimaryButton(
              label: 'Volver al inicio',
              onPressed: _goBack,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        TechnicianPanelScaffold(
          title: 'Verificación del negocio',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _submitting ? null : _goBack,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
            children: [
              _SellerVerificationChecklist(
                application: application,
                hasLocationDraft: _locationDraftReady,
              ),
              const SizedBox(height: 16),
              TechnicianPanelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.businessName,
                      style: TechnicianPanelTheme.title,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'RUC ${application.ruc}',
                      style: TechnicianPanelTheme.subtitle,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Completa la ubicación de tu negocio y adjunta la ficha RUC emitida por SUNAT.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TechnicianPanelCard(
                child: SellerLocationForm(
                  key: _locationFormKey,
                  initialAddress: application.location?.address ??
                      application.locationAddress,
                  initialLat: application.location?.lat,
                  initialLng: application.location?.lng,
                  enabled: !_submitting,
                  onLocationChanged: () {
                    setState(() {
                      _locationDraftReady =
                          _locationFormKey.currentState?.hasLocation ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              TechnicianDocumentUploadSlot(
                title: 'Ficha RUC',
                description: 'PDF o imagen legible de tu constancia RUC',
                required: true,
                icon: Icons.description_outlined,
                fileName: _rucDocument?.path.split(RegExp(r'[/\\]')).last,
                previewUrl: _rucDocument == null
                    ? application.rucDocumentUrl
                    : null,
                enabled: !_submitting,
                onPick: _pickRucDocument,
                onRemove: _rucDocument != null
                    ? () => setState(() => _rucDocument = null)
                    : null,
              ),
              const SizedBox(height: 12),
              TechnicianDocumentUploadSlot(
                title: 'Logo del negocio',
                description:
                    'Imagen de tu ferretería o marca. No uses tu foto personal de perfil.',
                required: false,
                icon: Icons.storefront_outlined,
                fileName: _logo?.path.split(RegExp(r'[/\\]')).last,
                previewUrl: _logo == null ? application.logoUrl : null,
                enabled: !_submitting,
                onPick: _pickLogo,
                onRemove: _logo != null ? () => setState(() => _logo = null) : null,
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TechnicianPanelPrimaryButton(
                label: 'Enviar verificación',
                isLoading: _submitting,
                icon: Icons.cloud_upload_outlined,
                onPressed: _submitting ? null : _submit,
              ),
            ),
          ),
        ),
        if (_submitting)
          UploadProgressOverlay(
            completed: _uploadCompleted,
            total: _uploadTotal,
          ),
      ],
    );
  }
}

class _SellerVerificationChecklist extends StatelessWidget {
  const _SellerVerificationChecklist({
    required this.application,
    required this.hasLocationDraft,
  });

  final SellerApplicationModel application;
  final bool hasLocationDraft;

  @override
  Widget build(BuildContext context) {
    final hasDocs = application.rucDocumentUrl?.isNotEmpty == true;
    final hasLocation = application.hasLocation || hasLocationDraft;

    final items = <({String label, bool done})>[
      (label: 'Ubicación del negocio', done: hasLocation),
      (label: 'Ficha RUC', done: hasDocs),
    ];

    return TechnicianPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requisitos', style: TechnicianPanelTheme.title),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    item.done
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    color: item.done
                        ? const Color(0xFF16A34A)
                        : TechnicianPanelColors.inkMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.label, style: TechnicianPanelTheme.subtitle),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
