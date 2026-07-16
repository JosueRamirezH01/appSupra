import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/route_paths.dart';
import '../../providers/categories/home_catalog_provider.dart';
import '../common_widgets.dart';
import 'home_subcategories_row.dart';

class HomeCatalogSections extends ConsumerWidget {
  const HomeCatalogSections({
    super.key,
    this.onProfessionSubcategoryTap,
    this.onProductSubcategoryTap,
  });

  final void Function(int subcategoryId)? onProfessionSubcategoryTap;
  final void Function(int subcategoryId)? onProductSubcategoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(homeCatalogSectionsProvider);

    return sections.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: LoadingView(message: 'Cargando servicios...'),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(homeCatalogSectionsProvider),
        ),
      ),
      data: (data) {
        final rows = <Widget>[];

        if (data.professions != null) {
          rows.add(
            HomeSubcategoriesRow(
              icon: Icons.engineering,
              section: data.professions!,
              showAllSubcategories: true,
              onSubcategoryTap: onProfessionSubcategoryTap == null
                  ? null
                  : (item) => onProfessionSubcategoryTap!(item.id),
            ),
          );
        }

        if (data.products != null) {
          rows.add(
            HomeSubcategoriesRow(
              icon: Icons.inventory_2,
              section: data.products!,
              onSubcategoryTap: onProductSubcategoryTap == null
                  ? null
                  : (item) => onProductSubcategoryTap!(item.id),
              onSeeMoreTap: () => context.push(RoutePaths.productsBrowse),
            ),
          );
        }

        if (rows.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: EmptyView(
              message: 'Aún no hay subcategorías publicadas.',
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }
}
