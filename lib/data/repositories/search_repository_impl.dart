import '../../data/datasources/search_remote_datasource.dart';
import '../../data/models/search/search_model.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._remote);

  final SearchRemoteDataSource _remote;

  @override
  Future<SearchSuggestResult> suggest(SearchSuggestRequest request) {
    return _remote.suggest(request);
  }

  @override
  Future<SearchQueryResult> search(SearchQuery query) {
    return _remote.search(query);
  }

  @override
  Future<List<SearchHistoryItemModel>> listHistory() {
    return _remote.listHistory();
  }

  @override
  Future<void> clearHistory() {
    return _remote.clearHistory();
  }

  @override
  Future<void> deleteHistoryItem(int historyId) {
    return _remote.deleteHistoryItem(historyId);
  }
}
