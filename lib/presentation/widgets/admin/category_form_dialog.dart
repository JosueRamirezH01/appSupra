import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../providers/repository_providers.dart';

class CategoryFormResult {
  const CategoryFormResult({
    required this.name,
    this.imageUrl,
  });

  final String name;
  final String? imageUrl;
}

Future<CategoryFormResult?> showCategoryFormDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  String? initialName,
  String? initialImageUrl,
}) async {
  final nameController = TextEditingController(text: initialName ?? '');
  String? imageUrl = initialImageUrl;
  File? pickedFile;
  var uploading = false;

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImage() async {
            final file = await ImagePickerUtils.pickImage(context);
            if (file == null) return;

            setState(() => uploading = true);
            try {
              final uploaded = await ref
                  .read(uploadsRepositoryProvider)
                  .uploadCategoryImage(file);
              setState(() {
                pickedFile = file;
                imageUrl = uploaded.url;
                uploading = false;
              });
            } catch (e) {
              setState(() => uploading = false);
              if (context.mounted) showErrorSnackBar(context, e);
            }
          }

          Widget preview() {
            if (pickedFile != null) {
              return ClipOval(
                child: Image.file(
                  pickedFile!,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              );
            }

            if (imageUrl != null && imageUrl!.isNotEmpty) {
              return ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
                ),
              );
            }

            return const Icon(Icons.image_outlined, size: 36, color: Color(0xFF9CA3AF));
          }

          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: uploading ? null : pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF3F4F6),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: preview(),
                      ),
                      if (uploading)
                        const SizedBox(
                          width: 88,
                          height: 88,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: uploading ? null : pickImage,
                  icon: const Icon(Icons.upload_outlined),
                  label: Text(imageUrl == null ? 'Subir imagen' : 'Cambiar imagen'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  autofocus: initialName == null,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: uploading ? null : () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: uploading ? null : () => Navigator.pop(dialogContext, true),
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );

  if (result != true || nameController.text.trim().isEmpty) return null;

  return CategoryFormResult(
    name: nameController.text.trim(),
    imageUrl: imageUrl,
  );
}
