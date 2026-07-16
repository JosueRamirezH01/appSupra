import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/auth/auth_payload_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/technician_application_form.dart';

class BecomeTechnicianScreen extends ConsumerStatefulWidget {
  const BecomeTechnicianScreen({super.key});

  @override
  ConsumerState<BecomeTechnicianScreen> createState() =>
      _BecomeTechnicianScreenState();
}

class _BecomeTechnicianScreenState extends ConsumerState<BecomeTechnicianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _technicianFormStateKey = GlobalKey<TechnicianApplicationFormState>();
  final _phoneController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final technicianForm = _technicianFormStateKey.currentState!;
    if (!technicianForm.validate()) return;

    final data = technicianForm.buildData();
    if (data.subcategoryIds.isEmpty) {
      showErrorSnackBar(context, 'Selecciona al menos una especialidad');
      return;
    }
    if (data.subSubCategoryIds.isEmpty) {
      showErrorSnackBar(context, 'Selecciona al menos un servicio');
      return;
    }

    setState(() => _submitting = true);

    try {
      await ref.read(authNotifierProvider.notifier).addTechnicianProfile(
            AddTechnicianProfileRequest(
              specialty: data.specialty,
              profileType: data.profileType,
              ruc: data.ruc,
              businessName: data.businessName,
              legalRepresentativeName: data.legalRepresentativeName,
              subcategoryIds: data.subcategoryIds,
              subSubCategoryIds: data.subSubCategoryIds,
              documentType: data.documentType,
              documentNumber: data.documentNumber,
              phone: _phoneController.text.trim(),
            ),
          );

      if (!mounted) return;
      context.go('${RoutePaths.technicianActivateLocation}?source=become');
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading || _submitting;

    return AuthFlowScaffold(
      title: 'Registrarme como técnico',
      subtitle: 'Paso 1 de 2 — Completa tu solicitud.',
      onBack: () => context.pop(),
      compactLogo: true,
      footer: AuthPrimaryButton(
        label: 'Enviar solicitud',
        isLoading: isLoading,
        onPressed: _submit,
      ),
      child: TechnicianApplicationForm(
        key: _technicianFormStateKey,
        formKey: _formKey,
        phoneController: _phoneController,
        showPhoneField: true,
        isRegistration: true,
      ),
    );
  }
}
