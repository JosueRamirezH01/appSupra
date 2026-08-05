import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Presentation-only expandable card: collapsed preview → expand details.
///
/// Supports controlled mode (`expanded` + `onExpandedChanged`) so parent
/// screens can keep the open/closed state across provider rebuilds.
class ExpandablePanelCard extends StatefulWidget {
  const ExpandablePanelCard({
    super.key,
    required this.collapsedPreview,
    required this.expandedChild,
    this.expanded,
    this.onExpandedChanged,
    this.initiallyExpanded = false,
    this.expandLabel = 'Ver más',
    this.collapseLabel = 'Ver menos',
    this.accentColor,
    this.padding = const EdgeInsets.all(16),
    this.decoration,
  }) : assert(
          expanded == null || onExpandedChanged != null,
          'onExpandedChanged is required when expanded is controlled',
        );

  final Widget collapsedPreview;
  final Widget expandedChild;

  /// When non-null, expand state is controlled by the parent.
  final bool? expanded;
  final ValueChanged<bool>? onExpandedChanged;

  final bool initiallyExpanded;
  final String expandLabel;
  final String collapseLabel;
  final Color? accentColor;
  final EdgeInsets padding;
  final BoxDecoration? decoration;

  @override
  State<ExpandablePanelCard> createState() => _ExpandablePanelCardState();
}

class _ExpandablePanelCardState extends State<ExpandablePanelCard> {
  late bool _uncontrolledExpanded = widget.initiallyExpanded;

  bool get _isControlled => widget.expanded != null;

  bool get _expanded =>
      _isControlled ? widget.expanded! : _uncontrolledExpanded;

  void _toggle() {
    final next = !_expanded;
    if (_isControlled) {
      widget.onExpandedChanged!(next);
      return;
    }
    setState(() => _uncontrolledExpanded = next);
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        widget.accentColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: widget.padding,
      decoration: widget.decoration ??
          BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? widget.expandedChild
                : GestureDetector(
                    onTap: _toggle,
                    behavior: HitTestBehavior.opaque,
                    child: widget.collapsedPreview,
                  ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  _expanded ? widget.collapseLabel : widget.expandLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
