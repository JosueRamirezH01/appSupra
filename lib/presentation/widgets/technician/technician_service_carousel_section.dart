import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/service_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_display_name.dart';
import '../../utils/technician_pricing_utils.dart';
import '../media/authenticated_network_image.dart';
import 'technician_contact_lead_sheet.dart';
import 'technician_profile_edit_sheets.dart';

/// Ancho fijo de cada card del carrusel (estilo marketplace).
const double _kServiceTileWidth = 132;

/// Alto fijo de la imagen: no se comprime aunque el texto de abajo crezca.
const double _kServiceTileImageHeight = 118;

/// Alto del carrusel = imagen fija + bloque de texto (nombre, precio, CTA).
const double _kServiceCarouselHeight = 232;

/// Extra cuando el dueño ve el CTA de catálogo bajo “Cotiza ahora”.
const double _kServiceCarouselHeightWithCatalogCta = 256;

bool _serviceHasCardImage(TechnicianSubSubCategoryModel service) {
  final url =
      (service.cardImageServiceUrl ?? service.imageUrl)?.trim() ?? '';
  return url.isNotEmpty;
}

bool _serviceIsClientVisible(TechnicianSubSubCategoryModel service) {
  return _serviceHasCardImage(service) && service.hasAnyServicePricing;
}

/// Carrusel horizontal de servicios de una especialidad en el perfil técnico.
class TechnicianServiceCarouselSection extends ConsumerWidget {
  const TechnicianServiceCarouselSection({
    super.key,
    required this.technicianUserId,
    required this.subcategoryName,
    required this.services,
    this.prioritizeSubSubCategoryId,
    this.isOwner = false,
    this.canEdit = false,
    this.onAddService,
    this.onRemoveService,
  });

  final int technicianUserId;
  final String subcategoryName;
  final List<TechnicianSubSubCategoryModel> services;
  /// Servicio a mostrar primero en el carrusel (contexto de browse).
  final int? prioritizeSubSubCategoryId;
  final bool isOwner;
  final bool canEdit;
  final Future<void> Function()? onAddService;
  final Future<void> Function(TechnicianSubSubCategoryModel service)? onRemoveService;

  bool get _canAddMore => canEdit && onAddService != null && services.length < ServiceConstants.maxServicesPerSpecialty;

  List<TechnicianSubSubCategoryModel> get _orderedServices {
    final items = [
      ...services.where((service) {
        // Cliente: solo cards con imagen + precio (portafolio no obligatorio).
        if (!isOwner && !canEdit) return _serviceIsClientVisible(service);
        return true;
      }),
    ];
    items.sort((a, b) {
      final prioritizeId = prioritizeSubSubCategoryId;
      if (prioritizeId != null) {
        final aPriority = a.id == prioritizeId ? 1 : 0;
        final bPriority = b.id == prioritizeId ? 1 : 0;
        if (aPriority != bPriority) return bPriority.compareTo(aPriority);
      }
      final aScore = a.hasPortfolio ? 1 : 0;
      final bScore = b.hasPortfolio ? 1 : 0;
      if (aScore != bScore) return bScore.compareTo(aScore);
      return a.name.compareTo(b.name);
    });
    return items;
  }

  bool get _ownerMayShowCatalogCta {
    if (!canEdit) return false;
    return _orderedServices.any(
      (service) =>
          _serviceHasCardImage(service) && service.hasAnyServicePricing,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordered = _orderedServices;
    if (ordered.isEmpty && !_canAddMore) return const SizedBox.shrink();

    final max = ServiceConstants.maxServicesPerSpecialty;
    final countLabel = '${services.length}/$max';
    final carouselHeight = _ownerMayShowCatalogCta
        ? _kServiceCarouselHeightWithCatalogCta
        : _kServiceCarouselHeight;
    final uploadingServiceId = ref.watch(serviceCardImageUploadingIdProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (canEdit)
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
        if (canEdit) ...[
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 8),
            child: Text(
              services.isEmpty
                  ? 'Agrega al menos un servicio de esta especialidad'
                  : 'Toca la card para ver · lápiz para cambiar la foto',
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
            height: carouselHeight,
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
                  isUploadingCardImage: uploadingServiceId == service.id,
                  onOpen: () => _openServiceCard(context, ref, service: service),
                  onAddCardImage: canEdit && uploadingServiceId == null
                      ? () => pickAndUpdateServiceCardImage(
                            context,
                            ref,
                            service: service,
                            userId: technicianUserId,
                          )
                      : null,
                  onOpenCatalog: canEdit ? () {
                    HapticFeedback.selectionClick();
                    context.push(
                            RoutePaths.technicianServiceCatalogPath(
                        technicianUserId,
                        service.id,
                      ),
                    );
                        }
                      : null,
                  onEditPrice: canEdit ? () {
                          HapticFeedback.selectionClick();
                          showEditServicePricingSheet(
                            context,
                            ref,
                            service: service,
                            userId: technicianUserId,
                          );
                        }
                      : null,
                  onRemove: canEdit && onRemoveService != null ? () => _confirmRemove(context, service) : null,
                );
              },
            ),
          ),
        if (canEdit && !_canAddMore && services.length >= max) ...[
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
    );
  }

  Future<void> _openServiceCard(
    BuildContext context,
    WidgetRef ref, {
    required TechnicianSubSubCategoryModel service,
  }) async {
    HapticFeedback.selectionClick();

    // Dueño: siempre detalle/edición.
    // Cliente con portafolio: detalle.
    // Cliente sin portafolio: Llamar / WhatsApp directo.
    final openDetail = isOwner || canEdit || service.hasPortfolio;
    if (openDetail) {
      if (!context.mounted) return;
      context.push(
        RoutePaths.technicianServiceDetailPath(
          technicianUserId,
          service.id,
        ),
      );
      return;
    }

    final technician = await ref.read(
      technicianDetailProvider(technicianUserId).future,
    );
    if (!context.mounted) return;

    await _showClientServiceContactSheet(
      context: context,
      technicianUserId: technicianUserId,
      technicianName: technician.publicDisplayName,
      technicianPhone: technician.phone,
      service: service,
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    TechnicianSubSubCategoryModel service,
  ) async {
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

Future<void> _showClientServiceContactSheet({
  required BuildContext context,
  required int technicianUserId,
  required String technicianName,
  required String? technicianPhone,
  required TechnicianSubSubCategoryModel service,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      final hasPhone =
          technicianPhone != null && technicianPhone.trim().isNotEmpty;

      Future<void> openLead(TechnicianContactLeadMode mode) async {
        Navigator.pop(ctx);
        if (!hasPhone) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$technicianName aún no tiene teléfono publicado.',
                style: GoogleFonts.poppins(),
              ),
            ),
          );
          return;
        }
        if (!context.mounted) return;
        await TechnicianContactLeadSheet.show(
          context: context,
          mode: mode,
          technicianUserId: technicianUserId,
          technicianName: technicianName,
          technicianPhone: technicianPhone,
          subcategoryId: service.subcategoryId,
          availableServices: [service],
          initialSubSubCategoryId: service.id,
          lockToService: true,
        );
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text(
                service.name,
                style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Este servicio aún no tiene catálogo. Contactá al técnico.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.4,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => openLead(TechnicianContactLeadMode.phone),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppBrandColors.textDark,
                        side: const BorderSide(
                          color: AppBrandColors.primaryGreen,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.phone_outlined, size: 18),
                      label: Text(
                        'Llamar',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () =>
                          openLead(TechnicianContactLeadMode.whatsApp),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.chat_rounded, size: 18),
                      label: Text(
                        'WhatsApp',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.isOwner,
    required this.canEdit,
    required this.onOpen,
    this.isUploadingCardImage = false,
    this.onAddCardImage,
    this.onOpenCatalog,
    this.onEditPrice,
    this.onRemove,
  });

  final TechnicianSubSubCategoryModel service;
  final bool isOwner;
  final bool canEdit;
  final bool isUploadingCardImage;
  final VoidCallback onOpen;
  final VoidCallback? onAddCardImage;
  final VoidCallback? onOpenCatalog;
  final VoidCallback? onEditPrice;
  final VoidCallback? onRemove;

  Future<void> _showRemoveMenu(BuildContext context) async {
    if (onRemove == null) return;
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
    if (action == 'remove') onRemove?.call();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.cardImageServiceUrl ?? service.imageUrl;
    final hasImage = _serviceHasCardImage(service);
    final hasPrice = service.hasAnyServicePricing;
    // Sin imagen: chip “Agregar fotos”. Con imagen+precio: CTA de catálogo abajo.
    final showAddPhotosNudge = canEdit && !hasImage;
    final showCatalogCta =
        canEdit && onOpenCatalog != null && hasImage && hasPrice;
    final photoCount = service.workPhotos.length;

    return Semantics(
      button: true,
      label: '${service.name}${showAddPhotosNudge ? ', sin fotos' : ''}',
      child: SizedBox(
        width: _kServiceTileWidth,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: isUploadingCardImage ? null : onOpen,
            onLongPress: onRemove == null ? null : () => _showRemoveMenu(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: _kServiceTileWidth,
                  height: _kServiceTileImageHeight,
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
                          if (imageUrl != null && imageUrl.trim().isNotEmpty)
                            AuthenticatedNetworkImage(
                              url: imageUrl.trim(),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  _TilePlaceholder(isOwner: isOwner),
                              placeholder: _TilePlaceholder(isOwner: isOwner),
                            )
                          else
                            _TilePlaceholder(isOwner: isOwner),
                          if (isUploadingCardImage)
                            const ColoredBox(
                              color: Color(0x66000000),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (showAddPhotosNudge && !isUploadingCardImage)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: _StatusChip(
                                icon: Icons.add_a_photo_outlined,
                                label: 'Agregar fotos',
                                foreground: Colors.white,
                                background: AppBrandColors.primaryGreen
                                    .withValues(alpha: 0.92),
                                onTap: onAddCardImage ?? onOpen,
                              ),
                            ),
                          if (canEdit && hasImage && !isUploadingCardImage)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.4),
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: onAddCardImage,
                                  onLongPress: onRemove == null
                                      ? null
                                      : () => _showRemoveMenu(context),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          service.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                          ),
                        ),
                        if (priceLabel != null || onEditPrice != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  priceLabel ?? 'Agregar precio',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                    color: priceLabel != null
                                        ? AppBrandColors.textDark
                                        : AppBrandColors.primaryGreen,
                                  ),
                                ),
                              ),
                              if (onEditPrice != null)
                                GestureDetector(
                                  onTap: onEditPrice,
                                  behavior: HitTestBehavior.opaque,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 2, top: 1),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      size: 14,
                                      color: AppBrandColors.primaryGreen,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: isUploadingCardImage ? null : onOpen,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppBrandColors.primaryGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Cotiza ahora',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (showCatalogCta) ...[
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              onOpenCatalog!();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              service.hasPortfolio
                                  ? 'Editar catálogo'
                                  : 'Agregar catálogo',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: AppBrandColors.primaryGreen,
                                decoration: TextDecoration.underline,
                                decorationColor: AppBrandColors.primaryGreen,
                              ),
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
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

    if (onTap == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        borderRadius: BorderRadius.circular(999),
        child: child,
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
      width: _kServiceTileWidth,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _kServiceTileWidth,
                height: _kServiceTileImageHeight,
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
