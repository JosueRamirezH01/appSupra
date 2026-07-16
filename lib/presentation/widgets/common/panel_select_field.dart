import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../technician/technician_panel_theme.dart';

class PanelSelectOption<T> {
  const PanelSelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
}

/// Select accesible con hoja inferior: mejor en móvil que el dropdown nativo.
class PanelSelectField<T> extends FormField<T> {
  PanelSelectField({
    super.key,
    required this.label,
    required this.options,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    this.hintText = 'Seleccionar',
    this.helperText,
    super.enabled = true,
    this.leadingIcon,
    this.sheetTitle,
    this.searchable = true,
    this.onChanged,
  }) : super(
          builder: (field) {
            final widget = field.widget as PanelSelectField<T>;
            final PanelSelectOption<T>? selected = () {
              for (final option in widget.options) {
                if (option.value == field.value) return option;
              }
              return null;
            }();

            Future<void> openSheet() async {
              if (!widget.enabled) return;

              final picked = await showModalBottomSheet<T>(
                context: field.context,
                isScrollControlled: true,
                useSafeArea: false,
                backgroundColor: Colors.transparent,
                builder: (context) => _PanelSelectSheet<T>(
                  title: widget.sheetTitle ?? widget.label,
                  options: widget.options,
                  selectedValue: field.value,
                  searchable: widget.searchable && widget.options.length > 6,
                ),
              );

              if (picked == null) return;
              field.didChange(picked);
              widget.onChanged?.call(picked);
            }

            final hasError = field.hasError;
            final borderColor =
                hasError ? Colors.redAccent : Colors.transparent;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  button: true,
                  enabled: widget.enabled,
                  label: widget.label,
                  value: selected?.label ?? widget.hintText,
                  child: Material(
                    color: widget.enabled
                        ? AppBrandColors.fieldFill
                        : AppBrandColors.fieldFill.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: widget.enabled ? openSheet : null,
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: borderColor,
                            width: hasError ? 1.8 : 0,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (widget.leadingIcon != null) ...[
                              Icon(
                                widget.leadingIcon,
                                size: 20,
                                color: widget.enabled
                                    ? AppBrandColors.primaryGreen
                                    : AppBrandColors.textMuted,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.label,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppBrandColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    selected?.label ?? widget.hintText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: selected == null
                                          ? FontWeight.w500
                                          : FontWeight.w600,
                                      color: selected == null
                                          ? AppBrandColors.textMuted
                                          : AppBrandColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.expand_more_rounded,
                              color: widget.enabled
                                  ? AppBrandColors.textMuted
                                  : AppBrandColors.textMuted
                                      .withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.helperText != null && !hasError) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.helperText!,
                    style: TechnicianPanelTheme.subtitle.copyWith(fontSize: 12),
                  ),
                ],
                if (hasError) ...[
                  const SizedBox(height: 6),
                  Text(
                    field.errorText!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.redAccent,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            );
          },
        );

  final String label;
  final List<PanelSelectOption<T>> options;
  final String hintText;
  final String? helperText;
  final IconData? leadingIcon;
  final String? sheetTitle;
  final bool searchable;
  final ValueChanged<T>? onChanged;
}

class _PanelSelectSheet<T> extends StatefulWidget {
  const _PanelSelectSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.searchable,
  });

  final String title;
  final List<PanelSelectOption<T>> options;
  final T? selectedValue;
  final bool searchable;

  @override
  State<_PanelSelectSheet<T>> createState() => _PanelSelectSheetState<T>();
}

class _PanelSelectSheetState<T> extends State<_PanelSelectSheet<T>> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PanelSelectOption<T>> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.options;

    return widget.options
        .where(
          (item) =>
              item.label.toLowerCase().contains(query) ||
              (item.subtitle?.toLowerCase().contains(query) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final maxHeight = mediaQuery.size.height * 0.78;
    final filtered = _filtered;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Material(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                            widget.title,
                            style: TechnicianPanelTheme.title,
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
                  if (widget.searchable) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar...',
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
                  ],
                  Flexible(
                    child: filtered.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No hay opciones que coincidan con tu búsqueda.',
                              textAlign: TextAlign.center,
                              style: TechnicianPanelTheme.subtitle,
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final option = filtered[index];
                              final selected =
                                  option.value == widget.selectedValue;

                              return Semantics(
                                button: true,
                                selected: selected,
                                label: option.label,
                                child: Material(
                                  color: selected
                                      ? AppBrandColors.primaryGreen
                                          .withValues(alpha: 0.1)
                                      : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(14),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: () =>
                                        Navigator.pop(context, option.value),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 14,
                                      ),
                                      child: Row(
                                        children: [
                                          if (option.leading != null) ...[
                                            option.leading!,
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  option.label,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: selected
                                                        ? FontWeight.w700
                                                        : FontWeight.w600,
                                                    color:
                                                        AppBrandColors.textDark,
                                                  ),
                                                ),
                                                if (option.subtitle != null) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    option.subtitle!,
                                                    style: TechnicianPanelTheme
                                                        .subtitle,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            selected
                                                ? Icons.check_circle_rounded
                                                : Icons
                                                    .radio_button_unchecked_rounded,
                                            color: selected
                                                ? AppBrandColors.primaryGreen
                                                : const Color(0xFFD1D5DB),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
