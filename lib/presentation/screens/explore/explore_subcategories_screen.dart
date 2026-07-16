import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/home_catalog_section.dart';
import '../../providers/categories/home_catalog_provider.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/home/home_category_circle.dart';
import '../../../routes/route_paths.dart';

class ExploreSubcategoriesScreen extends ConsumerWidget {
  const ExploreSubcategoriesScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  final int categoryId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategoriesAsync = ref.watch(exploreSubcategoriesProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
      ),
      body: subcategoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error al cargar subcategorías: $error'),
          ),
        ),
        data: (subcategories) {
          if (subcategories.isEmpty) {
            return const Center(child: Text('No hay subcategorías disponibles'));
          }

          return FutureBuilder<bool>(
            future: _isProductCategory(ref, categoryId),
            builder: (context, snapshot) {
              final isProducts = snapshot.data ?? false;

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.74,
                ),
                itemCount: subcategories.length,
                itemBuilder: (context, index) {
                  final item = subcategories[index];
                  return HomeCategoryCircle(
                    label: item.name,
                    imageUrl: item.imageUrl,
                    onTap: () {
                      if (isProducts) {
                        context.push(
                          RoutePaths.productsBrowsePath(subcategoryId: item.id),
                        );
                      } else {
                        context.push(
                          RoutePaths.professionalsBrowsePath(
                            subcategoryId: item.id,
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _isProductCategory(WidgetRef ref, int categoryId) async {
    final categories = await ref.read(categoriesRepositoryProvider).getCategories();
    for (final category in categories) {
      if (category.id == categoryId) {
        return matchesProductCategory(category.name);
      }
    }
    return false;
  }
}
