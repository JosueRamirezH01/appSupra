import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/categories/category_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/categories/categories_notifier.dart';
import '../../widgets/admin/category_form_dialog.dart';
import '../../widgets/common_widgets.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesListProvider(includeInactive: true));

    return AppScaffold(
      title: 'Categorías',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: categories.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(categoriesListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyView(message: 'No hay categorías');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final category = items[index];
              return Card(
                child: ListTile(
                  leading: _CategoryThumb(imageUrl: category.imageUrl),
                  title: Text(category.name),
                  subtitle: Text(category.status ? 'Activa' : 'Inactiva'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      try {
                        if (value == 'edit') {
                          await _showCategoryDialog(context, ref, category: category);
                        } else if (value == 'toggle') {
                          await ref
                              .read(categoriesListProvider(includeInactive: true).notifier)
                              .toggleStatus(category.id, !category.status);
                        } else if (value == 'subs') {
                          context.push(
                            '${RoutePaths.categories}/${category.id}/subcategories?name=${Uri.encodeComponent(category.name)}',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) showErrorSnackBar(context, e);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'subs', child: Text('Subcategorías')),
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(category.status ? 'Desactivar' : 'Activar'),
                      ),
                    ],
                  ),
                  onTap: () => context.push(
                    '${RoutePaths.categories}/${category.id}/subcategories?name=${Uri.encodeComponent(category.name)}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, {
    CategoryModel? category,
  }) async {
    final form = await showCategoryFormDialog(
      context: context,
      ref: ref,
      title: category == null ? 'Nueva categoría' : 'Editar categoría',
      initialName: category?.name,
      initialImageUrl: category?.imageUrl,
    );

    if (form == null) return;

    try {
      final notifier = ref.read(categoriesListProvider(includeInactive: true).notifier);
      if (category == null) {
        await notifier.create(form.name, imageUrl: form.imageUrl);
      } else {
        await notifier.updateCategory(
          category.id,
          form.name,
          imageUrl: form.imageUrl,
        );
      }
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }
}

class _CategoryThumb extends StatelessWidget {
  const _CategoryThumb({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.category_outlined),
        ),
      );
    }

    return const Icon(Icons.category_outlined);
  }
}
