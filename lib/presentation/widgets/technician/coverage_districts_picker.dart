import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/client_location_constants.dart';
import '../../../core/constants/coverage_constants.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../domain/entities/place_search_result.dart';
import '../../providers/location/client_location_data_providers.dart';
import '../auth/auth_ui.dart';

class CoverageDistrictsPicker extends ConsumerStatefulWidget {
  const CoverageDistrictsPicker({
    super.key,
    required this.selected,
    required this.coversAllPeru,
    required this.onCoversAllPeruChanged,
    required this.onSelectedChanged,
    this.enabled = true,
  });

  final List<TechnicianCoverageDistrictModel> selected;
  final bool coversAllPeru;
  final ValueChanged<bool> onCoversAllPeruChanged;
  final ValueChanged<List<TechnicianCoverageDistrictModel>> onSelectedChanged;
  final bool enabled;

  @override
  ConsumerState<CoverageDistrictsPicker> createState() =>
      _CoverageDistrictsPickerState();
}

class _CoverageDistrictsPickerState extends ConsumerState<CoverageDistrictsPicker> {
  final _searchController = TextEditingController();
  List<PlaceSearchResult> _suggestions = [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => _search(_searchController.text));
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < ClientLocationConstants.searchMinLength) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() => _searching = true);
    try {
      final results = await ref
          .read(clientLocationRemoteDataSourceProvider)
          .searchPlaces(trimmed);
      if (!mounted) return;
      setState(() {
        _suggestions = results.where((place) => place.id != null).toList();
      });
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _addPlace(PlaceSearchResult place) {
    final id = place.id;
    if (id == null || widget.coversAllPeru || !widget.enabled) return;
    if (widget.selected.any((item) => item.id == id)) return;
    if (widget.selected.length >= CoverageConstants.maxDistricts) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Máximo ${CoverageConstants.maxDistricts} distritos',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
      return;
    }

    final updated = [
      ...widget.selected,
      TechnicianCoverageDistrictModel(
        id: id,
        label: place.label,
        lat: place.lat,
        lng: place.lng,
      ),
    ];
    widget.onSelectedChanged(updated);
    _searchController.clear();
    setState(() => _suggestions = []);
  }

  void _removeDistrict(int id) {
    if (!widget.enabled) return;
    widget.onSelectedChanged(
      widget.selected.where((item) => item.id != id).toList(),
    );
  }

  String _shortLabel(String label) {
    final parts = label.split(',');
    return parts.first.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: widget.coversAllPeru,
            onChanged: widget.enabled ? widget.onCoversAllPeruChanged : null,
            title: Text(
              CoverageConstants.allPeruLabel,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Tu perfil aparecerá en búsquedas de todo el país',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppBrandColors.textMuted,
              ),
            ),
            activeThumbColor: AppBrandColors.primaryGreen,
          ),
        ),
        if (!widget.coversAllPeru) ...[
          const SizedBox(height: 8),
          const AuthSectionLabel('Distritos donde también atiendes'),
          const SizedBox(height: 8),
          Text(
            'Agrega distritos adicionales además de tu ubicación base.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          AuthRoundedField(
            controller: _searchController,
            label: 'Buscar distrito (ej. Chorrillos, Surco)',
          ),
          if (_searching)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(
                color: AppBrandColors.primaryGreen,
              ),
            ),
          if (_suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(12),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final place = _suggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      place.label,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.add_rounded),
                    onTap: () => _addPlace(place),
                  );
                },
              ),
            ),
          ],
          if (widget.selected.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selected.map((district) {
                return InputChip(
                  label: Text(_shortLabel(district.label)),
                  deleteIcon: const Icon(Icons.close_rounded, size: 18),
                  onDeleted: widget.enabled
                      ? () => _removeDistrict(district.id)
                      : null,
                  backgroundColor: const Color(0xFFE8F5E9),
                  labelStyle: GoogleFonts.poppins(fontSize: 13),
                );
              }).toList(),
            ),
          ],
        ],
      ],
    );
  }
}
