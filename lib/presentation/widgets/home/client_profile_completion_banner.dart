import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/auth/user_model.dart';
import '../../../routes/route_paths.dart';
import '../auth/auth_ui.dart';

class ClientProfileCompletionBanner extends StatelessWidget {
  const ClientProfileCompletionBanner({
    super.key,
    required this.completion,
  });

  final ClientProfileCompletionModel completion;

  static const _fieldLabels = <String, String>{
    'name': 'Nombre',
    'phone': 'Celular',
    'profilePhoto': 'Foto',
  };

  @override
  Widget build(BuildContext context) {
    final missing = completion.missingFields
        .map((field) => _fieldLabels[field] ?? field)
        .toList();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(RoutePaths.clientEditProfile),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppBrandColors.primaryGreen.withValues(alpha: 0.12),
                AppBrandColors.primaryGreen.withValues(alpha: 0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.28),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppBrandColors.primaryGreen.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        color: AppBrandColors.primaryGreen,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Completa tu perfil',
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppBrandColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mejora tu experiencia agregando los datos que faltan.',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppBrandColors.textMuted,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppBrandColors.primaryGreen.withValues(alpha: 0.8),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: completion.percent / 100,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.7),
                    color: AppBrandColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${completion.percent}% completado',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppBrandColors.primaryGreen,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push(RoutePaths.clientEditProfile),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Completar ahora',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppBrandColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                if (missing.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: missing
                        .map(
                          (label) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              label,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppBrandColors.textDark,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
