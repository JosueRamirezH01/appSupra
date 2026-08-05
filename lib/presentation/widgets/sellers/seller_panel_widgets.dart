import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/sellers/product_model.dart';
import '../../utils/seller_product_publish_status.dart';
import '../technician/technician_panel_theme.dart';
import '../technician/technician_panel_widgets.dart';

abstract final class SellerPanelStatusBanner {
  static TechnicianPanelStatusBanner fromVerification({
    required String? status,
    required bool verified,
    String? rejectionReason,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    if (verified || status == 'aprobado') {
      return TechnicianPanelStatusBanner(
        title: 'Negocio verificado',
        message:
            'Tu tienda está activa. Los clientes verán tu insignia de confianza.',
        icon: Icons.verified_rounded,
        accent: TechnicianPanelColors.success,
        background: TechnicianPanelColors.successSoft,
      );
    }

    return switch (status) {
      'pendiente' => TechnicianPanelStatusBanner(
          title: 'Verificación en revisión',
          message:
              'Recibimos tu ficha RUC. Mientras tanto puedes armar tu catálogo con productos no publicados.',
          icon: Icons.hourglass_top_rounded,
          accent: TechnicianPanelColors.warning,
          background: TechnicianPanelColors.warningSoft,
        ),
      'rechazado' => TechnicianPanelStatusBanner(
          title: 'Verificación rechazada',
          message:
              'Revisa el motivo y vuelve a enviar la documentación corregida.',
          icon: Icons.error_outline_rounded,
          accent: const Color(0xFFB91C1C),
          background: const Color(0xFFFEF2F2),
          extra: rejectionReason == null || rejectionReason.isEmpty
              ? null
              : 'Motivo: $rejectionReason',
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      _ => TechnicianPanelStatusBanner(
          title: 'Verifica tu negocio',
          message:
              'Sube tu ficha RUC para publicar productos visibles al cliente.',
          icon: Icons.storefront_outlined,
          accent: TechnicianPanelColors.primary,
          background: TechnicianPanelColors.primarySoft,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
    };
  }
}

String sellerProductStatusLabel(String status) => SellerProductStatusMeta.of(status).label;

Color sellerProductStatusColor(String status) => SellerProductStatusMeta.of(status).color;

class SellerProductStatusMeta {
  const SellerProductStatusMeta({
    required this.status,
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
  });

  factory SellerProductStatusMeta.of(String status) {
    if (isSellerProductPublished(status)) {
      return const SellerProductStatusMeta(
        status: 'activo',
        label: 'Publicado',
        description: 'Visible para clientes en el catálogo',
        color: TechnicianPanelColors.success,
        icon: Icons.public_rounded,
      );
    }

    return const SellerProductStatusMeta(
      status: 'no_publicado',
      label: 'No publicado',
      description: 'Solo visible para tu empresa. Los clientes no lo ven',
      color: Color(0xFF6B7280),
      icon: Icons.visibility_off_outlined,
    );
  }

  final String status;
  final String label;
  final String description;
  final Color color;
  final IconData icon;
}

Map<String, int> sellerProductStatusCounts(List<ProductPublicModel> products) {
  return sellerProductPublishCounts(products);
}

List<ProductPublicModel> filterSellerProductsByStatus(
  List<ProductPublicModel> products,
  String? status,
) {
  return filterSellerProductsByPublishStatus(products, status);
}

class SellerProductStatusChip extends StatelessWidget {
  const SellerProductStatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  final String status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final meta = SellerProductStatusMeta.of(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: meta.color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, size: compact ? 12 : 14, color: meta.color),
          SizedBox(width: compact ? 4 : 6),
          Text(
            meta.label,
            style: GoogleFonts.montserrat(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w700,
              color: meta.color,
            ),
          ),
        ],
      ),
    );
  }
}

class SellerProductStatusSummary extends StatelessWidget {
  const SellerProductStatusSummary({
    super.key,
    this.products = const [],
    this.counts,
    this.onStatusTap,
  });

  final List<ProductPublicModel> products;
  final Map<String, int>? counts;
  final ValueChanged<String>? onStatusTap;

  @override
  Widget build(BuildContext context) {
    final resolved = counts ?? sellerProductStatusCounts(products);

    return Row(
      children: [
        Expanded(
          child: _StatusCountCard(
            label: 'Publicados',
            count: resolved[SellerProductPublishFilter.published] ?? 0,
            color: TechnicianPanelColors.success,
            icon: Icons.public_rounded,
            onTap: onStatusTap == null
                ? null
                : () => onStatusTap!(SellerProductPublishFilter.published),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatusCountCard(
            label: 'No publicados',
            count: resolved[SellerProductPublishFilter.unpublished] ?? 0,
            color: const Color(0xFF6B7280),
            icon: Icons.visibility_off_outlined,
            onTap: onStatusTap == null
                ? null
                : () => onStatusTap!(SellerProductPublishFilter.unpublished),
          ),
        ),
      ],
    );
  }
}

class SellerProductStatusFilterBar extends StatelessWidget {
  const SellerProductStatusFilterBar({
    super.key,
    this.products = const [],
    this.counts,
    required this.selectedStatus,
    required this.onSelected,
  });

  final List<ProductPublicModel> products;
  final Map<String, int>? counts;
  final String? selectedStatus;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final resolved = counts ?? sellerProductStatusCounts(products);
    final total = (resolved[SellerProductPublishFilter.published] ?? 0) +
        (resolved[SellerProductPublishFilter.unpublished] ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SellerProductStatusSummary(counts: resolved),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'Todos ($total)',
                selected: selectedStatus == null,
                onTap: () => onSelected(null),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label:
                    'Publicados (${resolved[SellerProductPublishFilter.published] ?? 0})',
                selected: selectedStatus == SellerProductPublishFilter.published,
                accent: TechnicianPanelColors.success,
                onTap: () => onSelected(SellerProductPublishFilter.published),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label:
                    'No publicados (${resolved[SellerProductPublishFilter.unpublished] ?? 0})',
                selected:
                    selectedStatus == SellerProductPublishFilter.unpublished,
                accent: const Color(0xFF6B7280),
                onTap: () => onSelected(SellerProductPublishFilter.unpublished),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusCountCard extends StatelessWidget {
  const _StatusCountCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
    this.onTap,
  });

  final String label;
  final int count;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.accent,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? TechnicianPanelColors.primary;

    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      labelStyle: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: selected ? color : const Color(0xFF374151),
      ),
      selectedColor: color.withValues(alpha: 0.12),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected ? color : const Color(0xFFE5E7EB),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}
