import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/location_service.dart';
import '../../../routes/route_paths.dart';
import '../../models/service_area_location_pick.dart';
import '../auth/auth_ui.dart';

class SellerLocationFormData {
  const SellerLocationFormData({
    required this.lat,
    required this.lng,
    required this.address,
  });

  final double lat;
  final double lng;
  final String address;
}

class SellerLocationForm extends StatefulWidget {
  const SellerLocationForm({
    super.key,
    this.initialAddress,
    this.initialLat,
    this.initialLng,
    this.enabled = true,
    this.onLocationChanged,
  });

  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;
  final bool enabled;
  final VoidCallback? onLocationChanged;

  @override
  State<SellerLocationForm> createState() => SellerLocationFormState();
}

class SellerLocationFormState extends State<SellerLocationForm> {
  final _addressController = TextEditingController();

  double? _lat;
  double? _lng;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialAddress ?? '';
    _lat = widget.initialLat;
    _lng = widget.initialLng;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  bool get hasLocation => _lat != null && _lng != null;

  SellerLocationFormData? buildData() {
    if (_lat == null || _lng == null) return null;

    final address = _addressController.text.trim();
    if (address.length < 3) return null;

    return SellerLocationFormData(
      lat: _lat!,
      lng: _lng!,
      address: address,
    );
  }

  Future<void> _useCurrentLocation() async {
    if (!widget.enabled) return;

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
      widget.onLocationChanged?.call();
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _openMapPicker() async {
    if (!widget.enabled) return;

    final result = await context.push<ServiceAreaLocationPick>(
      RoutePaths.sellerLocationMap,
      extra: ServiceAreaMapPickerArgs(
        initialLat: _lat,
        initialLng: _lng,
        initialQuery: _addressController.text.trim(),
        pinOnly: true,
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _lat = result.lat;
      _lng = result.lng;
      _addressController.text = result.address;
    });
    widget.onLocationChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final busy = _locating || !widget.enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ubicación del negocio *',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Indica dónde está tu ferretería o almacén. Los clientes podrán ver tu zona.',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: const Color(0xFF6B7280),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: busy ? null : _useCurrentLocation,
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
        const SizedBox(height: 12),
        AuthRoundedField(
          controller: _addressController,
          label: 'Dirección o distrito *',
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: busy ? null : _openMapPicker,
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
        if (hasLocation) ...[
          const SizedBox(height: 12),
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
      ],
    );
  }
}
