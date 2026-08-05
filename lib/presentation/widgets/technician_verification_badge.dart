import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../utils/technician_display_name.dart';
import '../utils/technician_pricing_utils.dart';

class TechnicianVerificationState {
  const TechnicianVerificationState._({
    required this.isVerified,
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.border,
  });

  factory TechnicianVerificationState.from({
    required bool verified,
    String? verificationStatus,
  }) {
    final isApproved = verified || verificationStatus == 'aprobado';

    if (isApproved) {
      return TechnicianVerificationState._(
        isVerified: true,
        label: 'Identidad verificada',
        icon: Icons.verified_rounded,
        foreground: const Color(0xFF0F766E),
        background: const Color(0xFFE6F7F4),
        border: const Color(0xFF5EEAD4),
      );
    }

    if (verificationStatus == 'pendiente') {
      return TechnicianVerificationState._(
        isVerified: false,
        label: 'Verificación pendiente',
        icon: Icons.hourglass_top_rounded,
        foreground: const Color(0xFFB45309),
        background: const Color(0xFFFFF7ED),
        border: const Color(0xFFFDBA74),
      );
    }

    return TechnicianVerificationState._(
      isVerified: false,
      label: 'No verificado',
      icon: Icons.shield_outlined,
      foreground: const Color(0xFF6B7280),
      background: const Color(0xFFF3F4F6),
      border: const Color(0xFFD1D5DB),
    );
  }

  final bool isVerified;
  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Color border;
}

class TechnicianVerificationBadge extends StatelessWidget {
  const TechnicianVerificationBadge({
    super.key,
    required this.verified,
    this.verificationStatus,
    this.compact = false,
  });

  final bool verified;
  final String? verificationStatus;
  final bool compact;

  factory TechnicianVerificationBadge.fromPublic(
    TechnicianPublicModel tech, {
    bool compact = false,
  }) {
    return TechnicianVerificationBadge(
      verified: tech.verified,
      verificationStatus: tech.verificationStatus,
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TechnicianVerificationState.from(
      verified: verified,
      verificationStatus: verificationStatus,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: state.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: state.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            state.icon,
            size: compact ? 14 : 16,
            color: state.foreground,
          ),
          const SizedBox(width: 4),
          Text(
            state.label,
            style: GoogleFonts.poppins(
              fontSize: compact ? 11 : 12,
              color: state.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TechnicianCertificationBadge extends StatelessWidget {
  const TechnicianCertificationBadge({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_rounded,
            size: compact ? 14 : 16,
            color: const Color(0xFF1D4ED8),
          ),
          const SizedBox(width: 4),
          Text(
            'Certificación validada',
            style: GoogleFonts.poppins(
              fontSize: compact ? 11 : 12,
              color: const Color(0xFF1D4ED8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TechnicianAvatarWithBadge extends StatelessWidget {
  const TechnicianAvatarWithBadge({
    super.key,
    required this.name,
    this.photoUrl,
    required this.verified,
    this.verificationStatus,
    this.radius = 28,
  });

  final String name;
  final String? photoUrl;
  final bool verified;
  final String? verificationStatus;
  final double radius;

  factory TechnicianAvatarWithBadge.fromPublic(
    TechnicianPublicModel tech, {
    double radius = 28,
  }) {
    return TechnicianAvatarWithBadge(
      name: tech.publicDisplayName,
      photoUrl: tech.profilePhotoUrl,
      verified: tech.verified,
      verificationStatus: tech.verificationStatus,
      radius: radius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TechnicianVerificationState.from(
      verified: verified,
      verificationStatus: verificationStatus,
    );
    final badgeSize = radius * 0.62;

    return SizedBox(
      width: radius * 2 + 4,
      height: radius * 2 + 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: MediaUrlUtils.networkImage(photoUrl),
            child: photoUrl == null
                ? Text(name.characters.first.toUpperCase())
                : null,
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: state.isVerified
                    ? const Color(0xFF0D9488)
                    : const Color(0xFF9CA3AF),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                state.isVerified
                    ? Icons.verified_rounded
                    : Icons.shield_outlined,
                size: badgeSize * 0.62,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TechnicianListCard extends StatelessWidget {
  const TechnicianListCard({
    super.key,
    required this.technician,
    required this.onTap,
  });

  final TechnicianPublicModel technician;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      if (technician.specialty != null && technician.specialty!.isNotEmpty)
        technician.specialty!,
      ?formatMinimumQuoteLabel(technician.minimumQuote),
      if (technician.distanceKm != null)
        'A ${technician.distanceKm!.toStringAsFixed(1)} km',
      if (technician.averageRating != null)
        '★ ${technician.averageRating!.toStringAsFixed(1)} (${technician.ratingCount})',
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              TechnicianAvatarWithBadge.fromPublic(technician),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technician.publicDisplayName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    if (subtitleParts.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitleParts.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TechnicianVerificationBadge.fromPublic(technician),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}
