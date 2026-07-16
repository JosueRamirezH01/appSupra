import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../core/constants/service_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../models/client_technician_profile_ui_model.dart';
import '../../utils/technician_pricing_utils.dart';
import 'technician_contact_bottom_bar.dart';
import 'technician_profile_owner_config.dart';
import '../auth/auth_ui.dart';
import '../home/home_media_image.dart';
import '../technician_verification_badge.dart';

/// Perfil público del técnico — vista cliente (independiente / empresa).
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

  @override
  Widget build(BuildContext context) {
    final ui = ClientTechnicianProfileUiModel.from(technician);
    final theme = ui.theme;
    final workShowcase = _WorkShowcaseData.from(technician);
    final showWorkSection =
        workShowcase.isNotEmpty || (_isOwner && !theme.isEmpresa);
    final showAbout = ui.hasAbout || _isOwner;
    final showExperience =
        technician.experienceYears != null || (_isOwner && _canEdit);
    final showWhatYouOffer = technician.subcategories.isNotEmpty ||
        _hasAnyServices ||
        (_isOwner && _canEdit);
    final showServiceArea = ui.serviceArea != null ||
        technician.coversAllPeru ||
        technician.coverageDistricts.isNotEmpty ||
        technician.distanceKm != null ||
        (_isOwner && _canEdit);
    final contextService = _resolveContextService();

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
                _ProfileCoverSliver(
                  coverUrl: ui.coverUrl,
                  theme: theme,
                  automaticallyImplyLeading: !_isOwner,
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -28),
                    child: _ProfileIdentityCard(
                      ui: ui,
                      technician: technician,
                      theme: theme,
                      onEditPhoto: _canEdit
                          ? ownerConfig?.onEditProfilePhoto
                          : null,
                    ),
                  ),
                ),
                if (contextService != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: _ContactContextBanner(serviceName: contextService.name),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      _buildProfileSections(
                        ui: ui,
                        theme: theme,
                        workShowcase: workShowcase,
                        showAbout: showAbout,
                        showExperience: showExperience,
                        showWhatYouOffer: showWhatYouOffer,
                        showWorkSection: showWorkSection,
                        showServiceArea: showServiceArea,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isOwner)
            _OwnerPreviewBottomBar(theme: theme)
          else
            TechnicianContactBottomBar(
              technicianUserId: technician.id,
              technicianName: technician.name,
              phone: technician.phone,
              theme: theme,
              availableServices: technician.subSubCategories,
              contextSubSubCategoryId: contextSubSubCategoryId,
              subcategoryId: contextService?.subcategoryId ??
                  (technician.subcategories.isNotEmpty
                      ? technician.subcategories.first.id
                      : null),
            ),
        ],
      ),
    );
  }

  bool get _canHaveServices =>
      technician.subcategories.isNotEmpty &&
      technician.subcategories.every(
        (item) => !CatalogConstants.isOtrosSubcategoryName(item.name),
      );

  bool get _hasAnyServices =>
      technician.subSubCategories.isNotEmpty ||
      technician.pendingServices.isNotEmpty;

  TechnicianSubSubCategoryModel? _resolveContextService() {
    final contextId = contextSubSubCategoryId;
    if (contextId == null) return null;
    for (final service in technician.subSubCategories) {
      if (service.id == contextId) return service;
    }
    return null;
  }

  List<Widget> _buildProfileSections({
    required ClientTechnicianProfileUiModel ui,
    required ClientTechnicianProfileTheme theme,
    required _WorkShowcaseData workShowcase,
    required bool showAbout,
    required bool showExperience,
    required bool showWhatYouOffer,
    required bool showWorkSection,
    required bool showServiceArea,
  }) {
    Widget whatYouOfferSection() => _ProfileSectionCard(
          title: 'Qué ofreces',
          icon: Icons.handyman_outlined,
          editLabel: !_hasAnyServices ? 'Agregar' : 'Editar',
          onEdit: _canEdit ? ownerConfig?.onEditServices : null,
          theme: theme,
          child: _WhatYouOfferBlock(
            technician: technician,
            theme: theme,
            isOwner: _isOwner,
            canEdit: _canEdit,
            canHaveServices: _canHaveServices,
            hasAnyServices: _hasAnyServices,
            onManagePending: ownerConfig?.onManagePendingServices,
          ),
        );

    Widget aboutSection() => _ProfileSectionCard(
          title: ui.aboutTitle,
          icon: Icons.person_outline_rounded,
          onEdit: _canEdit ? ownerConfig?.onEditAbout : null,
          theme: theme,
          child: ui.hasAbout
              ? _ExpandableText(
                  text: technician.description!.trim(),
                  maxLines: 4,
                  linkColor: theme.accent,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.55,
                    color: AppBrandColors.textDark,
                  ),
                )
              : const _OwnerEmptyPlaceholder(
                  text:
                      'Agrega una descripción y teléfono para que los clientes te contacten.',
                ),
        );

    Widget experienceSection() => _ProfileSectionCard(
          title: 'Experiencia',
          icon: Icons.workspace_premium_outlined,
          onEdit: _canEdit ? ownerConfig?.onEditExperience : null,
          theme: theme,
          child: technician.experienceYears != null
              ? _ExperienceBlock(
                  technician: technician,
                  theme: theme,
                )
              : const _OwnerEmptyPlaceholder(
                  text: 'Indica cuántos años llevas trabajando en tu rubro.',
                ),
        );

    Widget workSection() => _ProfileSectionCard(
          title: ui.workPhotosTitle,
          icon: Icons.photo_library_outlined,
          onEdit: _canEdit ? ownerConfig?.onEditWorkGallery : null,
          theme: theme,
          child: workShowcase.isNotEmpty
              ? _UnifiedWorkShowcase(
                  data: workShowcase,
                  theme: theme,
                )
              : const _OwnerEmptyPlaceholder(
                  text:
                      'Sube fotos de trabajos reales para mostrar tu experiencia.',
                ),
        );

    Widget serviceAreaSection() => _ProfileSectionCard(
          title: 'Zona de servicio',
          icon: Icons.map_outlined,
          onEdit: _canEdit ? ownerConfig?.onEditServiceArea : null,
          theme: theme,
          child: ui.serviceArea != null ||
                  technician.coversAllPeru ||
                  technician.coverageDistricts.isNotEmpty
              ? _ServiceAreaBlock(
                  address: ui.serviceArea,
                  distanceKm: technician.distanceKm,
                  coversAllPeru: technician.coversAllPeru,
                  coverageDistricts: technician.coverageDistricts,
                  theme: theme,
                )
              : const _OwnerEmptyPlaceholder(
                  text: 'Configura dónde atiendes.',
                ),
        );

    final sections = <Widget>[];

    if (showWhatYouOffer) sections.add(whatYouOfferSection());
    if (showWorkSection) sections.add(workSection());
    if (showAbout) sections.add(aboutSection());
    if (showExperience) sections.add(experienceSection());
    if (showServiceArea) sections.add(serviceAreaSection());

    if (_isOwner) {
      return [
        if (showAbout) aboutSection(),
        if (showWhatYouOffer) whatYouOfferSection(),
        if (showExperience) experienceSection(),
        if (showWorkSection) workSection(),
        if (showServiceArea) serviceAreaSection(),
      ];
    }

    return sections;
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
              'Mi perfil público',
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
        border: Border.all(color: AppBrandColors.primaryGreen.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.handyman_outlined, color: AppBrandColors.primaryGreen, size: 20),
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
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
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
                  'Vista previa pública',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppBrandColors.textDark,
                  ),
                ),
                Text(
                  'Así te ven los clientes',
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
    );
  }
}

class _ProfileCoverSliver extends StatelessWidget {
  const _ProfileCoverSliver({
    required this.theme,
    this.coverUrl,
    this.automaticallyImplyLeading = true,
  });

  final String? coverUrl;
  final ClientTechnicianProfileTheme theme;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final resolved = MediaUrlUtils.resolve(coverUrl);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final topInset = MediaQuery.paddingOf(context).top;
    final coverImageHeight = (screenWidth * 0.38).clamp(140.0, 240.0);
    final toolbarHeight = automaticallyImplyLeading ? kToolbarHeight : 0.0;
    // primary: true incluye status bar; sumamos topInset para que la foto
    // visible bajo la barra de estado tenga la altura deseada.
    final expandedHeight = topInset + coverImageHeight + toolbarHeight;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      backgroundColor: theme.accent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : coverImageHeight + topInset;

            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: [
                if (resolved != null && resolved.isNotEmpty)
                  HomeMediaImage.profileCover(
                    context: context,
                    imageUrl: coverUrl,
                    width: width,
                    height: height,
                  )
                else
                  DecoratedBox(
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
                        theme.isEmpresa
                            ? Icons.business_rounded
                            : Icons.handyman_rounded,
                        size: 72,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x38000000),
                          Color(0x00000000),
                          Color(0x1F000000),
                        ],
                        stops: [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileIdentityCard extends StatelessWidget {
  const _ProfileIdentityCard({
    required this.ui,
    required this.technician,
    required this.theme,
    this.onEditPhoto,
  });

  final ClientTechnicianProfileUiModel ui;
  final TechnicianPublicModel technician;
  final ClientTechnicianProfileTheme theme;
  final VoidCallback? onEditPhoto;

  String? get _headline {
    final specialty = technician.specialty?.trim();
    if (specialty != null && specialty.isNotEmpty) return specialty;
    if (technician.subcategories.isEmpty) return null;
    return technician.subcategories.map((item) => item.name).join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
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
                      const SizedBox(height: 8),
                      _ProfileDisplayName(name: technician.name),
                      if (_headline != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _headline!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                            color: AppBrandColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (ui.metrics.isNotEmpty) ...[
              const SizedBox(height: 16),
              _ProfileMetricsStrip(metrics: ui.metrics, theme: theme),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TechnicianVerificationBadge.fromPublic(technician),
                if (technician.averageRating != null)
                  _RatingChip(
                    rating: technician.averageRating!,
                    count: technician.ratingCount,
                  ),
                if (technician.distanceKm != null)
                  _InfoChip(
                    icon: Icons.near_me_rounded,
                    label: 'A ${technician.distanceKm!.toStringAsFixed(1)} km',
                    accent: theme.accent,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMetricsStrip extends StatelessWidget {
  const _ProfileMetricsStrip({
    required this.metrics,
    required this.theme,
  });

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
              Container(
                width: 1,
                height: 34,
                color: theme.accentBorder,
              ),
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
  const _MetricCell({
    required this.metric,
    required this.theme,
  });

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

class _ProfileTrustStrip extends StatelessWidget {
  const _ProfileTrustStrip({
    required this.badges,
    required this.theme,
  });

  final List<ProfileTrustBadgeUi> badges;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: badges
          .map(
            (badge) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: theme.accentBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(badge.icon, size: 14, color: theme.accent),
                  const SizedBox(width: 6),
                  Text(
                    badge.label,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ProfileDisplayName extends StatelessWidget {
  const _ProfileDisplayName({required this.name});

  final String name;

  bool get _looksLikeEmail => name.contains('@');

  @override
  Widget build(BuildContext context) {
    final baseFontSize = _looksLikeEmail ? 15.0 : name.length > 22 ? 17.0 : 20.0;

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
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
            height: 1.15,
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

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rating, required this.count});

  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFB45309),
            ),
          ),
          if (count > 0)
            Text(
              ' ($count)',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: const Color(0xFFB45309),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppBrandColors.textDark,
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
    this.titleTrailing,
    this.onEdit,
    this.editLabel,
  });

  final String title;
  final Widget child;
  final ClientTechnicianProfileTheme theme;
  final IconData? icon;
  final Widget? titleTrailing;
  final VoidCallback? onEdit;
  final String? editLabel;

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
                      icon: Icon(Icons.edit_outlined, size: 16, color: theme.accent),
                      label: Text(
                        editLabel ?? 'Editar',
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
                    )
                  else
                    ?titleTrailing,
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

class _ExperienceBlock extends StatelessWidget {
  const _ExperienceBlock({
    required this.technician,
    required this.theme,
  });

  final TechnicianPublicModel technician;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (technician.experienceYears != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.accentSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  color: theme.accent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  technician.experienceYears == 1
                      ? '1 año de experiencia'
                      : technician.experienceYears == 0
                          ? 'Menos de 1 año de experiencia'
                          : '${technician.experienceYears} años de experiencia',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WhatYouOfferBlock extends StatelessWidget {
  const _WhatYouOfferBlock({
    required this.technician,
    required this.theme,
    required this.isOwner,
    required this.canEdit,
    required this.canHaveServices,
    required this.hasAnyServices,
    this.onManagePending,
  });

  final TechnicianPublicModel technician;
  final ClientTechnicianProfileTheme theme;
  final bool isOwner;
  final bool canEdit;
  final bool canHaveServices;
  final bool hasAnyServices;
  final VoidCallback? onManagePending;

  @override
  Widget build(BuildContext context) {
    final hasSpecialties = technician.subcategories.isNotEmpty;
    final missingPricingCount = isOwner && canEdit
        ? countSubcategoriesMissingPricing(technician.subcategories)
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasSpecialties && isOwner && canEdit) ...[
          const _OwnerEmptyPlaceholder(
            text: 'Agrega al menos una especialidad para que te encuentren.',
          ),
        ] else if (hasSpecialties) ...[
          Text(
            'Especialidades',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: technician.subcategories.map((item) {
              return _ReadOnlySpecialtyChip(
                label: item.name,
                theme: theme,
              );
            }).toList(),
          ),
          if (isOwner && canEdit) ...[
            const SizedBox(height: 12),
            if (missingPricingCount > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: Color(0xFFD97706),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        missingPricingCount == 1
                            ? '1 especialidad sin tarifa referencial. '
                                'Los clientes valoran saber un rango aproximado.'
                            : '$missingPricingCount especialidades sin tarifa referencial. '
                                'Los clientes valoran saber un rango aproximado.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF92400E),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (missingPricingCount > 0) const SizedBox(height: 12),
            Text(
              'Tarifas referenciales',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            for (final subcategory in technician.subcategories) ...[
              _OwnerSpecialtyPricingRow(
                subcategory: subcategory,
                theme: theme,
              ),
              const SizedBox(height: 6),
            ],
            const SizedBox(height: 2),
            Text(
              'Edita especialidades para cambiar rubros, tarifas y servicios.',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppBrandColors.textMuted,
                height: 1.35,
              ),
            ),
          ] else if (canEdit)
            Text(
              'Toca Editar arriba para cambiar especialidades y servicios.',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppBrandColors.textMuted,
                height: 1.35,
              ),
            ),
        ],
        if (hasSpecialties && canHaveServices) const SizedBox(height: 16),
        if (canHaveServices) ...[
          Text(
            'Servicios',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          if (hasAnyServices)
            _GroupedServicesList(technician: technician, theme: theme)
          else if (isOwner && canEdit)
            const _OwnerEmptyPlaceholder(
              text:
                  'Agrega entre ${ServiceConstants.minServicesPerSpecialty} y ${ServiceConstants.maxServicesPerSpecialty} servicios por cada especialidad.',
            )
          else
            Text(
              'Sin servicios publicados',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppBrandColors.textMuted,
              ),
            ),
          if (technician.pendingServices.isNotEmpty && onManagePending != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onManagePending,
                icon: const Icon(Icons.pending_actions_outlined, size: 18),
                label: Text(
                  'Gestionar propuestas (${technician.pendingServices.length})',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _ReadOnlySpecialtyChip extends StatelessWidget {
  const _ReadOnlySpecialtyChip({
    required this.label,
    required this.theme,
  });

  final String label;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.accentSoft,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: theme.accentBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.handyman_outlined, size: 14, color: theme.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppBrandColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerSpecialtyPricingRow extends StatelessWidget {
  const _OwnerSpecialtyPricingRow({
    required this.subcategory,
    required this.theme,
  });

  final TechnicianSubcategoryModel subcategory;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    final priceLabel = formatTechnicianPriceRange(
      priceMin: subcategory.priceMin,
      priceMax: subcategory.priceMax,
    );
    final hasPricing = priceLabel != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            subcategory.name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppBrandColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            hasPricing ? priceLabel : 'Sin tarifa · opcional',
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: hasPricing
                  ? theme.accent.withValues(alpha: 0.9)
                  : const Color(0xFFD97706),
            ),
          ),
        ),
      ],
    );
  }
}

class _GroupedServicesList extends StatelessWidget {
  const _GroupedServicesList({
    required this.technician,
    required this.theme,
  });

  final TechnicianPublicModel technician;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    final servicesBySub = <int, List<TechnicianSubSubCategoryModel>>{};
    for (final item in technician.subSubCategories) {
      servicesBySub.putIfAbsent(item.subcategoryId, () => []).add(item);
    }

    final pendingBySub = <int, List<TechnicianPendingServiceModel>>{};
    for (final item in technician.pendingServices) {
      pendingBySub.putIfAbsent(item.subcategoryId, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final subcategory in technician.subcategories) ...[
          if (servicesBySub[subcategory.id]?.isNotEmpty == true ||
              pendingBySub[subcategory.id]?.isNotEmpty == true) ...[
            Text(
              subcategory.name,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: theme.accent,
              ),
            ),
            if (formatTechnicianPriceRange(
                  priceMin: subcategory.priceMin,
                  priceMax: subcategory.priceMax,
                ) !=
                null) ...[
              const SizedBox(height: 4),
              Text(
                formatTechnicianPriceRange(
                  priceMin: subcategory.priceMin,
                  priceMax: subcategory.priceMax,
                )!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.accent.withValues(alpha: 0.85),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...?servicesBySub[subcategory.id]?.map(
                  (item) => _SpecialtyChip(label: item.name, theme: theme),
                ),
                ...?pendingBySub[subcategory.id]?.map(
                  (item) => _SpecialtyChip(
                    label: item.name,
                    theme: theme,
                    isPending: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  const _SpecialtyChip({
    required this.label,
    required this.theme,
    this.subtitle,
    this.outlined = false,
    this.isPending = false,
  });

  final String label;
  final String? subtitle;
  final bool outlined;
  final bool isPending;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: outlined || isPending ? Colors.white : theme.accentSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPending
              ? const Color(0xFFD97706).withValues(alpha: 0.5)
              : outlined
                  ? theme.accent.withValues(alpha: 0.45)
                  : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textDark,
            ),
          ),
          if (isPending)
            Text(
              'En revisión',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: const Color(0xFFD97706),
                fontWeight: FontWeight.w600,
              ),
            )
          else if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppBrandColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

class _WorkShowcaseData {
  const _WorkShowcaseData({
    required this.galleryPhotos,
    required this.featuredProjects,
  });

  final List<TechnicianWorkPhotoModel> galleryPhotos;
  final List<TechnicianPortfolioItemModel> featuredProjects;

  bool get isNotEmpty =>
      galleryPhotos.isNotEmpty || featuredProjects.isNotEmpty;

  static bool _hasProjectStory(TechnicianPortfolioItemModel item) {
    return item.description?.trim().isNotEmpty == true ||
        item.linkUrl?.trim().isNotEmpty == true;
  }

  static _WorkShowcaseData from(TechnicianPublicModel technician) {
    final featured =
        technician.portfolio.where(_hasProjectStory).toList(growable: false);

    if (technician.workPhotos.isNotEmpty) {
      return _WorkShowcaseData(
        galleryPhotos: technician.workPhotos,
        featuredProjects: featured,
      );
    }

    if (featured.isNotEmpty) {
      return _WorkShowcaseData(
        galleryPhotos: const [],
        featuredProjects: featured,
      );
    }

    final portfolioGallery = technician.portfolio
        .where((item) => item.imageUrl?.trim().isNotEmpty == true)
        .map(
          (item) => TechnicianWorkPhotoModel(
            id: item.id,
            imageUrl: item.imageUrl!,
            caption: item.title,
          ),
        )
        .toList(growable: false);

    return _WorkShowcaseData(
      galleryPhotos: portfolioGallery,
      featuredProjects: const [],
    );
  }
}

class _UnifiedWorkShowcase extends StatefulWidget {
  const _UnifiedWorkShowcase({
    required this.data,
    required this.theme,
  });

  final _WorkShowcaseData data;
  final ClientTechnicianProfileTheme theme;

  @override
  State<_UnifiedWorkShowcase> createState() => _UnifiedWorkShowcaseState();
}

class _UnifiedWorkShowcaseState extends State<_UnifiedWorkShowcase> {
  static const _featuredInitialCount = 2;

  bool _showAllFeatured = false;

  @override
  Widget build(BuildContext context) {
    final gallery = widget.data.galleryPhotos;
    final featured = widget.data.featuredProjects;
    final hasMoreFeatured = featured.length > _featuredInitialCount;
    final visibleFeatured = _showAllFeatured || !hasMoreFeatured ? featured : featured.take(_featuredInitialCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (gallery.isNotEmpty) ...[
          _WorkGalleryStrip(
            photos: gallery,
            theme: widget.theme,
          ),
          if (featured.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: const Color(0xFFE8EAED), height: 1),
            const SizedBox(height: 14),
          ],
        ],
        if (featured.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.theme.isEmpresa
                      ? 'Proyectos destacados'
                      : 'Trabajos destacados',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
              if (hasMoreFeatured)
                GestureDetector(
                  onTap: () =>
                      setState(() => _showAllFeatured = !_showAllFeatured),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    _showAllFeatured ? 'Ver menos' : 'Ver más',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: widget.theme.accent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < visibleFeatured.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _FeaturedProjectTile(
              item: visibleFeatured[i],
              theme: widget.theme,
            ),
          ],
        ],
      ],
    );
  }
}

class _WorkGalleryStrip extends StatelessWidget {
  const _WorkGalleryStrip({
    required this.photos,
    required this.theme,
  });

  final List<TechnicianWorkPhotoModel> photos;
  final ClientTechnicianProfileTheme theme;

  static const _tileSize = 128.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${photos.length} foto${photos.length == 1 ? '' : 's'}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppBrandColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: _tileSize + 8,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: photos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final photo = photos[index];
              return _GalleryTile(
                imageUrl: photo.imageUrl,
                caption: photo.caption,
                size: _tileSize,
                onTap: () => _openWorkPhotoViewer(
                  context,
                  photo.imageUrl,
                  photo.caption,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedProjectTile extends StatelessWidget {
  const _FeaturedProjectTile({
    required this.item,
    required this.theme,
  });

  final TechnicianPortfolioItemModel item;
  final ClientTechnicianProfileTheme theme;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Material(
      color: AppBrandColors.fieldFill,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: hasImage
            ? () => _openWorkPhotoViewer(
                  context,
                  imageUrl,
                  item.title,
                  subtitle: item.description,
                )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 88,
                    height: 88,
                    child: HomeMediaImage.workGalleryThumb(
                      context: context,
                      imageUrl: imageUrl,
                      width: 88,
                      height: 88,
                    ),
                  ),
                )
              else
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: theme.accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.handyman_outlined,
                    color: theme.accent,
                    size: 32,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    if (item.description != null &&
                        item.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!.trim(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppBrandColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
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

void _openWorkPhotoViewer(
  BuildContext context,
  String url,
  String? title, {
  String? subtitle,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: HomeMediaImage.workGalleryViewer(
              context: context,
              imageUrl: url,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width,
            ),
          ),
          if ((title != null && title.trim().isNotEmpty) ||
              (subtitle != null && subtitle.trim().isNotEmpty))
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  if (title != null && title.trim().isNotEmpty)
                    Text(
                      title.trim(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                    if (title != null && title.trim().isNotEmpty)
                      const SizedBox(height: 6),
                    Text(
                      subtitle.trim(),
                      style: GoogleFonts.poppins(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.imageUrl,
    required this.size,
    this.caption,
    this.onTap,
  });

  final String imageUrl;
  final double size;
  final String? caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              HomeMediaImage.workGalleryThumb(
                context: context,
                imageUrl: imageUrl,
                width: size,
                height: size,
              ),
              if (caption != null && caption!.trim().isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 6),
                    color: Colors.black.withValues(alpha: 0.45),
                    child: Text(
                      caption!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white,
                      ),
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
                  'Cobertura: Todo el Perú',
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
                  'A ${distanceKm!.toStringAsFixed(1)} km de tu ubicación',
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

/// Texto colapsable con "Ver más" / "Ver menos" solo si supera [maxLines].
class _ExpandableText extends StatefulWidget {
  const _ExpandableText({
    required this.text,
    required this.maxLines,
    required this.style,
    required this.linkColor,
  });

  final String text;
  final int maxLines;
  final TextStyle style;
  final Color linkColor;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  bool _exceedsMaxLines(double maxWidth, TextDirection direction) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: widget.maxLines,
      textDirection: direction,
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canExpand = _exceedsMaxLines(constraints.maxWidth, direction);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: widget.style,
              maxLines: _expanded ? null : widget.maxLines,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (canExpand) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  _expanded ? 'Ver menos' : 'Ver más',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.linkColor,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
