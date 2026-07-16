// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sellerCatalogControllerHash() =>
    r'98735e13165360e761d1ce4524afd55d6ff52ef0';

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

abstract class _$SellerCatalogController
    extends BuildlessAutoDisposeAsyncNotifier<SellerCatalogViewState> {
  late final int sellerId;

  FutureOr<SellerCatalogViewState> build(int sellerId);
}

/// See also [SellerCatalogController].
@ProviderFor(SellerCatalogController)
const sellerCatalogControllerProvider = SellerCatalogControllerFamily();

/// See also [SellerCatalogController].
class SellerCatalogControllerFamily
    extends Family<AsyncValue<SellerCatalogViewState>> {
  /// See also [SellerCatalogController].
  const SellerCatalogControllerFamily();

  /// See also [SellerCatalogController].
  SellerCatalogControllerProvider call(int sellerId) {
    return SellerCatalogControllerProvider(sellerId);
  }

  @override
  SellerCatalogControllerProvider getProviderOverride(
    covariant SellerCatalogControllerProvider provider,
  ) {
    return call(provider.sellerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sellerCatalogControllerProvider';
}

/// See also [SellerCatalogController].
class SellerCatalogControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SellerCatalogController,
          SellerCatalogViewState
        > {
  /// See also [SellerCatalogController].
  SellerCatalogControllerProvider(int sellerId)
    : this._internal(
        () => SellerCatalogController()..sellerId = sellerId,
        from: sellerCatalogControllerProvider,
        name: r'sellerCatalogControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sellerCatalogControllerHash,
        dependencies: SellerCatalogControllerFamily._dependencies,
        allTransitiveDependencies:
            SellerCatalogControllerFamily._allTransitiveDependencies,
        sellerId: sellerId,
      );

  SellerCatalogControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sellerId,
  }) : super.internal();

  final int sellerId;

  @override
  FutureOr<SellerCatalogViewState> runNotifierBuild(
    covariant SellerCatalogController notifier,
  ) {
    return notifier.build(sellerId);
  }

  @override
  Override overrideWith(SellerCatalogController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SellerCatalogControllerProvider._internal(
        () => create()..sellerId = sellerId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sellerId: sellerId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    SellerCatalogController,
    SellerCatalogViewState
  >
  createElement() {
    return _SellerCatalogControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SellerCatalogControllerProvider &&
        other.sellerId == sellerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sellerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SellerCatalogControllerRef
    on AutoDisposeAsyncNotifierProviderRef<SellerCatalogViewState> {
  /// The parameter `sellerId` of this provider.
  int get sellerId;
}

class _SellerCatalogControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SellerCatalogController,
          SellerCatalogViewState
        >
    with SellerCatalogControllerRef {
  _SellerCatalogControllerProviderElement(super.provider);

  @override
  int get sellerId => (origin as SellerCatalogControllerProvider).sellerId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
