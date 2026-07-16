import '../common/pagination_model.dart';
import '../sellers/product_model.dart';
import '../technicians/technician_model.dart';

enum SearchResultType {
  all('all'),
  technicians('technicians'),
  products('products');

  const SearchResultType(this.apiValue);

  final String apiValue;
}

class SearchHistoryItemModel {
  const SearchHistoryItemModel({
    required this.id,
    required this.term,
    required this.lastUsedAt,
  });

  factory SearchHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItemModel(
      id: json['id'] as int,
      term: json['term'] as String,
      lastUsedAt: DateTime.parse(json['lastUsedAt'] as String),
    );
  }

  final int id;
  final String term;
  final DateTime lastUsedAt;
}

class SearchSuggestResult {
  const SearchSuggestResult({
    this.recent = const [],
    this.popular = const [],
    this.technicians = const [],
    this.products = const [],
    this.categories = const [],
  });

  factory SearchSuggestResult.fromJson(Map<String, dynamic> json) {
    return SearchSuggestResult(
      recent: (json['recent'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                SearchHistoryItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      popular: (json['popular'] as List<dynamic>? ?? [])
          .map((item) => item as String)
          .toList(),
      technicians: (json['technicians'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                TechnicianPublicModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      products: (json['products'] as List<dynamic>? ?? [])
          .map(
            (item) => ProductPublicModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (item) => ProductSearchSuggestionModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  final List<SearchHistoryItemModel> recent;
  final List<String> popular;
  final List<TechnicianPublicModel> technicians;
  final List<ProductPublicModel> products;
  final List<ProductSearchSuggestionModel> categories;

  bool get hasMatches =>
      technicians.isNotEmpty || products.isNotEmpty || categories.isNotEmpty;
}

class SearchQueryResult {
  const SearchQueryResult({
    required this.type,
    this.technicians = const [],
    this.techniciansPagination,
    this.products = const [],
    this.productsPagination,
  });

  factory SearchQueryResult.fromJson(Map<String, dynamic> json) {
    final typeRaw = json['type'] as String? ?? 'all';
    final type = SearchResultType.values.firstWhere(
      (value) => value.apiValue == typeRaw,
      orElse: () => SearchResultType.all,
    );

    return SearchQueryResult(
      type: type,
      technicians: (json['technicians'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                TechnicianPublicModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      techniciansPagination: json['techniciansPagination'] == null
          ? null
          : PaginationModel.fromJson(
              json['techniciansPagination'] as Map<String, dynamic>,
            ),
      products: (json['products'] as List<dynamic>? ?? [])
          .map(
            (item) => ProductPublicModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      productsPagination: json['productsPagination'] == null
          ? null
          : PaginationModel.fromJson(
              json['productsPagination'] as Map<String, dynamic>,
            ),
    );
  }

  final SearchResultType type;
  final List<TechnicianPublicModel> technicians;
  final PaginationModel? techniciansPagination;
  final List<ProductPublicModel> products;
  final PaginationModel? productsPagination;
}

class SearchQuery {
  const SearchQuery({
    required this.q,
    this.type = SearchResultType.all,
    this.page = 1,
    this.limit = 20,
    this.lat,
    this.lng,
    this.radiusKm,
  });

  final String q;
  final SearchResultType type;
  final int page;
  final int limit;
  final double? lat;
  final double? lng;
  final int? radiusKm;
}

class SearchSuggestRequest {
  const SearchSuggestRequest({
    this.query,
    this.lat,
    this.lng,
    this.radiusKm,
  });

  final String? query;
  final double? lat;
  final double? lng;
  final int? radiusKm;
}
