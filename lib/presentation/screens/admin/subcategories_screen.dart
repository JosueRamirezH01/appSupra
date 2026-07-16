import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/categories/category_model.dart';
import '../../providers/categories/categories_notifier.dart';
import '../../widgets/admin/category_form_dialog.dart';
import '../../widgets/common_widgets.dart';

class SubcategoriesScreen extends ConsumerWidget {
  const SubcategoriesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final int categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategories = ref.watch(subcategoriesListProvider(categoryId));

    return AppScaffold(
      title: 'Subcategorías — $categoryName',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: subcategories.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(subcategoriesListProvider(categoryId)),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyView(message: 'No hay subcategorías');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: _CategoryThumb(imageUrl: item.imageUrl),
                  title: Text(item.name),
                  subtitle: Text(item.status ? 'Activa' : 'Inactiva'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      try {
                        final notifier =
                            ref.read(subcategoriesListProvider(categoryId).notifier);
                        if (value == 'edit') {
                          await _showDialog(context, ref, item: item);
                        } else if (value == 'toggle') {
                          await notifier.toggleStatus(item.id, !item.status);
                        } else if (value == 'subs') {
                          context.push(
                            '/admin/categories/$categoryId/subcategories/${item.id}/sub-subcategories?name=${Uri.encodeComponent(item.name)}',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) showErrorSnackBar(context, e);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'subs', child: Text('Sub-subcategorías')),
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                      const PopupMenuItem(value: 'toggle', child: Text('Activar/Desactivar')),
                    ],
                  ),
                  onTap: () => context.push(
                    '/admin/categories/$categoryId/subcategories/${item.id}/sub-subcategories?name=${Uri.encodeComponent(item.name)}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDialog(
    BuildContext context,
    WidgetRef ref, {
    SubcategoryModel? item,
  }) async {
    final form = await showCategoryFormDialog(
      context: context,
      ref: ref,
      title: item == null ? 'Nueva subcategoría' : 'Editar subcategoría',
      initialName: item?.name,
      initialImageUrl: item?.imageUrl,
    );

    if (form == null) return;

    try {
      final notifier = ref.read(subcategoriesListProvider(categoryId).notifier);
      if (item == null) {
        await notifier.create(form.name, imageUrl: form.imageUrl);
      } else {
        await notifier.updateSubcategory(
          item.id,
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
          errorBuilder: (_, __, ___) => const Icon(Icons.layers_outlined),
        ),
      );
    }

    return const Icon(Icons.layers_outlined);
  }
}
