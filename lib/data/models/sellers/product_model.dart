import '../common/pagination_model.dart';

class ProductImageModel {
  const ProductImageModel({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
    required this.isPrimary,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  final int id;
  final String imageUrl;
  final int sortOrder;
  final bool isPrimary;
}

class ProductSubSubCategoryModel {
  const ProductSubSubCategoryModel({
    required this.id,
    required this.name,
    this.contactMetricType = 'none',
  });

  factory ProductSubSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductSubSubCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      contactMetricType: json['contactMetricType'] as String? ?? 'none',
    );
  }

  final int id;
  final String name;
  final String contactMetricType;
}

class ProductSellerSummaryModel {
  const ProductSellerSummaryModel({
    required this.id,
    required this.businessName,
    this.logoUrl,
    required this.verified,
  });

  factory ProductSellerSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSellerSummaryModel(
      id: json['id'] as int,
      businessName: json['businessName'] as String,
      logoUrl: json['logoUrl'] as String?,
      verified: json['verified'] as bool? ?? false,
    );
  }

  final int id;
  final String businessName;
  final String? logoUrl;
  final bool verified;
}

class ProductPublicModel {
  const ProductPublicModel({
    required this.id,
    required this.sellerId,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.title,
    this.description,
    this.price,
    this.compareAtPrice,
    this.saleUnit,
    this.subSubCategories = const [],
    this.offerings = const [],
    required this.status,
    required this.images,
    this.seller,
    this.distanceKm,
    this.isStarred = false,
  });

  factory ProductPublicModel.fromJson(Map<String, dynamic> json) {
    return ProductPublicModel(
      id: json['id'] as int,
      sellerId: json['sellerId'] as int,
      subcategoryId: json['subcategoryId'] as int,
      subcategoryName: json['subcategoryName'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
      saleUnit: json['saleUnit'] as String?,
      subSubCategories: (json['subSubCategories'] as List<dynamic>? ?? [])
          .map(
            (e) => ProductSubSubCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      offerings: (json['offerings'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      status: json['status'] as String? ?? 'activo',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      seller: json['seller'] == null
          ? null
          : ProductSellerSummaryModel.fromJson(
              json['seller'] as Map<String, dynamic>,
            ),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      isStarred: json['isStarred'] as bool? ?? false,
    );
  }

  final int id;
  final int sellerId;
  final int subcategoryId;
  final String subcategoryName;
  final String title;
  final String? description;
  final double? price;
  final double? compareAtPrice;
  /// Unidad del precio referencial. Null si no hay precio.
  final String? saleUnit;
  final List<ProductSubSubCategoryModel> subSubCategories;
  final List<String> offerings;
  final String status;
  final List<ProductImageModel> images;
  final ProductSellerSummaryModel? seller;
  final double? distanceKm;
  final bool isStarred;

  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    final primary = images.where((image) => image.isPrimary).toList();
    return (primary.isNotEmpty ? primary.first : images.first).imageUrl;
  }

  List<String> get materialLabels => [
        ...subSubCategories.map((item) => item.name),
        ...offerings,
      ];

  String? get materialsPreview {
    final labels = materialLabels;
    if (labels.isEmpty) return null;
    if (labels.length <= 2) return labels.join(' · ');
    return '${labels[0]} · ${labels[1]} · +${labels.length - 2}';
  }
}

class ProductSearchSuggestionModel {
  const ProductSearchSuggestionModel({
    required this.type,
    required this.id,
    required this.name,
    this.subcategoryId,
    this.subcategoryName,
  });

  factory ProductSearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchSuggestionModel(
      type: json['type'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
      subcategoryId: json['subcategoryId'] as int?,
      subcategoryName: json['subcategoryName'] as String?,
    );
  }

  final String type;
  final int id;
  final String name;
  final int? subcategoryId;
  final String? subcategoryName;

  bool get isSubcategory => type == 'subcategory';
}

class ProductsQuery {
  const ProductsQuery({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.categoryId,
    this.subcategoryId,
    this.sellerId,
    this.lat,
    this.lng,
    this.radiusKm,
  });

  final int page;
  final int limit;
  final String? search;
  final int? categoryId;
  final int? subcategoryId;
  final int? sellerId;
  final double? lat;
  final double? lng;
  final int? radiusKm;
}

class RelatedProductsQuery {
  const RelatedProductsQuery({
    required this.professionSubcategoryId,
    this.page = 1,
    this.limit = 4,
    this.groupsLimit = 3,
    this.lat,
    this.lng,
    this.radiusKm,
  });

  final int professionSubcategoryId;
  final int page;
  final int limit;
  final int groupsLimit;
  final double? lat;
  final double? lng;
  final int? radiusKm;
}

class RelatedProductsBySubSubQuery {
  const RelatedProductsBySubSubQuery({
    required this.professionSubSubCategoryId,
    this.page = 1,
    this.limit = 4,
    this.groupsLimit = 3,
    this.view = 'carousel',
    this.lat,
    this.lng,
    this.radiusKm,
  });

  final int professionSubSubCategoryId;
  final int page;
  final int limit;
  final int groupsLimit;
  final String view;
  final double? lat;
  final double? lng;
  final int? radiusKm;
}

class RelatedProductGroup {
  const RelatedProductGroup({
    required this.subcategoryId,
    required this.subcategoryName,
    required this.products,
  });

  final int subcategoryId;
  final String subcategoryName;
  final List<ProductPublicModel> products;
}

class RelatedProductsResult {
  const RelatedProductsResult({
    this.layout = 'groups',
    this.groups = const [],
    this.products = const [],
    this.hasMore = false,
    this.total = 0,
    this.pagination,
  });

  final String layout;
  final List<RelatedProductGroup> groups;
  final List<ProductPublicModel> products;
  final bool hasMore;
  final int total;
  final PaginationModel? pagination;

  bool get isEmpty => products.isEmpty && groups.isEmpty;

  /// Prefiere `groups` del API. `layout: carousel` es un riel plano (destacados).
  factory RelatedProductsResult.fromApi(Map<String, dynamic> data) {
    final layout = data['layout'] as String?;
    final hasMore = data['hasMore'] as bool? ?? false;
    final total = (data['total'] as num?)?.toInt() ?? 0;
    final paginationJson = data['pagination'] as Map<String, dynamic>?;
    final pagination = paginationJson == null
        ? null
        : PaginationModel.fromJson(paginationJson);

    if (layout == 'carousel' || layout == 'catalog') {
      final products = (data['products'] as List<dynamic>? ?? [])
          .map((e) => ProductPublicModel.fromJson(e as Map<String, dynamic>))
          .where((product) => product.id > 0)
          .toList();
      final carouselProducts =
          layout == 'carousel' ? products.take(6).toList() : products;

      return RelatedProductsResult(
        layout: layout ?? 'carousel',
        products: carouselProducts,
        hasMore: hasMore,
        total: total,
        pagination: pagination,
        groups: carouselProducts.isEmpty
            ? const []
            : [
                RelatedProductGroup(
                  subcategoryId: 0,
                  subcategoryName: 'Materiales',
                  products: carouselProducts,
                ),
              ],
      );
    }
    final parsedGroups = (data['groups'] as List<dynamic>? ?? [])
        .map(_groupFromJson)
        .where((group) => group.products.isNotEmpty)
        .take(3)
        .toList();

    if (parsedGroups.isNotEmpty) {
      return RelatedProductsResult(
        groups: parsedGroups,
        products: parsedGroups.expand((group) => group.products).toList(),
      );
    }

    final products = (data['products'] as List<dynamic>? ?? [])
        .map((e) => ProductPublicModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return RelatedProductsResult(
      groups: _groupsFromFlatProducts(products),
      products: products,
    );
  }

  static RelatedProductGroup _groupFromJson(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    final subcategory = json['subcategory'] as Map<String, dynamic>?;
    final products = (json['products'] as List<dynamic>? ?? [])
        .map((e) => ProductPublicModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return RelatedProductGroup(
      subcategoryId: (subcategory?['id'] as num?)?.toInt() ??
          (products.isEmpty ? 0 : products.first.subcategoryId),
      subcategoryName: (subcategory?['name'] as String?)?.trim().isNotEmpty == true
          ? subcategory!['name'] as String
          : (products.isEmpty ? 'Materiales' : products.first.subcategoryName),
      products: products,
    );
  }

  static List<RelatedProductGroup> _groupsFromFlatProducts(
    List<ProductPublicModel> products,
  ) {
    if (products.isEmpty) return const [];

    final order = <int>[];
    final byRubro = <int, List<ProductPublicModel>>{};

    for (final product in products) {
      byRubro.putIfAbsent(product.subcategoryId, () {
        order.add(product.subcategoryId);
        return <ProductPublicModel>[];
      }).add(product);
    }

    return order
        .map(
          (id) => RelatedProductGroup(
            subcategoryId: id,
            subcategoryName: byRubro[id]!.first.subcategoryName,
            products: byRubro[id]!.take(4).toList(),
          ),
        )
        .take(3)
        .toList();
  }
}

class ProductOffersQuery {
  const ProductOffersQuery({
    this.view = 'carousel',
    this.page = 1,
    this.limit = 6,
    this.lat,
    this.lng,
    this.radiusKm,
  });

  final String view;
  final int page;
  final int limit;
  final double? lat;
  final double? lng;
  final int? radiusKm;
}

class ProductOffersResult {
  const ProductOffersResult({
    this.layout = 'carousel',
    this.products = const [],
    this.hasMore = false,
    this.total = 0,
    this.pagination,
  });

  final String layout;
  final List<ProductPublicModel> products;
  final bool hasMore;
  final int total;
  final PaginationModel? pagination;

  bool get isEmpty => products.isEmpty;

  factory ProductOffersResult.fromApi(Map<String, dynamic> data) {
    final layout = data['layout'] as String? ?? 'carousel';
    final products = (data['products'] as List<dynamic>? ?? [])
        .map((e) => ProductPublicModel.fromJson(e as Map<String, dynamic>))
        .where((product) => product.id > 0)
        .toList();
    final paginationJson = data['pagination'] as Map<String, dynamic>?;

    return ProductOffersResult(
      layout: layout,
      products: products,
      hasMore: data['hasMore'] as bool? ?? false,
      total: (data['total'] as num?)?.toInt() ?? 0,
      pagination: paginationJson == null
          ? null
          : PaginationModel.fromJson(paginationJson),
    );
  }
}

class ProductsListResult {
  const ProductsListResult({
    required this.products,
    required this.pagination,
    this.searchSuggestions = const [],
  });

  final List<ProductPublicModel> products;
  final PaginationModel pagination;
  final List<ProductSearchSuggestionModel> searchSuggestions;
}

class MyProductsQuery {
  const MyProductsQuery({
    this.page = 1,
    this.limit = 20,
    this.publishStatus,
  });

  final int page;
  final int limit;

  /// `activo` | `no_publicado` (filtro del panel).
  final String? publishStatus;
}

class MyProductsCounts {
  const MyProductsCounts({
    required this.total,
    required this.published,
    required this.unpublished,
    this.starred = 0,
  });

  factory MyProductsCounts.fromJson(Map<String, dynamic> json) {
    return MyProductsCounts(
      total: (json['total'] as num?)?.toInt() ?? 0,
      published: (json['published'] as num?)?.toInt() ?? 0,
      unpublished: (json['unpublished'] as num?)?.toInt() ?? 0,
      starred: (json['starred'] as num?)?.toInt() ?? 0,
    );
  }

  final int total;
  final int published;
  final int unpublished;
  final int starred;
}

class MyProductsListResult {
  const MyProductsListResult({
    required this.products,
    required this.pagination,
    required this.counts,
  });

  final List<ProductPublicModel> products;
  final PaginationModel pagination;
  final MyProductsCounts counts;
}

class CreateProductRequest {
  const CreateProductRequest({
    required this.subcategoryId,
    required this.title,
    required this.imageUrls,
    this.description,
    this.price,
    this.compareAtPrice,
    this.saleUnit,
    this.subSubCategoryIds = const [],
    this.offerings = const [],
    this.status,
    this.isStarred,
  });

  final int subcategoryId;
  final String title;
  final String? description;
  final double? price;
  final double? compareAtPrice;
  final String? saleUnit;
  final List<int> subSubCategoryIds;
  final List<String> offerings;
  final String? status;
  final List<String> imageUrls;
  final bool? isStarred;

  Map<String, dynamic> toJson() => {
        'subcategoryId': subcategoryId,
        'title': title,
        if (description != null && description!.trim().isNotEmpty)
          'description': description!.trim(),
        'price': price,
        'compareAtPrice': compareAtPrice,
        'saleUnit': price != null ? saleUnit : null,
        if (subSubCategoryIds.isNotEmpty) 'subSubCategoryIds': subSubCategoryIds,
        if (offerings.isNotEmpty) 'offerings': offerings,
        if (status != null) 'status': status,
        'imageUrls': imageUrls,
        if (isStarred != null) 'isStarred': isStarred,
      };
}

class UpdateProductRequest {
  const UpdateProductRequest({
    this.subcategoryId,
    this.title,
    this.description,
    this.price,
    this.compareAtPrice,
    this.saleUnit,
    this.subSubCategoryIds,
    this.offerings,
    this.status,
    this.imageUrls,
    this.setPricing = false,
    this.isStarred,
  });

  final int? subcategoryId;
  final String? title;
  final String? description;
  final double? price;
  final double? compareAtPrice;
  final String? saleUnit;
  final List<int>? subSubCategoryIds;
  final List<String>? offerings;
  final String? status;
  final List<String>? imageUrls;
  final bool setPricing;
  final bool? isStarred;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (subcategoryId != null) json['subcategoryId'] = subcategoryId;
    if (title != null) json['title'] = title;
    if (description != null) json['description'] = description;
    if (setPricing) {
      json['price'] = price;
      json['compareAtPrice'] = compareAtPrice;
      json['saleUnit'] = price != null ? saleUnit : null;
    }
    if (subSubCategoryIds != null) json['subSubCategoryIds'] = subSubCategoryIds;
    if (offerings != null) json['offerings'] = offerings;
    if (status != null) json['status'] = status;
    if (imageUrls != null) json['imageUrls'] = imageUrls;
    if (isStarred != null) json['isStarred'] = isStarred;
    return json;
  }
}
