import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/auth/auth_payload_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/sellers/seller_business_form.dart';

class BecomeSellerScreen extends ConsumerStatefulWidget {
  const BecomeSellerScreen({super.key});

  @override
  ConsumerState<BecomeSellerScreen> createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends ConsumerState<BecomeSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessFormStateKey = GlobalKey<SellerBusinessFormState>();
  final _phoneController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final businessForm = _businessFormStateKey.currentState!;
    if (!businessForm.validate()) return;

    final data = businessForm.buildData();
    setState(() => _submitting = true);

    try {
      await ref.read(authNotifierProvider.notifier).addSellerProfile(
            AddSellerProfileRequest(
              businessName: data.businessName,
              ruc: data.ruc,
              legalRepresentativeName: data.legalRepresentativeName,
              phone: data.phone,
              description: data.description,
            ),
          );

      if (!mounted) return;
      ref.read(activeAppViewProvider.notifier).preferSeller();
      context.go(RoutePaths.sellerOnboarding);
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
      title: 'Vender productos',
      subtitle:
          'Registra tu negocio con RUC. La ubicación y el logo se configuran al verificar el negocio.',
      onBack: () => context.pop(),
      footer: AuthPrimaryButton(
        label: 'Enviar solicitud',
        isLoading: isLoading,
        onPressed: _submit,
      ),
      child: SellerBusinessForm(
        key: _businessFormStateKey,
        formKey: _formKey,
        phoneController: _phoneController,
      ),
    );
  }
}
