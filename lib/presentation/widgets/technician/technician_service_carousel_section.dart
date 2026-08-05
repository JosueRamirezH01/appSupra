import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/service_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../utils/technician_pricing_utils.dart';

/// Carrusel horizontal de servicios de una especialidad en el perfil técnico.
class TechnicianServiceCarouselSection extends StatelessWidget {
  const TechnicianServiceCarouselSection({
    super.key,
    required this.technicianUserId,
    required this.subcategoryName,
    required this.services,
    this.isOwner = false,
    this.canEdit = false,
    this.onAddService,
    this.onRemoveService,
  });

  final int technicianUserId;
  final String subcategoryName;
  final List<TechnicianSubSubCategoryModel> services;
  final bool isOwner;
  final bool canEdit;
  final Future<void> Function()? onAddService;
  final Future<void> Function(TechnicianSubSubCategoryModel service)?
  onRemoveService;

  bool get _canAddMore =>
      canEdit &&
      onAddService != null &&
      services.length < ServiceConstants.maxServicesPerSpecialty;

  List<TechnicianSubSubCategoryModel> get _orderedServices {
    final items = [...services];
    items.sort((a, b) {
      final aScore = a.hasPortfolio ? 1 : 0;
      final bScore = b.hasPortfolio ? 1 : 0;
      if (aScore != bScore) return bScore.compareTo(aScore);
      return a.name.compareTo(b.name);
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty && !_canAddMore) return const SizedBox.shrink();

    final max = ServiceConstants.maxServicesPerSpecialty;
    final countLabel = '${services.length}/$max';

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    subcategoryName,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppBrandColors.textDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if(canEdit)
                Text(
                  countLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (canEdit) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 8),
              child: Text(
                services.isEmpty
                    ? 'Agrega al menos un servicio de esta especialidad'
                    : 'Toca para ver · Menú ⋯ para opciones',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  height: 1.3,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ),
          ] else
            const SizedBox(height: 10),
          if (services.isEmpty && _canAddMore)
            _EmptySpecialtyCard(onAdd: () => onAddService!())
          else
            SizedBox(
              height: 186,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                itemCount: _orderedServices.length + (_canAddMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index >= _orderedServices.length) {
                    return _AddServiceTile(
                      remaining: max - services.length,
                      onTap: () => onAddService!(),
                    );
                  }

                  final service = _orderedServices[index];
                  return _ServiceTile(
                    service: service,
                    isOwner: isOwner,
                    canEdit: canEdit,
                    onOpen: () {
                      HapticFeedback.selectionClick();
                      context.push(
                        RoutePaths.technicianServiceDetailPath(
                          technicianUserId,
                          service.id,
                        ),
                      );
                    },
                    onRemove: canEdit && onRemoveService != null
                        ? () => _confirmRemove(context, service)
                        : null,
                  );
                },
              ),
            ),
          if (canEdit &&
              !_canAddMore &&
              services.length >= max) ...[
            const SizedBox(height: 8),
            Text(
              'Límite de $max servicios en esta especialidad',
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

  Future<void> _confirmRemove(BuildContext context, TechnicianSubSubCategoryModel service) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Quitar este servicio?',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
        ),
        content: Text(
          '“${service.name}” dejará de mostrarse en tu perfil. '
          'Podrás volver a agregarlo después.',
          style: GoogleFonts.poppins(fontSize: 13.5, height: 1.45),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Quitar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await onRemoveService!(service);
    }
  }
}

class _EmptySpecialtyCard extends StatelessWidget {
  const _EmptySpecialtyCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppBrandColors.primaryGreen.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.selectionClick();
          onAdd();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppBrandColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aún no hay servicios',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Elige del catálogo lo que ofreces en este rubro.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.35,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppBrandColors.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.isOwner,
    required this.canEdit,
    required this.onOpen,
    this.onRemove,
  });

  final TechnicianSubSubCategoryModel service;
  final bool isOwner;
  final bool canEdit;
  final VoidCallback onOpen;
  final VoidCallback? onRemove;

  Future<void> _showOwnerMenu(BuildContext context) async {
    HapticFeedback.selectionClick();
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.open_in_new_rounded),
                title: Text(
                  service.hasPortfolio ? 'Ver / editar servicio' : 'Completar servicio',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  service.hasPortfolio
                      ? 'Descripción, experiencia y fotos'
                      : 'Agrega fotos y detalles',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                onTap: () => Navigator.pop(ctx, 'open'),
              ),
              if (onRemove != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFDC2626),
                  ),
                  title: Text(
                    'Quitar del perfil',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  onTap: () => Navigator.pop(ctx, 'remove'),
                ),
            ],
          ),
        ),
      ),
    );

    if (!context.mounted || action == null) return;
    if (action == 'open') onOpen();
    if (action == 'remove') onRemove?.call();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.previewImageUrl ?? service.imageUrl;
    final provider = MediaUrlUtils.networkImage(imageUrl);
    final showOwnerNudge = isOwner && !service.hasPortfolio;
    final photoCount = service.workPhotos.length;

    return Semantics(
      button: true,
      label: '${service.name}${showOwnerNudge ? ', sin fotos' : ''}',
      child: SizedBox(
        width: 132,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onOpen,
            onLongPress: onRemove,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x140B1C15),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (provider != null)
                            Image(
                              image: provider,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  _TilePlaceholder(isOwner: isOwner),
                            )
                          else
                            _TilePlaceholder(isOwner: isOwner),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x00000000),
                                  Color(0x66000000),
                                ],
                                stops: [0.45, 1],
                              ),
                            ),
                          ),
                          if (showOwnerNudge)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: _StatusChip(
                                icon: Icons.add_a_photo_outlined,
                                label: 'Agregar fotos',
                                foreground: Colors.white,
                                background: AppBrandColors.primaryGreen
                                    .withValues(alpha: 0.92),
                              ),
                            )
                          else if (photoCount > 0)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: _StatusChip(
                                icon: Icons.photo_library_outlined,
                                label: '$photoCount',
                                foreground: AppBrandColors.textDark,
                                background:
                                    Colors.white.withValues(alpha: 0.92),
                              ),
                            ),
                          if (canEdit)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.4),
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => _showOwnerMenu(context),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.more_horiz_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 10,
                            child: Text(
                              service.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                                shadows: const [
                                  Shadow(
                                    color: Color(0x66000000),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final priceLabel = serviceProfilePriceLabel(service);
                    final hasMeta = service.experienceYears != null ||
                        priceLabel != null;
                    if (!hasMeta) {
                      return const SizedBox(height: 4);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (service.experienceYears != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${service.experienceYears} años exp.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppBrandColors.primaryGreen,
                            ),
                          ),
                        ],
                        if (priceLabel != null) ...[
                          SizedBox(
                            height: service.experienceYears != null ? 2 : 6,
                          ),
                          Text(
                            priceLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppBrandColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _TilePlaceholder extends StatelessWidget {
  const _TilePlaceholder({required this.isOwner});

  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppBrandColors.fieldFill,
      child: Center(
        child: Icon(
          isOwner ? Icons.add_photo_alternate_outlined : Icons.handyman_outlined,
          color: isOwner
              ? AppBrandColors.primaryGreen
              : const Color(0xFFA8B59C),
          size: 30,
        ),
      ),
    );
  }
}

class _AddServiceTile extends StatelessWidget {
  const _AddServiceTile({required this.onTap, required this.remaining});

  final VoidCallback onTap;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.06),
                    border: Border.all(
                      color: AppBrandColors.primaryGreen.withValues(alpha: 0.35),
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppBrandColors.primaryGreen.withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppBrandColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Agregar\nservicio',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppBrandColors.primaryGreen,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$remaining disponibles',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppBrandColors.primaryGreen.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
