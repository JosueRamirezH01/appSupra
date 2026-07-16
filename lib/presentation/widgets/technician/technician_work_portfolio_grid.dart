import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/utils/media_url_utils.dart';
import 'technician_panel_theme.dart';

class TechnicianWorkPortfolioGrid extends StatelessWidget {
  const TechnicianWorkPortfolioGrid({
    super.key,
    required this.existingUrls,
    required this.newPhotos,
    this.enabled = true,
    this.onAdd,
    this.onRemoveExisting,
    this.onRemoveNew,
    this.onTapExisting,
    this.onTapNew,
  });

  final List<String> existingUrls;
  final List<File> newPhotos;
  final bool enabled;
  final VoidCallback? onAdd;
  final void Function(int index)? onRemoveExisting;
  final void Function(int index)? onRemoveNew;
  final void Function(int index, String url)? onTapExisting;
  final void Function(int index, File file)? onTapNew;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < existingUrls.length; i++)
          _WorkPortfolioThumb(
            child: _buildNetworkImage(existingUrls[i]),
            onRemove: enabled && onRemoveExisting != null
                ? () => onRemoveExisting!(i)
                : null,
            onTap: onTapExisting != null
                ? () => onTapExisting!(i, existingUrls[i])
                : null,
          ),
        for (var i = 0; i < newPhotos.length; i++)
          _WorkPortfolioThumb(
            child: Image.file(newPhotos[i], fit: BoxFit.cover),
            onRemove:
                enabled && onRemoveNew != null ? () => onRemoveNew!(i) : null,
            onTap: onTapNew != null ? () => onTapNew!(i, newPhotos[i]) : null,
          ),
        if (enabled && onAdd != null)
          _AddPhotoTile(onTap: onAdd!),
      ],
    );
  }

  Widget _buildNetworkImage(String url) {
    final provider = MediaUrlUtils.networkImage(url);
    if (provider == null) {
      return ColoredBox(
        color: TechnicianPanelColors.border,
        child: const Icon(Icons.broken_image_outlined),
      );
    }
    return Image(image: provider, fit: BoxFit.cover);
  }
}

class _WorkPortfolioThumb extends StatelessWidget {
  const _WorkPortfolioThumb({
    required this.child,
    this.onRemove,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(width: 96, height: 96, child: child),
          ),
          if (onRemove != null)
            Positioned(
              top: -6,
              right: -6,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  onTap: onRemove,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TechnicianPanelColors.border),
          color: TechnicianPanelColors.primarySoft,
        ),
        child: const Icon(
          Icons.add_photo_alternate_outlined,
          color: TechnicianPanelColors.primary,
        ),
      ),
    );
  }
}
