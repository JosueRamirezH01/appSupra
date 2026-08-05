import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage_service.dart';
import '../../../core/utils/media_url_utils.dart';

/// Loads public or private `/uploads` media with the correct headers.
///
/// Private identity docs require Bearer; public portfolio/work photos do not.
/// Single presentation widget — reuse instead of duplicating Image.network + auth.
class AuthenticatedNetworkImage extends ConsumerWidget {
  const AuthenticatedNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.errorBuilder,
    this.placeholder,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolved = MediaUrlUtils.resolve(url) ?? url;

    return FutureBuilder<String?>(
      future: ref.read(secureStorageServiceProvider).getAccessToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return placeholder ??
              SizedBox(
                width: width,
                height: height,
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
        }

        final headers = MediaUrlUtils.headersForMedia(
          url: resolved,
          accessToken: snapshot.data,
        );

        return Image.network(
          resolved,
          fit: fit,
          width: width,
          height: height,
          alignment: alignment,
          headers: headers,
          errorBuilder: errorBuilder ??
              (context, error, stackTrace) =>
                  placeholder ??
                  ColoredBox(
                    color: const Color(0xFFE2E8F0),
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return placeholder ??
                SizedBox(
                  width: width,
                  height: height,
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
          },
        );
      },
    );
  }
}
