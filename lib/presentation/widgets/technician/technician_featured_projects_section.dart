import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/featured_projects_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../models/client_technician_profile_ui_model.dart';
import '../../utils/technician_portfolio_utils.dart';

/// Lista vertical de proyectos destacados en el perfil público.
class TechnicianFeaturedProjectsSection extends StatelessWidget {
  const TechnicianFeaturedProjectsSection({
    super.key,
    required this.technicianUserId,
    required this.projects,
    required this.theme,
    this.isOwner = false,
    this.canEdit = false,
    this.onManage,
  });

  final int technicianUserId;
  final List<TechnicianPortfolioItemModel> projects;
  final ClientTechnicianProfileTheme theme;
  final bool isOwner;
  final bool canEdit;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final showEmptyOwner = isOwner && canEdit && projects.isEmpty;
    if (projects.isEmpty && !showEmptyOwner) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Proyectos destacados',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
              if (canEdit && onManage != null)
                TextButton.icon(
                  onPressed: onManage,
                  icon: Icon(Icons.edit_outlined, size: 16, color: theme.accent),
                  label: Text(
                    projects.isEmpty ? 'Agregar' : 'Editar',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: theme.accent,
                    ),
                  ),
                ),
            ],
          ),
          if (projects.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Toca un proyecto para ver fotos y detalles',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < projects.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _FeaturedProjectRow(
                project: projects[i],
                theme: theme,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push(
                    RoutePaths.technicianFeaturedProjectPath(
                      technicianUserId,
                      projects[i].id,
                    ),
                  );
                },
              ),
            ],
          ] else if (showEmptyOwner) ...[
            const SizedBox(height: 10),
            _OwnerEmptyProjectsCard(
              theme: theme,
              onTap: onManage,
            ),
          ],
          if (canEdit && projects.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '${projects.length}/${FeaturedProjectsConstants.maxProjects} proyectos',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppBrandColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FeaturedProjectRow extends StatelessWidget {
  const _FeaturedProjectRow({
    required this.project,
    required this.theme,
    required this.onTap,
  });

  final TechnicianPortfolioItemModel project;
  final ClientTechnicianProfileTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cover = MediaUrlUtils.networkImage(project.coverUrl);
    final description = project.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    return Semantics(
      button: true,
      label: 'Proyecto en ${project.displayLocation}',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8EAED)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 15,
                              color: theme.accent,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                project.displayLocation,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                  color: AppBrandColors.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          hasDescription
                              ? description
                              : 'Sin descripción del proyecto',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            height: 1.35,
                            color: hasDescription ? AppBrandColors.textMuted : AppBrandColors.textMuted.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: cover != null ? Image(image: cover, fit: BoxFit.cover) : ColoredBox(
                        color: theme.accentSoft,
                        child: Icon(
                          Icons.photo_outlined,
                          color: theme.accent,
                          size: 28,
                        ),
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

class _OwnerEmptyProjectsCard extends StatelessWidget {
  const _OwnerEmptyProjectsCard({
    required this.theme,
    this.onTap,
  });

  final ClientTechnicianProfileTheme theme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.accentSoft,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.accentBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.add_photo_alternate_outlined, color: theme.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Agrega hasta ${FeaturedProjectsConstants.maxProjects} proyectos con lugar y fotos',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.accent),
            ],
          ),
        ),
      ),
    );
  }
}
