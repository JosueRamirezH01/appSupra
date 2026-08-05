/// Pure helpers for collapsing long lists in the UI layer.
/// Keeps truncation rules out of widgets and out of domain/data.
class CollapsibleSlice<T> {
  const CollapsibleSlice({
    required this.visible,
    required this.hiddenCount,
    required this.isTruncated,
  });

  final List<T> visible;
  final int hiddenCount;
  final bool isTruncated;
}

abstract final class CollapsibleListUtils {
  static const int defaultChipPreviewLimit = 6;
  static const int defaultSpecialtyPreviewLimit = 5;

  static CollapsibleSlice<T> slice<T>(
    List<T> items, {
    required int previewLimit,
    required bool expanded,
  }) {
    if (expanded || items.length <= previewLimit) {
      return CollapsibleSlice(
        visible: items,
        hiddenCount: 0,
        isTruncated: items.length > previewLimit,
      );
    }

    return CollapsibleSlice(
      visible: items.take(previewLimit).toList(growable: false),
      hiddenCount: items.length - previewLimit,
      isTruncated: true,
    );
  }
}
