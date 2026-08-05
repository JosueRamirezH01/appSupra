import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../widgets/media/authenticated_network_image.dart';

/// Galería a pantalla completa: swipe entre fotos, zoom y contador `N / total`.
///
/// No cambia el flujo de negocio: solo mejora la navegación visual entre
/// imágenes ya cargadas del servicio.
class TechnicianPhotoGalleryScreen extends StatefulWidget {
  const TechnicianPhotoGalleryScreen({
    super.key,
    required this.title,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  final String title;
  final List<String> imageUrls;
  final int initialIndex;

  @override
  State<TechnicianPhotoGalleryScreen> createState() =>
      _TechnicianPhotoGalleryScreenState();
}

class _TechnicianPhotoGalleryScreenState
    extends State<TechnicianPhotoGalleryScreen> {
  late final PageController _pageController;
  late int _index;

  List<String> get _urls => widget.imageUrls
      .map(MediaUrlUtils.resolve)
      .whereType<String>()
      .where((url) => url.isNotEmpty)
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    final total = _urls.length;
    _index = total == 0
        ? 0
        : widget.initialIndex.clamp(0, total - 1).toInt();
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = _urls;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          if (urls.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_index + 1} / ${urls.length}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: urls.isEmpty
          ? const Center(
              child: Text(
                'No hay fotos para mostrar',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: urls.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) {
                    return _ZoomablePhoto(url: urls[index]);
                  },
                ),
                if (urls.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 28 + MediaQuery.paddingOf(context).bottom,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < urls.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _index ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? Colors.white
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ZoomablePhoto extends StatelessWidget {
  const _ZoomablePhoto({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.8,
        maxScale: 4,
        child: AuthenticatedNetworkImage(
          url: url,
          fit: BoxFit.contain,
          placeholder: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          errorBuilder: (_, _, _) => const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white70,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  'No se pudo cargar la imagen',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
