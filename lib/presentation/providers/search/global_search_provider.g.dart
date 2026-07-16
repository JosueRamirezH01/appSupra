// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalSearchBootstrapHash() =>
    r'b531981fac1569f730696e17c0cb7ea8754c6a79';

/// See also [globalSearchBootstrap].
@ProviderFor(globalSearchBootstrap)
final globalSearchBootstrapProvider =
    AutoDisposeFutureProvider<SearchSuggestResult>.internal(
      globalSearchBootstrap,
      name: r'globalSearchBootstrapProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$globalSearchBootstrapHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlobalSearchBootstrapRef =
    AutoDisposeFutureProviderRef<SearchSuggestResult>;
String _$globalSearchSuggestionsHash() =>
    r'c4ed8789cc1099f3c100123d77d5913c46cc3aa3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [globalSearchSuggestions].
@ProviderFor(globalSearchSuggestions)
const globalSearchSuggestionsProvider = GlobalSearchSuggestionsFamily();

/// See also [globalSearchSuggestions].
class GlobalSearchSuggestionsFamily
    extends Family<AsyncValue<SearchSuggestResult>> {
  /// See also [globalSearchSuggestions].
  const GlobalSearchSuggestionsFamily();

  /// See also [globalSearchSuggestions].
  GlobalSearchSuggestionsProvider call(String query) {
    return GlobalSearchSuggestionsProvider(query);
  }

  @override
  GlobalSearchSuggestionsProvider getProviderOverride(
    covariant GlobalSearchSuggestionsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'globalSearchSuggestionsProvider';
}

/// See also [globalSearchSuggestions].
class GlobalSearchSuggestionsProvider
    extends AutoDisposeFutureProvider<SearchSuggestResult> {
  /// See also [globalSearchSuggestions].
  GlobalSearchSuggestionsProvider(String query)
    : this._internal(
        (ref) =>
            globalSearchSuggestions(ref as GlobalSearchSuggestionsRef, query),
        from: globalSearchSuggestionsProvider,
        name: r'globalSearchSuggestionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$globalSearchSuggestionsHash,
        dependencies: GlobalSearchSuggestionsFamily._dependencies,
        allTransitiveDependencies:
            GlobalSearchSuggestionsFamily._allTransitiveDependencies,
        query: query,
      );

  GlobalSearchSuggestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<SearchSuggestResult> Function(GlobalSearchSuggestionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GlobalSearchSuggestionsProvider._internal(
        (ref) => create(ref as GlobalSearchSuggestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SearchSuggestResult> createElement() {
    return _GlobalSearchSuggestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalSearchSuggestionsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlobalSearchSuggestionsRef
    on AutoDisposeFutureProviderRef<SearchSuggestResult> {
  /// The parameter `query` of this provider.
  String get query;
}

class _GlobalSearchSuggestionsProviderElement
    extends AutoDisposeFutureProviderElement<SearchSuggestResult>
    with GlobalSearchSuggestionsRef {
  _GlobalSearchSuggestionsProviderElement(super.provider);

  @override
  String get query => (origin as GlobalSearchSuggestionsProvider).query;
}

String _$globalSearchResultsHash() =>
    r'7c36014142dc18bff87181f480b1046aef40ae7c';

/// See also [globalSearchResults].
@ProviderFor(globalSearchResults)
const globalSearchResultsProvider = GlobalSearchResultsFamily();

/// See also [globalSearchResults].
class GlobalSearchResultsFamily extends Family<AsyncValue<SearchQueryResult>> {
  /// See also [globalSearchResults].
  const GlobalSearchResultsFamily();

  /// See also [globalSearchResults].
  GlobalSearchResultsProvider call(String query, SearchResultType type) {
    return GlobalSearchResultsProvider(query, type);
  }

  @override
  GlobalSearchResultsProvider getProviderOverride(
    covariant GlobalSearchResultsProvider provider,
  ) {
    return call(provider.query, provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'globalSearchResultsProvider';
}

/// See also [globalSearchResults].
class GlobalSearchResultsProvider
    extends AutoDisposeFutureProvider<SearchQueryResult> {
  /// See also [globalSearchResults].
  GlobalSearchResultsProvider(String query, SearchResultType type)
    : this._internal(
        (ref) =>
            globalSearchResults(ref as GlobalSearchResultsRef, query, type),
        from: globalSearchResultsProvider,
        name: r'globalSearchResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$globalSearchResultsHash,
        dependencies: GlobalSearchResultsFamily._dependencies,
        allTransitiveDependencies:
            GlobalSearchResultsFamily._allTransitiveDependencies,
        query: query,
        type: type,
      );

  GlobalSearchResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.type,
  }) : super.internal();

  final String query;
  final SearchResultType type;

  @override
  Override overrideWith(
    FutureOr<SearchQueryResult> Function(GlobalSearchResultsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GlobalSearchResultsProvider._internal(
        (ref) => create(ref as GlobalSearchResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SearchQueryResult> createElement() {
    return _GlobalSearchResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalSearchResultsProvider &&
        other.query == query &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlobalSearchResultsRef
    on AutoDisposeFutureProviderRef<SearchQueryResult> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `type` of this provider.
  SearchResultType get type;
}

class _GlobalSearchResultsProviderElement
    extends AutoDisposeFutureProviderElement<SearchQueryResult>
    with GlobalSearchResultsRef {
  _GlobalSearchResultsProviderElement(super.provider);

  @override
  String get query => (origin as GlobalSearchResultsProvider).query;
  @override
  SearchResultType get type => (origin as GlobalSearchResultsProvider).type;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
