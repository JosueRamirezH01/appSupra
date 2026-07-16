import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_onboarding_status.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/technician/service_area_form.dart';

enum _OnboardingStep { welcome, serviceArea, verifyIntro, done }

class TechnicianOnboardingScreen extends ConsumerStatefulWidget {
  const TechnicianOnboardingScreen({
    super.key,
    this.submitted = false,
    this.resume = false,
  });

  final bool submitted;
  final bool resume;

  @override
  ConsumerState<TechnicianOnboardingScreen> createState() =>
      _TechnicianOnboardingScreenState();
}

class _TechnicianOnboardingScreenState
    extends ConsumerState<TechnicianOnboardingScreen> {
  _OnboardingStep? _step;
  bool _savingArea = false;

  void _goHome() {
    ref.read(activeAppViewProvider.notifier).preferClient();
    context.go(RoutePaths.home);
  }

  void _openVerification() {
    context.push('${RoutePaths.technicianVerification}?onboarding=true');
  }

  Future<void> _saveServiceArea(ServiceAreaFormData data) async {
    setState(() => _savingArea = true);

    try {
      await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
            UpdateTechnicianProfileRequest(
              location: LocationModel(
                lat: data.lat,
                lng: data.lng,
                address: data.address,
              ),
              coverageRadiusKm: data.coverageRadiusKm,
              coversAllPeru: data.coversAllPeru,
              coveragePlaceIds: data.coveragePlaceIds,
              primaryCoveragePlaceId: data.primaryCoveragePlaceId,
            ),
          );

      if (!mounted) return;
      ref.invalidate(myTechnicianProfileProvider);
      setState(() => _step = _OnboardingStep.verifyIntro);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _savingArea = false);
    }
  }

  _OnboardingStep _resolveStep(TechnicianApplicationModel profile) {
    if (widget.submitted || profile.verificationStatus == 'pendiente') {
      return _OnboardingStep.done;
    }
    if (TechnicianOnboardingStatus.isFullyActivated(profile)) {
      return _OnboardingStep.done;
    }
    if (!profile.hasServiceArea) {
      if (_step != null) return _step!;
      return widget.resume
          ? _OnboardingStep.serviceArea
          : _OnboardingStep.welcome;
    }
    if (profile.canSubmitVerification) {
      return _OnboardingStep.verifyIntro;
    }
    return _OnboardingStep.done;
  }

  int _stepIndex(_OnboardingStep step) {
    return switch (step) {
      _OnboardingStep.welcome => 0,
      _OnboardingStep.serviceArea => 1,
      _OnboardingStep.verifyIntro => 2,
      _OnboardingStep.done => 3,
    };
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myTechnicianProfileProvider);

    return profileAsync.when(
      loading: () => const AuthFlowScaffold(
        title: 'Activar perfil',
        compactLogo: true,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => AuthFlowScaffold(
        title: 'Activar perfil',
        compactLogo: true,
        onBack: _goHome,
        child: Text('No se pudo cargar tu perfil: $e'),
      ),
      data: (profile) {
        final step = _step ?? _resolveStep(profile);
        if (TechnicianOnboardingStatus.isFullyActivated(profile) &&
            step != _OnboardingStep.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _goHome();
          });
        }

        return AuthFlowScaffold(
          title: _titleFor(step),
          subtitle: _subtitleFor(step),
          compactLogo: true,
          progress: (_stepIndex(step) + 1) / 4,
          onBack: step == _OnboardingStep.welcome ? _goHome : () {
            setState(() {
              _step = switch (step) {
                _OnboardingStep.serviceArea => _OnboardingStep.welcome,
                _OnboardingStep.verifyIntro => _OnboardingStep.serviceArea,
                _ => _OnboardingStep.welcome,
              };
            });
          },
          topActions: step == _OnboardingStep.welcome
              ? [
                  TextButton(
                    onPressed: _goHome,
                    child: Text(
                      'Ir al inicio',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ]
              : null,
          footer: _buildFooter(step, profile),
          child: _buildStepContent(step, profile),
        );
      },
    );
  }

  String _titleFor(_OnboardingStep step) {
    return switch (step) {
      _OnboardingStep.welcome => '¡Cuenta creada!',
      _OnboardingStep.serviceArea => '¿Dónde prestas servicio?',
      _OnboardingStep.verifyIntro => 'Verifica tu identidad',
      _OnboardingStep.done => '¡Solicitud enviada!',
    };
  }

  String? _subtitleFor(_OnboardingStep step) {
    return switch (step) {
      _OnboardingStep.welcome => 'Faltan 2 pasos para activar tu perfil profesional.',
      _OnboardingStep.serviceArea =>
        'Los clientes cercanos podrán encontrarte en la app.',
      _OnboardingStep.verifyIntro =>
        'Sube fotos claras del mismo documento que registraste.',
      _OnboardingStep.done =>
        'Revisaremos tus documentos en 24–48 horas hábiles.',
    };
  }

  Widget? _buildFooter(_OnboardingStep step, TechnicianApplicationModel profile) {
    return switch (step) {
      _OnboardingStep.welcome => AuthPrimaryButton(
          label: 'Empezar configuración',
          isLoading: false,
          onPressed: () => setState(() => _step = _OnboardingStep.serviceArea),
        ),
      _OnboardingStep.verifyIntro => AuthPrimaryButton(
          label: 'Subir documentos',
          isLoading: false,
          onPressed: _openVerification,
        ),
      _OnboardingStep.done => AuthPrimaryButton(
          label: 'Ir a mi panel técnico',
          isLoading: false,
          onPressed: _goHome,
        ),
      _OnboardingStep.serviceArea => null,
    };
  }

  Widget _buildStepContent(
    _OnboardingStep step,
    TechnicianApplicationModel profile,
  ) {
    return switch (step) {
      _OnboardingStep.welcome => _WelcomeStep(),
      _OnboardingStep.serviceArea => ServiceAreaForm(
          initialAddress: profile.location?.address,
          initialLat: profile.location?.lat,
          initialLng: profile.location?.lng,
          initialCoverageRadiusKm: profile.coverageRadiusKm,
          initialCoversAllPeru: profile.coversAllPeru,
          initialCoverageDistricts: profile.coverageDistricts,
          isLoading: _savingArea,
          showCoverageRadius: false,
          submitLabel: 'Guardar y continuar',
          onSubmit: _saveServiceArea,
        ),
      _OnboardingStep.verifyIntro => _VerifyIntroStep(profile: profile),
      _OnboardingStep.done => _DoneStep(profile: profile),
    };
  }
}

class _WelcomeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthInfoTip(
          message:
              'Tu perfil no será visible para clientes hasta completar la activación.',
          icon: Icons.info_outline_rounded,
        ),
        const SizedBox(height: 20),
        _OnboardingCheckRow(label: 'Cuenta y especialidades', done: true),
        _OnboardingCheckRow(label: 'Zona de servicio', done: false),
        _OnboardingCheckRow(label: 'Verificación de identidad', done: false),
      ],
    );
  }
}

class _OnboardingCheckRow extends StatelessWidget {
  const _OnboardingCheckRow({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: done ? AppBrandColors.primaryGreen : AppBrandColors.textMuted,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                color: done ? AppBrandColors.textDark : AppBrandColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyIntroStep extends StatelessWidget {
  const _VerifyIntroStep({required this.profile});

  final TechnicianApplicationModel profile;

  @override
  Widget build(BuildContext context) {
    final isEmpresa = profile.profileType == 'empresa';
    final docLabel = profile.documentType ?? 'Documento';
    final docNumber = profile.documentNumber ?? '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppBrandColors.primaryGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Documento registrado',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$docLabel · $docNumber',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isEmpresa) ...[
          _OnboardingCheckRow(label: 'Ficha RUC', done: false),
          _OnboardingCheckRow(
            label: 'DNI representante (frente y reverso)',
            done: false,
          ),
        ] else ...[
          _OnboardingCheckRow(label: 'Foto frontal del DNI', done: false),
          _OnboardingCheckRow(label: 'Foto reverso del DNI', done: false),
          _OnboardingCheckRow(label: 'Selfie con buena luz', done: false),
        ],
        const SizedBox(height: 12),
        const AuthInfoTip(
          message:
              'Asegúrate de que el número coincida con el documento en las fotos.',
          icon: Icons.lightbulb_outline_rounded,
        ),
      ],
    );
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.profile});

  final TechnicianApplicationModel profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 40,
              color: AppBrandColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const AuthInfoTip(
          message:
              'Mientras tanto puedes completar tu descripción y portafolio desde el panel técnico.',
          icon: Icons.tips_and_updates_outlined,
        ),
        const SizedBox(height: 16),
        _OnboardingCheckRow(label: 'Cuenta y especialidades', done: true),
        _OnboardingCheckRow(label: 'Zona de servicio', done: profile.hasServiceArea),
        _OnboardingCheckRow(label: 'Documentos enviados', done: true),
      ],
    );
  }
}
