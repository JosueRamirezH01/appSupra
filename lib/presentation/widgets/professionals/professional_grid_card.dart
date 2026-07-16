import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../auth/auth_ui.dart';
import '../catalog/browse_card_media_placeholder.dart';
import '../technician_verification_badge.dart';

class ProfessionalGridCard extends StatelessWidget {
  const ProfessionalGridCard({
    super.key,
    required this.technician,
    required this.onTap,
    this.highlightSubSubCategoryId,
    this.showPriorityMatch = false,
  });

  final TechnicianPublicModel technician;
  final VoidCallback onTap;
  final int? highlightSubSubCategoryId;
  final bool showPriorityMatch;

  static String badgeLabel(
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

    if (technician.subSubCategories.isNotEmpty) {
      return technician.subSubCategories.first.name;
    }
    if (technician.subcategories.isNotEmpty) {
      return technician.subcategories.first.name;
    }
    if (technician.specialty != null && technician.specialty!.isNotEmpty) {
      return technician.specialty!;
    }
    return 'Profesional';
  }

  static String? coverImageUrl(TechnicianPublicModel technician) {
    if (technician.workPhotos.isNotEmpty) {
      return technician.workPhotos.first.imageUrl;
    }
    for (final item in technician.portfolio) {
      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
        return item.imageUrl;
      }
    }
    return technician.profilePhotoUrl;
  }

  static String shortName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) return fullName;
    final last = parts.last;
    if (last.isEmpty) return parts.first;
    return '${parts.first} ${last[0].toUpperCase()}.';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = MediaUrlUtils.resolve(coverImageUrl(technician));
    final description = technician.description?.trim().isNotEmpty == true
        ? technician.description!.trim()
        : (technician.specialty ?? 'Profesional verificado');
    final badge = badgeLabel(
      technician,
      highlightSubSubCategoryId: highlightSubSubCategoryId,
    );

    return Material(
      color: Colors.white,
      elevation: showPriorityMatch ? 4 : 2,
      shadowColor: showPriorityMatch
          ? const Color(0x3376B72A)
          : const Color(0x1A000000),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.05,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CardImage(imageUrl: imageUrl),
                  if (showPriorityMatch)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppBrandColors.primaryGreen,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Coincide',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortName(technician.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: TechnicianVerificationBadge.fromPublic(
                        technician,
                        compact: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const BrowseCardMediaPlaceholder(
        kind: BrowseCardMediaKind.professional,
      );
    }

    return Image(
      image: MediaUrlUtils.networkImage(imageUrl)!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const BrowseCardMediaPlaceholder(
        kind: BrowseCardMediaKind.professional,
      ),
    );
  }
}
