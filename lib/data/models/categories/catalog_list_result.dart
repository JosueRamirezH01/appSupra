class CatalogListQuery {
  const CatalogListQuery({
    this.page,
    this.limit,
    this.search,
    this.includeInactive = false,
  });

  final int? page;
  final int? limit;
  final String? search;
  final bool includeInactive;

  Map<String, dynamic>? toQueryParameters() {
    final params = <String, dynamic>{};
    if (includeInactive) params['includeInactive'] = 'true';
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (search != null && search!.trim().isNotEmpty) {
      params['search'] = search!.trim();
    }
    return params.isEmpty ? null : params;
  }
}

class CatalogPagination {
  const CatalogPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory CatalogPagination.fromJson(Map<String, dynamic> json) {
    return CatalogPagination(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );
  }

  final int page;
  final int limit;
  final int total;
  final int totalPages;
}

class CatalogListResult<T> {
  const CatalogListResult({
    required this.items,
    this.pagination,
  });

  final List<T> items;
  final CatalogPagination? pagination;
}
