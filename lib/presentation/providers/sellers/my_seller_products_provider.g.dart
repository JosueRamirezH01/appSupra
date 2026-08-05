// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_seller_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mySellerProductsPreviewHash() =>
    r'e286fd32b2b28d1d40a42ec3029a6ba1e8ec1680';

/// Preview del home vendedor (carrusel): solo 8 ítems + conteos globales.
///
/// Copied from [mySellerProductsPreview].
@ProviderFor(mySellerProductsPreview)
final mySellerProductsPreviewProvider =
    AutoDisposeFutureProvider<MyProductsListResult>.internal(
      mySellerProductsPreview,
      name: r'mySellerProductsPreviewProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mySellerProductsPreviewHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MySellerProductsPreviewRef =
    AutoDisposeFutureProviderRef<MyProductsListResult>;
String _$mySellerProductsControllerHash() =>
    r'7d755b438c413ba32c25ab3db8e98e5560ec3c44';

/// Listado paginado de "Mis productos".
///
/// Copied from [MySellerProductsController].
@ProviderFor(MySellerProductsController)
final mySellerProductsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      MySellerProductsController,
      MySellerProductsViewState
    >.internal(
      MySellerProductsController.new,
      name: r'mySellerProductsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mySellerProductsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MySellerProductsController =
    AutoDisposeAsyncNotifier<MySellerProductsViewState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
