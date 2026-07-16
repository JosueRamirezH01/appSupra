import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/app_view.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/home/home_content_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/categories/home_catalog_provider.dart' as catalog_providers;
import '../../providers/home/home_content_notifier.dart';
import 'home_carousel_banner.dart';
import 'home_catalog_sections.dart';
import 'home_content_sheet.dart';
import 'home_hero_section.dart';
import 'home_layout_metrics.dart';
import 'home_media_image.dart';

class ClientHomeHeader extends ConsumerStatefulWidget {
  const ClientHomeHeader({
    super.key,
    required this.user,
    required this.activeView,
  });

  final UserModel? user;
  final AppView activeView;

  @override
  ConsumerState<ClientHomeHeader> createState() => _ClientHomeHeaderState();
}

class _ClientHomeHeaderState extends ConsumerState<ClientHomeHeader> {
  int _selectedTab = 0;
  String? _warmedImageKey;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmHomeImages());
  }

  void _warmHomeImages() {
    if (!mounted) return;

    final content = ref.read(homeContentProvider).valueOrNull;
    final catalog = ref.read(catalog_providers.homeCatalogSectionsProvider).valueOrNull;

    final carouselUrls =
        content?.carouselSlides.map((slide) => slide.imageUrl).toList() ?? const [];
    final categoryUrls = <String>[];

    for (final section in [catalog?.professions, catalog?.products]) {
      if (section == null) continue;
      for (final item in section.subcategories) {
        final url = item.imageUrl;
        if (url != null && url.isNotEmpty) {
          categoryUrls.add(url);
        }
      }
    }

    final key = [
      content?.hero.backgroundImageUrl ?? '',
      ...carouselUrls,
      ...categoryUrls,
    ].join('|');

    if (key.isEmpty || key == _warmedImageKey) return;
    _warmedImageKey = key;

    HomeMediaImage.warmUp(
      context,
      heroUrl: content?.hero.backgroundImageUrl,
      carouselUrls: carouselUrls,
      categoryUrls: categoryUrls,
    );
  }

  void _openProfessionalsBrowse({int? subcategoryId}) {
    context.push(RoutePaths.professionalsBrowsePath(subcategoryId: subcategoryId));
  }

  void _openProductsBrowse({int? subcategoryId}) {
    context.push(RoutePaths.productsBrowsePath(subcategoryId: subcategoryId));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeContentProvider, (_, next) {
      if (next.hasValue) _warmHomeImages();
    });
    ref.listen(catalog_providers.homeCatalogSectionsProvider, (_, next) {
      if (next.hasValue) _warmHomeImages();
    });

    final backgroundImageUrl = ref.watch(homeHeroBackgroundUrlProvider);
    final carouselSlides = ref.watch(homeCarouselSlidesProvider);
    final hasCarousel = carouselSlides.isNotEmpty;
    final carouselHeight = HomeLayoutMetrics.carouselHeight(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeroSection(
              user: widget.user,
              activeView: widget.activeView,
              selectedTab: _selectedTab,
              backgroundImageUrl: backgroundImageUrl,
              reserveCarouselSpace: hasCarousel,
              onTabSelected: (index) => setState(() => _selectedTab = index),
              onProfesionalesTap: () => _openProfessionalsBrowse(),
              onProductosTap: () => _openProductsBrowse(),
              onSearchTap: () => context.push(RoutePaths.globalSearch),
            ),
            HomeContentSheet(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (hasCarousel)
                    SizedBox(
                      height: HomeLayoutMetrics.sheetTopInsetForCarousel(
                        context,
                      ),
                    ),
                  HomeCatalogSections(
                    onProfessionSubcategoryTap: (subcategoryId) => _openProfessionalsBrowse(subcategoryId: subcategoryId),
                    onProductSubcategoryTap: (subcategoryId) => _openProductsBrowse(subcategoryId: subcategoryId),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (hasCarousel)
          Positioned(
            top: HomeLayoutMetrics.carouselTop(context),
            left: 0,
            right: 0,
            height: carouselHeight,
            child: HomeCarouselBanner(
              slides: carouselSlides,
              onSlideAction: buttonBanner,
            ),
          ),
      ],
    );
  }

  void buttonBanner(HomeCarouselSlideModel slide) {
    debugPrint('Carousel action: ${slide.title}');
  }
}
