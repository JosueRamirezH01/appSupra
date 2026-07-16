import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../core/utils/navigation_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/upload_progress_overlay.dart';

bool _hasVerificationDocuments(TechnicianApplicationModel profile) {
  if (profile.profileType == 'empresa') {
    return profile.rucDocumentUrl != null &&
        (profile.legalRepresentativeDocumentFrontUrl != null ||
            profile.legalRepresentativeDocumentUrl != null) &&
        profile.legalRepresentativeDocumentBackUrl != null;
  }

  return (profile.documentFrontImageUrl != null ||
          profile.documentImageUrl != null) &&
      profile.documentBackImageUrl != null &&
      profile.facePhotoUrl != null;
}

class TechnicianVerificationScreen extends ConsumerStatefulWidget {
  const TechnicianVerificationScreen({super.key, this.onboarding = false});

  final bool onboarding;

  @override
  ConsumerState<TechnicianVerificationScreen> createState() =>
      _TechnicianVerificationScreenState();
}

class _TechnicianVerificationScreenState
    extends ConsumerState<TechnicianVerificationScreen> {
  File? _documentFront;
  File? _documentBack;
  File? _facePhoto;
  File? _rucDocument;
  File? _representativeFront;
  File? _representativeBack;

  bool _loadingProfile = true;
  bool _submitting = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;
  String _uploadStatus = '';
  TechnicianApplicationModel? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile =
          await ref.read(techniciansRepositoryProvider).getMyProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loadingProfile = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingProfile = false);
      showErrorSnackBar(context, e);
    }
  }

  void _goToTechnicianHome() {
    if (widget.onboarding) {
      context.go(RoutePaths.technicianOnboarding);
      return;
    }
    goToTechnicianHome(context, ref);
  }

  void _finishAfterSubmit() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Documentos enviados. Revisaremos tu insignia verificada (24–48 h hábiles). Tu perfil técnico sigue activo.',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: TechnicianPanelColors.primary,
      ),
    );
    if (widget.onboarding) {
      ref.invalidate(myTechnicianProfileProvider);
      context.go('${RoutePaths.technicianOnboarding}?submitted=1');
      return;
    }
    _goToTechnicianHome();
  }

  Future<void> _pickImage(void Function(File file) onPicked) async {
    final file = await ImagePickerUtils.pickImage(context);
    if (file != null) setState(() => onPicked(file));
  }

  Future<void> _pickImageOrPdf(void Function(File file) onPicked) async {
    final file = await ImagePickerUtils.pickImageOrPdf(context);
    if (file != null) setState(() => onPicked(file));
  }

  String? _previewUrl(File? file, String? existingUrl) {
    if (file != null) return null;
    return existingUrl;
  }

  bool _validateBeforeSubmit(bool isEmpresa) {
    if (!isEmpresa) {
      final hasFront = _documentFront != null ||
          _profile?.documentFrontImageUrl != null ||
          _profile?.documentImageUrl != null;
      if (!hasFront) {
        showErrorSnackBar(context, 'Sube la foto frontal de tu DNI');
        return false;
      }
      if (_documentBack == null && _profile?.documentBackImageUrl == null) {
        showErrorSnackBar(context, 'Sube la foto reverso de tu DNI');
        return false;
      }
      if (_facePhoto == null && _profile?.facePhotoUrl == null) {
        showErrorSnackBar(context, 'Sube tu foto de rostro');
        return false;
      }
      return true;
    }

    if (_rucDocument == null && _profile?.rucDocumentUrl == null) {
      showErrorSnackBar(context, 'Sube la ficha RUC');
      return false;
    }
    final hasRepFront = _representativeFront != null ||
        _profile?.legalRepresentativeDocumentFrontUrl != null ||
        _profile?.legalRepresentativeDocumentUrl != null;
    if (!hasRepFront) {
      showErrorSnackBar(
        context,
        'Sube la foto frontal del DNI del representante legal',
      );
      return false;
    }
    if (_representativeBack == null &&
        _profile?.legalRepresentativeDocumentBackUrl == null) {
      showErrorSnackBar(
        context,
        'Sube la foto reverso del DNI del representante legal',
      );
      return false;
    }
    return true;
  }

  List<MediaUploadTaskItem> _collectUploadTasks(bool isEmpresa) {
    final tasks = <MediaUploadTaskItem>[];

    if (isEmpresa) {
      if (_rucDocument != null) {
        tasks.add(
          MediaUploadTaskItem(
            file: _rucDocument!,
            category: UploadCategory.document,
          ),
        );
      }
      if (_representativeFront != null) {
        tasks.add(
          MediaUploadTaskItem(
            file: _representativeFront!,
            category: UploadCategory.document,
          ),
        );
      }
      if (_representativeBack != null) {
        tasks.add(
          MediaUploadTaskItem(
            file: _representativeBack!,
            category: UploadCategory.document,
          ),
        );
      }
      return tasks;
    }

    if (_documentFront != null) {
      tasks.add(
        MediaUploadTaskItem(
          file: _documentFront!,
          category: UploadCategory.document,
        ),
      );
    }
    if (_documentBack != null) {
      tasks.add(
        MediaUploadTaskItem(
          file: _documentBack!,
          category: UploadCategory.document,
        ),
      );
    }
    if (_facePhoto != null) {
      tasks.add(
        MediaUploadTaskItem(
          file: _facePhoto!,
          category: UploadCategory.facePhoto,
        ),
      );
    }

    return tasks;
  }

  Future<void> _submit() async {
    final profile = _profile;
    if (profile == null) return;

    final isEmpresa = profile.profileType == 'empresa';
    if (!_validateBeforeSubmit(isEmpresa)) return;

    final uploadTasks = _collectUploadTasks(isEmpresa);

    setState(() {
      _submitting = true;
      _uploadCompleted = 0;
      _uploadTotal = uploadTasks.length;
      _uploadStatus = uploadTasks.isEmpty
          ? 'Enviando verificación...'
          : 'Subiendo archivos...';
    });

    try {
      final uploadsRepo = ref.read(uploadsRepositoryProvider);
      final techniciansRepo = ref.read(techniciansRepositoryProvider);

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

      if (!mounted) return;
      setState(() => _uploadStatus = 'Enviando verificación...');

      var uploadIndex = 0;

      if (isEmpresa) {
        await techniciansRepo.submitVerification(
          SubmitTechnicianVerificationRequest(
            rucDocumentUrl: _rucDocument != null
                ? uploadedUrls[uploadIndex++]
                : profile.rucDocumentUrl,
            legalRepresentativeDocumentFrontUrl: _representativeFront != null
                ? uploadedUrls[uploadIndex++]
                : profile.legalRepresentativeDocumentFrontUrl ??
                    profile.legalRepresentativeDocumentUrl,
            legalRepresentativeDocumentBackUrl: _representativeBack != null
                ? uploadedUrls[uploadIndex++]
                : profile.legalRepresentativeDocumentBackUrl,
          ),
        );
      } else {
        await techniciansRepo.submitVerification(
          SubmitTechnicianVerificationRequest(
            documentFrontImageUrl: _documentFront != null
                ? uploadedUrls[uploadIndex++]
                : profile.documentFrontImageUrl ?? profile.documentImageUrl,
            documentBackImageUrl: _documentBack != null
                ? uploadedUrls[uploadIndex++]
                : profile.documentBackImageUrl,
            facePhotoUrl: _facePhoto != null
                ? uploadedUrls[uploadIndex++]
                : profile.facePhotoUrl,
          ),
        );
      }

      await ref.read(authNotifierProvider.notifier).refreshProfile();
      ref.invalidate(myTechnicianProfileProvider);

      if (!mounted) return;
      ref.invalidate(myTechnicianProfileProvider);
      _finishAfterSubmit();
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
          _uploadCompleted = 0;
          _uploadTotal = 0;
          _uploadStatus = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingProfile) {
      return const Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: TechnicianPanelColors.primary,
          ),
        ),
      );
    }

    final profile = _profile;
    if (profile == null) {
      return TechnicianPanelScaffold(
        title: 'Verificación',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goToTechnicianHome,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No se pudo cargar tu perfil técnico',
                  style: TechnicianPanelTheme.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TechnicianPanelPrimaryButton(
                  label: 'Ir al inicio',
                  onPressed: _goToTechnicianHome,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isEmpresa = profile.profileType == 'empresa';
    final canSubmit = profile.canSubmitVerification;
    final needsServiceArea =
        !profile.hasServiceArea &&
        (profile.verificationStatus == 'sin_verificar' ||
            profile.verificationStatus == 'rechazado');

    if (needsServiceArea) {
      return TechnicianPanelScaffold(
        title: 'Verificación de perfil',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goToTechnicianHome,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _VerificationChecklist(profile: profile),
            const SizedBox(height: 20),
            TechnicianPanelPrimaryButton(
              label: 'Configurar zona de servicio',
              icon: Icons.location_on_outlined,
              onPressed: () {
                if (widget.onboarding) {
                  context.go(RoutePaths.technicianOnboarding);
                  return;
                }
                context.push(RoutePaths.technicianServiceArea);
              },
            ),
          ],
        ),
      );
    }

    if (!canSubmit) {
      return TechnicianPanelScaffold(
        title: 'Verificación de perfil',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goToTechnicianHome,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(_blockedSubtitle(profile), style: TechnicianPanelTheme.subtitle),
            const SizedBox(height: 16),
            TechnicianPanelStatusBanner.fromVerification(
              status: profile.verificationStatus,
              verified: profile.verified,
              rejectionReason: profile.rejectionReason,
            ),
            const SizedBox(height: 24),
            TechnicianPanelPrimaryButton(
              label: 'Volver al inicio',
              onPressed: _goToTechnicianHome,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        TechnicianPanelScaffold(
      title: 'Verificación de perfil',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: _submitting ? null : _goToTechnicianHome,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
        children: [
          _VerificationChecklist(profile: profile),
          const SizedBox(height: 20),
          TechnicianPanelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEmpresa ? 'Verificación empresarial' : 'Verificación personal',
                  style: TechnicianPanelTheme.title,
                ),
                const SizedBox(height: 6),
                Text(
                  isEmpresa
                      ? 'Adjunta la ficha RUC y el DNI del representante legal (frontal y reverso).'
                      : 'Adjunta tu DNI (frontal y reverso) y una foto de rostro.',
                  style: TechnicianPanelTheme.subtitle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildRequiredDocumentsSection(profile, isEmpresa),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TechnicianPanelPrimaryButton(
                label: 'Enviar verificación',
                isLoading: _submitting,
                icon: Icons.cloud_upload_outlined,
                onPressed: _submitting ? null : _submit,
              ),
              const SizedBox(height: 10),
              TechnicianPanelSecondaryButton(
                label: 'Continuar al inicio',
                onPressed: _submitting ? null : _goToTechnicianHome,
              ),
            ],
          ),
        ),
      ),
    ),
        if (_submitting)
          UploadProgressOverlay(
            completed: _uploadCompleted,
            total: _uploadTotal,
            statusMessage:
                _uploadStatus == 'Enviando verificación...' ? _uploadStatus : null,
          ),
      ],
    );
  }

  String _blockedSubtitle(TechnicianApplicationModel profile) {
    return switch (profile.verificationStatus) {
      'pendiente' =>
        'Ya enviaste tus documentos. Revisamos tu insignia verificada; tu perfil técnico sigue activo.',
      'aprobado' => 'Ya tienes la insignia de identidad verificada.',
      _ => 'No puedes enviar documentos en este momento.',
    };
  }

  Widget _buildRequiredDocumentsSection(
    TechnicianApplicationModel profile,
    bool isEmpresa,
  ) {
    if (isEmpresa) {
      return TechnicianDocumentSectionGroup(
        title: 'Documentos obligatorios',
        subtitle: 'Requeridos para validar tu empresa',
        slots: [
          TechnicianDocumentUploadSlot(
            title: 'Ficha RUC',
            description: 'Imagen o PDF de la ficha RUC vigente.',
            required: true,
            icon: Icons.description_outlined,
            fileName: _rucDocument != null ? fileNameFromPath(_rucDocument!) : null,
            previewUrl: _previewUrl(_rucDocument, profile.rucDocumentUrl),
            enabled: !_submitting,
            onPick: () => _pickImageOrPdf((f) => _rucDocument = f),
            onRemove: () => setState(() => _rucDocument = null),
          ),
          TechnicianDocumentUploadSlot(
            title: 'DNI representante legal (frontal)',
            description: 'Foto frontal clara del documento del representante legal.',
            required: true,
            icon: Icons.credit_card_outlined,
            fileName: _representativeFront != null
                ? fileNameFromPath(_representativeFront!)
                : null,
            previewUrl: _previewUrl(
              _representativeFront,
              profile.legalRepresentativeDocumentFrontUrl ??
                  profile.legalRepresentativeDocumentUrl,
            ),
            enabled: !_submitting,
            onPick: () => _pickImage((f) => _representativeFront = f),
            onRemove: () => setState(() => _representativeFront = null),
          ),
          TechnicianDocumentUploadSlot(
            title: 'DNI representante legal (reverso)',
            description: 'Foto del reverso del documento del representante legal.',
            required: true,
            icon: Icons.credit_card_outlined,
            fileName: _representativeBack != null
                ? fileNameFromPath(_representativeBack!)
                : null,
            previewUrl: _previewUrl(
              _representativeBack,
              profile.legalRepresentativeDocumentBackUrl,
            ),
            enabled: !_submitting,
            onPick: () => _pickImage((f) => _representativeBack = f),
            onRemove: () => setState(() => _representativeBack = null),
          ),
        ],
        footerNote:
            'RUC: JPG, PNG, WEBP o PDF. Resto: JPG, PNG o WEBP. Máximo 10 MB.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TechnicianDocumentSectionGroup(
          title: 'Documentos obligatorios',
          subtitle: 'Requeridos para validar tu identidad',
          slots: [
            TechnicianDocumentUploadSlot(
              title: 'DNI frontal',
              description: 'Foto frontal clara de tu DNI, CE o pasaporte.',
              required: true,
              icon: Icons.credit_card_outlined,
              fileName:
                  _documentFront != null ? fileNameFromPath(_documentFront!) : null,
              previewUrl: _previewUrl(
                _documentFront,
                profile.documentFrontImageUrl ?? profile.documentImageUrl,
              ),
              enabled: !_submitting,
              onPick: () => _pickImage((f) => _documentFront = f),
              onRemove: () => setState(() => _documentFront = null),
            ),
            TechnicianDocumentUploadSlot(
              title: 'DNI reverso',
              description: 'Foto del reverso de tu documento de identidad.',
              required: true,
              icon: Icons.credit_card_outlined,
              fileName:
                  _documentBack != null ? fileNameFromPath(_documentBack!) : null,
              previewUrl: _previewUrl(_documentBack, profile.documentBackImageUrl),
              enabled: !_submitting,
              onPick: () => _pickImage((f) => _documentBack = f),
              onRemove: () => setState(() => _documentBack = null),
            ),
            TechnicianDocumentUploadSlot(
              title: 'Foto de rostro',
              description:
                  'Selfie con buena luz, rostro visible y sin accesorios que tapen tu identidad.',
              required: true,
              icon: Icons.face_retouching_natural_outlined,
              fileName: _facePhoto != null ? fileNameFromPath(_facePhoto!) : null,
              previewUrl: _previewUrl(_facePhoto, profile.facePhotoUrl),
              enabled: !_submitting,
              onPick: () => _pickImage((f) => _facePhoto = f),
              onRemove: () => setState(() => _facePhoto = null),
            ),
          ],
          footerNote: 'Formatos: JPG, PNG o WEBP. Máximo 5 MB por archivo.',
        ),
      ],
    );
  }
}

class _VerificationChecklist extends StatelessWidget {
  const _VerificationChecklist({required this.profile});

  final TechnicianApplicationModel profile;

  @override
  Widget build(BuildContext context) {
    final hasDocs = profile.verificationStatus == 'pendiente' ||
        profile.verificationStatus == 'aprobado' ||
        _hasVerificationDocuments(profile);

    final items = <({String label, bool done})>[
      (
        label: 'Subcategoría seleccionada',
        done: profile.subcategories.isNotEmpty,
      ),
      (
        label: 'Zona de servicio configurada',
        done: profile.hasServiceArea,
      ),
      (
        label: 'Documentos de verificación',
        done: hasDocs,
      ),
    ];

    return TechnicianPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requisitos previos', style: TechnicianPanelTheme.title),
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
