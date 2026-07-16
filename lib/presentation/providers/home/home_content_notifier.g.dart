// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_content_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeContentHash() => r'f1552206ecb3ff5b2a014c9f11e0d58cf80c7f1d';

/// See also [homeContent].
@ProviderFor(homeContent)
final homeContentProvider = FutureProvider<HomeContentModel>.internal(
  homeContent,
  name: r'homeContentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeContentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeContentRef = FutureProviderRef<HomeContentModel>;
String _$homeHeroBackgroundUrlHash() =>
    r'82b58f735b127de1f392acf671a8c1f122f89ac6';

/// URL del fondo del hero ya normalizada para el dispositivo.
///
/// Copied from [homeHeroBackgroundUrl].
@ProviderFor(homeHeroBackgroundUrl)
final homeHeroBackgroundUrlProvider = Provider<String?>.internal(
  homeHeroBackgroundUrl,
  name: r'homeHeroBackgroundUrlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeHeroBackgroundUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeHeroBackgroundUrlRef = ProviderRef<String?>;
String _$homeCarouselSlidesHash() =>
    r'ac067f17ca59aca91e0faf5cc6649256106ec1ba';

/// Slides activos del carrusel del home, ordenados para el banner.
///
/// Copied from [homeCarouselSlides].
@ProviderFor(homeCarouselSlides)
final homeCarouselSlidesProvider =
    Provider<List<HomeCarouselSlideModel>>.internal(
      homeCarouselSlides,
      name: r'homeCarouselSlidesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeCarouselSlidesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeCarouselSlidesRef = ProviderRef<List<HomeCarouselSlideModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
