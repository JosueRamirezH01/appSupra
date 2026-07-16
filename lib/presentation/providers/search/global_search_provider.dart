import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/search/search_model.dart';
import '../location/client_location_provider.dart';
import '../repository_providers.dart';

part 'global_search_provider.g.dart';

Future<SearchSuggestRequest> _buildSuggestRequest(
  Ref ref,
  String? query,
) async {
  final clientLocation = await ref.watch(activeClientLocationProvider.future);
  final trimmed = query?.trim();
  return SearchSuggestRequest(
    query: trimmed == null || trimmed.isEmpty ? null : trimmed,
    lat: clientLocation?.lat,
    lng: clientLocation?.lng,
    radiusKm: clientLocation?.radiusKm ?? 15,
  );
}

Future<SearchQuery> _buildSearchQuery(
  Ref ref,
  String query,
  SearchResultType type,
) async {
  final clientLocation = await ref.watch(activeClientLocationProvider.future);
  return SearchQuery(
    q: query.trim(),
    type: type,
    lat: clientLocation?.lat,
    lng: clientLocation?.lng,
    radiusKm: clientLocation?.radiusKm ?? 15,
  );
}

@riverpod
Future<SearchSuggestResult> globalSearchBootstrap(GlobalSearchBootstrapRef ref) async {
  final request = await _buildSuggestRequest(ref, null);
  return ref.read(searchRepositoryProvider).suggest(request);
}

@riverpod
Future<SearchSuggestResult> globalSearchSuggestions(
  GlobalSearchSuggestionsRef ref,
  String query,
) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) {
    return const SearchSuggestResult();
  }

  final request = await _buildSuggestRequest(ref, trimmed);
  return ref.read(searchRepositoryProvider).suggest(request);
}

@riverpod
Future<SearchQueryResult> globalSearchResults(
  GlobalSearchResultsRef ref,
  String query,
  SearchResultType type,
) async {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return SearchQueryResult(type: type);
  }

  final searchQuery = await _buildSearchQuery(ref, trimmed, type);
  return ref.read(searchRepositoryProvider).search(searchQuery);
}
