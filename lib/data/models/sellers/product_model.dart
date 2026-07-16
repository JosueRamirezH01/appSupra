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
    this.subSubCategories = const [],
    this.offerings = const [],
    required this.status,
    required     this.images,
    this.seller,
    this.distanceKm,
  });

  factory ProductPublicModel.fromJson(Map<String, dynamic> json) {
    return ProductPublicModel(
      id: json['id'] as int,
      sellerId: json['sellerId'] as int,
      subcategoryId: json['subcategoryId'] as int,
      subcategoryName: json['subcategoryName'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String?,
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
    );
  }

  final int id;
  final int sellerId;
  final int subcategoryId;
  final String subcategoryName;
  final String title;
  final String? description;
  final List<ProductSubSubCategoryModel> subSubCategories;
  final List<String> offerings;
  final String status;
  final List<ProductImageModel> images;
  final ProductSellerSummaryModel? seller;
  final double? distanceKm;

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

class CreateProductRequest {
  const CreateProductRequest({
    required this.subcategoryId,
    required this.title,
    required this.imageUrls,
    this.description,
    this.subSubCategoryIds = const [],
    this.offerings = const [],
    this.status,
  });

  final int subcategoryId;
  final String title;
  final String? description;
  final List<int> subSubCategoryIds;
  final List<String> offerings;
  final String? status;
  final List<String> imageUrls;

  Map<String, dynamic> toJson() => {
        'subcategoryId': subcategoryId,
        'title': title,
        if (description != null && description!.trim().isNotEmpty)
          'description': description!.trim(),
        if (subSubCategoryIds.isNotEmpty) 'subSubCategoryIds': subSubCategoryIds,
        if (offerings.isNotEmpty) 'offerings': offerings,
        if (status != null) 'status': status,
        'imageUrls': imageUrls,
      };
}

class UpdateProductRequest {
  const UpdateProductRequest({
    this.subcategoryId,
    this.title,
    this.description,
    this.subSubCategoryIds,
    this.offerings,
    this.status,
    this.imageUrls,
  });

  final int? subcategoryId;
  final String? title;
  final String? description;
  final List<int>? subSubCategoryIds;
  final List<String>? offerings;
  final String? status;
  final List<String>? imageUrls;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (subcategoryId != null) json['subcategoryId'] = subcategoryId;
    if (title != null) json['title'] = title;
    if (description != null) json['description'] = description;
    if (subSubCategoryIds != null) json['subSubCategoryIds'] = subSubCategoryIds;
    if (offerings != null) json['offerings'] = offerings;
    if (status != null) json['status'] = status;
    if (imageUrls != null) json['imageUrls'] = imageUrls;
    return json;
  }
}
