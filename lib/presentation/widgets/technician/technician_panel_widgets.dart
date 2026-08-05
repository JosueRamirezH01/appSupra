import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'technician_panel_theme.dart';

class TechnicianPanelScaffold extends StatelessWidget {
  const TechnicianPanelScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.header,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TechnicianPanelColors.background,
      appBar: AppBar(
        backgroundColor: TechnicianPanelColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: leading,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        actions: actions,
        iconTheme: const IconThemeData(color: TechnicianPanelColors.ink),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) header!,
          Expanded(child: body),
        ],
      ),
    );
  }
}

class TechnicianPanelSection extends StatelessWidget {
  const TechnicianPanelSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TechnicianPanelTheme.title),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: TechnicianPanelTheme.subtitle),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class TechnicianPanelCard extends StatelessWidget {
  const TechnicianPanelCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: TechnicianPanelTheme.cardDecoration(color: color),
      child: child,
    );
  }
}

class TechnicianPanelChip extends StatelessWidget {
  const TechnicianPanelChip({
    super.key,
    required this.label,
    this.icon,
    this.tint = TechnicianPanelColors.primarySoft,
  });

  final String label;
  final IconData? icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TechnicianPanelColors.primaryMuted),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: TechnicianPanelColors.primary),
            const SizedBox(width: 4),
          ],
          Flexible(child: Text(label, style: TechnicianPanelTheme.chip, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

class TechnicianPanelActionTile extends StatelessWidget {
  const TechnicianPanelActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final opacity = enabled ? 1.0 : 0.45;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: TechnicianPanelColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TechnicianPanelColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: TechnicianPanelColors.primarySoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: TechnicianPanelColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: TechnicianPanelColors.ink,
                                ),
                              ),
                            ),
                            if (badge != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: TechnicianPanelColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  badge!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(subtitle, style: TechnicianPanelTheme.subtitle),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: TechnicianPanelColors.inkSoft,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TechnicianPanelPrimaryButton extends StatelessWidget {
  const TechnicianPanelPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: TechnicianPanelColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: TechnicianPanelColors.primaryMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

class TechnicianPanelSecondaryButton extends StatelessWidget {
  const TechnicianPanelSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: TechnicianPanelColors.ink,
          side: const BorderSide(color: TechnicianPanelColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Slot reutilizable para subir documentos en verificación (escalable a N campos).
class TechnicianDocumentUploadSlot extends StatelessWidget {
  const TechnicianDocumentUploadSlot({
    super.key,
    required this.title,
    required this.description,
    required this.required,
    required this.icon,
    this.fileName,
    this.previewUrl,
    this.enabled = true,
    required this.onPick,
    this.onRemove,
  });

  final String title;
  final String description;
  final bool required;
  final IconData icon;
  final String? fileName;
  final String? previewUrl;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  bool get _hasFile =>
      (fileName != null && fileName!.isNotEmpty) ||
      (previewUrl != null && previewUrl!.isNotEmpty);

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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _hasFile
                      ? TechnicianPanelColors.successSoft
                      : TechnicianPanelColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _hasFile ? Icons.check_circle_outline_rounded : icon,
                  color: _hasFile
                      ? TechnicianPanelColors.success
                      : TechnicianPanelColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            required ? '$title *' : title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: TechnicianPanelColors.ink,
                            ),
                          ),
                        ),
                        if (required)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: TechnicianPanelColors.primarySoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Requerido',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: TechnicianPanelColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: TechnicianPanelTheme.subtitle),
                  ],
                ),
              ),
            ],
          ),
          if (previewUrl != null && previewUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  previewUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _previewPlaceholder(),
                ),
              ),
            ),
          ],
          if (fileName != null && fileName!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: TechnicianPanelColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 18,
                    color: TechnicianPanelColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TechnicianPanelTheme.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TechnicianPanelSecondaryButton(
                  label: _hasFile ? 'Cambiar archivo' : 'Subir archivo',
                  onPressed: enabled ? onPick : null,
                ),
              ),
              if (_hasFile && onRemove != null) ...[
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: enabled ? onRemove : null,
                  style: IconButton.styleFrom(
                    backgroundColor: TechnicianPanelColors.background,
                    foregroundColor: TechnicianPanelColors.inkMuted,
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewPlaceholder() {
    return Container(
      color: TechnicianPanelColors.background,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined),
    );
  }
}

class TechnicianDocumentSectionGroup extends StatelessWidget {
  const TechnicianDocumentSectionGroup({
    super.key,
    required this.title,
    this.subtitle,
    required this.slots,
    this.footerNote,
  });

  final String title;
  final String? subtitle;
  final List<Widget> slots;
  final String? footerNote;

  @override
  Widget build(BuildContext context) {
    return TechnicianPanelSection(
      title: title,
      subtitle: subtitle,
      child: Column(
        children: [
          for (var i = 0; i < slots.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            slots[i],
          ],
          if (footerNote != null) ...[
            const SizedBox(height: 10),
            Text(footerNote!, style: TechnicianPanelTheme.subtitle),
          ],
        ],
      ),
    );
  }
}

class TechnicianPanelStatusBanner extends StatelessWidget {
  const TechnicianPanelStatusBanner({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.accent,
    required this.background,
    this.actionLabel,
    this.onAction,
    this.extra,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color accent;
  final Color background;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TechnicianPanelTheme.body.copyWith(
              color: TechnicianPanelColors.inkMuted,
            ),
          ),
          if (extra != null && extra!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              extra!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(foregroundColor: accent),
                child: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static TechnicianPanelStatusBanner fromVerification({
    required String? status,
    required bool verified,
    String? rejectionReason,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    if (verified || status == 'aprobado') {
      return TechnicianPanelStatusBanner(
        title: 'Insignia verificada',
        message:
            'Tu perfil técnico sigue activo. Los clientes verán tu insignia de confianza en tu perfil público.',
        icon: Icons.verified_rounded,
        accent: TechnicianPanelColors.success,
        background: TechnicianPanelColors.successSoft,
      );
    }

    return switch (status) {
      'pendiente' => TechnicianPanelStatusBanner(
          title: 'Insignia en revisión',
          message:
              'Recibimos tus documentos. Te avisaremos cuando finalice la revisión. Tu perfil técnico sigue activo.',
          icon: Icons.hourglass_top_rounded,
          accent: TechnicianPanelColors.warning,
          background: TechnicianPanelColors.warningSoft,
        ),
      'rechazado' => TechnicianPanelStatusBanner(
          title: 'Documentos rechazados',
          message:
              'Revisa el motivo y vuelve a enviar los documentos corregidos. Tu perfil técnico sigue activo.',
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
          title: 'Obtén tu insignia verificada',
          message:
              'Sube tus documentos para mostrar la insignia de confianza. Es opcional: puedes seguir usando la app como técnico.',
          icon: Icons.verified_user_outlined,
          accent: TechnicianPanelColors.primary,
          background: TechnicianPanelColors.primarySoft,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
    };
  }
}

String fileNameFromPath(File file) =>
    file.path.split(Platform.pathSeparator).last;
