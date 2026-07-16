import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/categories/category_model.dart';
import '../../providers/categories/categories_notifier.dart';
import '../../widgets/admin/category_form_dialog.dart';
import '../../widgets/common_widgets.dart';

class SubSubCategoriesScreen extends ConsumerWidget {
  const SubSubCategoriesScreen({
    super.key,
    required this.subcategoryId,
    required this.subcategoryName,
  });

  final int subcategoryId;
  final String subcategoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(subSubCategoriesListProvider(subcategoryId));

    return AppScaffold(
      title: 'Sub-subcategorías — $subcategoryName',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: items.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(subSubCategoriesListProvider(subcategoryId)),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyView(message: 'No hay sub-subcategorías');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                child: ListTile(
                  leading: _CategoryThumb(imageUrl: item.imageUrl),
                  title: Text(item.name),
                  subtitle: Text(item.status ? 'Activa' : 'Inactiva'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      try {
                        final notifier =
                            ref.read(subSubCategoriesListProvider(subcategoryId).notifier);
                        if (value == 'edit') {
                          await _showDialog(context, ref, item: item);
                        } else if (value == 'toggle') {
                          await notifier.toggleStatus(item.id, !item.status);
                        }
                      } catch (e) {
                        if (context.mounted) showErrorSnackBar(context, e);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(value: 'toggle', child: Text('Activar/Desactivar')),
                    ],
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
    SubSubCategoryModel? item,
  }) async {
    final form = await showCategoryFormDialog(
      context: context,
      ref: ref,
      title: item == null ? 'Nueva sub-subcategoría' : 'Editar',
      initialName: item?.name,
      initialImageUrl: item?.imageUrl,
    );

    if (form == null) return;

    try {
      final notifier = ref.read(subSubCategoriesListProvider(subcategoryId).notifier);
      if (item == null) {
        await notifier.create(form.name, imageUrl: form.imageUrl);
      } else {
        await notifier.updateSubSubCategory(
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
          errorBuilder: (_, __, ___) => const Icon(Icons.account_tree_outlined),
        ),
      );
    }

    return const Icon(Icons.account_tree_outlined);
  }
}
