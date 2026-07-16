import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/storage/secure_storage_service.dart';
import '../../core/utils/media_url_utils.dart';
import 'auth/auth_ui.dart';

class DocumentPreviewTile extends ConsumerWidget {
  const DocumentPreviewTile({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolved = MediaUrlUtils.resolve(url) ?? url;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: FutureBuilder<String?>(
              future: ref.read(secureStorageServiceProvider).getAccessToken(),
              builder: (context, snapshot) {
                final headers = MediaUrlUtils.headersForMedia(
                  url: resolved,
                  accessToken: snapshot.data,
                );

                return Image.network(
                  resolved,
                  fit: BoxFit.cover,
                  headers: headers,
                  errorBuilder: (_, _, _) => Container(
                    color: AppBrandColors.fieldFill,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                );
              },
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
