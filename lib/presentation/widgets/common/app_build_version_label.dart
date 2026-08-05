import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Etiqueta discreta de versión (p. ej. soporte / beta).
/// Formato: `v1.0.1 · 10` (versionName · versionCode).
class AppBuildVersionLabel extends StatefulWidget {
  const AppBuildVersionLabel({
    super.key,
    this.onDarkBackground = false,
  });

  /// `true` cuando el fondo es oscuro/verde (texto claro).
  final bool onDarkBackground;

  @override
  State<AppBuildVersionLabel> createState() => _AppBuildVersionLabelState();
}

class _AppBuildVersionLabelState extends State<AppBuildVersionLabel> {
  String? _label;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _label = 'v${info.version} · ${info.buildNumber}';
      });
    } catch (_) {
      // Silencioso: la versión es informativa, no bloquea el login.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_label == null) return const SizedBox.shrink();

    final color = widget.onDarkBackground
        ? Colors.white.withValues(alpha: 0.72)
        : const Color(0xFF64748B).withValues(alpha: 0.85);

    return IgnorePointer(
      child: Text(
        _label!,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

/// Posiciona [AppBuildVersionLabel] en la esquina inferior derecha, respetando SafeArea.
class AppBuildVersionCorner extends StatelessWidget {
  const AppBuildVersionCorner({
    super.key,
    this.onDarkBackground = false,
  });

  final bool onDarkBackground;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    return Positioned(
      right: 16 + padding.right,
      bottom: 10 + padding.bottom,
      child: AppBuildVersionLabel(onDarkBackground: onDarkBackground),
    );
  }
}
