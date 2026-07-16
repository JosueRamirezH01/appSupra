import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_ui.dart';

class ProfilePhotoField extends StatelessWidget {
  const ProfilePhotoField({
    super.key,
    required this.photo,
    required this.onPick,
    this.enabled = true,
    this.required = true,
  });

  final File? photo;
  final VoidCallback onPick;
  final bool enabled;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photo != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPick : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: AppBrandColors.fieldFill.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasPhoto
                  ? AppBrandColors.primaryGreen.withValues(alpha: 0.35)
                  : const Color(0xFFDCE8CF),
              width: hasPhoto ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: hasPhoto
                            ? AppBrandColors.primaryGreen
                            : const Color(0xFFE5E7EB),
                        width: hasPhoto ? 2.5 : 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasPhoto
                        ? Image.file(photo!, fit: BoxFit.cover)
                        : Icon(
                            Icons.person_outline_rounded,
                            size: 42,
                            color: AppBrandColors.primaryGreen.withValues(
                              alpha: 0.7,
                            ),
                          ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppBrandColors.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      hasPhoto ? Icons.edit_rounded : Icons.add_a_photo_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                required ? 'Foto de perfil *' : 'Foto de perfil',
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hasPhoto
                    ? 'Toca para cambiar la imagen'
                    : 'Toca para elegir desde galería o cámara',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppBrandColors.textMuted,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'JPG, PNG o WEBP',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
