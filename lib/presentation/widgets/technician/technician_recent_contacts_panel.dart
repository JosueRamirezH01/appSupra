import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/contact_launch_actions.dart';
import '../../../core/utils/contact_metric_utils.dart';
import '../../../data/models/technicians/contact_lead_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_verification_status.dart';
import 'technician_panel_theme.dart';
import 'technician_panel_widgets.dart';

/// Tope del inbox en el home: 3 filas compactas. El resto vive en Ver todos.
const kTechnicianHomeContactsPreviewLimit = 3;

class TechnicianRecentContactsPanel extends ConsumerWidget {
  const TechnicianRecentContactsPanel({super.key, this.onViewAll});

  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(
      myTechnicianContactLeadsProvider(
        limit: kTechnicianHomeContactsPreviewLimit,
      ),
    );

    return contacts.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (page) {
        if (page.contacts.isEmpty) return const SizedBox.shrink();

        final preview = page.contacts
            .take(kTechnicianHomeContactsPreviewLimit)
            .toList(growable: false);
        final hasMore = page.total > preview.length;

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TechnicianPanelSection(
            title: 'Contactos recientes',
            trailing: hasMore && onViewAll != null
                ? TechnicianViewAllContactsAction(
                    total: page.total,
                    onPressed: onViewAll!,
                  )
                : null,
            child: TechnicianPanelCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  for (var i = 0; i < preview.length; i++) ...[
                    TechnicianContactLeadRow(contact: preview[i]),
                    if (i != preview.length - 1)
                      const Divider(
                        height: 1,
                        indent: 68,
                        color: TechnicianPanelColors.border,
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TechnicianViewAllContactsAction extends StatelessWidget {
  const TechnicianViewAllContactsAction({
    super.key,
    required this.total,
    required this.onPressed,
  });

  final int total;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: TechnicianPanelColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Ver todos ($total)',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class TechnicianContactLeadRow extends StatelessWidget {
  const TechnicianContactLeadRow({super.key, required this.contact});

  final TechnicianContactLeadItemModel contact;

  @override
  Widget build(BuildContext context) {
    final isWhatsApp = contact.channel == 'whatsapp';
    final service = contact.subSubCategoryName?.trim();
    final subtitle = [
      if (service != null && service.isNotEmpty) service,
      isWhatsApp ? 'WhatsApp' : 'Llamada',
    ].join(' · ');

    return InkWell(
      onTap: () => showTechnicianContactLeadSheet(context, contact),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Row(
          children: [
            _ContactAvatar(name: contact.guestName, isWhatsApp: isWhatsApp),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.guestName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: TechnicianPanelColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TechnicianPanelTheme.label.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _relativeTime(contact.createdAt),
              style: TechnicianPanelTheme.label,
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: TechnicianPanelColors.inkSoft,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showTechnicianContactLeadSheet(
  BuildContext context,
  TechnicianContactLeadItemModel contact,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: TechnicianPanelColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => _ContactLeadDetailSheet(contact: contact),
  );
}

class _ContactLeadDetailSheet extends StatelessWidget {
  const _ContactLeadDetailSheet({required this.contact});

  final TechnicianContactLeadItemModel contact;

  @override
  Widget build(BuildContext context) {
    final isWhatsApp = contact.channel == 'whatsapp';
    final metric = ContactMetricUtils.formatMetricSummary(
      type: contact.contactMetricType,
      value: contact.metricValue,
    );
    final message = contact.message?.trim();
    final service = contact.subSubCategoryName?.trim();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TechnicianPanelColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ContactAvatar(
                name: contact.guestName,
                isWhatsApp: isWhatsApp,
                radius: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.guestName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: TechnicianPanelColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${isWhatsApp ? 'WhatsApp' : 'Llamada'} · ${_relativeTime(contact.createdAt)}',
                      style: TechnicianPanelTheme.subtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (service != null && service.isNotEmpty) ...[
            const SizedBox(height: 16),
            _DetailLine(label: 'Servicio', value: service),
          ],
          if (metric.isNotEmpty) ...[
            const SizedBox(height: 8),
            _DetailLine(
              label: ContactMetricUtils.metricContextPrefix(
                contact.contactMetricType,
              ),
              value: metric,
            ),
          ],
          const SizedBox(height: 8),
          _DetailLine(label: 'Teléfono', value: contact.guestPhone),
          const SizedBox(height: 8),
          _DetailLine(label: 'Email', value: contact.guestEmail),
          if (message != null && message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Mensaje', style: TechnicianPanelTheme.label),
            const SizedBox(height: 4),
            Text(message, style: TechnicianPanelTheme.body),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      ContactLaunchActions.call(context, contact.guestPhone),
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: const Text('Llamar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TechnicianPanelColors.ink,
                    side: const BorderSide(color: TechnicianPanelColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => ContactLaunchActions.whatsApp(
                    context,
                    contact.guestPhone,
                  ),
                  icon: const Icon(Icons.chat_rounded, size: 18),
                  label: const Text('WhatsApp'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(label, style: TechnicianPanelTheme.label),
        ),
        Expanded(child: Text(value, style: TechnicianPanelTheme.body)),
      ],
    );
  }
}

class _ContactAvatar extends StatelessWidget {
  const _ContactAvatar({
    required this.name,
    required this.isWhatsApp,
    this.radius = 18,
  });

  final String name;
  final bool isWhatsApp;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final accent = isWhatsApp
        ? const Color(0xFF1B7F44)
        : TechnicianPanelColors.primary;
    final fill = isWhatsApp
        ? const Color(0xFF25D366).withValues(alpha: 0.14)
        : TechnicianPanelColors.primarySoft;

    return CircleAvatar(
      radius: radius,
      backgroundColor: fill,
      child: Text(
        _initials(name),
        style: GoogleFonts.poppins(
          fontSize: radius * 0.62,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first.substring(0, 1)}${parts[1].substring(0, 1)}'
      .toUpperCase();
}

String _relativeTime(String raw) {
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw;
  return TechnicianVerificationStatus.formatRelative(parsed);
}
