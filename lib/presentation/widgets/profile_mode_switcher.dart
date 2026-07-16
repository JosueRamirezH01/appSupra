import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/app_view.dart';
import 'auth/auth_ui.dart';
import 'technician/technician_panel_theme.dart';

class ProfileModeSwitcher extends StatelessWidget {
  const ProfileModeSwitcher({
    super.key,
    required this.activeView,
    required this.availableViews,
    required this.onChanged,
    this.technicianPanelStyle = false,
  });

  final AppView activeView;
  final List<AppView> availableViews;
  final ValueChanged<AppView> onChanged;
  final bool technicianPanelStyle;

  @override
  Widget build(BuildContext context) {
    final switchable = availableViews
        .where((view) =>
            view == AppView.client ||
            view == AppView.technician ||
            view == AppView.seller)
        .toList();

    if (switchable.length < 2) return const SizedBox.shrink();

    final trackColor = technicianPanelStyle
        ? TechnicianPanelColors.surface
        : AppBrandColors.fieldFill;
    final selectedColor = technicianPanelStyle
        ? TechnicianPanelColors.primarySoft
        : Colors.white;
    final activeIconColor = technicianPanelStyle
        ? TechnicianPanelColors.primary
        : AppBrandColors.primaryGreen;
    final activeTextColor = technicianPanelStyle
        ? TechnicianPanelColors.ink
        : AppBrandColors.textDark;
    final inactiveColor = technicianPanelStyle
        ? TechnicianPanelColors.inkSoft
        : AppBrandColors.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(28),
          border: technicianPanelStyle
              ? Border.all(color: TechnicianPanelColors.border)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: switchable.map((view) {
              final selected = activeView == view;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: selected ? selectedColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: selected && !technicianPanelStyle
                        ? const [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => onChanged(view),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              view == AppView.client
                                  ? Icons.person_outline
                                  : Icons.engineering_outlined,
                              size: 18,
                              color: selected ? activeIconColor : inactiveColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              view.label,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: selected ? activeTextColor : inactiveColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
