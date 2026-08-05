import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/contact_metric_utils.dart';
import '../../../data/models/technicians/contact_lead_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import 'technician_panel_theme.dart';
import 'technician_panel_widgets.dart';

class TechnicianRecentContactsPanel extends ConsumerWidget {
  const TechnicianRecentContactsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(myTechnicianContactLeadsProvider());

    return contacts.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (page) {
        if (page.contacts.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TechnicianPanelSection(
            title: 'Contactos recientes',
            subtitle:
                'Clientes que dejaron sus datos antes de llamarte o escribirte por WhatsApp.',
            child: Column(
              children: [
                for (final contact in page.contacts) ...[
                  _ContactLeadTile(contact: contact),
                  if (contact != page.contacts.last) const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContactLeadTile extends StatelessWidget {
  const _ContactLeadTile({required this.contact});

  final TechnicianContactLeadItemModel contact;

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(contact.createdAt);
    final dateLabel = createdAt == null
        ? contact.createdAt
        : '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')} '
            '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    final metric = ContactMetricUtils.formatMetricSummary(
      type: contact.contactMetricType,
      value: contact.metricValue,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TechnicianPanelColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TechnicianPanelColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  contact.guestName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: TechnicianPanelColors.ink,
                  ),
                ),
              ),
              _ChannelPill(channel: contact.channel),
            ],
          ),
          const SizedBox(height: 4),
          Text(dateLabel, style: TechnicianPanelTheme.label),
          if (contact.subSubCategoryName != null) ...[
            const SizedBox(height: 8),
            Text(
              'Servicio: ${contact.subSubCategoryName}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: TechnicianPanelColors.ink,
              ),
            ),
          ],
          if (metric.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${ContactMetricUtils.metricContextPrefix(contact.contactMetricType)}: $metric',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: TechnicianPanelColors.inkMuted,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '${contact.guestPhone} · ${contact.guestEmail}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: TechnicianPanelColors.inkMuted,
            ),
          ),
          if (contact.message != null && contact.message!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              contact.message!.trim(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: TechnicianPanelColors.ink,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChannelPill extends StatelessWidget {
  const _ChannelPill({required this.channel});

  final String channel;

  @override
  Widget build(BuildContext context) {
    final isWhatsApp = channel == 'whatsapp';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isWhatsApp
            ? const Color(0xFF25D366).withValues(alpha: 0.12)
            : TechnicianPanelColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isWhatsApp ? 'WhatsApp' : 'Llamada',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isWhatsApp ? const Color(0xFF1B7F44) : TechnicianPanelColors.primary,
        ),
      ),
    );
  }
}
