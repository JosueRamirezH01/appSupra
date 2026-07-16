import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../technician/technician_panel_theme.dart';

class SellerProductPublishSelector extends StatelessWidget {
  const SellerProductPublishSelector({
    super.key,
    required this.isPublished,
    required this.onChanged,
    required this.sellerApproved,
    this.enabled = true,
  });

  final bool isPublished;
  final ValueChanged<bool> onChanged;
  final bool sellerApproved;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canPublish = sellerApproved && enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Visibilidad en el catálogo',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Elige si los clientes pueden ver este producto en la app.',
          style: TechnicianPanelTheme.subtitle,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PublishOptionCard(
                title: 'No publicado',
                subtitle: 'Solo tu empresa lo ve. Ideal mientras lo preparas.',
                icon: Icons.visibility_off_outlined,
                selected: !isPublished,
                enabled: enabled,
                accent: const Color(0xFF6B7280),
                onTap: () => onChanged(false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PublishOptionCard(
                title: 'Publicado',
                subtitle: 'Visible para clientes en búsquedas y catálogo.',
                icon: Icons.public_rounded,
                selected: isPublished,
                enabled: canPublish,
                accent: TechnicianPanelColors.success,
                onTap: canPublish ? () => onChanged(true) : null,
              ),
            ),
          ],
        ),
        if (!sellerApproved) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TechnicianPanelColors.warningSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TechnicianPanelColors.warning.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: TechnicianPanelColors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Para publicar necesitas que tu negocio esté verificado. '
                    'Mientras tanto guarda como no publicado.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF92400E),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PublishOptionCard extends StatelessWidget {
  const _PublishOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && onTap != null;
    final borderColor = selected ? accent : const Color(0xFFE5E7EB);
    final background = selected ? accent.withValues(alpha: 0.08) : Colors.white;

    return Semantics(
      button: true,
      selected: selected,
      enabled: effectiveEnabled,
      label: title,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: effectiveEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: selected ? 1.8 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: effectiveEnabled
                          ? accent
                          : accent.withValues(alpha: 0.45),
                    ),
                    const Spacer(),
                    Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: selected
                          ? accent
                          : const Color(0xFFD1D5DB),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: effectiveEnabled
                        ? TechnicianPanelColors.ink
                        : TechnicianPanelColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: TechnicianPanelColors.inkMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
