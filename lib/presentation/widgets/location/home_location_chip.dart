import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/client_location_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/location/client_location_provider.dart';
import '../home/home_layout_metrics.dart';
import 'client_location_search_sheet.dart';

class HomeLocationChip extends ConsumerWidget {
  const HomeLocationChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(activeClientLocationProvider);
    final label = locationAsync.valueOrNull?.label ?? ClientLocationConstants.defaultBarLabel;
    final compact = HomeLayoutMetrics.isCompactScreen(context);
    final rowHeight = HomeLayoutMetrics.searchRowHeight(context);

    return Container(
      height: rowHeight,
      constraints: BoxConstraints(maxWidth: compact ? 108 : 132),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showClientLocationSearchSheet(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              color: AppBrandColors.primaryGreen,
              size: 22,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
