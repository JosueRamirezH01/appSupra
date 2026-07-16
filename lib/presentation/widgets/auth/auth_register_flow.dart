import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_ui.dart';

enum RegisterFlowRole { technician, seller }

class RegisterFlowCopy {
  const RegisterFlowCopy({
    required this.roleLabel,
    required this.roleIcon,
    required this.stepLabels,
    required this.accountTip,
    required this.profileTip,
    required this.submitLabel,
  });

  final String roleLabel;
  final IconData roleIcon;
  final List<String> stepLabels;
  final String accountTip;
  final String profileTip;
  final String submitLabel;

  static const technician = RegisterFlowCopy(
    roleLabel: 'Registro técnico',
    roleIcon: Icons.engineering_outlined,
    stepLabels: ['Cuenta', 'Perfil profesional'],
    accountTip:
        'Crea tu acceso con email y contraseña. También tendrás perfil de cliente.',
    profileTip:
        'Tu solicitud será revisada por un administrador antes de aparecer en búsquedas.',
    submitLabel: 'Crear cuenta técnico',
  );

  static const seller = RegisterFlowCopy(
    roleLabel: 'Registro vendedor',
    roleIcon: Icons.storefront_outlined,
    stepLabels: ['Cuenta', 'Datos del negocio'],
    accountTip:
        'Usa un correo que revises a diario. Recibirás avisos sobre tu verificación.',
    profileTip:
        'Solo negocios con RUC. Podrás publicar productos tras la aprobación.',
    submitLabel: 'Crear cuenta vendedor',
  );
}

/// Encabezado con rol, paso actual y barra de progreso segmentada.
class AuthRegisterFlowHeader extends StatelessWidget {
  const AuthRegisterFlowHeader({
    super.key,
    required this.copy,
    required this.currentStep,
  });

  final RegisterFlowCopy copy;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppBrandColors.primaryGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                copy.roleIcon,
                color: AppBrandColors.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.roleLabel,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppBrandColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Paso ${currentStep + 1} de ${copy.stepLabels.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AuthStepIndicator(
          currentStep: currentStep,
          labels: copy.stepLabels,
        ),
      ],
    );
  }
}

class AuthStepIndicator extends StatelessWidget {
  const AuthStepIndicator({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                color: index <= currentStep
                    ? AppBrandColors.primaryGreen
                    : const Color(0xFFE5E7EB),
              ),
            ),
          _StepNode(
            index: index,
            label: labels[index],
            isActive: index == currentStep,
            isCompleted: index < currentStep,
          ),
        ],
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  final int index;
  final String label;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final Color circleColor;
    final Color borderColor;
    final Widget child;

    if (isCompleted) {
      circleColor = AppBrandColors.primaryGreen;
      borderColor = AppBrandColors.primaryGreen;
      child = const Icon(Icons.check_rounded, color: Colors.white, size: 16);
    } else if (isActive) {
      circleColor = AppBrandColors.primaryGreen;
      borderColor = AppBrandColors.primaryGreen;
      child = Text(
        '${index + 1}',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Colors.white,
        ),
      );
    } else {
      circleColor = Colors.white;
      borderColor = const Color(0xFFD1D5DB);
      child = Text(
        '${index + 1}',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: AppBrandColors.textMuted,
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: child,
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 88,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive || isCompleted
                  ? AppBrandColors.textDark
                  : AppBrandColors.textMuted,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

/// Requisitos de contraseña con feedback visual en tiempo real.
class AuthPasswordHints extends StatefulWidget {
  const AuthPasswordHints({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<AuthPasswordHints> createState() => _AuthPasswordHintsState();
}

class _AuthPasswordHintsState extends State<AuthPasswordHints> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tu contraseña debe incluir:',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppBrandColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        _HintRow(
          label: 'Mínimo 8 caracteres',
          met: value.length >= 8,
        ),
        _HintRow(
          label: 'Una mayúscula',
          met: RegExp(r'[A-Z]').hasMatch(value),
        ),
        _HintRow(
          label: 'Una minúscula',
          met: RegExp(r'[a-z]').hasMatch(value),
        ),
        _HintRow(
          label: 'Un número',
          met: RegExp(r'\d').hasMatch(value),
        ),
      ],
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 16,
            color: met ? AppBrandColors.primaryGreen : const Color(0xFFD1D5DB),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: met ? AppBrandColors.textDark : AppBrandColors.textMuted,
              fontWeight: met ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pie de formulario con CTA principal destacado.
class AuthRegisterFlowFooter extends StatelessWidget {
  const AuthRegisterFlowFooter({
    super.key,
    required this.isFirstStep,
    required this.isLoading,
    required this.primaryLabel,
    required this.onPrimary,
    required this.onBack,
  });

  final bool isFirstStep;
  final bool isLoading;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthPrimaryButton(
          label: primaryLabel,
          isLoading: isLoading,
          onPressed: onPrimary,
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: isLoading ? null : onBack,
            child: Text(
              isFirstStep ? 'Volver' : 'Paso anterior',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
