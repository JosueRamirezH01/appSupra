import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/app_view.dart';
import '../../../data/models/auth/user_model.dart';
import '../auth/auth_ui.dart';
import 'home_layout_metrics.dart';
import 'home_media_image.dart';
import 'home_media_placeholder.dart';
import 'home_role_chip.dart';
import '../location/home_location_chip.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.user,
    required this.activeView,
    required this.selectedTab,
    required this.backgroundImageUrl,
    required this.reserveCarouselSpace,
    required this.onTabSelected,
    required this.onSearchTap,
    this.onProfesionalesTap,
    this.onProductosTap,
  });

  final UserModel? user;
  final AppView activeView;
  final int selectedTab;
  final String? backgroundImageUrl;
  final bool reserveCarouselSpace;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onSearchTap;
  final VoidCallback? onProfesionalesTap;
  final VoidCallback? onProductosTap;

  @override
  Widget build(BuildContext context) {
    final textScale = HomeLayoutMetrics.clampedTextScale(context);
    final heroHeight = HomeLayoutMetrics.heroHeight(
      context,
      hasCarousel: reserveCarouselSpace,
    );
    final searchHeight = HomeLayoutMetrics.searchRowHeight(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: SizedBox(
        width: double.infinity,
        height: heroHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _HeroBackground(
              imageUrl: backgroundImageUrl,
              height: heroHeight,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.38),
                    Colors.black.withValues(
                      alpha: reserveCarouselSpace ? 0.06 : 0.14,
                    ),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Flexible(
                              child: HomeLocationChip(),
                            ),

                            Flexible(
                              child: HomeRoleChipButton(
                                user: user,
                                activeView: activeView,
                                height: searchHeight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        _HeaderSearchField(
                          height: searchHeight,
                          onTap: onSearchTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground({
    this.imageUrl,
    required this.height,
  });

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    if (!hasImage) {
      return const HomeMediaPlaceholder.hero();
    }

    return HomeMediaImage.heroBackground(
      context: context,
      imageUrl: imageUrl,
      height: height,
    );
  }
}

class _HeaderSearchField extends StatelessWidget {
  const _HeaderSearchField({
    required this.height,
    required this.onTap,
  });

  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Que estas buscando?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Material(
                color: AppBrandColors.primaryGreen,
                borderRadius: BorderRadius.circular(8),
                child: const SizedBox(
                  width: 38,
                  height: 38,
                  child: Icon(Icons.search, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

