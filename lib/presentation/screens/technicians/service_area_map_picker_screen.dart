import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/location_service.dart';
import '../../models/service_area_coverage.dart';
import '../../models/service_area_location_pick.dart';
import '../../widgets/auth/auth_ui.dart';

/// Lima centro — fallback cuando no hay ubicación previa ni GPS.
const _defaultLatLng = LatLng(-12.0464, -77.0428);

class ServiceAreaMapPickerScreen extends StatefulWidget {
  const ServiceAreaMapPickerScreen({
    super.key,
    this.initialLat,
    this.initialLng,
    this.initialQuery,
    this.initialCoverageRadiusKm = ServiceAreaCoverage.defaultKm,
    this.pinOnly = false,
  });

  final double? initialLat;
  final double? initialLng;
  final String? initialQuery;
  final int initialCoverageRadiusKm;
  final bool pinOnly;

  @override
  State<ServiceAreaMapPickerScreen> createState() =>
      _ServiceAreaMapPickerScreenState();
}

class _ServiceAreaMapPickerScreenState extends State<ServiceAreaMapPickerScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  GoogleMapController? _mapController;
  LatLng _markerPosition = _defaultLatLng;
  Size _mapSize = Size.zero;
  late int _coverageRadiusKm;
  String _address = '';
  bool _mapReady = false;
  bool _locating = false;
  bool _searching = false;
  bool _resolvingAddress = false;
  bool _confirming = false;
  bool _pinAdjusted = false;
  bool _suppressNextCameraIdle = false;
  Timer? _reverseGeocodeDebounce;
  Timer? _fitCameraDebounce;

  static final _circleFill = AppBrandColors.primaryGreen.withValues(alpha: 0.2);
  static const _circleStroke = AppBrandColors.primaryGreen;

  @override
  void initState() {
    super.initState();
    _coverageRadiusKm = ServiceAreaCoverage.normalize(widget.initialCoverageRadiusKm);
    _searchController.text = widget.initialQuery?.trim() ?? '';
    if (widget.initialLat != null && widget.initialLng != null) {
      _markerPosition = LatLng(widget.initialLat!, widget.initialLng!);
      _address = _searchController.text;
      _scheduleReverseGeocode(_markerPosition);
    } else if (_searchController.text.length >= 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _searchAddress());
    } else {
      _tryCurrentLocation(silent: true);
    }
  }

  @override
  void dispose() {
    _reverseGeocodeDebounce?.cancel();
    _fitCameraDebounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Circle> get _coverageCircles => widget.pinOnly
      ? const {}
      : {
          Circle(
            circleId: const CircleId('service_area_coverage'),
            center: _markerPosition,
            radius: _coverageRadiusKm * 1000,
            fillColor: _circleFill,
            strokeColor: _circleStroke,
            strokeWidth: 2,
          ),
        };

  void _onRadiusChanged(double value) {
    setState(() {
      _coverageRadiusKm = ServiceAreaCoverage.snapFromSlider(value);
    });
    _scheduleFitCoverageInView();
  }

  void _scheduleFitCoverageInView() {
    _fitCameraDebounce?.cancel();
    _fitCameraDebounce = Timer(const Duration(milliseconds: 280), () {
      _fitCoverageInView();
    });
  }

  Future<void> _fitCoverageInView() async {
    final controller = _mapController;
    if (controller == null) return;

    _suppressNextCameraIdle = true;

    final radiusMeters = _coverageRadiusKm * 1000.0;
    final latRad = _markerPosition.latitude * math.pi / 180;
    final latDelta = radiusMeters / 111320;
    final lngDelta = radiusMeters / (111320 * math.cos(latRad));

    final bounds = LatLngBounds(
      southwest: LatLng(
        _markerPosition.latitude - latDelta,
        _markerPosition.longitude - lngDelta,
      ),
      northeast: LatLng(
        _markerPosition.latitude + latDelta,
        _markerPosition.longitude + lngDelta,
      ),
    );

    try {
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 72),
      );
    } catch (_) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _markerPosition, zoom: 12),
        ),
      );
    }
  }

  Future<void> _syncPositionFromMapCenter({required bool userMovedMap}) async {
    final controller = _mapController;
    if (controller == null || _mapSize == Size.zero) return;

    final center = await controller.getLatLng(
      ScreenCoordinate(
        x: (_mapSize.width / 2).round(),
        y: (_mapSize.height / 2).round(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _markerPosition = center;
      if (userMovedMap) {
        _pinAdjusted = true;
      }
    });

    if (userMovedMap) {
      _scheduleReverseGeocode(center);
    }
  }

  Future<void> _onCameraIdle() async {
    if (_suppressNextCameraIdle) {
      _suppressNextCameraIdle = false;
      return;
    }

    await _syncPositionFromMapCenter(userMovedMap: true);
  }

  Future<void> _tryCurrentLocation({bool silent = false}) async {
    setState(() => _locating = true);
    try {
      final point = await LocationService.getCurrentPosition();
      if (!mounted || point == null) {
        if (!silent && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo obtener tu ubicación')),
          );
        }
        return;
      }

      final position = LatLng(point.lat, point.lng);
      setState(() {
        _markerPosition = position;
        _pinAdjusted = true;
        if (point.address != null && point.address!.isNotEmpty) {
          _address = point.address!;
          _searchController.text = point.address!;
        } else {
          _address = '';
        }
      });
      await _moveCamera(position);
      _scheduleReverseGeocode(position);
      if (!widget.pinOnly) {
        _scheduleFitCoverageInView();
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();
    if (query.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe al menos 3 caracteres')),
      );
      return;
    }

    _searchFocus.unfocus();
    setState(() => _searching = true);
    try {
      final point = await LocationService.geocodeAddress(query);
      if (!mounted) return;
      if (point == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No encontramos esa dirección o distrito')),
        );
        return;
      }

      final position = LatLng(point.lat, point.lng);
      setState(() {
        _markerPosition = position;
        _address = query;
        _searchController.text = query;
        _pinAdjusted = false;
      });
      await _moveCamera(position);
      if (!widget.pinOnly) {
        _scheduleFitCoverageInView();
      }
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = _mapController;
    if (controller == null) return;

    _suppressNextCameraIdle = true;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14),
      ),
    );
  }

  void _scheduleReverseGeocode(LatLng position) {
    _reverseGeocodeDebounce?.cancel();
    _reverseGeocodeDebounce = Timer(const Duration(milliseconds: 450), () {
      _resolveAddress(position);
    });
  }

  Future<void> _resolveAddress(LatLng position) async {
    setState(() => _resolvingAddress = true);
    try {
      final label = await LocationService.reverseGeocode(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;
      if (label != null && label.isNotEmpty) {
        setState(() {
          _address = label;
          _searchController.text = label;
        });
      } else if (_pinAdjusted) {
        setState(() {
          _address = '';
          _searchController.text = '';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No detectamos el distrito. Busca "Los Olivos, Lima" o mueve el mapa.',
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _resolvingAddress = false);
    }
  }

  Future<void> _confirm() async {
    if (_confirming || _resolvingAddress) return;

    setState(() => _confirming = true);
    try {
      _reverseGeocodeDebounce?.cancel();
      await _syncPositionFromMapCenter(userMovedMap: false);

      if (_pinAdjusted || _address.trim().isEmpty) {
        await _resolveAddress(_markerPosition);
      }

      if (!mounted) return;

      final address = _address.trim().isNotEmpty
          ? _address.trim()
          : _searchController.text.trim();

      if (address.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Confirma una dirección o distrito antes de continuar'),
          ),
        );
        return;
      }

      context.pop(
        ServiceAreaLocationPick(
          lat: _markerPosition.latitude,
          lng: _markerPosition.longitude,
          address: address,
          coverageRadiusKm: _coverageRadiusKm,
        ),
      );
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Widget _buildCenterPin() {
    return IgnorePointer(
      child: Transform.translate(
        offset: const Offset(0, -22),
        child: Icon(
          Icons.location_on_rounded,
          size: 48,
          color: AppBrandColors.primaryGreen,
          shadows: const [
            Shadow(
              color: Color(0x44000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool busy) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppBrandColors.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  decoration: InputDecoration(
                    hintText: 'Ej. Los Olivos, Lima',
                    hintStyle: GoogleFonts.poppins(
                      color: AppBrandColors.textMuted,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchAddress(),
                ),
              ),
              IconButton(
                onPressed: busy ? null : _searchAddress,
                icon: _searching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward_rounded),
                color: AppBrandColors.primaryGreen,
                tooltip: 'Buscar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(bool busy) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.swipe_rounded,
                        color: AppBrandColors.primaryGreen.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mueve el mapa hasta que el pin quede sobre tu zona',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _resolvingAddress
                                  ? 'Obteniendo distrito...'
                                  : (_address.isEmpty
                                      ? 'También puedes buscar arriba o usar tu ubicación'
                                      : _address),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppBrandColors.textMuted,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!widget.pinOnly) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Radio de cobertura: $_coverageRadiusKm km',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ajusta el área donde atiendes clientes',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppBrandColors.primaryGreen,
                        inactiveTrackColor:
                            AppBrandColors.primaryGreen.withValues(alpha: 0.2),
                        thumbColor: AppBrandColors.primaryGreen,
                        overlayColor:
                            AppBrandColors.primaryGreen.withValues(alpha: 0.12),
                      ),
                      child: Slider(
                        value: _coverageRadiusKm.toDouble(),
                        min: ServiceAreaCoverage.minKm.toDouble(),
                        max: ServiceAreaCoverage.maxKm.toDouble(),
                        divisions:
                            ServiceAreaCoverage.maxKm - ServiceAreaCoverage.minKm,
                        label: '$_coverageRadiusKm km',
                        onChanged: busy ? null : _onRadiusChanged,
                      ),
                    ),
                    Wrap(
                      spacing: 4,
                      runSpacing: 0,
                      children: ServiceAreaCoverage.allowedKm
                          .map(
                            (km) => TextButton(
                              onPressed: busy
                                  ? null
                                  : () => _onRadiusChanged(km.toDouble()),
                              style: TextButton.styleFrom(
                                foregroundColor: _coverageRadiusKm == km
                                    ? AppBrandColors.primaryGreen
                                    : AppBrandColors.textMuted,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '$km km',
                                style: GoogleFonts.poppins(
                                  fontWeight: _coverageRadiusKm == km
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: busy ? null : () => _tryCurrentLocation(),
                  icon: _locating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location_rounded),
                  label: Text(
                    'Mi ubicación',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: busy ? null : _confirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppBrandColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Usar este punto',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final busy = _locating || _searching || _confirming || _resolvingAddress;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppBrandColors.textDark,
        elevation: 0,
        title: Text(
          'Seleccionar ubicación',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: busy ? null : _confirm,
            child: Text(
              'Confirmar',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: AppBrandColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(

        child: Column(
          children: [
            _buildSearchBar(busy),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _mapSize = Size(constraints.maxWidth, constraints.maxHeight);

                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _markerPosition,
                          zoom: 12,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        circles: _coverageCircles,
                        onCameraIdle: _onCameraIdle,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          setState(() => _mapReady = true);
                          if (!widget.pinOnly) {
                            _scheduleFitCoverageInView();
                          }
                        },
                      ),
                      if (!_mapReady)
                        const ColoredBox(
                          color: Color(0xFFF3F4F6),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      Center(child: _buildCenterPin()),
                    ],
                  );
                },
              ),
            ),
            _buildBottomPanel(busy),
          ],
        ),
      ),
    );
  }
}
