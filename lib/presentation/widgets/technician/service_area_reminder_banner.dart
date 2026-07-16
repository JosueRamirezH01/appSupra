import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'technician_panel_theme.dart';
import 'technician_panel_widgets.dart';

/// Aviso dismissible por visita: sin persistir "ignorar" entre refrescos.
class ServiceAreaReminderBanner extends StatelessWidget {
  const ServiceAreaReminderBanner({
    super.key,
    required this.onConfigure,
    required this.onDismiss,
  });

  final VoidCallback onConfigure;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return TechnicianPanelCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TechnicianPanelColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: TechnicianPanelColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configura tu zona de servicio',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: TechnicianPanelColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coloca tu zona de servicio para figurar cuando los '
                      'clientes busquen técnicos cercanos.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.4,
                        color: TechnicianPanelColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded, size: 20),
                color: TechnicianPanelColors.inkMuted,
                tooltip: 'Ignorar por ahora',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDismiss,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TechnicianPanelColors.inkMuted,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Ignorar por ahora',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onConfigure,
                  style: FilledButton.styleFrom(
                    backgroundColor: TechnicianPanelColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Configurar ahora',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
