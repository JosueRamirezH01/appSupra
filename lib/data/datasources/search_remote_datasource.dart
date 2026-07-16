import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/search/search_model.dart';

class SearchRemoteDataSource {
  SearchRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SearchSuggestResult> suggest(SearchSuggestRequest request) async {
    final query = request.query?.trim();
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.searchSuggest,
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        if (request.lat != null && request.lng != null) ...{
          'lat': request.lat,
          'lng': request.lng,
          'radiusKm': request.radiusKm ?? 15,
        },
      },
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) throw AppException.unknown('Respuesta inválida');
    return SearchSuggestResult.fromJson(data);
  }

  Future<SearchQueryResult> search(SearchQuery query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.search,
      queryParameters: {
        'q': query.q,
        'type': query.type.apiValue,
        'page': query.page,
        'limit': query.limit,
        if (query.lat != null && query.lng != null) ...{
          'lat': query.lat,
          'lng': query.lng,
          'radiusKm': query.radiusKm ?? 15,
        },
      },
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) throw AppException.unknown('Respuesta inválida');
    return SearchQueryResult.fromJson(data);
  }

  Future<List<SearchHistoryItemModel>> listHistory() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.searchHistory,
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final history = data?['history'] as List<dynamic>? ?? [];
    return history
        .map(
          (item) =>
              SearchHistoryItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> clearHistory() async {
    await _dio.delete<void>(ApiEndpoints.searchHistory);
  }

  Future<void> deleteHistoryItem(int historyId) async {
    await _dio.delete<void>(ApiEndpoints.searchHistoryItem(historyId));
  }
}
