import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/categories/category_model.dart';
import '../repository_providers.dart';

/// Fuente canónica de categorías activas para experiencias públicas.
///
/// Los consumidores comparten una sola petición en lugar de consultar
/// `/categories` de forma independiente.
final activeCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.read(categoriesRepositoryProvider).getCategories();
});
