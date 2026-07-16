import '../../data/models/search/search_model.dart';

abstract class SearchRepository {
  Future<SearchSuggestResult> suggest(SearchSuggestRequest request);
  Future<SearchQueryResult> search(SearchQuery query);
  Future<List<SearchHistoryItemModel>> listHistory();
  Future<void> clearHistory();
  Future<void> deleteHistoryItem(int historyId);
}
