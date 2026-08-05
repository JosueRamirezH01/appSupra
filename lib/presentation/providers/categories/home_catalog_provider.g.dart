// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeCatalogSectionsHash() =>
    r'f56b4e78655f9464c07e7fa3cdcefce8e10222e5';

/// See also [homeCatalogSections].
@ProviderFor(homeCatalogSections)
final homeCatalogSectionsProvider =
    FutureProvider<HomeCatalogSections>.internal(
      homeCatalogSections,
      name: r'homeCatalogSectionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeCatalogSectionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeCatalogSectionsRef = FutureProviderRef<HomeCatalogSections>;
String _$exploreSubcategoriesHash() =>
    r'84f28d542cde9d2cdf18e3a695183b5afa594555';

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

/// See also [exploreSubcategories].
@ProviderFor(exploreSubcategories)
const exploreSubcategoriesProvider = ExploreSubcategoriesFamily();

/// See also [exploreSubcategories].
class ExploreSubcategoriesFamily
    extends Family<AsyncValue<List<SubcategoryModel>>> {
  /// See also [exploreSubcategories].
  const ExploreSubcategoriesFamily();

  /// See also [exploreSubcategories].
  ExploreSubcategoriesProvider call(int categoryId) {
    return ExploreSubcategoriesProvider(categoryId);
  }

  @override
  ExploreSubcategoriesProvider getProviderOverride(
    covariant ExploreSubcategoriesProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exploreSubcategoriesProvider';
}

/// See also [exploreSubcategories].
class ExploreSubcategoriesProvider
    extends AutoDisposeFutureProvider<List<SubcategoryModel>> {
  /// See also [exploreSubcategories].
  ExploreSubcategoriesProvider(int categoryId)
    : this._internal(
        (ref) =>
            exploreSubcategories(ref as ExploreSubcategoriesRef, categoryId),
        from: exploreSubcategoriesProvider,
        name: r'exploreSubcategoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exploreSubcategoriesHash,
        dependencies: ExploreSubcategoriesFamily._dependencies,
        allTransitiveDependencies:
            ExploreSubcategoriesFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  ExploreSubcategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  Override overrideWith(
    FutureOr<List<SubcategoryModel>> Function(ExploreSubcategoriesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExploreSubcategoriesProvider._internal(
        (ref) => create(ref as ExploreSubcategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SubcategoryModel>> createElement() {
    return _ExploreSubcategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExploreSubcategoriesProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExploreSubcategoriesRef
    on AutoDisposeFutureProviderRef<List<SubcategoryModel>> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _ExploreSubcategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<SubcategoryModel>>
    with ExploreSubcategoriesRef {
  _ExploreSubcategoriesProviderElement(super.provider);

  @override
  int get categoryId => (origin as ExploreSubcategoriesProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
