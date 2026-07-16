import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'technician_panel_theme.dart';

class TechnicianChannelCards extends StatelessWidget {
  const TechnicianChannelCards({
    super.key,
    required this.phone,
    required this.whatsapp,
  });

  final int phone;
  final int whatsapp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ChannelCard(
            icon: Icons.phone_in_talk_rounded,
            label: 'Llamadas',
            value: phone,
            accent: const Color(0xFF2563EB),
            background: const Color(0xFFEFF6FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ChannelCard(
            icon: Icons.chat_rounded,
            label: 'WhatsApp',
            value: whatsapp,
            accent: TechnicianPanelColors.primary,
            background: TechnicianPanelColors.primarySoft,
          ),
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.background,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color accent;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: accent),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$value',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: TechnicianPanelColors.ink,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class TechnicianViewCompleteAction extends StatelessWidget {
  const TechnicianViewCompleteAction({super.key, required this.onPressed});

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility_outlined, size: 16),
          const SizedBox(width: 4),
          Text(
            'Ver completo',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
