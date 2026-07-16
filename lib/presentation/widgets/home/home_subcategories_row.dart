import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../data/models/categories/category_model.dart';
import '../../../routes/route_paths.dart';
import '../../models/home_catalog_section.dart';
import 'home_category_circle.dart';
import 'home_layout_metrics.dart';

class HomeSubcategoriesRow extends StatelessWidget {
  const HomeSubcategoriesRow({
    super.key,
    required this.section,
    required this.icon,
    this.previewCount = CatalogConstants.homePreviewDisplayCount,
    this.showAllSubcategories = false,
    this.onSubcategoryTap,
    this.onSeeMoreTap,
  });
  final IconData icon;
  final HomeCatalogSection section;
  final int previewCount;
  final bool showAllSubcategories;
  final ValueChanged<SubcategoryModel>? onSubcategoryTap;
  final VoidCallback? onSeeMoreTap;

  @override
  Widget build(BuildContext context) {
    final visibleItems = showAllSubcategories
        ? section.subcategories
        : section.subcategories.take(previewCount).toList();
    final totalCount = section.totalSubcategories ?? section.subcategories.length;
    final showSeeMore = !showAllSubcategories && totalCount > previewCount;
    final itemCount = visibleItems.length + (showSeeMore ? 1 : 0);
    final itemWidth = HomeLayoutMetrics.categoryItemWidth(context);
    final rowHeight = HomeLayoutMetrics.categoryRowHeight(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: Row(
            children: [
              Icon(icon, size: 20),
              SizedBox(width: 8),
              Text(
                section.title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: rowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: itemCount,
            separatorBuilder: (_, _) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              if (showSeeMore && index == visibleItems.length) {
                return SizedBox(
                  width: itemWidth,
                  height: rowHeight,
                  child: HomeSeeMoreCircle(
                    onTap: onSeeMoreTap ??
                        () => context.push(
                              RoutePaths.exploreSubcategoriesPath(
                                section.categoryId,
                                title: section.title,
                              ),
                            ),
                  ),
                );
              }

              final item = visibleItems[index];
              return SizedBox(
                width: itemWidth,
                height: rowHeight,
                child: HomeCategoryCircle(
                  label: item.name,
                  imageUrl: item.imageUrl,
                  onTap: onSubcategoryTap == null
                      ? null
                      : () => onSubcategoryTap!(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
