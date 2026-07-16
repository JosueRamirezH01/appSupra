import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../auth/auth_ui.dart';
import '../home/home_media_image.dart';
import '../technician_verification_badge.dart';
import '../professionals/professional_grid_card.dart';

/// Tarjeta compacta para listas horizontales de técnicos (home, carruseles).
class TechnicianHorizontalCard extends StatelessWidget {
  const TechnicianHorizontalCard({
    super.key,
    required this.technician,
    required this.onTap,
    this.width = cardWidth,
  });

  static const double cardWidth = 168;
  static const double cardHeight = 252;

  final TechnicianPublicModel technician;
  final VoidCallback onTap;
  final double width;

  static String _subcategoryLabel(TechnicianPublicModel technician) {
    if (technician.subcategories.isNotEmpty) {
      return technician.subcategories.first.name;
    }
    if (technician.specialty != null && technician.specialty!.isNotEmpty) {
      return technician.specialty!;
    }
    return 'Profesional';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ProfessionalGridCard.coverImageUrl(technician);
    final category = _subcategoryLabel(technician);
    final imageSize = width - 20;

    return SizedBox(
      width: width,
      height: cardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EAED)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: _CardImage(imageUrl: imageUrl, size: imageSize),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    technician.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      height: 1.2,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: TechnicianVerificationBadge.fromPublic(
                        technician,
                        compact: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final resolved = MediaUrlUtils.resolve(imageUrl);
    if (resolved == null || resolved.isEmpty) {
      return ColoredBox(
        color: AppBrandColors.fieldFill,
        child: Center(
          child: Icon(
            Icons.person_outline_rounded,
            size: size * 0.34,
            color: AppBrandColors.primaryGreen.withValues(alpha: 0.75),
          ),
        ),
      );
    }

    return HomeMediaImage.workGalleryThumb(
      context: context,
      imageUrl: resolved,
      width: size,
      height: size,
    );
  }
}
