import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/media_url_utils.dart';
import 'home_media_placeholder.dart';

/// Imágenes del home con caché en disco, memoria optimizada y fade-in.
class HomeMediaImage {
  HomeMediaImage._();

  static int cachePixels(double logicalSize, BuildContext context) {
    final ratio = MediaQuery.devicePixelRatioOf(context);
    return (logicalSize * ratio).round().clamp(1, 4096);
  }

  static bool isSvgUrl(String? url) =>
      url != null && url.toLowerCase().contains('.svg');

  /// Portada de perfil: recorte limpio a todo el ancho.
  static Widget profileCover({
    required BuildContext context,
    required String? imageUrl,
    required double width,
    required double height,
  }) {
    final resolved = MediaUrlUtils.resolve(imageUrl);
    if (resolved == null || resolved.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: const HomeMediaPlaceholder.hero(),
      );
    }

    final memWidth = cachePixels(width, context);
    final memHeight = cachePixels(height, context);

    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: _ProfileCoverFrame(
          url: resolved,
          width: width,
          height: height,
          memWidth: memWidth,
          memHeight: memHeight,
          isSvg: isSvgUrl(resolved),
        ),
      ),
    );
  }

  /// Fondo del hero a pantalla completa.
  static Widget heroBackground({
    required BuildContext context,
    required String? imageUrl,
    required double height,
  }) {
    final resolved = MediaUrlUtils.resolve(imageUrl);
    if (resolved == null || resolved.isEmpty) {
      return const HomeMediaPlaceholder.hero();
    }

    if (isSvgUrl(resolved)) {
      return _CachedSvgImage(
        url: resolved,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        placeholder: const HomeMediaPlaceholder.hero(),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    final memWidth = cachePixels(width, context);
    final memHeight = cachePixels(height, context);

    return CachedNetworkImage(
      imageUrl: resolved,
      httpHeaders: MediaUrlUtils.imageHttpHeaders,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      memCacheWidth: memWidth,
      memCacheHeight: memHeight,
      maxWidthDiskCache: memWidth,
      maxHeightDiskCache: memHeight,
      filterQuality: FilterQuality.medium,
      fadeInDuration: const Duration(milliseconds: 250),
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => const HomeMediaPlaceholder.hero(),
      errorWidget: (_, _, _) => const HomeMediaPlaceholder.hero(),
    );
  }

  /// Banner del carrusel.
  static Widget carouselSlide({
    required BuildContext context,
    required String imageUrl,
    required double width,
    required double height,
  }) {
    final resolved = MediaUrlUtils.resolve(imageUrl);
    if (resolved == null || resolved.isEmpty) {
      return const HomeMediaPlaceholder.carousel();
    }

    if (isSvgUrl(resolved)) {
      return SizedBox(
        width: width,
        height: height,
        child: _CachedSvgImage(
          url: resolved,
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
          placeholder: const HomeMediaPlaceholder.carousel(),
        ),
      );
    }

    final memWidth = cachePixels(width, context);
    final memHeight = cachePixels(height, context);

    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: resolved,
        httpHeaders: MediaUrlUtils.imageHttpHeaders,
        fit: BoxFit.fitWidth,
        alignment: Alignment.bottomCenter,
        width: width,
        height: height,
        memCacheWidth: memWidth,
        memCacheHeight: memHeight,
        maxWidthDiskCache: memWidth,
        maxHeightDiskCache: memHeight,
        filterQuality: FilterQuality.medium,
        fadeInDuration: const Duration(milliseconds: 250),
        fadeOutDuration: Duration.zero,
        placeholder: (_, _) => const HomeMediaPlaceholder.carousel(),
        errorWidget: (_, _, _) => const HomeMediaPlaceholder.carousel(),
      ),
    );
  }

  /// Miniatura cuadrada de galería de trabajos / proyectos (recorte centrado).
  static Widget workGalleryThumb({
    required BuildContext context,
    required String imageUrl,
    required double width,
    required double height,
  }) {
    return _boxedNetworkImage(
      context: context,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      filterQuality: FilterQuality.medium,
      placeholder: const HomeMediaPlaceholder.hero(),
    );
  }

  /// Vista ampliada de foto (por defecto sin recortar).
  /// En hero de producto se puede usar [BoxFit.cover] para llenar el marco.
  static Widget workGalleryViewer({
    required BuildContext context,
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.contain,
  }) {
    return _boxedNetworkImage(
      context: context,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      placeholder: const HomeMediaPlaceholder.hero(),
    );
  }

  static Widget _boxedNetworkImage({
    required BuildContext context,
    required String imageUrl,
    required double width,
    required double height,
    required BoxFit fit,
    required Alignment alignment,
    required FilterQuality filterQuality,
    required Widget placeholder,
  }) {
    final resolved = MediaUrlUtils.resolve(imageUrl);
    if (resolved == null || resolved.isEmpty) {
      return SizedBox(width: width, height: height, child: placeholder);
    }

    if (isSvgUrl(resolved)) {
      return SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: _CachedSvgImage(
            url: resolved,
            fit: fit,
            alignment: alignment,
            placeholder: placeholder,
          ),
        ),
      );
    }

    final memWidth = cachePixels(width, context);
    final memHeight = cachePixels(height, context);

    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: CachedNetworkImage(
          imageUrl: resolved,
          httpHeaders: MediaUrlUtils.imageHttpHeaders,
          fit: fit,
          alignment: alignment,
          width: width,
          height: height,
          memCacheWidth: memWidth,
          memCacheHeight: memHeight,
          maxWidthDiskCache: memWidth,
          maxHeightDiskCache: memHeight,
          filterQuality: filterQuality,
          fadeInDuration: const Duration(milliseconds: 250),
          fadeOutDuration: Duration.zero,
          placeholder: (_, _) => placeholder,
          errorWidget: (_, _, _) => placeholder,
        ),
      ),
    );
  }

  /// Ícono circular de categoría / subcategoría.
  static Widget categoryCircle({
    required BuildContext context,
    required String? imageUrl,
    required double size,
    required IconData fallbackIcon,
  }) {
    final resolved = MediaUrlUtils.resolve(imageUrl);
    if (resolved == null || resolved.isEmpty) {
      return HomeMediaPlaceholder.category(icon: fallbackIcon, size: size);
    }

    if (isSvgUrl(resolved)) {
      return _CachedSvgImage(
        url: resolved,
        fit: BoxFit.cover,
        placeholder: HomeMediaPlaceholder.category(
          icon: fallbackIcon,
          size: size,
        ),
      );
    }

    final memSize = cachePixels(size, context);

    return CachedNetworkImage(
      imageUrl: resolved,
      httpHeaders: MediaUrlUtils.imageHttpHeaders,
      fit: BoxFit.cover,
      width: size,
      height: size,
      memCacheWidth: memSize,
      memCacheHeight: memSize,
      maxWidthDiskCache: memSize,
      maxHeightDiskCache: memSize,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) =>
          HomeMediaPlaceholder.category(icon: fallbackIcon, size: size),
      errorWidget: (_, _, _) =>
          HomeMediaPlaceholder.category(icon: fallbackIcon, size: size),
    );
  }

  static Future<void> warmUp(
    BuildContext context, {
    String? heroUrl,
    Iterable<String> carouselUrls = const [],
    Iterable<String> categoryUrls = const [],
  }) async {
    if (!context.mounted) return;

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bannerMemWidth = (screenWidth * dpr).round().clamp(1, 4096);
    final categoryMemSize = (140 * dpr).round().clamp(1, 512);

    final tasks = <Future<void>>[];

    void queueUrl(String? raw, {required int maxWidth, int? maxHeight}) {
      final resolved = MediaUrlUtils.resolve(raw);
      if (resolved == null || resolved.isEmpty) return;

      if (isSvgUrl(resolved)) {
        tasks.add(
          DefaultCacheManager().downloadFile(
            resolved,
            authHeaders: MediaUrlUtils.imageHttpHeaders ?? const {},
          ),
        );
        return;
      }

      tasks.add(
        precacheImage(
          CachedNetworkImageProvider(
            resolved,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            headers: MediaUrlUtils.imageHttpHeaders,
          ),
          context,
        ),
      );
    }

    queueUrl(heroUrl, maxWidth: bannerMemWidth);

    for (final raw in carouselUrls) {
      queueUrl(raw, maxWidth: bannerMemWidth);
    }

    for (final raw in categoryUrls) {
      queueUrl(raw, maxWidth: categoryMemSize, maxHeight: categoryMemSize);
    }

    await Future.wait(tasks);
  }
}

/// Portada limpia con recorte centrado, sin rellenos laterales difuminados.
class _ProfileCoverFrame extends StatelessWidget {
  const _ProfileCoverFrame({
    required this.url,
    required this.width,
    required this.height,
    required this.memWidth,
    required this.memHeight,
    required this.isSvg,
  });

  final String url;
  final double width;
  final double height;
  final int memWidth;
  final int memHeight;
  final bool isSvg;

  static const _placeholder = HomeMediaPlaceholder.hero();

  @override
  Widget build(BuildContext context) {
    return _ProfileCoverLayer(
      url: url,
      width: width,
      height: height,
      memWidth: memWidth,
      memHeight: memHeight,
      isSvg: isSvg,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}

class _ProfileCoverLayer extends StatelessWidget {
  const _ProfileCoverLayer({
    required this.url,
    required this.width,
    required this.height,
    required this.memWidth,
    required this.memHeight,
    required this.isSvg,
    required this.fit,
    required this.alignment,
  });

  final String url;
  final double width;
  final double height;
  final int memWidth;
  final int memHeight;
  final bool isSvg;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (isSvg) {
      return _CachedSvgImage(
        url: url,
        fit: fit,
        alignment: alignment,
        placeholder: _ProfileCoverFrame._placeholder,
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: MediaUrlUtils.imageHttpHeaders,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      memCacheWidth: memWidth,
      memCacheHeight: memHeight,
      maxWidthDiskCache: memWidth,
      maxHeightDiskCache: memHeight,
      filterQuality: FilterQuality.high,
      fadeInDuration: const Duration(milliseconds: 250),
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => _ProfileCoverFrame._placeholder,
      errorWidget: (_, _, _) => _ProfileCoverFrame._placeholder,
    );
  }
}

class _CachedSvgImage extends StatefulWidget {
  const _CachedSvgImage({
    required this.url,
    required this.fit,
    this.alignment = Alignment.center,
    required this.placeholder,
  });

  final String url;
  final BoxFit fit;
  final Alignment alignment;
  final Widget placeholder;

  @override
  State<_CachedSvgImage> createState() => _CachedSvgImageState();
}

class _CachedSvgImageState extends State<_CachedSvgImage> {
  late Future<String> _svgFuture;

  @override
  void initState() {
    super.initState();
    _svgFuture = _loadSvg();
  }

  @override
  void didUpdateWidget(covariant _CachedSvgImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _svgFuture = _loadSvg();
    }
  }

  Future<String> _loadSvg() async {
    final file = await DefaultCacheManager().getSingleFile(
      widget.url,
      headers: MediaUrlUtils.imageHttpHeaders ?? const {},
    );
    return file.readAsString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _svgFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return widget.placeholder;
        }

        return SvgPicture.string(
          snapshot.data!,
          fit: widget.fit,
          alignment: widget.alignment,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
}
