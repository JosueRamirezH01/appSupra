import 'package:flutter/material.dart';

import '../../../data/models/categories/category_model.dart';
import 'home_category_circle.dart';
import 'home_layout_metrics.dart';

class HomeCategoriesGrid extends StatelessWidget {
  const HomeCategoriesGrid({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    final items = categories.where((c) => c.status).take(8).toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 4,
        childAspectRatio: HomeLayoutMetrics.categoryGridAspectRatio(context),
      ),
      itemBuilder: (context, index) {
        final category = items[index];
        return HomeCategoryCircle(
          label: category.name,
          imageUrl: category.imageUrl,
        );
      },
    );
  }
}
