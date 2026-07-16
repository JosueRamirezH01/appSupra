import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/home/home_content_model.dart';
import 'home_layout_metrics.dart';
import 'home_media_image.dart';

class HomeCarouselBanner extends StatefulWidget {
  const HomeCarouselBanner({
    super.key,
    required this.slides,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.onSlideAction,
  });

  final List<HomeCarouselSlideModel> slides;
  final Duration autoPlayInterval;
  final ValueChanged<HomeCarouselSlideModel>? onSlideAction;

  @override
  State<HomeCarouselBanner> createState() => _HomeCarouselBannerState();
}

class _HomeCarouselBannerState extends State<HomeCarouselBanner> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant HomeCarouselBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slides.length != widget.slides.length) {
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _restartAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.slides.length <= 1) return;

    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!_pageController.hasClients || !mounted) return;

      final nextPage = (_currentPage + 1) % widget.slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoPlay() {
    _autoPlayTimer?.cancel();
    _startAutoPlay();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _restartAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    final height = HomeLayoutMetrics.carouselHeight(context);
    final horizontalPadding = HomeLayoutMetrics.carouselHorizontalPadding(context);
    final borderRadius = BorderRadius.vertical(
      bottom: Radius.circular(HomeLayoutMetrics.carouselBottomRadius),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.slides.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final slide = widget.slides[index];
                  return _CarouselSlideCard(
                    slide: slide,
                    slideWidth: MediaQuery.sizeOf(context).width - (HomeLayoutMetrics.carouselHorizontalPadding(context) * 2),
                    slideHeight: height,
                    onAction: widget.onSlideAction == null
                        ? null
                        : () => widget.onSlideAction!(slide),
                  );
                },
              ),
              if (widget.slides.length > 1)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: _PageIndicators(
                    count: widget.slides.length,
                    currentIndex: _currentPage,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselSlideCard extends StatelessWidget {
  const _CarouselSlideCard({
    required this.slide,
    required this.slideWidth,
    required this.slideHeight,
    this.onAction,
  });

  final HomeCarouselSlideModel slide;
  final double slideWidth;
  final double slideHeight;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final buttonLabel = slide.buttonLabel.trim().isEmpty
        ? 'AQUÍ'
        : slide.buttonLabel.trim();
    final ctaBottom = HomeLayoutMetrics.carouselCtaBottom(context, slideHeight);
    final ctaFontSize = HomeLayoutMetrics.carouselCtaFontSize(slideHeight);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: _CarouselSlideMedia(
            imageUrl: slide.imageUrl,
            width: slideWidth,
            height: slideHeight,
          ),
        ),
        Positioned(
          right: 14,
          bottom: ctaBottom,
          child: _CarouselCtaButton(
            label: buttonLabel,
            fontSize: ctaFontSize,
            onPressed: onAction,
          ),
        ),
      ],
    );
  }
}

class _CarouselCtaButton extends StatelessWidget {
  const _CarouselCtaButton({
    required this.label,
    required this.fontSize,
    this.onPressed,
  });

  final String label;
  final double fontSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {

    return Material(
      color: const Color(0xFF0B1C15),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: fontSize * 0.85,
            vertical: fontSize * 0.4,
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselSlideMedia extends StatelessWidget {
  const _CarouselSlideMedia({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return HomeMediaImage.carouselSlide(
      context: context,
      imageUrl: imageUrl,
      width: width,
      height: height,
    );
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final active = index == currentIndex;
        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.only(left: index == 0 ? 0 : 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? Colors.white
                : Colors.white.withValues(alpha: 0.35),
            border: active
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
          ),
        );
      }),
    );
  }
}
