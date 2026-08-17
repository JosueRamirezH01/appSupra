import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/location_service.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../models/service_area_coverage.dart';
import '../../models/service_area_location_pick.dart';
import '../auth/auth_ui.dart';
import 'coverage_districts_picker.dart';

class ServiceAreaFormData {
  const ServiceAreaFormData({
    required this.lat,
    required this.lng,
    required this.address,
    required this.coverageRadiusKm,
    required this.coversAllPeru,
    required this.coveragePlaceIds,
    this.primaryCoveragePlaceId,
  });

  final double lat;
  final double lng;
  final String address;
  final int coverageRadiusKm;
  final bool coversAllPeru;
  final List<int> coveragePlaceIds;
  final int? primaryCoveragePlaceId;
}

class ServiceAreaForm extends StatefulWidget {
  const ServiceAreaForm({
    super.key,
    this.initialAddress,
    this.initialCoverageRadiusKm = ServiceAreaCoverage.defaultKm,
    this.initialLat,
    this.initialLng,
    this.initialCoversAllPeru = false,
    this.initialCoverageDistricts = const [],
    required this.onSubmit,
    this.isLoading = false,
    this.submitLabel = 'Guardar y continuar',
    this.showCoverageRadius = false,
  });

  final String? initialAddress;
  final int initialCoverageRadiusKm;
  final double? initialLat;
  final double? initialLng;
  final bool initialCoversAllPeru;
  final List<TechnicianCoverageDistrictModel> initialCoverageDistricts;
  final ValueChanged<ServiceAreaFormData> onSubmit;
  final bool isLoading;
  final String submitLabel;
  final bool showCoverageRadius;

  @override
  State<ServiceAreaForm> createState() => _ServiceAreaFormState();
}

class _ServiceAreaFormState extends State<ServiceAreaForm> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double? _lat;
  double? _lng;
  late int _coverageRadiusKm;
  late bool _coversAllPeru;
  late List<TechnicianCoverageDistrictModel> _selectedDistricts;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialAddress ?? '';
    _lat = widget.initialLat;
    _lng = widget.initialLng;
    _coverageRadiusKm =
        ServiceAreaCoverage.normalize(widget.initialCoverageRadiusKm);
    _coversAllPeru = widget.initialCoversAllPeru;
    _selectedDistricts = List<TechnicianCoverageDistrictModel>.from(
      widget.initialCoverageDistricts,
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  bool get _isBusy => widget.isLoading || _locating;

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      final point = await LocationService.getCurrentPosition();
      if (!mounted) return;
      if (point == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener tu ubicación')),
        );
        return;
      }

      setState(() {
        _lat = point.lat;
        _lng = point.lng;
        if (point.address != null && point.address!.isNotEmpty) {
          _addressController.text = point.address!;
        }
      });
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _openMapPicker() async {
    final result = await context.push<ServiceAreaLocationPick>(
      RoutePaths.technicianServiceAreaMap,
      extra: ServiceAreaMapPickerArgs(
        initialLat: _lat,
        initialLng: _lng,
        initialQuery: _addressController.text.trim(),
        initialCoverageRadiusKm: _coverageRadiusKm,
        pinOnly: !widget.showCoverageRadius,
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _lat = result.lat;
      _lng = result.lng;
      _addressController.text = result.address;
      if (widget.showCoverageRadius) {
        _coverageRadiusKm = result.coverageRadiusKm;
      }
    });
  }

  int get _effectiveCoverageRadiusKm => widget.showCoverageRadius
      ? _coverageRadiusKm
      : ServiceAreaCoverage.defaultKm;

  int? _resolvePrimaryPlaceId() {
    if (_selectedDistricts.isEmpty) return null;
    final primary = _selectedDistricts.where((item) => item.isPrimary);
    if (primary.isNotEmpty) return primary.first.id;
    return _selectedDistricts.first.id;
  }

  void _submit() {
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa tu ubicación (GPS o mapa)'),
        ),
      );
      return;
    }

    final address = _addressController.text.trim();
    if (address.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa la dirección de tu ubicación')),
      );
      return;
    }

    widget.onSubmit(
      ServiceAreaFormData(
        lat: _lat!,
        lng: _lng!,
        address: address,
        coverageRadiusKm: _effectiveCoverageRadiusKm,
        coversAllPeru: _coversAllPeru,
        coveragePlaceIds:
            _coversAllPeru ? const [] : _selectedDistricts.map((e) => e.id).toList(),
        primaryCoveragePlaceId: _coversAllPeru ? null : _resolvePrimaryPlaceId(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCoordinates = _lat != null && _lng != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tu ubicación es el punto de partida. Dónde atiendes son los distritos en los que aceptas trabajos.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.45,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          _ServiceAreaSection(
            step: 1,
            title: 'Tu ubicación',
            description:
                'Desde dónde sales. Lo ven tus clientes como referencia.',
            icon: Icons.location_on_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _isBusy ? null : _useCurrentLocation,
                  icon: _locating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location_rounded),
                  label: Text(
                    'Usar mi ubicación actual',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 14),
                AuthRoundedField(
                  controller: _addressController,
                  label: 'Ej. Av. Las Palmeras 123, Los Olivos',
                  validator: (value) =>
                      value == null || value.trim().length < 3
                      ? 'Mínimo 3 caracteres'
                      : null,
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: _isBusy ? null : _openMapPicker,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppBrandColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(
                    'Seleccionar en mapa',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                ),
                if (hasCoordinates) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF16A34A),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _addressController.text.trim().isEmpty
                                ? 'Ubicación lista'
                                : _addressController.text.trim(),
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ServiceAreaSection(
            step: 2,
            title: 'Dónde atiendes',
            description:
                'Departamento, provincia y distritos. También puedes marcar toda la provincia.',
            icon: Icons.map_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.showCoverageRadius) ...[
                  const AuthSectionLabel('Radio'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ServiceAreaCoverage.allowedKm.map((radius) {
                      final selected = _coverageRadiusKm == radius;
                      return ChoiceChip(
                        label: Text('$radius km'),
                        selected: selected,
                        onSelected: _isBusy || _coversAllPeru
                            ? null
                            : (_) => setState(() => _coverageRadiusKm = radius),
                        selectedColor: AppBrandColors.primaryGreen.withValues(
                          alpha: 0.2,
                        ),
                        labelStyle: GoogleFonts.poppins(
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                CoverageDistrictsPicker(
                  selected: _selectedDistricts,
                  coversAllPeru: _coversAllPeru,
                  enabled: !_isBusy,
                  onCoversAllPeruChanged: (value) {
                    setState(() {
                      _coversAllPeru = value;
                      if (value) {
                        _selectedDistricts = [];
                      }
                    });
                  },
                  onSelectedChanged: (districts) {
                    setState(() => _selectedDistricts = districts);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AuthPrimaryButton(
            label: widget.submitLabel,
            isLoading: _isBusy,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _ServiceAreaSection extends StatelessWidget {
  const _ServiceAreaSection({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
    required this.child,
  });

  final int step;
  final String title;
  final String description;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EAED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$step',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppBrandColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 18, color: AppBrandColors.primaryGreen),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppBrandColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          height: 1.4,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8EAED)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
