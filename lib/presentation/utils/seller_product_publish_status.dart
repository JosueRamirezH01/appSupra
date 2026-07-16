import '../../../data/models/sellers/product_model.dart';

/// Filtros de visibilidad para el vendedor (UX de 2 estados).
abstract final class SellerProductPublishFilter {
  static const published = 'activo';
  static const unpublished = 'no_publicado';
}

bool isSellerProductPublished(String status) => status == 'activo';

String sellerProductApiStatus({required bool published, required bool sellerApproved}) {
  if (published && sellerApproved) return 'activo';
  return 'borrador';
}

bool sellerProductPublishedFromApi(String status) => status == 'activo';

Map<String, int> sellerProductPublishCounts(List<ProductPublicModel> products) {
  var published = 0;
  var unpublished = 0;

  for (final product in products) {
    if (isSellerProductPublished(product.status)) {
      published++;
    } else {
      unpublished++;
    }
  }

  return {
    SellerProductPublishFilter.published: published,
    SellerProductPublishFilter.unpublished: unpublished,
  };
}

List<ProductPublicModel> filterSellerProductsByPublishStatus(
  List<ProductPublicModel> products,
  String? filter,
) {
  if (filter == null) return products;

  if (filter == SellerProductPublishFilter.published) {
    return products.where((product) => isSellerProductPublished(product.status)).toList();
  }

  if (filter == SellerProductPublishFilter.unpublished) {
    return products.where((product) => !isSellerProductPublished(product.status)).toList();
  }

  return products;
}
