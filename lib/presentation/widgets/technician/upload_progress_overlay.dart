import 'package:flutter/material.dart';

import 'technician_panel_theme.dart';

/// Bloqueo modal con progreso de subida (ej. "Subiendo 3 de 8").
class UploadProgressOverlay extends StatelessWidget {
  const UploadProgressOverlay({
    super.key,
    required this.completed,
    required this.total,
    this.statusMessage,
  });

  final int completed;
  final int total;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    final hasCount = total > 0;
    final message = statusMessage ??
        (hasCount ? 'Subiendo $completed de $total' : 'Procesando...');
    final progress = hasCount ? (completed / total).clamp(0.0, 1.0) : null;

    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      message,
                      style: TechnicianPanelTheme.title,
                      textAlign: TextAlign.center,
                    ),
                    if (hasCount) ...[
                      const SizedBox(height: 8),
                      Text(
                        '$completed de $total archivo${total == 1 ? '' : 's'}',
                        style: TechnicianPanelTheme.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: progress != null
                          ? LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: TechnicianPanelColors.border,
                              color: TechnicianPanelColors.primary,
                            )
                          : const LinearProgressIndicator(
                              minHeight: 8,
                              color: TechnicianPanelColors.primary,
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No cierres la app hasta que termine',
                      style: TechnicianPanelTheme.label.copyWith(
                        color: TechnicianPanelColors.inkSoft,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
