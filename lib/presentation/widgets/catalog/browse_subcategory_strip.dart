import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/categories/category_model.dart';
import '../home/home_category_circle.dart';

class BrowseSubcategoryStrip extends StatefulWidget {
  const BrowseSubcategoryStrip({
    super.key,
    required this.subcategories,
    required this.selectedSubcategoryId,
    required this.onSelected,
  });

  final List<SubcategoryModel> subcategories;
  final int? selectedSubcategoryId;
  final ValueChanged<int?> onSelected;

  @override
  State<BrowseSubcategoryStrip> createState() => _BrowseSubcategoryStripState();
}

class _BrowseSubcategoryStripState extends State<BrowseSubcategoryStrip> {
  final _scrollController = ScrollController();
  final _itemKeys = <int, GlobalKey>{};

  @override
  void didUpdateWidget(covariant BrowseSubcategoryStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSubcategoryId != widget.selectedSubcategoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    final selectedId = widget.selectedSubcategoryId;
    if (selectedId == null) return;
    final key = _itemKeys[selectedId];
    final context = key?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      alignment: 0.4,
    );
  }

  GlobalKey _keyFor(int subcategoryId) =>
      _itemKeys.putIfAbsent(subcategoryId, GlobalKey.new);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width * 0.2;

    return SizedBox(
      height: size.height * 0.12,
      child: ListView.separated(
        controller: _scrollController,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        itemCount: widget.subcategories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final selected = widget.selectedSubcategoryId == null;
            return SizedBox(
              width: itemWidth,
              child: _BrowseCategoryItem(
                selected: selected,
                child: HomeCategoryCircle(
                  label: 'TODOS',
                  icon: Icons.apps_rounded,
                  selected: selected,
                  labelColor: Colors.white,
                  selectedBorderColor: AppBrandColors.primaryGreen,
                  onTap: () => widget.onSelected(null),
                ),
              ),
            );
          }

          final item = widget.subcategories[index - 1];
          final selected = widget.selectedSubcategoryId == item.id;

          return SizedBox(
            key: _keyFor(item.id),
            width: itemWidth,
            child: _BrowseCategoryItem(
              selected: selected,
              child: HomeCategoryCircle(
                label: item.name.toUpperCase(),
                imageUrl: item.imageUrl,
                selected: selected,
                labelColor: Colors.white,
                selectedBorderColor: AppBrandColors.primaryGreen,
                onTap: () => widget.onSelected(item.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BrowseCategoryItem extends StatelessWidget {
  const _BrowseCategoryItem({
    required this.selected,
    required this.child,
  });

  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.03 : 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}

String? resolveSubcategoryLabel(
  List<SubcategoryModel> subcategories,
  int? subcategoryId,
) {
  if (subcategoryId == null) return null;
  for (final item in subcategories) {
    if (item.id == subcategoryId) return item.name;
  }
  return null;
}
