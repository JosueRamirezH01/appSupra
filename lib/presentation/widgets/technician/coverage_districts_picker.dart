import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/coverage_constants.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../domain/entities/location_hierarchy_place.dart';
import '../../providers/location/client_location_data_providers.dart';
import '../auth/auth_ui.dart';
import '../common/panel_select_field.dart';

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
  int _cascadeNonce = 0;
  int? _departmentId;
  int? _provinceId;

  List<LocationHierarchyPlace> _departments = const [];
  List<LocationHierarchyPlace> _provinces = const [];
  List<LocationHierarchyPlace> _districts = const [];

  bool _loadingDepartments = false;
  bool _loadingProvinces = false;
  bool _loadingDistricts = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadDepartments();
    });
  }

  Future<void> _loadDepartments() async {
    setState(() => _loadingDepartments = true);
    try {
      final places = await ref
          .read(clientLocationRemoteDataSourceProvider)
          .listDepartments();
      if (!mounted) return;
      setState(() => _departments = places);
    } catch (_) {
      if (!mounted) return;
      _showError('No se pudieron cargar los departamentos');
    } finally {
      if (mounted) setState(() => _loadingDepartments = false);
    }
  }

  Future<void> _onDepartmentSelected(int departmentId) async {
    if (!widget.enabled || widget.coversAllPeru) return;

    setState(() {
      _departmentId = departmentId;
      _provinceId = null;
      _provinces = const [];
      _districts = const [];
      _loadingProvinces = true;
    });

    try {
      final places = await ref
          .read(clientLocationRemoteDataSourceProvider)
          .listProvinces(departmentId);
      if (!mounted) return;
      setState(() => _provinces = places);
    } catch (_) {
      if (!mounted) return;
      _showError('No se pudieron cargar las provincias');
    } finally {
      if (mounted) setState(() => _loadingProvinces = false);
    }
  }

  Future<void> _onProvinceSelected(int provinceId) async {
    if (!widget.enabled || widget.coversAllPeru) return;

    setState(() {
      _provinceId = provinceId;
      _districts = const [];
      _loadingDistricts = true;
    });

    try {
      final places = await ref
          .read(clientLocationRemoteDataSourceProvider)
          .listDistricts(provinceId);
      if (!mounted) return;
      setState(() => _districts = places);
    } catch (_) {
      if (!mounted) return;
      _showError('No se pudieron cargar los distritos');
    } finally {
      if (mounted) setState(() => _loadingDistricts = false);
    }
  }

  void _resetCascade() {
    if (!widget.enabled || widget.coversAllPeru) return;
    setState(() {
      _cascadeNonce += 1;
      _departmentId = null;
      _provinceId = null;
      _provinces = const [];
      _districts = const [];
      _loadingProvinces = false;
      _loadingDistricts = false;
    });
  }

  LocationHierarchyPlace? get _selectedProvince {
    final provinceId = _provinceId;
    if (provinceId == null) return null;
    for (final place in _provinces) {
      if (place.id == provinceId) return place;
    }
    return null;
  }

  bool get _wholeProvinceSelected {
    final provinceId = _provinceId;
    if (provinceId == null) return false;
    return widget.selected.any((item) => item.id == provinceId);
  }

  void _removeDistrict(int id) {
    if (!widget.enabled) return;
    widget.onSelectedChanged(
      widget.selected.where((item) => item.id != id).toList(),
    );
  }

  void _toggleWholeProvince(bool enabled) {
    final province = _selectedProvince;
    if (!widget.enabled || widget.coversAllPeru || province == null) return;

    final districtIds = _districts.map((item) => item.id).toSet();
    final withoutCurrentProvince = widget.selected
        .where((item) => item.id != province.id && !districtIds.contains(item.id))
        .toList();

    if (!enabled) {
      widget.onSelectedChanged(withoutCurrentProvince);
      return;
    }

    if (withoutCurrentProvince.length >= CoverageConstants.maxDistricts) {
      _showError('Máximo ${CoverageConstants.maxDistricts} zonas');
      return;
    }

    widget.onSelectedChanged([
      ...withoutCurrentProvince,
      TechnicianCoverageDistrictModel(
        id: province.id,
        label: CoverageConstants.wholeProvinceLabel(province.name),
        lat: province.lat,
        lng: province.lng,
      ),
    ]);
  }

  Future<void> _openDistrictSheet() async {
    if (!widget.enabled || widget.coversAllPeru || _provinceId == null) return;
    if (_districts.isEmpty) return;

    final remaining =
        CoverageConstants.maxDistricts - widget.selected.length;
    if (remaining <= 0 &&
        widget.selected.every(
          (item) => !_districts.any((district) => district.id == item.id),
        )) {
      _showError('Máximo ${CoverageConstants.maxDistricts} zonas');
      return;
    }

    final picked = await showModalBottomSheet<List<LocationHierarchyPlace>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (context) => _CoverageDistrictsSheet(
        districts: _districts,
        selectedIds: widget.selected.map((item) => item.id).toSet(),
        maxDistricts: CoverageConstants.maxDistricts,
        alreadySelectedCount: widget.selected
            .where((item) => !_districts.any((district) => district.id == item.id))
            .length,
      ),
    );

    if (picked == null || !mounted) return;
    _applyProvinceSelection(picked);
  }

  void _applyProvinceSelection(List<LocationHierarchyPlace> picked) {
    final districtIds = _districts.map((item) => item.id).toSet();
    final kept = widget.selected
        .where(
          (item) =>
              !districtIds.contains(item.id) && item.id != _provinceId,
        )
        .toList();

    final merged = [
      ...kept,
      ...picked.map(
        (place) => TechnicianCoverageDistrictModel(
          id: place.id,
          label: place.label,
          lat: place.lat,
          lng: place.lng,
        ),
      ),
    ];

    if (merged.length > CoverageConstants.maxDistricts) {
      _showError('Máximo ${CoverageConstants.maxDistricts} zonas');
      return;
    }

    widget.onSelectedChanged(merged);
  }

  void _toggleDistrict(LocationHierarchyPlace place) {
    if (!widget.enabled || widget.coversAllPeru) return;

    final already = widget.selected.any((item) => item.id == place.id);
    if (already) {
      _removeDistrict(place.id);
      return;
    }

    if (widget.selected.length >= CoverageConstants.maxDistricts) {
      _showError('Máximo ${CoverageConstants.maxDistricts} zonas');
      return;
    }

    widget.onSelectedChanged([
      ...widget.selected,
      TechnicianCoverageDistrictModel(
        id: place.id,
        label: place.label,
        lat: place.lat,
        lng: place.lng,
      ),
    ]);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
      ),
    );
  }

  String _shortLabel(String label) {
    if (label.toLowerCase().startsWith('toda la provincia')) {
      return label;
    }
    final parts = label.split(',');
    return parts.first.trim();
  }

  bool get _busy =>
      _loadingDepartments || _loadingProvinces || _loadingDistricts;

  @override
  Widget build(BuildContext context) {
    final canEdit = widget.enabled && !widget.coversAllPeru;
    final selectedInProvince = _districts
        .where((district) => widget.selected.any((item) => item.id == district.id))
        .length;

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
          const AuthSectionLabel('Zonas de atención'),
          const SizedBox(height: 8),
          Text(
            'Elige departamento y provincia. Luego marca toda la provincia '
            'o distritos sueltos. Otra zona suma sin borrar lo elegido.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: LinearProgressIndicator(
                color: AppBrandColors.primaryGreen,
              ),
            ),
          PanelSelectField<int>(
            key: ValueKey('coverage-dept-$_cascadeNonce'),
            label: 'Departamento',
            hintText: 'Selecciona un departamento',
            sheetTitle: 'Departamento',
            leadingIcon: Icons.map_outlined,
            enabled: canEdit && !_loadingDepartments,
            options: _departments
                .map(
                  (place) => PanelSelectOption(
                    value: place.id,
                    label: place.name,
                  ),
                )
                .toList(),
            onChanged: _onDepartmentSelected,
          ),
          const SizedBox(height: 10),
          PanelSelectField<int>(
            key: ValueKey('coverage-prov-$_cascadeNonce-${_departmentId ?? 0}'),
            label: 'Provincia',
            hintText: _departmentId == null
                ? 'Primero elige un departamento'
                : 'Selecciona una provincia',
            sheetTitle: 'Provincia',
            leadingIcon: Icons.location_city_outlined,
            enabled: canEdit && _departmentId != null && !_loadingProvinces,
            options: _provinces
                .map(
                  (place) => PanelSelectOption(
                    value: place.id,
                    label: place.name,
                  ),
                )
                .toList(),
            onChanged: _onProvinceSelected,
          ),
          if (_provinceId != null) ...[
            const SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _wholeProvinceSelected,
                onChanged: canEdit ? _toggleWholeProvince : null,
                title: Text(
                  CoverageConstants.wholeProvinceLabel(
                    _selectedProvince?.name ?? 'esta provincia',
                  ),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Aparecerás en búsquedas de todos sus distritos.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                activeThumbColor: AppBrandColors.primaryGreen,
              ),
            ),
          ],
          if (!_wholeProvinceSelected) ...[
          const SizedBox(height: 10),
          _DistrictSelectTrigger(
            enabled: canEdit && _provinceId != null && !_loadingDistricts,
            countLabel: _provinceId == null
                ? 'Primero elige una provincia'
                : _districts.isEmpty && !_loadingDistricts
                    ? 'Aún no hay distritos para esta provincia'
                    : selectedInProvince == 0
                        ? 'Agregar distritos de esta provincia'
                        : '$selectedInProvince distrito${selectedInProvince == 1 ? '' : 's'} de esta provincia',
            onTap: _openDistrictSheet,
          ),
          if (_districts.isNotEmpty && _districts.length <= 12) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _districts.map((district) {
                final selected = widget.selected.any((item) => item.id == district.id);
                return FilterChip(
                  label: Text(district.name),
                  selected: selected,
                  onSelected: canEdit ? (_) => _toggleDistrict(district) : null,
                  selectedColor: AppBrandColors.primaryGreen.withValues(alpha: 0.18),
                  checkmarkColor: AppBrandColors.primaryGreen,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: canEdit && (_departmentId != null || widget.selected.isNotEmpty)
                  ? _resetCascade
                  : null,
              icon: const Icon(Icons.add_location_alt_outlined, size: 20),
              label: Text(
                CoverageConstants.otherZoneLabel,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (widget.selected.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${widget.selected.length} de ${CoverageConstants.maxDistricts} zonas',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
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

class _DistrictSelectTrigger extends StatelessWidget {
  const _DistrictSelectTrigger({
    required this.enabled,
    required this.countLabel,
    required this.onTap,
  });

  final bool enabled;
  final String countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: 'Distritos',
      value: countLabel,
      child: Material(
        color: enabled
            ? AppBrandColors.fieldFill
            : AppBrandColors.fieldFill.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Row(
              children: [
                Icon(
                  Icons.apartment_outlined,
                  size: 20,
                  color: enabled
                      ? AppBrandColors.primaryGreen
                      : AppBrandColors.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distritos',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        countLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: enabled
                              ? AppBrandColors.textDark
                              : AppBrandColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.expand_more_rounded,
                  color: enabled
                      ? AppBrandColors.textMuted
                      : AppBrandColors.textMuted.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverageDistrictsSheet extends StatefulWidget {
  const _CoverageDistrictsSheet({
    required this.districts,
    required this.selectedIds,
    required this.maxDistricts,
    required this.alreadySelectedCount,
  });

  final List<LocationHierarchyPlace> districts;
  final Set<int> selectedIds;
  final int maxDistricts;
  final int alreadySelectedCount;

  @override
  State<_CoverageDistrictsSheet> createState() => _CoverageDistrictsSheetState();
}

class _CoverageDistrictsSheetState extends State<_CoverageDistrictsSheet> {
  final _searchController = TextEditingController();
  late Set<int> _selectedIds;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.districts
        .where((item) => widget.selectedIds.contains(item.id))
        .map((item) => item.id)
        .toSet();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LocationHierarchyPlace> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.districts;
    return widget.districts
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.label.toLowerCase().contains(query),
        )
        .toList();
  }

  int get _totalSelected => widget.alreadySelectedCount + _selectedIds.length;

  void _toggle(LocationHierarchyPlace place) {
    final selected = _selectedIds.contains(place.id);
    if (selected) {
      setState(() => _selectedIds.remove(place.id));
      return;
    }

    if (_totalSelected >= widget.maxDistricts) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Máximo ${widget.maxDistricts} zonas',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
      return;
    }

    setState(() => _selectedIds.add(place.id));
  }

  void _confirm() {
    final picked = widget.districts
        .where((item) => _selectedIds.contains(item.id))
        .toList(growable: false);
    Navigator.pop(context, picked);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final filtered = _filtered;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.82),
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Distritos',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Cerrar',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar distrito',
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$_totalSelected de ${widget.maxDistricts} distritos',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'No hay distritos que coincidan.',
                              style: GoogleFonts.poppins(
                                color: AppBrandColors.textMuted,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final district = filtered[index];
                              final selected = _selectedIds.contains(district.id);
                              return Material(
                                color: selected
                                    ? AppBrandColors.primaryGreen.withValues(alpha: 0.1)
                                    : const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(14),
                                child: CheckboxListTile(
                                  value: selected,
                                  onChanged: (_) => _toggle(district),
                                  title: Text(
                                    district.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: district.label != district.name
                                      ? Text(
                                          district.label,
                                          style: GoogleFonts.poppins(fontSize: 12),
                                        )
                                      : null,
                                  activeColor: AppBrandColors.primaryGreen,
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _confirm,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppBrandColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          _selectedIds.isEmpty
                              ? 'Listo'
                              : 'Agregar ${_selectedIds.length} distrito${_selectedIds.length == 1 ? '' : 's'}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
