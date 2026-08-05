import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';

/// Prefijo para previsualizar archivos locales en el carrusel (owner preview).
const kWorkCaseLocalFilePrefix = 'localfile:';

bool isWorkCaseLocalFileUrl(String url) =>
    url.startsWith(kWorkCaseLocalFilePrefix);

String workCaseLocalFilePath(String url) =>
    url.substring(kWorkCaseLocalFilePrefix.length);

Widget buildWorkCaseImage({
  required String imageUrl,
  BoxFit fit = BoxFit.cover,
}) {
  if (isWorkCaseLocalFileUrl(imageUrl)) {
    final file = File(workCaseLocalFilePath(imageUrl));
    if (file.existsSync()) {
      return Image.file(file, fit: fit);
    }
    return const ColoredBox(
      color: Color(0xFFE8EAED),
      child: Icon(Icons.broken_image_outlined),
    );
  }

  final provider = MediaUrlUtils.networkImage(imageUrl);
  if (provider == null) {
    return const ColoredBox(
      color: Color(0xFFE8EAED),
      child: Icon(Icons.broken_image_outlined),
    );
  }
  return Image(image: provider, fit: fit);
}

/// Carrusel público de casos de trabajo (imagen + descripción + estimación).
class TechnicianWorkCasesCarousel extends StatelessWidget {
  const TechnicianWorkCasesCarousel({
    super.key,
    required this.photos,
    required this.onTap,
  });

  final List<TechnicianWorkPhotoModel> photos;
  final void Function(TechnicianWorkPhotoModel photo, int index) onTap;

  static String formatEstimatedCost(double? value) {
    if (value == null) return 'Sin estimado';
    final rounded = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return 'Estimado S/ $rounded';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final photo = photos[index];
          return _WorkCaseCard(
            photo: photo,
            onTap: () => onTap(photo, index),
          );
        },
      ),
    );
  }
}

Future<void> showWorkCaseDetailSheet({
  required BuildContext context,
  required TechnicianWorkPhotoModel photo,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      final caption = photo.caption?.trim();
      final hasCaption = caption != null && caption.isNotEmpty;

      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 11,
                  child: buildWorkCaseImage(imageUrl: photo.imageUrl),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                hasCaption ? caption : 'Trabajo realizado',
                style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                TechnicianWorkCasesCarousel.formatEstimatedCost(
                  photo.estimatedCost,
                ),
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Estimación referencial de un trabajo ya realizado. '
                'No es la cotización de este servicio.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  height: 1.4,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _WorkCaseCard extends StatelessWidget {
  const _WorkCaseCard({
    required this.photo,
    required this.onTap,
  });

  final TechnicianWorkPhotoModel photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final caption = photo.caption?.trim();
    final hasCaption = caption != null && caption.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: 176,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8EAED)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: buildWorkCaseImage(imageUrl: photo.imageUrl),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasCaption ? caption : 'Trabajo realizado',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: AppBrandColors.textDark,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        TechnicianWorkCasesCarousel.formatEstimatedCost(
                          photo.estimatedCost,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppBrandColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
