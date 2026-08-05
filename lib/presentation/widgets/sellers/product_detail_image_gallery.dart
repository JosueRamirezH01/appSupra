
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../home/home_media_image.dart';
import 'product_client_image_source.dart';

/// Galería hero del detalle de producto (cliente y vista previa vendedor).
class ProductDetailImageGallery extends StatefulWidget {
  const ProductDetailImageGallery({
    super.key,
    required this.images,
    required this.viewportWidth,
    /// Solo PageView + overlays (para SliverAppBar). Sin thumbnails debajo.
    this.heroMode = false,
  });

  final List<ProductClientImageSource> images;
  final double viewportWidth;
  final bool heroMode;

  static const double aspectRatio = 2 / 1;

  @override
  State<ProductDetailImageGallery> createState() => _ProductDetailImageGalleryState();
}

class _ProductDetailImageGalleryState extends State<ProductDetailImageGallery> {
  late final PageController _pageController;
  late final ScrollController _thumbController;

  int _pageIndex = 0;

  double get _galleryHeight => widget.viewportWidth / ProductDetailImageGallery.aspectRatio;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _thumbController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _pageIndex = index);
    _scrollThumbnailIntoView(index);
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollThumbnailIntoView(int index) {
    if (widget.images.length <= 1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_thumbController.hasClients) return;
      const thumbWidth = 64.0;
      const gap = 8.0;
      final offset = (thumbWidth + gap) * index - widget.viewportWidth / 2 + thumbWidth / 2;
      _thumbController.animateTo(
        offset.clamp(0.0, _thumbController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _openFullscreen() {
    if (widget.images.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => _ProductImageFullscreenViewer(
          images: widget.images,
          initialIndex: _pageIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      if (widget.heroMode) {
        return const ColoredBox(
          color: Color(0xFFF3F4F6),
          child: Center(
            child: Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: Color(0xFF9CA3AF),
            ),
          ),
        );
      }
      return _EmptyGallery(height: _galleryHeight);
    }

    final hasMultiple = widget.images.length > 1;
    // En hero híbrido la galería ya está debajo del AppBar: overlay corto.
    final topSafe = widget.heroMode ? 12.0 : 14.0;

    Widget buildHero({required double width, required double height}) {
      return GestureDetector(
        onTap: _openFullscreen,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: const Color(0xFFF3F4F6),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _GallerySlide(
                    source: widget.images[index],
                    width: width,
                    height: height,
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 88,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ),
            if (hasMultiple && widget.heroMode)
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: _PageDots(
                  count: widget.images.length,
                  index: _pageIndex,
                  onDark: true,
                ),
              ),
            if (hasMultiple)
              Positioned(
                right: 14,
                top: widget.heroMode ? topSafe + 44 : null,
                bottom: widget.heroMode ? null : 14,
                child: _ImageCounterBadge(
                  current: _pageIndex + 1,
                  total: widget.images.length,
                ),
              ),
            Positioned(
              right: 14,
              top: topSafe,
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  onTap: _openFullscreen,
                  borderRadius: BorderRadius.circular(999),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.zoom_out_map_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.heroMode) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : widget.viewportWidth;
          final height = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : _galleryHeight;
          return SizedBox(
            width: width,
            height: height,
            child: buildHero(width: width, height: height),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: _galleryHeight,
          width: widget.viewportWidth,
          child: buildHero(
            width: widget.viewportWidth,
            height: _galleryHeight,
          ),
        ),
        if (hasMultiple) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              controller: _thumbController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return _GalleryThumbnail(
                  source: widget.images[index],
                  selected: index == _pageIndex,
                  onTap: () => _goToPage(index),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          _PageDots(
            count: widget.images.length,
            index: _pageIndex,
          ),
        ],
      ],
    );
  }
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFF3F4F6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 48,
            color: AppBrandColors.textMuted.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 10),
          Text(
            'Sin fotos del producto',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppBrandColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _GallerySlide extends StatelessWidget {
  const _GallerySlide({
    required this.source,
    required this.width,
    required this.height,
  });

  final ProductClientImageSource source;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Opción A: cover llena el marco 4:3 (sin bandas); puede recortar bordes.
    return ColoredBox(
      color: const Color(0xFFF3F4F6),
      child: switch (source) {
        ProductClientLocalImage(:final file) => Image.file(
            file,
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ProductClientNetworkImage(:final url) => HomeMediaImage.workGalleryViewer(
            context: context,
            imageUrl: MediaUrlUtils.resolve(url)!,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
      },
    );
  }
}

class _GalleryThumbnail extends StatelessWidget {
  const _GalleryThumbnail({
    required this.source,
    required this.selected,
    required this.onTap,
  });

  final ProductClientImageSource source;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppBrandColors.primaryGreen : const Color(0xFFE5E7EB),
            width: selected ? 2.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: switch (source) {
            ProductClientLocalImage(:final file) => Image.file(
                file,
                fit: BoxFit.cover,
                width: 64,
                height: 64,
              ),
            ProductClientNetworkImage(:final url) => HomeMediaImage.workGalleryThumb(
                context: context,
                imageUrl: MediaUrlUtils.resolve(url)!,
                width: 64,
                height: 64,
              ),
          },
        ),
      ),
    );
  }
}

class _ImageCounterBadge extends StatelessWidget {
  const _ImageCounterBadge({
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$current / $total',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({
    required this.count,
    required this.index,
    this.onDark = false,
  });

  final int count;
  final int index;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: active ? 22 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: active
                ? (onDark ? Colors.white : AppBrandColors.primaryGreen)
                : (onDark
                    ? Colors.white.withValues(alpha: 0.45)
                    : const Color(0xFFD1D5DB)),
          ),
        );
      }),
    );
  }
}

class _ProductImageFullscreenViewer extends StatefulWidget {
  const _ProductImageFullscreenViewer({
    required this.images,
    required this.initialIndex,
  });

  final List<ProductClientImageSource> images;
  final int initialIndex;

  @override
  State<_ProductImageFullscreenViewer> createState() =>
      _ProductImageFullscreenViewerState();
}

class _ProductImageFullscreenViewerState
    extends State<_ProductImageFullscreenViewer> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, index) {
              final source = widget.images[index];
              return InteractiveViewer(
                minScale: 1,
                maxScale: 3.5,
                child: Center(
                  child: switch (source) {
                    ProductClientLocalImage(:final file) => Image.file(
                        file,
                        fit: BoxFit.contain,
                        width: size.width,
                        height: size.height,
                      ),
                    ProductClientNetworkImage(:final url) =>
                      HomeMediaImage.workGalleryViewer(
                        context: context,
                        imageUrl: MediaUrlUtils.resolve(url)!,
                        width: size.width,
                        height: size.height,
                      ),
                  },
                ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  const Spacer(),
                  if (widget.images.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${_index + 1} / ${widget.images.length}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
