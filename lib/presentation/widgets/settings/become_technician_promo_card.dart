import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class BecomeTechnicianPromoCard extends StatelessWidget {
  const BecomeTechnicianPromoCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.work_outline, color: AppBrandColors.primaryGreen),
            const SizedBox(height: 8),
            Text(
              '¿Ofreces servicios técnicos?',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Regístrate como técnico, envía tus documentos y empieza a recibir solicitudes.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: onTap,
                child: const Text('Registrarme como técnico'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
