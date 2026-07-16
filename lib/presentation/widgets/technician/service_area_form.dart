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
          content: Text('Usa tu ubicación actual o selecciona un punto en el mapa'),
        ),
      );
      return;
    }

    final address = _addressController.text.trim();
    if (address.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una dirección o distrito')),
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
            'Indica desde dónde prestas servicio y en qué distritos atiendes.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          const AuthSectionLabel('Ubicación base'),
          const SizedBox(height: 8),
          AuthRoundedField(
            controller: _addressController,
            label: 'Ej. Surquillo, Lima',
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ubicación lista${_addressController.text.trim().isEmpty ? '' : ': ${_addressController.text.trim()}'}',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.showCoverageRadius) ...[
            const SizedBox(height: 20),
            const AuthSectionLabel('Radio de cobertura'),
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
                  selectedColor:
                      AppBrandColors.primaryGreen.withValues(alpha: 0.2),
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
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
