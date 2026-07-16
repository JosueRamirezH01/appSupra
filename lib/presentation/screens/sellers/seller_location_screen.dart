import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/sellers/seller_location_form.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';

class SellerLocationScreen extends ConsumerStatefulWidget {
  const SellerLocationScreen({super.key});

  @override
  ConsumerState<SellerLocationScreen> createState() =>
      _SellerLocationScreenState();
}

class _SellerLocationScreenState extends ConsumerState<SellerLocationScreen> {
  final _locationFormKey = GlobalKey<SellerLocationFormState>();

  bool _submitting = false;

  Future<void> _save(SellerApplicationModel application) async {
    final location = _locationFormKey.currentState?.buildData();
    if (location == null) {
      showErrorSnackBar(
        context,
        'Indica la ubicación de tu negocio (GPS o mapa)',
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(sellersRepositoryProvider).updateProfile(
            UpdateSellerProfileRequest(
              locationAddress: location.address,
              locationLat: location.lat,
              locationLng: location.lng,
            ),
          );

      ref.invalidate(mySellerApplicationProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ubicación actualizada',
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
    final application = ref.watch(mySellerApplicationProvider);

    return application.when(
      loading: () => const Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        body: LoadingView(message: 'Cargando ubicación...'),
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
        title: 'Ubicación del negocio',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _submitting ? null : () => context.pop(),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            TechnicianPanelCard(
              child: Text(
                'Los clientes podrán ver en qué zona está tu ferretería o almacén.',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TechnicianPanelCard(
              child: SellerLocationForm(
                key: _locationFormKey,
                initialAddress:
                    data.location?.address ?? data.locationAddress,
                initialLat: data.location?.lat,
                initialLng: data.location?.lng,
                enabled: !_submitting,
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TechnicianPanelPrimaryButton(
              label: 'Guardar ubicación',
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
