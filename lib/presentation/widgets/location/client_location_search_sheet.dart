import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/client_location_constants.dart';
import '../../../core/utils/location_search_errors.dart';
import '../../providers/location/client_location_actions.dart';
import '../../providers/location/client_location_provider.dart';
import '../../providers/location/client_location_search.dart';
import '../auth/auth_ui.dart';

Future<void> showClientLocationSearchSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const ClientLocationSearchSheet(),
  );
}

class ClientLocationSearchSheet extends ConsumerStatefulWidget {
  const ClientLocationSearchSheet({super.key});

  @override
  ConsumerState<ClientLocationSearchSheet> createState() =>
      _ClientLocationSearchSheetState();
}

class _ClientLocationSearchSheetState
    extends ConsumerState<ClientLocationSearchSheet> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<GeoSearchResult> _results = [];
  GeoSearchResult? _selected;
  bool _searching = false;
  bool _locating = false;
  String? _error;
  String? _emptyHint;

  bool get _isBusy => _searching || _locating;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();

    if (query.length < ClientLocationConstants.searchMinLength) {
      setState(() {
        _results = [];
        _selected = null;
        _searching = false;
        _error = null;
        _emptyHint = null;
      });
      return;
    }

    setState(() {
      _searching = true;
      _error = null;
      _emptyHint = null;
    });

    _debounce = Timer(
      const Duration(milliseconds: ClientLocationConstants.searchDebounceMs),
      () async {
        try {
          final results = await searchClientPlaces(ref, query);
          if (!mounted) return;
          setState(() {
            _results = results;
            _searching = false;
            _selected = _results.length == 1 ? _results.first : _selected;
            _emptyHint = _results.isEmpty
                ? 'No encontramos ese lugar. Prueba con un distrito o ciudad.'
                : null;
          });
        } catch (error, stackTrace) {
          debugPrint('Location search failed: $error');
          debugPrintStack(stackTrace: stackTrace);
          if (!mounted) return;
          setState(() {
            _searching = false;
            _error = resolveLocationSearchError(error);
            _emptyHint = null;
            _results = [];
          });
        }
      },
    );
  }

  Future<void> _useCurrentLocation() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _locating = true;
      _error = null;
      _emptyHint = null;
    });

    try {
      final location = await useCurrentClientLocation(ref);
      if (!mounted || location == null) return;
      Navigator.of(context).pop();
    } on CurrentClientLocationException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          action: error.shouldOpenSettings
              ? SnackBarAction(
                  label: 'Ajustes',
                  onPressed: Geolocator.openAppSettings,
                )
              : null,
        ),
      );
    } catch (error) {
      debugPrint('Use current location failed: $error');
      if (!mounted) return;
      const message = 'No se pudo usar tu ubicación. Intenta de nuevo.';
      setState(() => _error = message);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _confirm() async {
    final selected = _selected;
    if (selected == null) return;

    try {
      await confirmClientLocation(
        ref,
        selected.toClientLocation(
          radiusKm: ClientLocationConstants.defaultRadiusKm,
        ),
      );

      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      debugPrint('Confirm location failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo guardar la ubicación. Cierra y abre la app, luego intenta de nuevo.',
          ),
        ),
      );
    }
  }

  Future<void> _clearActiveLocation() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _selected = null;
      _results = [];
      _error = null;
      _emptyHint = null;
      _searchController.clear();
    });

    try {
      await clearClientLocation(ref);
    } catch (error) {
      debugPrint('Clear location failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo quitar la zona activa. Intenta de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeLocation = ref.watch(activeClientLocationProvider).valueOrNull;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final topPadding = MediaQuery.paddingOf(context).top;
    final maxSheetHeight = (screenHeight - viewInsets.bottom - topPadding) * 0.92;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxSheetHeight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '¿DONDE BUSCAR?',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppBrandColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Usa tu ubicación actual o elige otra zona.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppBrandColors.textMuted,
            ),
          ),
          if (activeLocation != null) ...[
            const SizedBox(height: 16),
            Text(
              'Zona activa',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            _ActiveLocationChip(
              label: activeLocation.label,
              onClear: _isBusy ? null : _clearActiveLocation,
            ),
          ],
          const SizedBox(height: 16),
          _CurrentLocationActionCard(
            isLoading: _locating,
            onTap: _isBusy ? null : _useCurrentLocation,
          ),
          const SizedBox(height: 16),
          _SearchDivider(),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            autofocus: false,
            enabled: !_locating,
            textInputAction: TextInputAction.search,
            onChanged: _onQueryChanged,
            onSubmitted: _onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Ej. Los Olivos, Cañete, Miraflores',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
              filled: true,
              fillColor: AppBrandColors.inputFill,
              border: AppBrandColors.outlineInput(radius: 12),
              enabledBorder: AppBrandColors.outlineInput(radius: 12),
              focusedBorder: AppBrandColors.outlineInput(
                radius: 12,
                color: AppBrandColors.primaryGreen,
                width: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _error!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.red.shade700,
                ),
              ),
            ),
          if (_emptyHint != null && _error == null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _emptyHint!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ),
          if (_results.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _results[index];
                final selected = _selected == item;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: selected
                        ? AppBrandColors.primaryGreen
                        : AppBrandColors.textMuted,
                  ),
                  title: Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  trailing: selected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppBrandColors.primaryGreen,
                        )
                      : null,
                  onTap: _isBusy ? null : () => setState(() => _selected = item),
                );
              },
            ),
          const SizedBox(height: 16),
          AuthPrimaryButton(
            label: 'Confirmar zona',
            onPressed: _selected == null || _isBusy ? null : _confirm,
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveLocationChip extends StatelessWidget {
  const _ActiveLocationChip({
    required this.label,
    required this.onClear,
  });

  final String label;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InputChip(
        avatar: const Icon(
          Icons.location_on,
          color: AppBrandColors.primaryGreen,
          size: 18,
        ),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppBrandColors.textDark,
          ),
        ),
        deleteIcon: const Icon(
          Icons.close_rounded,
          size: 18,
          color: AppBrandColors.textMuted,
        ),
        onDeleted: onClear,
        backgroundColor: const Color(0xFFF0FDF4),
        side: const BorderSide(color: Color(0xFFBBF7D0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}

class _CurrentLocationActionCard extends StatelessWidget {
  const _CurrentLocationActionCard({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF0FDF4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppBrandColors.primaryGreen.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(11),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.my_location_rounded,
                        color: AppBrandColors.primaryGreen,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usar mi ubicación actual',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isLoading
                          ? 'Obteniendo tu posición…'
                          : 'Ver profesionales cerca de ti',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isLoading ? Icons.hourglass_top_rounded : Icons.chevron_right_rounded,
                color: AppBrandColors.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'o busca otra zona',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppBrandColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
