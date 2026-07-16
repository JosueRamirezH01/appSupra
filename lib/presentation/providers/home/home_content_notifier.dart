import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/home/home_content_model.dart';
import '../repository_providers.dart';

part 'home_content_notifier.g.dart';

@Riverpod(keepAlive: true)
Future<HomeContentModel> homeContent(HomeContentRef ref) {
  return ref.read(homeRepositoryProvider).getHomeContent();
}

/// URL del fondo del hero ya normalizada para el dispositivo.
@Riverpod(keepAlive: true)
String? homeHeroBackgroundUrl(HomeHeroBackgroundUrlRef ref) {
  return ref.watch(homeContentProvider).maybeWhen(
        data: (content) =>
            MediaUrlUtils.resolve(content.hero.backgroundImageUrl),
        orElse: () => null,
      );
}

/// Slides activos del carrusel del home, ordenados para el banner.
@Riverpod(keepAlive: true)
List<HomeCarouselSlideModel> homeCarouselSlides(HomeCarouselSlidesRef ref) {
  return ref.watch(homeContentProvider).maybeWhen(
        data: (content) {
          final slides = content.carouselSlides
              .where((slide) => slide.status)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              return order != 0 ? order : a.id.compareTo(b.id);
            });
          return slides;
        },
        orElse: () => const [],
      );
}
