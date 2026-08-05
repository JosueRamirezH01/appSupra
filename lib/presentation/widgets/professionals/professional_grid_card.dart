import 'package:flutter/material.dart';

import '../../../data/models/technicians/technician_model.dart';
import '../technicians/technician_horizontal_card.dart';

/// Card de profesional en grids (browse / búsqueda).
///
/// Reutiliza el diseño unificado de [TechnicianHorizontalCard] con
/// verificación en sello (arriba a la derecha).
class ProfessionalGridCard extends StatelessWidget {
  const ProfessionalGridCard({
    super.key,
    required this.technician,
    required this.onTap,
    this.highlightSubSubCategoryId,
    this.showPriorityMatch = false,
  });

  final TechnicianPublicModel technician;
  final VoidCallback onTap;
  final int? highlightSubSubCategoryId;
  final bool showPriorityMatch;

  /// Compat: consumidores que aún referencian helpers del card antiguo.
  static String badgeLabel(
    TechnicianPublicModel technician, {
    int? highlightSubSubCategoryId,
  }) =>
      TechnicianHorizontalCard.categoryLabel(
        technician,
        highlightSubSubCategoryId: highlightSubSubCategoryId,
      );

  static String? coverImageUrl(TechnicianPublicModel technician) =>
      TechnicianHorizontalCard.identityImageUrl(technician);

  static String shortName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) return fullName;
    final last = parts.last;
    if (last.isEmpty) return parts.first;
    return '${parts.first} ${last[0].toUpperCase()}.';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : TechnicianHorizontalCard.cardWidth;

        return Align(
          alignment: Alignment.topCenter,
          child: TechnicianHorizontalCard(
            technician: technician,
            width: width,
            onTap: onTap,
            verification: TechnicianCardVerification.seal,
            highlightSubSubCategoryId: highlightSubSubCategoryId,
            showPriorityMatch: showPriorityMatch,
          ),
        );
      },
    );
  }
}
