import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/app_version/app_version_model.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({
    super.key,
    required this.result,
    this.canDismiss = false,
    this.onDismiss,
  });

  final AppVersionCheckResult result;
  final bool canDismiss;
  final VoidCallback? onDismiss;

  Future<void> _openStore() async {
    final uri = Uri.parse(result.policy.storeUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.system_update_alt_rounded,
                size: 72,
                color: AppBrandColors.primaryGreen,
              ),
              const SizedBox(height: 20),
              Text(
                canDismiss ? 'Actualización disponible' : 'Actualización obligatoria',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                result.policy.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppBrandColors.textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tu versión: ${result.installedVersionName} (${result.installedVersionCode})\n'
                'Requerida: ${result.policy.minVersionName} (${result.policy.minVersionCode})',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppBrandColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _openStore,
                child: const Text('Actualizar en Play Store'),
              ),
              if (canDismiss) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onDismiss,
                  child: const Text('Más tarde'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
