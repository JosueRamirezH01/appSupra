import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/technician_submitted_documents.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';

class TechnicianDocumentViewerScreen extends StatefulWidget {
  const TechnicianDocumentViewerScreen({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  State<TechnicianDocumentViewerScreen> createState() =>
      _TechnicianDocumentViewerScreenState();
}

class _TechnicianDocumentViewerScreenState
    extends State<TechnicianDocumentViewerScreen> {
  bool _loadingExternal = false;

  Future<void> _openExternally() async {
    setState(() => _loadingExternal = true);
    try {
      final uri = Uri.parse(widget.url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!mounted) return;
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo abrir el documento',
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingExternal = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferImage = technicianDocumentLooksLikeImage(widget.url);

    return Scaffold(
      backgroundColor: preferImage ? Colors.black : TechnicianPanelColors.background,
      appBar: AppBar(
        backgroundColor:
            preferImage ? Colors.black : TechnicianPanelColors.background,
        foregroundColor:
            preferImage ? Colors.white : TechnicianPanelColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Abrir externamente',
            onPressed: _loadingExternal ? null : _openExternally,
            icon: _loadingExternal
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
      body: preferImage ? _ImageViewer(url: widget.url) : _ExternalDocumentBody(
        title: widget.title,
        onOpen: _openExternally,
        isLoading: _loadingExternal,
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          },
          errorBuilder: (_, __, ___) => _ExternalDocumentBody(
            title: 'Documento',
            onOpen: () async {
              final uri = Uri.parse(url);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            isLoading: false,
          ),
        ),
      ),
    );
  }
}

class _ExternalDocumentBody extends StatelessWidget {
  const _ExternalDocumentBody({
    required this.title,
    required this.onOpen,
    required this.isLoading,
  });

  final String title;
  final VoidCallback onOpen;
  final bool isLoading;

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
              Text(title, style: TechnicianPanelTheme.title, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Este archivo se abrirá en otra aplicación para que puedas verlo completo.',
                style: TechnicianPanelTheme.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TechnicianPanelPrimaryButton(
                label: 'Abrir documento',
                icon: Icons.open_in_new_rounded,
                isLoading: isLoading,
                onPressed: isLoading ? null : onOpen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
