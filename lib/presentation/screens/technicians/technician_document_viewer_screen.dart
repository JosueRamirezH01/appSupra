import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../utils/technician_submitted_documents.dart';
import '../../widgets/media/authenticated_network_image.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';

class TechnicianDocumentViewerScreen extends StatelessWidget {
  const TechnicianDocumentViewerScreen({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final preferImage = technicianDocumentLooksLikeImage(url);
    final isPrivate = MediaUrlUtils.isPrivateMediaUrl(url);

    return Scaffold(
      backgroundColor:
          preferImage ? Colors.black : TechnicianPanelColors.background,
      appBar: AppBar(
        backgroundColor:
            preferImage ? Colors.black : TechnicianPanelColors.background,
        foregroundColor:
            preferImage ? Colors.white : TechnicianPanelColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: preferImage
          ? _AuthenticatedImageViewer(url: url)
          : _UnsupportedDocumentBody(
              title: title,
              isPrivate: isPrivate,
            ),
    );
  }
}

class _AuthenticatedImageViewer extends StatelessWidget {
  const _AuthenticatedImageViewer({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: AuthenticatedNetworkImage(
          url: url,
          fit: BoxFit.contain,
          placeholder: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          errorBuilder: (_, _, _) => const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined, color: Colors.white70, size: 48),
                SizedBox(height: 12),
                Text(
                  'No se pudo cargar el documento',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnsupportedDocumentBody extends StatelessWidget {
  const _UnsupportedDocumentBody({
    required this.title,
    required this.isPrivate,
  });

  final String title;
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: TechnicianPanelCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: TechnicianPanelColors.primarySoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.insert_drive_file_outlined,
                  size: 32,
                  color: TechnicianPanelColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TechnicianPanelTheme.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isPrivate
                    ? 'Este archivo es privado y solo se puede ver dentro de la app. '
                        'Si no se muestra, vuelve a la lista e intenta de nuevo.'
                    : 'Este tipo de archivo no se puede previsualizar aquí.',
                style: TechnicianPanelTheme.subtitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
