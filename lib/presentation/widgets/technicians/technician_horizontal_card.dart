import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../utils/technician_pricing_utils.dart';
import '../../utils/technician_display_name.dart';
import '../auth/auth_ui.dart';
import '../home/home_media_image.dart';
import '../technician_verification_badge.dart';

/// Cómo mostrar la verificación en la card.
enum TechnicianCardVerification {
  /// Badge con texto (home / descubrimiento).
  labeled,

  /// Solo sello sobre la foto, arriba a la derecha (lista / browse).
  seal,
}

/// Card unificada de técnico (home y lista de profesionales).
class TechnicianHorizontalCard extends StatelessWidget {
  const TechnicianHorizontalCard({
    super.key,
    required this.technician,
    required this.onTap,
    this.width = cardWidth,
    this.verification = TechnicianCardVerification.labeled,
    this.highlightSubSubCategoryId,
    this.showPriorityMatch = false,
  });

  static const double cardWidth = 168;

  /// Altura de referencia (ancho por defecto). Preferir [heightForWidth].
  static double get cardHeight => heightForWidth(cardWidth);

  static const double _contentPadding = 20;
  static const double _imageToTextGap = 8;

  final TechnicianPublicModel technician;
  final VoidCallback onTap;
  final double width;
  final TechnicianCardVerification verification;
  final int? highlightSubSubCategoryId;
  final bool showPriorityMatch;

  /// Altura total según ancho y modo de verificación.
  static double heightForWidth(
    double width, {
    TechnicianCardVerification verification = TechnicianCardVerification.labeled,
  }) {
    final imageSide = (width - _contentPadding).clamp(96.0, 220.0);
    final textBlock = verification == TechnicianCardVerification.seal ? 55.0 : 90.0;
    return _contentPadding + imageSide + _imageToTextGap + textBlock;
  }

  /// Aspect ratio para grids de 2 columnas.
  static double gridAspectRatio({
    required double gridInnerWidth,
    required double crossAxisSpacing,
    int crossAxisCount = 2,
    TechnicianCardVerification verification = TechnicianCardVerification.seal,
  }) {
    final cardW = (gridInnerWidth - crossAxisSpacing * (crossAxisCount - 1)) / crossAxisCount;
    return cardW / heightForWidth(cardW, verification: verification);
  }

  /// Imagen de identidad para cards: perfil (independiente) o logo (empresa).
  /// No usa fotos de trabajo/portafolio.
  static String? identityImageUrl(TechnicianPublicModel technician) {
    final isEmpresa = technician.profileType == 'empresa';
    if (isEmpresa) {
      final logo = technician.companyLogoUrl?.trim();
      if (logo != null && logo.isNotEmpty) return logo;
      final photo = technician.profilePhotoUrl?.trim();
      if (photo != null && photo.isNotEmpty) return photo;
      return null;
    }
    final photo = technician.profilePhotoUrl?.trim();
    if (photo != null && photo.isNotEmpty) return photo;
    return null;
  }

  /// @deprecated Usar [identityImageUrl]. Se mantiene por compatibilidad.
  static String? coverImageUrl(TechnicianPublicModel technician) =>
      identityImageUrl(technician);

  static String categoryLabel(
    TechnicianPublicModel technician, {
    int? highlightSubSubCategoryId,
  }) {
    if (highlightSubSubCategoryId != null) {
      for (final item in technician.subSubCategories) {
        if (item.id == highlightSubSubCategoryId) {
          return item.name;
        }
      }
    }
    if (technician.subcategories.isNotEmpty) {
      return technician.subcategories.first.name;
    }
    if (technician.subSubCategories.isNotEmpty) {
      return technician.subSubCategories.first.name;
    }
    if (technician.specialty != null && technician.specialty!.isNotEmpty) {
      return technician.specialty!;
    }
    return 'Profesional';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = identityImageUrl(technician);
    final category = categoryLabel(technician,
      highlightSubSubCategoryId: highlightSubSubCategoryId,
    );
    final quoteLabel = formatMinimumQuoteLabel(technician.minimumQuote);
    final height = heightForWidth(width, verification: verification);
    final textScaler = MediaQuery.textScalerOf(context);
    final largeText = textScaler.scale(14) > 15.5;
    final useSeal = verification == TechnicianCardVerification.seal;
    final isEmpresa = technician.profileType == 'empresa';
    final verificationState = TechnicianVerificationState.from(
      verified: technician.verified,
      verificationStatus: technician.verificationStatus,
    );

    return SizedBox(
      width: width,
      height: height,
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _CardImage(
                            imageUrl: imageUrl,
                            size: width,
                            isEmpresa: isEmpresa,
                          ),
                          if (showPriorityMatch)
                            const Positioned(
                              left: 7,
                              top: 7,
                              child: _CornerPill(
                                label: 'Coincide',
                                background: AppBrandColors.primaryGreen,
                              ),
                            )
                          else if (technician.placement == 'membership')
                            const Positioned(
                              left: 7,
                              top: 7,
                              child: _CornerPill(
                                label: 'Destacado',
                                background: Color(0xD92F3437),
                              ),
                            ),
                          if (useSeal && verificationState.isVerified)
                            const Positioned(
                              right: 7,
                              top: 7,
                              child: _VerifiedSeal(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: _imageToTextGap),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final nameMaxLines =
                            (constraints.maxHeight < 70 || largeText) ? 1 : 2;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              technician.publicDisplayName,
                              maxLines: nameMaxLines,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                color: AppBrandColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                height: 1.15,
                                color: AppBrandColors.textMuted,
                              ),
                            ),
                            if (quoteLabel != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                quoteLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  height: 1.15,
                                  fontWeight: FontWeight.w600,
                                  color: AppBrandColors.primaryGreen,
                                ),
                              ),
                            ],
                            if (technician.distanceKm != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'A ${technician.distanceKm!.toStringAsFixed(1)} km',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  height: 1.15,
                                  color: AppBrandColors.textMuted,
                                ),
                              ),
                            ],
                            if (!useSeal) ...[
                              const SizedBox(height: 4),
                              Flexible(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: TechnicianVerificationBadge.fromPublic(
                                      technician,
                                      compact: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
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

class _VerifiedSeal extends StatelessWidget {
  const _VerifiedSeal();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xE60F766E),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(5),
        child: Icon(
          Icons.verified_rounded,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _CornerPill extends StatelessWidget {
  const _CornerPill({
    required this.label,
    required this.background,
  });

  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.imageUrl,
    required this.size,
    this.isEmpresa = false,
  });

  final String? imageUrl;
  final double size;
  final bool isEmpresa;

  @override
  Widget build(BuildContext context) {
    final resolved = MediaUrlUtils.resolve(imageUrl);
    if (resolved == null || resolved.isEmpty) {
      return ColoredBox(
        color: AppBrandColors.fieldFill,
        child: Center(
          child: Icon(
            isEmpresa ? Icons.business_rounded : Icons.person_outline_rounded,
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
