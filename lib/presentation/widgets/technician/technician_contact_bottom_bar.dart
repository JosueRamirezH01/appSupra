import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../models/client_technician_profile_ui_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import 'technician_contact_lead_sheet.dart';

class TechnicianContactBottomBar extends ConsumerWidget {
  const TechnicianContactBottomBar({
    super.key,
    required this.technicianUserId,
    required this.technicianName,
    required this.phone,
    required this.theme,
    this.subcategoryId,
    this.availableServices = const [],
    this.contextSubSubCategoryId,
    this.lockToService = false,
  });

  final int technicianUserId;
  final String technicianName;
  final String? phone;
  final ClientTechnicianProfileTheme theme;
  final int? subcategoryId;
  final List<TechnicianSubSubCategoryModel> availableServices;
  final int? contextSubSubCategoryId;
  final bool lockToService;

  bool get _hasPhone => phone != null && phone!.trim().isNotEmpty;

  void _openLeadSheet(
    BuildContext context,
    WidgetRef ref,
    TechnicianContactLeadMode mode,
  ) {
    if (!_hasPhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$technicianName aún no tiene teléfono publicado.'),
        ),
      );
      return;
    }

    TechnicianContactLeadSheet.show(
      context: context,
      mode: mode,
      technicianUserId: technicianUserId,
      technicianName: technicianName,
      technicianPhone: phone,
      subcategoryId: subcategoryId,
      availableServices: availableServices,
      initialSubSubCategoryId: contextSubSubCategoryId,
      lockToService: lockToService,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _hasPhone
                  ? () => _openLeadSheet(context, ref, TechnicianContactLeadMode.phone)
                  : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppBrandColors.textDark,
                side: BorderSide(color: theme.accent),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.phone_outlined),
              label: Text(
                'Llamar',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: _hasPhone
                  ? () => _openLeadSheet(context, ref, TechnicianContactLeadMode.whatsApp)
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.chat_rounded),
              label: Text(
                'WhatsApp',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
