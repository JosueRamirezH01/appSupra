import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/sellers/seller_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../utils/seller_onboarding_status.dart';
import '../../widgets/auth/auth_ui.dart';

enum _OnboardingStep { welcome, verifyIntro, done }

class SellerOnboardingScreen extends ConsumerStatefulWidget {
  const SellerOnboardingScreen({
    super.key,
    this.submitted = false,
    this.resume = false,
  });

  final bool submitted;
  final bool resume;

  @override
  ConsumerState<SellerOnboardingScreen> createState() =>
      _SellerOnboardingScreenState();
}

class _SellerOnboardingScreenState extends ConsumerState<SellerOnboardingScreen> {
  _OnboardingStep? _step;
  bool _handledSubmittedRedirect = false;

  void _goSellerHome({bool showSubmittedMessage = false}) {
    ref.read(activeAppViewProvider.notifier).preferSeller();
    if (showSubmittedMessage) {
      context.go('${RoutePaths.panel}?sellerVerificationSubmitted=1');
      return;
    }
    context.go(RoutePaths.panel);
  }

  void _goClientHome() {
    ref.read(activeAppViewProvider.notifier).preferClient();
    context.go(RoutePaths.home);
  }

  void _openVerification() {
    context.push('${RoutePaths.sellerVerification}?onboarding=true');
  }

  _OnboardingStep _resolveStep(SellerApplicationModel profile) {
    if (widget.submitted || profile.verificationStatus == 'pendiente') {
      return _OnboardingStep.done;
    }
    if (SellerOnboardingStatus.isOnboardingComplete(profile)) {
      return _OnboardingStep.done;
    }
    if (!SellerOnboardingStatus.hasSubmittedVerification(profile)) {
      if (_step != null) return _step!;
      return widget.resume
          ? _OnboardingStep.verifyIntro
          : _OnboardingStep.welcome;
    }
    return _OnboardingStep.done;
  }

  int _stepIndex(_OnboardingStep step) {
    return switch (step) {
      _OnboardingStep.welcome => 0,
      _OnboardingStep.verifyIntro => 1,
      _OnboardingStep.done => 2,
    };
  }

  @override
  Widget build(BuildContext context) {
    final applicationAsync = ref.watch(mySellerApplicationProvider);

    return applicationAsync.when(
      loading: () => const AuthFlowScaffold(
        title: 'Activa tu negocio',
        compactLogo: true,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => AuthFlowScaffold(
        title: 'Activa tu negocio',
        compactLogo: true,
        onBack: _goClientHome,
        child: Text('No se pudo cargar tu negocio: $e'),
      ),
      data: (profile) {
        if (SellerOnboardingStatus.isOnboardingComplete(profile) &&
            !_handledSubmittedRedirect) {
          _handledSubmittedRedirect = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _goSellerHome(showSubmittedMessage: widget.submitted);
          });
        }

        final step = _step ?? _resolveStep(profile);

        return AuthFlowScaffold(
          title: _titleFor(step, profile),
          subtitle: _subtitleFor(step, profile),
          compactLogo: true,
          progress: (_stepIndex(step) + 1) / 3,
          onBack: step == _OnboardingStep.welcome
              ? _goClientHome
              : () {
                  setState(() {
                    _step = switch (step) {
                      _OnboardingStep.verifyIntro => _OnboardingStep.welcome,
                      _ => _OnboardingStep.welcome,
                    };
                  });
                },
          topActions: step == _OnboardingStep.welcome
              ? [
                  TextButton(
                    onPressed: _goClientHome,
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

  String _titleFor(_OnboardingStep step, SellerApplicationModel profile) {
    return switch (step) {
      _OnboardingStep.welcome => '¡Cuenta creada!',
      _OnboardingStep.verifyIntro => 'Verifica tu negocio',
      _OnboardingStep.done => profile.verificationStatus == 'aprobado' ||
              profile.verified
          ? '¡Negocio activado!'
          : '¡Solicitud enviada!',
    };
  }

  String? _subtitleFor(_OnboardingStep step, SellerApplicationModel profile) {
    return switch (step) {
      _OnboardingStep.welcome =>
        'Un paso más: verifica tu negocio para poder publicar en el catálogo.',
      _OnboardingStep.verifyIntro =>
        'Indica la ubicación de tu local y adjunta la ficha RUC.',
      _OnboardingStep.done => profile.verificationStatus == 'aprobado' ||
              profile.verified
          ? 'Gestiona y publica productos desde tu panel de vendedor.'
          : 'Revisaremos tu negocio en 24–48 horas. Mientras tanto arma tu catálogo como no publicado.',
    };
  }

  Widget? _buildFooter(
    _OnboardingStep step,
    SellerApplicationModel profile,
  ) {
    return switch (step) {
      _OnboardingStep.welcome => AuthPrimaryButton(
          label: 'Empezar verificación',
          isLoading: false,
          onPressed: () =>
              setState(() => _step = _OnboardingStep.verifyIntro),
        ),
      _OnboardingStep.verifyIntro => AuthPrimaryButton(
          label: 'Completar verificación',
          isLoading: false,
          onPressed: _openVerification,
        ),
      _OnboardingStep.done => AuthPrimaryButton(
          label: 'Ir a mi panel de vendedor',
          isLoading: false,
          onPressed: () => _goSellerHome(),
        ),
    };
  }

  Widget _buildStepContent(
    _OnboardingStep step,
    SellerApplicationModel profile,
  ) {
    return switch (step) {
      _OnboardingStep.welcome => const _WelcomeStep(),
      _OnboardingStep.verifyIntro => _VerifyIntroStep(profile: profile),
      _OnboardingStep.done => _DoneStep(profile: profile),
    };
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthInfoTip(
          message:
              'Después de verificar podrás usar tu panel para agregar productos (inicialmente como no publicados).',
          icon: Icons.info_outline_rounded,
        ),
        const SizedBox(height: 20),
        _OnboardingCheckRow(label: 'Cuenta y datos del negocio', done: true),
        _OnboardingCheckRow(label: 'Verificación (ubicación + ficha RUC)', done: false),
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

  final SellerApplicationModel profile;

  @override
  Widget build(BuildContext context) {
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
                'Negocio registrado',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${profile.businessName} · RUC ${profile.ruc}',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _OnboardingCheckRow(label: 'Ubicación del local', done: profile.hasLocation),
        const _OnboardingCheckRow(label: 'Ficha RUC (SUNAT)', done: false),
        const _OnboardingCheckRow(label: 'Logo del negocio (opcional)', done: false),
        const SizedBox(height: 12),
        const AuthInfoTip(
          message: 'El RUC debe coincidir con la ficha que adjuntes.',
          icon: Icons.lightbulb_outline_rounded,
        ),
      ],
    );
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.profile});

  final SellerApplicationModel profile;

  @override
  Widget build(BuildContext context) {
    final approved =
        profile.verificationStatus == 'aprobado' || profile.verified;

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
        AuthInfoTip(
          message: approved
              ? 'Tu negocio ya está verificado. Publica productos desde el panel cuando estén listos.'
              : 'Tu verificación está en revisión. Desde el panel puedes crear productos como no publicados.',
          icon: Icons.tips_and_updates_outlined,
        ),
        const SizedBox(height: 16),
        const _OnboardingCheckRow(label: 'Cuenta y datos del negocio', done: true),
        const _OnboardingCheckRow(label: 'Verificación enviada', done: true),
        if (!approved)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: _OnboardingCheckRow(
              label: 'Aprobación del negocio (en revisión)',
              done: false,
            ),
          ),
      ],
    );
  }
}
