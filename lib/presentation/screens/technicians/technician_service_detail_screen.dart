import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/technicians/contact_lead_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../models/client_technician_profile_ui_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_display_name.dart';
import '../../utils/technician_pricing_utils.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/service_related_products_rail.dart';
import '../../widgets/technician/technician_contact_bottom_bar.dart';
import '../../widgets/technician/technician_work_cases_carousel.dart';

/// Detalle de un servicio del técnico (solo lectura).
///
/// Dueño y cliente ven la misma vitrina. La edición del dueño vive en el
/// perfil (carrusel: imagen, precio y catálogo).
class TechnicianServiceDetailScreen extends ConsumerWidget {
  const TechnicianServiceDetailScreen({
    super.key,
    required this.userId,
    required this.subSubCategoryId,
  });

  final int userId;
  final int subSubCategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authNotifierProvider).valueOrNull;
    final isOwner = authUser?.id == userId;

    final serviceAsync = isOwner
        ? ref.watch(myTechnicianServiceProvider(subSubCategoryId))
        : ref.watch(publicTechnicianServiceProvider(userId, subSubCategoryId));
    final technicianAsync = ref.watch(technicianDetailProvider(userId));

    return serviceAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: _buildPlainAppBar(context, title: 'Servicio'),
        body: const LoadingView(message: 'Cargando servicio...'),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: _buildPlainAppBar(context, title: 'Servicio'),
        body: ErrorView(
          error: error,
          onRetry: () {
            if (isOwner) {
              ref.invalidate(myTechnicianServiceProvider(subSubCategoryId));
            } else {
              ref.invalidate(
                publicTechnicianServiceProvider(userId, subSubCategoryId),
              );
            }
          },
        ),
      ),
      data: (service) {
        final technician = technicianAsync.valueOrNull;
        return _ReadOnlyServiceDetailView(
          technicianUserId: userId,
          technicianName: technician?.publicDisplayName ?? 'Técnico',
          technicianPhone: technician?.phone,
          profileType: technician?.profileType ?? 'independiente',
          service: service,
          hideContactActions: isOwner,
          showOwnerHint: isOwner,
        );
      },
    );
  }
}

AppBar _buildPlainAppBar(BuildContext context, {required String title}) {
  return AppBar(
    backgroundColor: AppBrandColors.scaffoldBackground,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: AppBrandColors.textDark,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => context.pop(),
    ),
    title: Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppBrandColors.textDark,
      ),
    ),
  );
}

class _ReadOnlyServiceDetailView extends StatelessWidget {
  const _ReadOnlyServiceDetailView({
    required this.technicianUserId,
    required this.technicianName,
    required this.technicianPhone,
    required this.profileType,
    required this.service,
    this.hideContactActions = false,
    this.showOwnerHint = false,
  });

  final int technicianUserId;
  final String technicianName;
  final String? technicianPhone;
  final String profileType;
  final TechnicianSubSubCategoryModel service;
  final bool hideContactActions;
  final bool showOwnerHint;

  @override
  Widget build(BuildContext context) {
    final photos = service.workPhotos;
    final description = service.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final theme = ClientTechnicianProfileTheme.fromProfileType(profileType);
    final hiringModes = serviceHiringModePrices(service);
    final contactMetricType = ContactMetricType.fromJson(
      service.contactMetricType,
    );
    final metaParts = <String>[
      if (service.subcategoryName.isNotEmpty) service.subcategoryName,
    ];

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppBrandColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          service.name,
          maxLines: 2,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppBrandColors.textDark,
          ),
        ),
      ),
      body: Column(
        children: [
          if (showOwnerHint)
            Material(
              color: const Color(0xFFEFF6FF),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Color(0xFF1D4ED8),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Así lo ven tus clientes. Edita foto, precio y catálogo desde tu perfil.',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          height: 1.35,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (hiringModes.isNotEmpty) ...[
                        Text(
                          'Modos de contratación:',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppBrandColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (var i = 0; i < hiringModes.length; i++) ...[
                          if (i > 0) const SizedBox(height: 14),
                          _HiringModeRow(mode: hiringModes[i]),
                        ],
                        const SizedBox(height: 10),
                        Text(
                          'Precios referenciales, la cotización final puede variar.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 1.35,
                            color: AppBrandColors.textMuted,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _SectionTitle(
                        title: 'Portafolio',
                        trailing: photos.isEmpty
                            ? null
                            : '${photos.length} caso${photos.length == 1 ? '' : 's'}',
                      ),
                      const SizedBox(height: 12),
                      if (photos.isEmpty)
                        Text(
                          showOwnerHint
                              ? 'Aún no hay trabajos. Agrega tu catálogo desde la card en tu perfil.'
                              : 'Aún no hay trabajos publicados en este servicio.',
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            height: 1.4,
                            color: AppBrandColors.textMuted,
                          ),
                        )
                      else
                        TechnicianWorkCasesCarousel(
                          photos: photos,
                          contactMetricType: contactMetricType,
                          onTap: (photo, _) => showWorkCaseDetailSheet(
                            context: context,
                            photo: photo,
                            contactMetricType: contactMetricType,
                            contact: hideContactActions
                                ? null
                                : WorkCaseContactContext(
                                    technicianUserId: technicianUserId,
                                    technicianName: technicianName,
                                    technicianPhone: technicianPhone,
                                    service: service,
                                  ),
                          ),
                        ),
                      if (hasDescription) ...[
                        const SizedBox(height: 16),
                        const _SectionTitle(
                          title: 'Qué incluye',
                          trailing: null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            height: 1.55,
                            color: AppBrandColors.textDark,
                          ),
                        ),
                      ],
                      if (!hideContactActions) ...[
                        const SizedBox(height: 24),
                        TechnicianContactBottomBar(
                          technicianUserId: technicianUserId,
                          technicianName: technicianName,
                          phone: technicianPhone,
                          theme: theme,
                          subcategoryId: service.subcategoryId,
                          availableServices: [service],
                          contextSubSubCategoryId: service.id,
                          lockToService: true,
                          embedded: true,
                        ),
                      ],
                    ],
                  ),
                ),
                ServiceRelatedProductsRail(
                  technicianUserId: technicianUserId,
                  professionSubSubCategoryId: service.id,
                  professionSubSubCategoryName: service.name,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HiringModeRow extends StatelessWidget {
  const _HiringModeRow({required this.mode});

  final ServiceHiringModePrice mode;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(top: 1),
          decoration: const BoxDecoration(
            color: AppBrandColors.primaryGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mode.title,
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  color: AppBrandColors.textDark,
                ),
              ),
              if (mode.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  mode.subtitle!,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    height: 1.3,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                mode.priceRange,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppBrandColors.textDark,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppBrandColors.textMuted,
            ),
          ),
      ],
    );
  }
}
