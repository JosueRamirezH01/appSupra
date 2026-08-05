import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/collapsible_list_utils.dart';

/// Presentation widget: shows a limited set of chips with Ver más / Ver menos.
/// Domain/data stay untouched; only UI state lives here.
class CollapsibleChipWrap extends StatefulWidget {
  const CollapsibleChipWrap({
    super.key,
    required this.chips,
    this.previewLimit = CollapsibleListUtils.defaultChipPreviewLimit,
    this.spacing = 8,
    this.runSpacing = 8,
    this.moreLabelBuilder,
    this.lessLabel = 'Ver menos',
    this.toggleColor,
  });

  final List<Widget> chips;
  final int previewLimit;
  final double spacing;
  final double runSpacing;
  final String Function(int hiddenCount)? moreLabelBuilder;
  final String lessLabel;
  final Color? toggleColor;

  @override
  State<CollapsibleChipWrap> createState() => _CollapsibleChipWrapState();
}

class _CollapsibleChipWrapState extends State<CollapsibleChipWrap> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.chips.isEmpty) return const SizedBox.shrink();

    final slice = CollapsibleListUtils.slice(
      widget.chips,
      previewLimit: widget.previewLimit,
      expanded: _expanded,
    );

    final moreLabel = widget.moreLabelBuilder?.call(slice.hiddenCount) ??
        '+${slice.hiddenCount} más';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: slice.visible,
        ),
        if (slice.isTruncated) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                _expanded ? widget.lessLabel : moreLabel,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: widget.toggleColor ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
