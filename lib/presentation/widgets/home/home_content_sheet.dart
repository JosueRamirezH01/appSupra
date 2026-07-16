import 'package:flutter/material.dart';

/// Panel blanco con esquinas superiores redondeadas, superpuesto al hero.
class HomeContentSheet extends StatelessWidget {
  const HomeContentSheet({super.key, required this.child});

  static const overlap = 10.0;
  static const topRadius = 16.0;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(
      top: Radius.circular(topRadius),
    );

    return Transform.translate(
      offset: const Offset(0, -overlap),
      child: PhysicalModel(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
          child: child,
        ),
      ),
    );
  }
}
