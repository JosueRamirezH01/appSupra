import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class SellerStoreStickyChrome extends StatelessWidget {
  const SellerStoreStickyChrome({
    super.key,
    required this.storeName,
    required this.searchController,
    required this.searchFocus,
    required this.onBack,
    required this.onQueryChanged,
    required this.barOpacity,
    required this.showCategories,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.chipKeys = const {},
  });

  final String storeName;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onBack;
  final ValueChanged<String> onQueryChanged;
  final double barOpacity;
  final bool showCategories;
  final List<({int id, String name})> categories;
  final int? selectedCategoryId;
  final ValueChanged<int> onCategorySelected;
  final Map<int, GlobalKey> chipKeys;

  static const side = 16.0;
  static const backSize = 40.0;
  static const barRowHeight = 40.0;
  static const barInset = 8.0;
  static const chipsHeight = 48.0;

  static double compactHeightFor(BuildContext context) {
    return MediaQuery.paddingOf(context).top + barInset * 2 + barRowHeight;
  }

  static double pinHeightFor(BuildContext context, {required bool chipsVisible}) {
    final compact = compactHeightFor(context);
    return chipsVisible ? compact + chipsHeight : compact;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final visible = barOpacity > 0.02 || showCategories;
    if (!visible) return const SizedBox.shrink();

    return IgnorePointer(
      ignoring: barOpacity < 0.4 && !showCategories,
      child: Opacity(
        opacity: showCategories ? 1 : barOpacity.clamp(0.0, 1.0),
        child: Material(
          color: Colors.white,
          elevation: 3,
          shadowColor: const Color(0x330B1C15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(side, top + barInset, side, barInset),
                child: SizedBox(
                  height: barRowHeight,
                  child: Row(
                    children: [
                      _BackButton(onPressed: onBack),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          focusNode: searchFocus,
                          textInputAction: TextInputAction.search,
                          onChanged: onQueryChanged,
                          style: GoogleFonts.poppins(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Buscar en $storeName',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppBrandColors.textMuted,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppBrandColors.textMuted,
                              size: 22,
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 32,
                            ),
                            suffixIcon: searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      onQueryChanged('');
                                    },
                                    icon: const Icon(Icons.close_rounded, size: 18),
                                  ),
                            filled: true,
                            fillColor: AppBrandColors.fieldFill,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showCategories)
                SizedBox(
                  height: chipsHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(side, 0, side, 10),
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = categories[index];
                      return KeyedSubtree(
                        key: chipKeys[item.id],
                        child: _CategoryChip(
                          label: item.name,
                          selected: item.id == selectedCategoryId,
                          onTap: () => onCategorySelected(item.id),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppBrandColors.fieldFill,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox(
          width: SellerStoreStickyChrome.backSize,
          height: SellerStoreStickyChrome.backSize,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppBrandColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppBrandColors.primaryGreen
          : AppBrandColors.fieldFill,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppBrandColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
