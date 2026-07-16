import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/technician/service_area_form.dart';

class ServiceAreaScreen extends ConsumerStatefulWidget {
  const ServiceAreaScreen({
    super.key,
    this.continueToVerification = true,
  });

  final bool continueToVerification;

  @override
  ConsumerState<ServiceAreaScreen> createState() => _ServiceAreaScreenState();
}

class _ServiceAreaScreenState extends ConsumerState<ServiceAreaScreen> {
  bool _submitting = false;

  Future<void> _save(ServiceAreaFormData data) async {
    setState(() => _submitting = true);

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Zona de servicio guardada',
            style: Theme.of(context).textTheme.bodyMedium,
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

    return AuthFlowScaffold(
      title: 'Zona de servicio',
      subtitle: widget.continueToVerification
          ? 'Configura dónde prestas tus servicios antes de continuar.'
          : 'Indica dónde prestas servicio y en qué distritos atiendes.',
      onBack: () => context.pop(),
      compactLogo: true,
      child: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
        data: (data) => ServiceAreaForm(
          initialAddress: data.location?.address,
          initialLat: data.location?.lat,
          initialLng: data.location?.lng,
          initialCoverageRadiusKm: data.coverageRadiusKm,
          initialCoversAllPeru: data.coversAllPeru,
          initialCoverageDistricts: data.coverageDistricts,
          isLoading: _submitting,
          showCoverageRadius: false,
          submitLabel:
              widget.continueToVerification ? 'Guardar y continuar' : 'Guardar cambios',
          onSubmit: _save,
        ),
      ),
    );
  }
}
