import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_submitted_documents.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/media/authenticated_network_image.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../../routes/route_paths.dart';
import 'technician_document_viewer_screen.dart';

class TechnicianSubmittedDocumentsScreen extends ConsumerWidget {
  const TechnicianSubmittedDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myTechnicianProfileProvider);

    return profile.when(
      loading: () => const TechnicianPanelScaffold(
        title: 'Documentos enviados',
        body: LoadingView(message: 'Cargando documentos...'),
      ),
      error: (e, _) => TechnicianPanelScaffold(
        title: 'Documentos enviados',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(myTechnicianProfileProvider),
        ),
      ),
      data: (data) {
        final documents = TechnicianSubmittedDocuments.fromProfile(data);

        return TechnicianPanelScaffold(
          title: 'Documentos enviados',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          body: documents.isEmpty
              ? _EmptyDocuments(
                  canSubmitVerification: data.canSubmitVerification,
                  onUpload: () =>
                      context.push(RoutePaths.technicianVerification),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    TechnicianPanelCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${documents.length} documento${documents.length == 1 ? '' : 's'} en tu expediente',
                            style: TechnicianPanelTheme.title,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Toca un documento para abrirlo y revisarlo.',
                            style: TechnicianPanelTheme.subtitle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TechnicianPanelSection(
                      title: 'Archivos subidos',
                      child: Column(
                        children: [
                          for (var i = 0; i < documents.length; i++) ...[
                            if (i > 0) const SizedBox(height: 10),
                            _DocumentListTile(
                              document: documents[i],
                              onTap: () => _openDocument(context, documents[i]),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _openDocument(BuildContext context, TechnicianSubmittedDocument doc) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TechnicianDocumentViewerScreen(
          title: doc.title,
          url: doc.url,
        ),
      ),
    );
  }
}

class _DocumentListTile extends StatelessWidget {
  const _DocumentListTile({
    required this.document,
    required this.onTap,
  });

  final TechnicianSubmittedDocument document;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isImage = technicianDocumentLooksLikeImage(document.url);

    return Material(
      color: TechnicianPanelColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TechnicianPanelColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: isImage
                        ? AuthenticatedNetworkImage(
                            url: document.url,
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                            placeholder: _iconThumb(),
                          )
                        : _iconThumb(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.title, style: TechnicianPanelTheme.title),
                      if (document.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          document.subtitle!,
                          style: TechnicianPanelTheme.subtitle,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'Toca para abrir',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: TechnicianPanelColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: TechnicianPanelColors.inkSoft,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconThumb() {
    return ColoredBox(
      color: TechnicianPanelColors.primarySoft,
      child: Center(
        child: Icon(document.icon, color: TechnicianPanelColors.primary),
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  const _EmptyDocuments({
    required this.canSubmitVerification,
    required this.onUpload,
  });

  final bool canSubmitVerification;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: TechnicianPanelColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                size: 36,
                color: TechnicianPanelColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no hay documentos',
              style: TechnicianPanelTheme.display.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando subas archivos de verificación aparecerán aquí para que puedas revisarlos.',
              style: TechnicianPanelTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (canSubmitVerification)
              TechnicianPanelPrimaryButton(
                label: 'Ir a verificación',
                icon: Icons.upload_file_outlined,
                onPressed: onUpload,
              ),
          ],
        ),
      ),
    );
  }
}
