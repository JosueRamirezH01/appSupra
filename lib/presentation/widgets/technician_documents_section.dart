import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/auth_ui.dart';
import 'media/authenticated_network_image.dart';

class DocumentPreviewTile extends StatelessWidget {
  const DocumentPreviewTile({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: AuthenticatedNetworkImage(
              url: url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppBrandColors.fieldFill,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class TechnicianDocumentsSection extends StatelessWidget {
  const TechnicianDocumentsSection({
    super.key,
    this.documentImageUrl,
    this.rucDocumentUrl,
    this.legalRepresentativeDocumentUrl,
    this.profileType = 'independiente',
  });

  final String? documentImageUrl;
  final String? rucDocumentUrl;
  final String? legalRepresentativeDocumentUrl;
  final String profileType;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    if (documentImageUrl != null && documentImageUrl!.isNotEmpty) {
      items.add(
        DocumentPreviewTile(
          title: 'Documento de identidad',
          url: documentImageUrl!,
        ),
      );
    }

    if (profileType == 'empresa') {
      if (rucDocumentUrl != null && rucDocumentUrl!.isNotEmpty) {
        items.add(
          DocumentPreviewTile(title: 'Ficha RUC', url: rucDocumentUrl!),
        );
      }
      if (legalRepresentativeDocumentUrl != null &&
          legalRepresentativeDocumentUrl!.isNotEmpty) {
        items.add(
          DocumentPreviewTile(
            title: 'Documento representante legal',
            url: legalRepresentativeDocumentUrl!,
          ),
        );
      }
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthSectionLabel('Documentos enviados'),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: item,
          ),
        ),
      ],
    );
  }
}
