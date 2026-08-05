import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/technician/service_area_form.dart';

/// Pantalla post-registro para activar el perfil técnico con ubicación obligatoria.
class TechnicianActivateLocationScreen extends ConsumerStatefulWidget {
  const TechnicianActivateLocationScreen({super.key, this.source = 'register'});

  /// `register` = registro directo, `become` = conversión, `profile` = perfil.
  final String source;

  @override
  ConsumerState<TechnicianActivateLocationScreen> createState() =>
      _TechnicianActivateLocationScreenState();
}

class _TechnicianActivateLocationScreenState
    extends ConsumerState<TechnicianActivateLocationScreen> {
  bool _saving = false;

  bool get _fromBecome => widget.source == 'become';
  bool get _fromProfile => widget.source == 'profile';

  String get _title {
    if (_fromProfile) return 'Configura tu ubicación';
    if (_fromBecome) return 'Activa tu perfil técnico';
    return '¡Cuenta creada!';
  }

  String get _subtitle {
    if (_fromProfile || _fromBecome) {
      return 'Indica dónde prestas servicio para que los clientes puedan encontrarte.';
    }
    return 'Un último paso: ¿dónde atiendes? Con esto activas tu perfil profesional.';
  }

  void _goHome({bool activated = false}) {
    if (activated) {
      ref.read(activeAppViewProvider.notifier).preferTechnician();
      context.go('${RoutePaths.panel}?technicianActivated=1');
      return;
    }
    ref.read(activeAppViewProvider.notifier).preferClient();
    context.go(RoutePaths.home);
  }

  Future<void> _save(ServiceAreaFormData data) async {
    setState(() => _saving = true);

    try {
      await ref
          .read(myTechnicianProfileProvider.notifier)
          .updateProfile(
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
      _goHome(activated: true);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myTechnicianProfileProvider);

    return AuthFlowScaffold(
      title: _title,
      subtitle: _subtitle,
      compactLogo: true,
      progress: 1,
      onBack: () => _goHome(),
      topActions: [
        TextButton(
          onPressed: _saving ? null : () => _goHome(),
          child: Text(
            'Lo haré después',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
      child: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('No se pudo cargar tu perfil: $e'),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthInfoTip(
              message:
                  'Sin ubicación tu perfil técnico queda inactivo. Podrás seguir usando la app como cliente.',
              icon: Icons.info_outline_rounded,
            ),
            const SizedBox(height: 16),
            ServiceAreaForm(
              initialAddress: data.location?.address,
              initialLat: data.location?.lat,
              initialLng: data.location?.lng,
              initialCoverageRadiusKm: data.coverageRadiusKm,
              initialCoversAllPeru: data.coversAllPeru,
              initialCoverageDistricts: data.coverageDistricts,
              isLoading: _saving,
              showCoverageRadius: false,
              submitLabel: 'Guardar y activar mi perfil',
              onSubmit: _save,
            ),
          ],
        ),
      ),
    );
  }
}
