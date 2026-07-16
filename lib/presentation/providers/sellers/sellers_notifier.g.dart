// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellers_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productDetailHash() => r'640682834c0ff84dcd7592a3f06b53f2a41d7e2f';

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

/// See also [productDetail].
@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily();

/// See also [productDetail].
class ProductDetailFamily extends Family<AsyncValue<ProductPublicModel>> {
  /// See also [productDetail].
  const ProductDetailFamily();

  /// See also [productDetail].
  ProductDetailProvider call(int productId) {
    return ProductDetailProvider(productId);
  }

  @override
  ProductDetailProvider getProviderOverride(
    covariant ProductDetailProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProvider';
}

/// See also [productDetail].
class ProductDetailProvider
    extends AutoDisposeFutureProvider<ProductPublicModel> {
  /// See also [productDetail].
  ProductDetailProvider(int productId)
    : this._internal(
        (ref) => productDetail(ref as ProductDetailRef, productId),
        from: productDetailProvider,
        name: r'productDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productDetailHash,
        dependencies: ProductDetailFamily._dependencies,
        allTransitiveDependencies:
            ProductDetailFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final int productId;

  @override
  Override overrideWith(
    FutureOr<ProductPublicModel> Function(ProductDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProvider._internal(
        (ref) => create(ref as ProductDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProductPublicModel> createElement() {
    return _ProductDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailRef on AutoDisposeFutureProviderRef<ProductPublicModel> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _ProductDetailProviderElement
    extends AutoDisposeFutureProviderElement<ProductPublicModel>
    with ProductDetailRef {
  _ProductDetailProviderElement(super.provider);

  @override
  int get productId => (origin as ProductDetailProvider).productId;
}

String _$sellerPublicProfileHash() =>
    r'5fc057820568d2f6f24094ee40f8f6be94365b27';

/// See also [sellerPublicProfile].
@ProviderFor(sellerPublicProfile)
const sellerPublicProfileProvider = SellerPublicProfileFamily();

/// See also [sellerPublicProfile].
class SellerPublicProfileFamily extends Family<AsyncValue<SellerPublicModel>> {
  /// See also [sellerPublicProfile].
  const SellerPublicProfileFamily();

  /// See also [sellerPublicProfile].
  SellerPublicProfileProvider call(int userId) {
    return SellerPublicProfileProvider(userId);
  }

  @override
  SellerPublicProfileProvider getProviderOverride(
    covariant SellerPublicProfileProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sellerPublicProfileProvider';
}

/// See also [sellerPublicProfile].
class SellerPublicProfileProvider
    extends AutoDisposeFutureProvider<SellerPublicModel> {
  /// See also [sellerPublicProfile].
  SellerPublicProfileProvider(int userId)
    : this._internal(
        (ref) => sellerPublicProfile(ref as SellerPublicProfileRef, userId),
        from: sellerPublicProfileProvider,
        name: r'sellerPublicProfileProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sellerPublicProfileHash,
        dependencies: SellerPublicProfileFamily._dependencies,
        allTransitiveDependencies:
            SellerPublicProfileFamily._allTransitiveDependencies,
        userId: userId,
      );

  SellerPublicProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<SellerPublicModel> Function(SellerPublicProfileRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SellerPublicProfileProvider._internal(
        (ref) => create(ref as SellerPublicProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SellerPublicModel> createElement() {
    return _SellerPublicProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SellerPublicProfileProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SellerPublicProfileRef
    on AutoDisposeFutureProviderRef<SellerPublicModel> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _SellerPublicProfileProviderElement
    extends AutoDisposeFutureProviderElement<SellerPublicModel>
    with SellerPublicProfileRef {
  _SellerPublicProfileProviderElement(super.provider);

  @override
  int get userId => (origin as SellerPublicProfileProvider).userId;
}

String _$mySellerApplicationHash() =>
    r'c400e3d14e413b95745965a4d8cca1b56f354bc4';

/// See also [mySellerApplication].
@ProviderFor(mySellerApplication)
final mySellerApplicationProvider =
    AutoDisposeFutureProvider<SellerApplicationModel>.internal(
      mySellerApplication,
      name: r'mySellerApplicationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mySellerApplicationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MySellerApplicationRef =
    AutoDisposeFutureProviderRef<SellerApplicationModel>;
String _$mySellerProductsHash() => r'e290684ccb35353e07403a654796f61480c100eb';

/// See also [mySellerProducts].
@ProviderFor(mySellerProducts)
final mySellerProductsProvider =
    AutoDisposeFutureProvider<List<ProductPublicModel>>.internal(
      mySellerProducts,
      name: r'mySellerProductsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mySellerProductsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MySellerProductsRef =
    AutoDisposeFutureProviderRef<List<ProductPublicModel>>;
String _$sellerProductSubcategoriesHash() =>
    r'c2f81bdac03a15043989cccdabefc7074855ec8a';

/// See also [sellerProductSubcategories].
@ProviderFor(sellerProductSubcategories)
final sellerProductSubcategoriesProvider =
    AutoDisposeFutureProvider<List<SubcategoryModel>>.internal(
      sellerProductSubcategories,
      name: r'sellerProductSubcategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sellerProductSubcategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SellerProductSubcategoriesRef =
    AutoDisposeFutureProviderRef<List<SubcategoryModel>>;
String _$productsListHash() => r'3a7c7178320bd7fd767f7026c62416ed818a759c';

/// See also [ProductsList].
@ProviderFor(ProductsList)
final productsListProvider =
    AutoDisposeAsyncNotifierProvider<ProductsList, ProductsListResult>.internal(
      ProductsList.new,
      name: r'productsListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productsListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProductsList = AutoDisposeAsyncNotifier<ProductsListResult>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
