// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_browse_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productCategoryIdHash() => r'124a9f87ba143a62f4210942b0c8e41da4a8365f';

/// See also [productCategoryId].
@ProviderFor(productCategoryId)
final productCategoryIdProvider = FutureProvider<int?>.internal(
  productCategoryId,
  name: r'productCategoryIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productCategoryIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductCategoryIdRef = FutureProviderRef<int?>;
String _$productBrowseSubcategoriesHash() =>
    r'217b21c36e5be10dba6df26a6f188bf2f7bec9ca';

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

/// See also [productBrowseSubcategories].
@ProviderFor(productBrowseSubcategories)
const productBrowseSubcategoriesProvider = ProductBrowseSubcategoriesFamily();

/// See also [productBrowseSubcategories].
class ProductBrowseSubcategoriesFamily
    extends Family<AsyncValue<List<SubcategoryModel>>> {
  /// See also [productBrowseSubcategories].
  const ProductBrowseSubcategoriesFamily();

  /// See also [productBrowseSubcategories].
  ProductBrowseSubcategoriesProvider call(int categoryId) {
    return ProductBrowseSubcategoriesProvider(categoryId);
  }

  @override
  ProductBrowseSubcategoriesProvider getProviderOverride(
    covariant ProductBrowseSubcategoriesProvider provider,
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
  String? get name => r'productBrowseSubcategoriesProvider';
}

/// See also [productBrowseSubcategories].
class ProductBrowseSubcategoriesProvider
    extends AutoDisposeFutureProvider<List<SubcategoryModel>> {
  /// See also [productBrowseSubcategories].
  ProductBrowseSubcategoriesProvider(int categoryId)
    : this._internal(
        (ref) => productBrowseSubcategories(
          ref as ProductBrowseSubcategoriesRef,
          categoryId,
        ),
        from: productBrowseSubcategoriesProvider,
        name: r'productBrowseSubcategoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productBrowseSubcategoriesHash,
        dependencies: ProductBrowseSubcategoriesFamily._dependencies,
        allTransitiveDependencies:
            ProductBrowseSubcategoriesFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  ProductBrowseSubcategoriesProvider._internal(
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
    FutureOr<List<SubcategoryModel>> Function(
      ProductBrowseSubcategoriesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductBrowseSubcategoriesProvider._internal(
        (ref) => create(ref as ProductBrowseSubcategoriesRef),
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
    return _ProductBrowseSubcategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductBrowseSubcategoriesProvider &&
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
mixin ProductBrowseSubcategoriesRef
    on AutoDisposeFutureProviderRef<List<SubcategoryModel>> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _ProductBrowseSubcategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<SubcategoryModel>>
    with ProductBrowseSubcategoriesRef {
  _ProductBrowseSubcategoriesProviderElement(super.provider);

  @override
  int get categoryId =>
      (origin as ProductBrowseSubcategoriesProvider).categoryId;
}

String _$productsBrowseControllerHash() =>
    r'abdbf9059716cd97fd8cebcd3e0dbe89af4b3e8c';

abstract class _$ProductsBrowseController
    extends BuildlessAutoDisposeAsyncNotifier<ProductsBrowseViewState> {
  late final int categoryId;
  late final int? initialSubcategoryId;

  FutureOr<ProductsBrowseViewState> build(
    int categoryId, {
    int? initialSubcategoryId,
  });
}

/// See also [ProductsBrowseController].
@ProviderFor(ProductsBrowseController)
const productsBrowseControllerProvider = ProductsBrowseControllerFamily();

/// See also [ProductsBrowseController].
class ProductsBrowseControllerFamily
    extends Family<AsyncValue<ProductsBrowseViewState>> {
  /// See also [ProductsBrowseController].
  const ProductsBrowseControllerFamily();

  /// See also [ProductsBrowseController].
  ProductsBrowseControllerProvider call(
    int categoryId, {
    int? initialSubcategoryId,
  }) {
    return ProductsBrowseControllerProvider(
      categoryId,
      initialSubcategoryId: initialSubcategoryId,
    );
  }

  @override
  ProductsBrowseControllerProvider getProviderOverride(
    covariant ProductsBrowseControllerProvider provider,
  ) {
    return call(
      provider.categoryId,
      initialSubcategoryId: provider.initialSubcategoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productsBrowseControllerProvider';
}

/// See also [ProductsBrowseController].
class ProductsBrowseControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProductsBrowseController,
          ProductsBrowseViewState
        > {
  /// See also [ProductsBrowseController].
  ProductsBrowseControllerProvider(int categoryId, {int? initialSubcategoryId})
    : this._internal(
        () => ProductsBrowseController()
          ..categoryId = categoryId
          ..initialSubcategoryId = initialSubcategoryId,
        from: productsBrowseControllerProvider,
        name: r'productsBrowseControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productsBrowseControllerHash,
        dependencies: ProductsBrowseControllerFamily._dependencies,
        allTransitiveDependencies:
            ProductsBrowseControllerFamily._allTransitiveDependencies,
        categoryId: categoryId,
        initialSubcategoryId: initialSubcategoryId,
      );

  ProductsBrowseControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.initialSubcategoryId,
  }) : super.internal();

  final int categoryId;
  final int? initialSubcategoryId;

  @override
  FutureOr<ProductsBrowseViewState> runNotifierBuild(
    covariant ProductsBrowseController notifier,
  ) {
    return notifier.build(
      categoryId,
      initialSubcategoryId: initialSubcategoryId,
    );
  }

  @override
  Override overrideWith(ProductsBrowseController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductsBrowseControllerProvider._internal(
        () => create()
          ..categoryId = categoryId
          ..initialSubcategoryId = initialSubcategoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        initialSubcategoryId: initialSubcategoryId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ProductsBrowseController,
    ProductsBrowseViewState
  >
  createElement() {
    return _ProductsBrowseControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsBrowseControllerProvider &&
        other.categoryId == categoryId &&
        other.initialSubcategoryId == initialSubcategoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, initialSubcategoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductsBrowseControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ProductsBrowseViewState> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;

  /// The parameter `initialSubcategoryId` of this provider.
  int? get initialSubcategoryId;
}

class _ProductsBrowseControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProductsBrowseController,
          ProductsBrowseViewState
        >
    with ProductsBrowseControllerRef {
  _ProductsBrowseControllerProviderElement(super.provider);

  @override
  int get categoryId => (origin as ProductsBrowseControllerProvider).categoryId;
  @override
  int? get initialSubcategoryId =>
      (origin as ProductsBrowseControllerProvider).initialSubcategoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
