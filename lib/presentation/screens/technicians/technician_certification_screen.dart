import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/repository_providers.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/upload_progress_overlay.dart';
import '../../widgets/technician_verification_badge.dart';

class TechnicianCertificationScreen extends ConsumerStatefulWidget {
  const TechnicianCertificationScreen({super.key});

  @override
  ConsumerState<TechnicianCertificationScreen> createState() =>
      _TechnicianCertificationScreenState();
}

class _TechnicianCertificationScreenState
    extends ConsumerState<TechnicianCertificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuerController = TextEditingController();
  File? _document;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    final file = await ImagePickerUtils.pickImageOrPdf(context);
    if (file != null) setState(() => _document = file);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_document == null) {
      showErrorSnackBar(context, 'Sube el certificado en PDF');
      return;
    }

    setState(() => _submitting = true);
    try {
      final upload = await ref.read(uploadsRepositoryProvider).uploadTechnicianFile(
            category: UploadCategory.certification,
            file: _document!,
          );

      await ref.read(myTechnicianProfileProvider.notifier).submitCertification(
            SubmitTechnicianCertificationRequest(
              name: _nameController.text.trim(),
              issuer: _issuerController.text.trim().isEmpty
                  ? null
                  : _issuerController.text.trim(),
              imageUrl: upload.file.url,
            ),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Certificado enviado. Te avisaremos cuando sea validado.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
      context.pop();
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myTechnicianProfileProvider);

    return profile.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Certificación')),
        body: Center(child: Text('$e')),
      ),
      data: (data) {
        if (!data.verified || data.verificationStatus != 'aprobado') {
          return TechnicianPanelScaffold(
            title: 'Certificación',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Primero verifica tu identidad',
                    style: TechnicianPanelTheme.title,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cuando tu identidad esté aprobada podrás subir un certificado de estudios o servicios.',
                    style: TechnicianPanelTheme.subtitle,
                  ),
                ],
              ),
            ),
          );
        }

        if (data.hasValidatedCertifications) {
          return TechnicianPanelScaffold(
            title: 'Certificación',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TechnicianCertificationBadge(compact: false),
                  const SizedBox(height: 16),
                  Text(
                    'Ya tienes una certificación validada visible en tu perfil público.',
                    style: TechnicianPanelTheme.subtitle,
                  ),
                ],
              ),
            ),
          );
        }

        if (data.certificationPending) {
          return TechnicianPanelScaffold(
            title: 'Certificación',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TechnicianPanelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.hourglass_top_rounded,
                              color: TechnicianPanelColors.warning,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Certificación en revisión',
                              style: TechnicianPanelTheme.title,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tu documento está pendiente de validación por nuestro equipo.',
                          style: TechnicianPanelTheme.subtitle,
                        ),
                      ],
                    ),
                  ),
                  if (data.certifications.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      data.certifications.first.name,
                      style: TechnicianPanelTheme.title,
                    ),
                    if (data.certifications.first.issuer != null)
                      Text(
                        data.certifications.first.issuer!,
                        style: TechnicianPanelTheme.subtitle,
                      ),
                  ],
                ],
              ),
            ),
          );
        }

        return Stack(
          children: [
            TechnicianPanelScaffold(
              title: 'Certificación',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _submitting ? null : () => context.pop(),
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                children: [
                  TechnicianPanelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insignia de certificación validada',
                          style: TechnicianPanelTheme.title,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sube un certificado de estudios o servicios que avalen tu formación. '
                          'Los clientes confían más en perfiles con certificaciones revisadas.',
                          style: TechnicianPanelTheme.subtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthRoundedField(
                          controller: _nameController,
                          label: 'Nombre del certificado *',
                          validator: (v) => v == null || v.trim().length < 2
                              ? 'Mínimo 2 caracteres'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        AuthRoundedField(
                          controller: _issuerController,
                          label: 'Institución emisora',
                        ),
                        const SizedBox(height: 20),
                        TechnicianDocumentUploadSlot(
                          title: 'Documento PDF *',
                          description:
                              'Certificado, diploma o constancia que avala tu formación.',
                          required: true,
                          icon: Icons.picture_as_pdf_outlined,
                          fileName: _document != null
                              ? _document!.path.split(RegExp(r'[\\/]')).last
                              : null,
                          enabled: !_submitting,
                          onPick: _pickDocument,
                          onRemove: () => setState(() => _document = null),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TechnicianPanelPrimaryButton(
                    label: 'Enviar certificado',
                    isLoading: _submitting,
                    icon: Icons.cloud_upload_outlined,
                    onPressed: _submitting ? null : _submit,
                  ),
                ),
              ),
            ),
            if (_submitting)
              const UploadProgressOverlay(
                completed: 0,
                total: 1,
                statusMessage: 'Subiendo certificado...',
              ),
          ],
        );
      },
    );
  }
}
