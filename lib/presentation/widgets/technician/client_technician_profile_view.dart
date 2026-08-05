import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/service_constants.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../models/client_technician_profile_ui_model.dart';
import '../../utils/technician_display_name.dart';
import '../../utils/technician_pricing_utils.dart';
import 'technician_featured_projects_section.dart';
import 'technician_profile_owner_config.dart';
import 'technician_service_carousel_section.dart';
import '../home/home_media_image.dart';
import '../technician_verification_badge.dart';

/// Perfil publico del tecnico ” vista cliente (independiente / empresa).
class ClientTechnicianProfileView extends StatelessWidget {
  const ClientTechnicianProfileView({
    super.key,
    required this.technician,
    this.ownerConfig,
    this.showBackButton = false,
    this.contextSubSubCategoryId,
  });

  final TechnicianPublicModel technician;
  final TechnicianProfileOwnerConfig? ownerConfig;
  final bool showBackButton;
  final int? contextSubSubCategoryId;

  bool get _isOwner => ownerConfig != null;
  bool get _canEdit => ownerConfig?.canEdit ?? false;

  bool _showMoreAboutCta(ClientTechnicianProfileUiModel ui) {
    if (_isOwner && _canEdit) return true;
    return ui.hasAbout ||
        ui.serviceArea != null ||
        technician.coversAllPeru ||
        technician.coverageDistricts.isNotEmpty ||
        technician.distanceKm != null;
  }

  String _moreAboutLabel(ClientTechnicianProfileTheme theme) =>
      theme.isEmpresa ? 'Más sobre la empresa' : 'Más sobre mí';

  @override
  Widget build(BuildContext context) {
    final ui = ClientTechnicianProfileUiModel.from(technician);
    final theme = ui.theme;
    final contextService = _resolveContextService();
    final showMoreAbout = _showMoreAboutCta(ui);

    return ColoredBox(
      color: AppBrandColors.scaffoldBackground,
      child: Column(
        children: [
          if (_isOwner)
            _OwnerPreviewHeader(
              canEdit: _canEdit,
              showBackButton: showBackButton,
            ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                ..._buildProfileHeroSlivers(
                  context: context,
                  coverUrl: ui.coverUrl,
                  technician: technician,
                  theme: theme,
                  showBackButton: !_isOwner,
                  onEditPhoto: _canEdit ? ownerConfig?.onEditProfilePhoto : null,
                  moreAboutLabel: showMoreAbout ? _moreAboutLabel(theme) : null,
                  onMoreAbout: showMoreAbout
                      ? () {
                          HapticFeedback.selectionClick();
                          showTechnicianAboutProfileSheet(
                            context,
                            technician: technician,
                            ui: ui,
                            canEdit: _canEdit,
                            onEditAbout: ownerConfig?.onEditAbout,
                            onEditServiceArea: ownerConfig?.onEditServiceArea,
                          );
                        }
                      : null,
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12)),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      _buildProfileSections(
                        ui: ui,
                        theme: theme,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isOwner)
            _OwnerPreviewBottomBar(theme: theme),
        ],
      ),
    );
  }

  TechnicianSubSubCategoryModel? _resolveContextService() {
    final contextId = contextSubSubCategoryId;
    if (contextId == null) return null;
    for (final service in technician.subSubCategories) {
      if (service.id == contextId) return service;
    }
    return null;
  }

  List<Widget> _buildProfileSections({required ClientTechnicianProfileUiModel ui, required ClientTechnicianProfileTheme theme,}) {
    final sections = <Widget>[];

    if (_isOwner && _canEdit) {
      final progress = _OwnerProfileProgress.from(
        technician: technician,
        hasAbout: ui.hasAbout,
        hasServiceArea:
            ui.serviceArea != null ||
            technician.coversAllPeru ||
            technician.coverageDistricts.isNotEmpty,
      );
      if (!progress.isComplete) {
        sections.add(
          _OwnerProfileProgressBanner(
            progress: progress,
            theme: theme,
            onTapAbout: ownerConfig?.onEditAbout,
            onTapSpecialties: ownerConfig?.onManageSpecialties,
            onTapServiceArea: ownerConfig?.onEditServiceArea,
          ),
        );
      }
    }

    sections.addAll(_buildServiceCarousels());

    if (_isOwner && _canEdit && ownerConfig?.onManageSpecialties != null) {
      sections.add(
        _OwnerSpecialtiesManageBar(
          specialtyCount: technician.subcategories.length,
          maxSpecialties: ServiceConstants.maxRegistrationSpecialties,
          onManage: ownerConfig!.onManageSpecialties!,
        ),
      );
    }

    sections.add(
      TechnicianFeaturedProjectsSection(
        technicianUserId: technician.id,
        projects: technician.portfolio,
        theme: theme,
        isOwner: _isOwner,
        canEdit: _canEdit,
        onManage: _canEdit ? ownerConfig?.onEditFeaturedProjects : null,
      ),
    );

    return sections;
  }

  List<Widget> _buildServiceCarousels() {
    return [
      for (final subcategory in technician.subcategories)
        TechnicianServiceCarouselSection(
          technicianUserId: technician.id,
          subcategoryName: subcategory.name,
          services: technician.subSubCategories.where((service) => service.subcategoryId == subcategory.id).toList(),
          isOwner: _isOwner,
          canEdit: _canEdit,
          onAddService:
              _canEdit && ownerConfig?.onAddServiceToSpecialty != null
              ? () => ownerConfig!.onAddServiceToSpecialty!(subcategory)
              : null,
          onRemoveService: _canEdit && ownerConfig?.onRemoveService != null
              ? (service) => ownerConfig!.onRemoveService!(service)
              : null,
        ),
    ];
  }
}

class _OwnerPreviewHeader extends StatelessWidget {
  const _OwnerPreviewHeader({
    required this.canEdit,
    required this.showBackButton,
  });

  final bool canEdit;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(4, top + 4, 16, 8),
      color: AppBrandColors.scaffoldBackground,
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            )
          else
            const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mi perfil publico',
              style: GoogleFonts.montserrat(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppBrandColors.textDark,
              ),
            ),
          ),
          if (!canEdit)
            Text(
              'Solo lectura',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _OwnerProfileProgress {
  const _OwnerProfileProgress({
    required this.completed,
    required this.total,
    required this.hasSpecialty,
    required this.hasServicePhotos,
    required this.hasAbout,
    required this.hasServiceArea,
  });

  final int completed;
  final int total;
  final bool hasSpecialty;
  final bool hasServicePhotos;
  final bool hasAbout;
  final bool hasServiceArea;

  bool get isComplete => completed >= total;

  factory _OwnerProfileProgress.from({
    required TechnicianPublicModel technician,
    required bool hasAbout,
    required bool hasServiceArea,
  }) {
    final hasSpecialty = technician.subcategories.isNotEmpty;
    final hasServicePhotos = technician.subSubCategories.any(
      (service) => service.hasPortfolio || service.workPhotos.isNotEmpty,
    );
    var completed = 0;
    if (hasSpecialty) completed++;
    if (hasServicePhotos) completed++;
    if (hasAbout) completed++;
    return _OwnerProfileProgress(
      completed: completed,
      total: 3,
      hasSpecialty: hasSpecialty,
      hasServicePhotos: hasServicePhotos,
      hasAbout: hasAbout,
      hasServiceArea: hasServiceArea,
    );
  }
}

class _OwnerProfileProgressBanner extends StatelessWidget {
  const _OwnerProfileProgressBanner({
    required this.progress,
    required this.theme,
    this.onTapAbout,
    this.onTapSpecialties,
    this.onTapServiceArea,
  });

  final _OwnerProfileProgress progress;
  final ClientTechnicianProfileTheme theme;
  final VoidCallback? onTapAbout;
  final VoidCallback? onTapSpecialties;
  final VoidCallback? onTapServiceArea;

  @override
  Widget build(BuildContext context) {
    late final String nextHint;
    VoidCallback? nextAction;
    if (!progress.hasSpecialty) {
      nextHint = 'Agrega una especialidad';
      nextAction = onTapSpecialties;
    } else if (!progress.hasServicePhotos) {
      nextHint = 'Agrega fotos a un servicio';
      nextAction = null;
    } else if (!progress.hasAbout) {
      nextHint = 'Completa tu presentación';
      nextAction = onTapAbout;
    } else if (!progress.hasServiceArea) {
      nextHint = 'Configura tu zona de servicio';
      nextAction = onTapServiceArea;
    } else {
      nextHint = 'Sigue mejorando tu perfil';
      nextAction = null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: theme.accentSoft,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: nextAction,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress.completed / progress.total,
                        strokeWidth: 4,
                        backgroundColor: Colors.white,
                        color: theme.accent,
                      ),
                      Center(
                        child: Text(
                          '${progress.completed}/${progress.total}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppBrandColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completa tu perfil',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: AppBrandColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nextHint,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (nextAction != null)
                  Icon(Icons.chevron_right_rounded, color: theme.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// CTA owner-only debajo de los carruseles: gestionar especialidades (máx. 3).
class _OwnerSpecialtiesManageBar extends StatelessWidget {
  const _OwnerSpecialtiesManageBar({
    required this.specialtyCount,
    required this.maxSpecialties,
    required this.onManage,
  });

  final int specialtyCount;
  final int maxSpecialties;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final atLimit = specialtyCount >= maxSpecialties;
    final empty = specialtyCount == 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (empty)
            FilledButton.icon(
              onPressed: onManage,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                'Agregar especialidad',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppBrandColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: onManage,
              icon: Icon(
                atLimit ? Icons.tune_rounded : Icons.add_rounded,
                size: 20,
              ),
              label: Text(
                atLimit
                    ? 'Administrar especialidades'
                    : 'Agregar o administrar especialidades',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppBrandColors.primaryGreen,
                side: BorderSide(
                  color: AppBrandColors.primaryGreen.withValues(alpha: 0.55),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            atLimit
                ? 'Límite de $maxSpecialties especialidades · $specialtyCount/$maxSpecialties'
                : '$specialtyCount de $maxSpecialties especialidades',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: AppBrandColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerEmptyPlaceholder extends StatelessWidget {
  const _OwnerEmptyPlaceholder({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        height: 1.45,
        color: AppBrandColors.textMuted,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _ContactContextBanner extends StatelessWidget {
  const _ContactContextBanner({required this.serviceName});

  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppBrandColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppBrandColors.primaryGreen.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.handyman_outlined,
            color: AppBrandColors.primaryGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Interesado en: $serviceName',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerPreviewBottomBar extends StatelessWidget {
  const _OwnerPreviewBottomBar({required this.theme});

  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 10,
      shadowColor: const Color(0x22000000),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, color: theme.accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Vista previa publica',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    Text(
                      'Asi te ven los clientes',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Portada colapsable + card de identidad superpuesta que permanece (pinned).
List<Widget> _buildProfileHeroSlivers({
  required BuildContext context,
  required TechnicianPublicModel technician,
  required ClientTechnicianProfileTheme theme,
  required bool showBackButton,
  String? coverUrl,
  VoidCallback? onEditPhoto,
  String? moreAboutLabel,
  VoidCallback? onMoreAbout,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final topInset = showBackButton ? MediaQuery.paddingOf(context).top : 0.0;
  final coverHeight = (screenWidth * 0.36).clamp(180.0, 200.0) + topInset;
  final hasMinimumQuote = technician.minimumQuote != null;
  final identityCardHeight = moreAboutLabel != null
      ? (hasMinimumQuote ? 214.0 : 214.0)
      : (hasMinimumQuote ? 214.0 : 170.0);
  final overlap = (screenWidth * 0.14).clamp(48.0, 60.0);

  return [
    SliverPersistentHeader(
      pinned: true,
      delegate: _ProfileHeroHeaderDelegate(
        coverHeight: coverHeight,
        identityCardHeight: identityCardHeight,
        overlap: overlap,
        topInset: topInset,
        showBackButton: showBackButton,
        coverUrl: coverUrl,
        theme: theme,
        screenWidth: screenWidth,
        onBack: () => Navigator.of(context).maybePop(),
        identityCard: _ProfileIdentityCard(
          technician: technician,
          theme: theme,
          onEditPhoto: onEditPhoto,
          moreAboutLabel: moreAboutLabel,
          onMoreAbout: onMoreAbout,
        ),
      ),
    ),
  ];
}

class _ProfileHeroHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfileHeroHeaderDelegate({
    required this.coverHeight,
    required this.identityCardHeight,
    required this.overlap,
    required this.topInset,
    required this.showBackButton,
    required this.theme,
    required this.screenWidth,
    required this.onBack,
    required this.identityCard,
    this.coverUrl,
  });

  final double coverHeight;
  final double identityCardHeight;
  final double overlap;
  final double topInset;
  final bool showBackButton;
  final String? coverUrl;
  final ClientTechnicianProfileTheme theme;
  final double screenWidth;
  final VoidCallback onBack;
  final Widget identityCard;

  @override
  double get maxExtent => coverHeight + identityCardHeight - overlap;

  @override
  double get minExtent => identityCardHeight + 8;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final collapseRange = (maxExtent - minExtent).clamp(1.0, double.infinity);
    final t = (shrinkOffset / collapseRange).clamp(0.0, 1.0);
    final coverOpacity = (1.0 - t * 1.35).clamp(0.0, 1.0);
    final coverSlide = -shrinkOffset * 0.35;

    return ColoredBox(
      color: AppBrandColors.scaffoldBackground,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: coverSlide,
            left: 0,
            right: 0,
            height: coverHeight,
            child: IgnorePointer(
              ignoring: coverOpacity < 0.15,
              child: Opacity(
                opacity: coverOpacity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _ProfileCoverBackground(
                      coverUrl: coverUrl,
                      theme: theme,
                      width: screenWidth,
                      height: coverHeight,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x33000000),
                            Color(0x00000000),
                            Color(0x24000000),
                          ],
                          stops: [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showBackButton)
            Positioned(
              top: topInset + 6,
              left: 8,
              child: Material(
                color: coverOpacity > 0.45
                    ? Colors.black.withValues(alpha: 0.28)
                    : Colors.white.withValues(alpha: 0.92),
                elevation: coverOpacity > 0.45 ? 0 : 2,
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Volver',
                  onPressed: onBack,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: coverOpacity > 0.45
                        ? Colors.white
                        : AppBrandColors.textDark,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: overlapsContent || t > 0.85
                    ? const [
                        BoxShadow(
                          color: Color(0x140B1C15),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: identityCard,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ProfileHeroHeaderDelegate oldDelegate) {
    return coverHeight != oldDelegate.coverHeight ||
        identityCardHeight != oldDelegate.identityCardHeight ||
        overlap != oldDelegate.overlap ||
        coverUrl != oldDelegate.coverUrl ||
        showBackButton != oldDelegate.showBackButton ||
        theme != oldDelegate.theme ||
        identityCard != oldDelegate.identityCard;
  }
}

class _ProfileCoverBackground extends StatelessWidget {
  const _ProfileCoverBackground({
    required this.theme,
    required this.width,
    required this.height,
    this.coverUrl,
  });

  final String? coverUrl;
  final ClientTechnicianProfileTheme theme;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final resolved = MediaUrlUtils.resolve(coverUrl);
    if (resolved != null && resolved.isNotEmpty) {
      return HomeMediaImage.profileCover(
        context: context,
        imageUrl: coverUrl,
        width: width,
        height: height,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.accent,
            theme.accent.withValues(alpha: 0.82),
            theme.isEmpresa
                ? const Color(0xFF061E33)
                : const Color(0xFF3D7A1C),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          theme.isEmpresa ? Icons.business_rounded : Icons.handyman_rounded,
          size: 64,
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _ProfileIdentityCard extends StatelessWidget {
  const _ProfileIdentityCard({
    required this.technician,
    required this.theme,
    this.onEditPhoto,
    this.moreAboutLabel,
    this.onMoreAbout,
  });

  final TechnicianPublicModel technician;
  final ClientTechnicianProfileTheme theme;
  final VoidCallback? onEditPhoto;
  final String? moreAboutLabel;
  final VoidCallback? onMoreAbout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8EAED)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140B1C15),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: theme.accent.withValues(alpha: 0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TechnicianAvatarWithBadge.fromPublic(
                        technician,
                        radius: 38,
                      ),
                    ),
                    if (onEditPhoto != null)
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Material(
                          color: theme.accent,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            onTap: onEditPhoto,
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileTypeChip(theme: theme),
                      const SizedBox(height: 14),
                      _ProfileDisplayName(name: technician.publicDisplayName),
                      if (formatMinimumQuoteLabel(technician.minimumQuote)
                          case final quoteLabel?) ...[
                        const SizedBox(height: 6),
                        Text(
                          quoteLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: theme.accent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (moreAboutLabel != null && onMoreAbout != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _MoreAboutCta(
                  label: moreAboutLabel!,
                  theme: theme,
                  onTap: onMoreAbout!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileMetricsStrip extends StatelessWidget {
  const _ProfileMetricsStrip({required this.metrics, required this.theme});

  final List<ProfileMetricUi> metrics;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.accentSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.accentBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 34, color: theme.accentBorder),
            Expanded(
              child: _MetricCell(metric: metrics[i], theme: theme),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.metric, required this.theme});

  final ProfileMetricUi metric;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(metric.icon, size: 18, color: theme.accent),
        const SizedBox(height: 4),
        Text(
          metric.value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          metric.label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppBrandColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _ProfileDisplayName extends StatelessWidget {
  const _ProfileDisplayName({required this.name});

  final String name;

  bool get _looksLikeEmail => name.contains('@');

  @override
  Widget build(BuildContext context) {
    final baseFontSize = _looksLikeEmail ? 15.0: name.length > 15 ? 15.0 : 16.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          maxLines: 1,
          style: GoogleFonts.montserrat(
            fontSize: baseFontSize,
            fontWeight: FontWeight.w700,
            color: AppBrandColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _ProfileTypeChip extends StatelessWidget {
  const _ProfileTypeChip({required this.theme});

  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.accentSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.accentBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            theme.isEmpresa ? Icons.business_rounded : Icons.person_rounded,
            size: 14,
            color: theme.accent,
          ),
          const SizedBox(width: 4),
          Text(
            theme.isEmpresa ? 'Empresa' : 'Independiente',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({
    required this.title,
    required this.child,
    required this.theme,
    this.icon,
    this.onEdit,
  });

  final String title;
  final Widget child;
  final ClientTechnicianProfileTheme theme;
  final IconData? icon;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EAED)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080B1C15),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
              decoration: BoxDecoration(
                color: theme.accentSoft.withValues(alpha: 0.55),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.accentBorder),
                      ),
                      child: Icon(icon, size: 17, color: theme.accent),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: theme.accent,
                      ),
                      label: Text(
                        'Editar',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.accent,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceAreaBlock extends StatelessWidget {
  const _ServiceAreaBlock({
    this.address,
    this.distanceKm,
    this.coversAllPeru = false,
    this.coverageDistricts = const [],
    required this.theme,
  });

  final String? address;
  final double? distanceKm;
  final bool coversAllPeru;
  final List<TechnicianCoverageDistrictModel> coverageDistricts;
  final ClientTechnicianProfileTheme theme;

  String _shortDistrictLabel(String label) {
    final parts = label.split(',');
    return parts.first.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.accentSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.location_on_rounded, color: theme.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (address != null)
                Text(
                  address!,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textDark,
                  ),
                ),
              if (coversAllPeru) ...[
                if (address != null) const SizedBox(height: 4),
                Text(
                  'Cobertura: Todo el Peru',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.accent,
                  ),
                ),
              ],
              if (!coversAllPeru && coverageDistricts.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Distritos de cobertura',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: coverageDistricts.map((district) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.accentSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _shortDistrictLabel(district.label),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: district.isPrimary
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: AppBrandColors.textDark,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (distanceKm != null) ...[
                if (address != null ||
                    coversAllPeru ||
                    coverageDistricts.isNotEmpty)
                  const SizedBox(height: 4),
                Text(
                  'A ${distanceKm!.toStringAsFixed(1)} km de tu ubicacion',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// CTA explícito bajo la identidad: abre Sobre mí + Zona en bottom sheet.
class _MoreAboutCta extends StatelessWidget {
  const _MoreAboutCta({
    required this.label,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final ClientTechnicianProfileTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.accentSoft,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: theme.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.accent,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: theme.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showTechnicianAboutProfileSheet(
  BuildContext context, {
  required TechnicianPublicModel technician,
  required ClientTechnicianProfileUiModel ui,
  required bool canEdit,
  VoidCallback? onEditAbout,
  VoidCallback? onEditServiceArea,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppBrandColors.scaffoldBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final theme = ui.theme;
      final showAbout = ui.hasAbout || canEdit;
      final hasServiceAreaContent =
          ui.serviceArea != null ||
          technician.coversAllPeru ||
          technician.coverageDistricts.isNotEmpty;
      final showServiceArea = hasServiceAreaContent || canEdit;

      void openEdit(VoidCallback? action) {
        Navigator.of(ctx).pop();
        if (action == null) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          action();
        });
      }

      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.62,
        minChildSize: 0.42,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        theme.isEmpresa
                            ? 'Más sobre la empresa'
                            : 'Más sobre mí',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppBrandColors.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppBrandColors.textMuted,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  children: [
                    if (showAbout)
                      _ProfileSectionCard(
                        title: ui.aboutTitle,
                        icon: Icons.person_outline_rounded,
                        onEdit: canEdit && onEditAbout != null
                            ? () => openEdit(onEditAbout)
                            : null,
                        theme: theme,
                        child: ui.hasAbout
                            ? Text(
                                technician.description!.trim(),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: AppBrandColors.textDark,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _OwnerEmptyPlaceholder(
                                    text: theme.isEmpresa
                                        ? 'Cuenta quiénes son y qué los diferencia.'
                                        : 'Cuéntale a tus clientes quién eres y cómo trabajas.',
                                  ),
                                  if (canEdit && onEditAbout != null) ...[
                                    const SizedBox(height: 10),
                                    TextButton.icon(
                                      onPressed: () => openEdit(onEditAbout),
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        color: theme.accent,
                                      ),
                                      label: Text(
                                        'Escribir ahora',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: theme.accent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                    if (technician.minimumQuote != null ||
                        (canEdit && onEditAbout != null))
                      _ProfileSectionCard(
                        title: 'Cotización mínima',
                        icon: Icons.payments_outlined,
                        onEdit: canEdit && onEditAbout != null
                            ? () => openEdit(onEditAbout)
                            : null,
                        theme: theme,
                        child: () {
                          final quoteLabel = formatMinimumQuoteLabel(
                            technician.minimumQuote,
                            compact: false,
                          );
                          if (quoteLabel != null) {
                            return Text(
                              quoteLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                                color: AppBrandColors.textDark,
                              ),
                            );
                          }
                          return const _OwnerEmptyPlaceholder(
                            text:
                                'Indica desde qué monto aceptas trabajos. '
                                'Ejemplo: S/ 100',
                          );
                        }(),
                      ),
                    if (showServiceArea)
                      _ProfileSectionCard(
                        title: 'Zona de servicio',
                        icon: Icons.map_outlined,
                        onEdit: canEdit && onEditServiceArea != null
                            ? () => openEdit(onEditServiceArea)
                            : null,
                        theme: theme,
                        child: hasServiceAreaContent
                            ? _ServiceAreaBlock(
                                address: ui.serviceArea,
                                distanceKm: technician.distanceKm,
                                coversAllPeru: technician.coversAllPeru,
                                coverageDistricts:
                                    technician.coverageDistricts,
                                theme: theme,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _OwnerEmptyPlaceholder(
                                    text: 'Configura dónde atiendes.',
                                  ),
                                  if (canEdit &&
                                      onEditServiceArea != null) ...[
                                    const SizedBox(height: 10),
                                    TextButton.icon(
                                      onPressed: () =>
                                          openEdit(onEditServiceArea),
                                      icon: Icon(
                                        Icons.map_outlined,
                                        color: theme.accent,
                                      ),
                                      label: Text(
                                        'Configurar zona',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: theme.accent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
