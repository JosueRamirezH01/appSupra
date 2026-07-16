import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/sellers/seller_business_form.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';

class SellerProfileEditScreen extends ConsumerStatefulWidget {
  const SellerProfileEditScreen({super.key});

  @override
  ConsumerState<SellerProfileEditScreen> createState() =>
      _SellerProfileEditScreenState();
}

class _SellerProfileEditScreenState extends ConsumerState<SellerProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<SellerBusinessFormState>();

  bool _submitting = false;

  Future<void> _save(SellerApplicationModel application) async {
    final businessForm = _businessFormKey.currentState!;
    if (!businessForm.validate()) return;

    final business = businessForm.buildData();

    setState(() => _submitting = true);
    try {
      await ref.read(sellersRepositoryProvider).updateProfile(
            UpdateSellerProfileRequest(
              businessName: business.businessName,
              phone: business.phone,
              description: business.description,
            ),
          );

      ref.invalidate(mySellerApplicationProvider);
      await ref.read(authNotifierProvider.notifier).refreshProfile();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Perfil actualizado',
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

  SellerBusinessFormData _initialBusinessData(SellerApplicationModel application) {
    return SellerBusinessFormData(
      businessName: application.businessName,
      ruc: application.ruc,
      legalRepresentativeName: application.legalRepresentativeName,
      phone: application.phone,
      description: application.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    final application = ref.watch(mySellerApplicationProvider);

    return application.when(
      loading: () => const Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        body: LoadingView(message: 'Cargando perfil...'),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        appBar: AppBar(),
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(mySellerApplicationProvider),
        ),
      ),
      data: (data) => TechnicianPanelScaffold(
        title: 'Editar perfil del negocio',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _submitting ? null : () => context.pop(),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            TechnicianPanelCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información registrada',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyRow(label: 'Cuenta', value: data.name),
                  _ReadOnlyRow(label: 'RUC', value: data.ruc),
                  _ReadOnlyRow(
                    label: 'Representante legal',
                    value: data.legalRepresentativeName,
                  ),
                  _ReadOnlyRow(
                    label: 'Estado',
                    value: _verificationStatusLabel(data.verificationStatus),
                  ),
                  if (data.rejectionReason?.trim().isNotEmpty == true)
                    _ReadOnlyRow(
                      label: 'Motivo de rechazo',
                      value: data.rejectionReason!,
                    ),
                  _ReadOnlyRow(
                    label: 'Productos en catálogo',
                    value: '${data.productCount}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TechnicianPanelCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos editables',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'El logo y la ubicación del local se configuran en la verificación del negocio. '
                    'Tu foto de perfil personal se edita desde ajustes de cuenta.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SellerBusinessForm(
                    key: _businessFormKey,
                    formKey: _formKey,
                    initialData: _initialBusinessData(data),
                    lockIdentityFields: true,
                    includeAddressField: false,
                    includeDescriptionField: true,
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
              label: 'Guardar cambios',
              isLoading: _submitting,
              icon: Icons.save_outlined,
              onPressed: _submitting ? null : () => _save(data),
            ),
          ),
        ),
      ),
    );
  }
}

String _verificationStatusLabel(String status) {
  return switch (status) {
    'aprobado' => 'Verificado',
    'pendiente' => 'En revisión',
    'rechazado' => 'Rechazado',
    _ => 'Sin verificar',
  };
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: TechnicianPanelColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
