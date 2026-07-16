import 'package:flutter/material.dart';

import '../auth/auth_ui.dart';

/// Placeholder cuando no hay imagen o la carga falla.
class HomeMediaPlaceholder extends StatelessWidget {
  const HomeMediaPlaceholder.hero({super.key})
      : icon = Icons.home_work_outlined,
        width = null,
        height = null,
        iconSize = 52,
        circular = false,
        expand = true,
        backgroundColor = const Color(0xFFEAF3DD);

  const HomeMediaPlaceholder.carousel({super.key})
      : icon = Icons.view_carousel_outlined,
        width = null,
        height = null,
        iconSize = 40,
        circular = false,
        expand = true,
        backgroundColor = const Color(0xFFF3F4F6);

  const HomeMediaPlaceholder.category({
    super.key,
    required this.icon,
    double size = 72,
  })  : width = size,
        height = size,
        iconSize = size * 0.42,
        circular = true,
        expand = false,
        backgroundColor = Colors.white;

  final IconData icon;
  final double? width;
  final double? height;
  final double iconSize;
  final bool circular;
  final bool expand;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: expand ? null : width,
      height: expand ? null : height,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(color: const Color(0xFFE8EAED)),
        boxShadow: expand
            ? null
            : const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: AppBrandColors.primaryGreen.withValues(alpha: 0.9),
        ),
      ),
    );

    if (expand) {
      return SizedBox.expand(child: placeholder);
    }

    return placeholder;
  }
}
