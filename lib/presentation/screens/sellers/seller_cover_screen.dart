import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home/home_media_image.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/upload_progress_overlay.dart';

class SellerCoverScreen extends ConsumerStatefulWidget {
  const SellerCoverScreen({super.key});

  @override
  ConsumerState<SellerCoverScreen> createState() => _SellerCoverScreenState();
}

class _SellerCoverScreenState extends ConsumerState<SellerCoverScreen> {
  File? _pickedFile;
  bool _removed = false;
  bool _submitting = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;

  bool _hasCover(SellerApplicationModel application) {
    final current = application.coverUrl?.trim();
    if (_removed) return _pickedFile != null;
    if (_pickedFile != null) return true;
    return current != null && current.isNotEmpty;
  }

  Future<void> _pick() async {
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;
    setState(() {
      _pickedFile = file;
      _removed = false;
    });
  }

  void _remove() {
    setState(() {
      _pickedFile = null;
      _removed = true;
    });
  }

  Future<void> _save(SellerApplicationModel application) async {
    final hadCover = application.coverUrl?.trim().isNotEmpty == true;
    if (_pickedFile == null && !_removed) {
      context.pop();
      return;
    }
    if (_removed && _pickedFile == null && !hadCover) {
      context.pop();
      return;
    }

    setState(() {
      _submitting = true;
      _uploadCompleted = 0;
      _uploadTotal = _pickedFile == null ? 0 : 1;
    });

    try {
      String? uploadedUrl;
      if (_pickedFile != null) {
        final urls = await MediaUploadUtils.uploadMixedReferences(
          repository: ref.read(uploadsRepositoryProvider),
          tasks: [
            MediaUploadTaskItem(
              file: _pickedFile!,
              category: UploadCategory.storeCover,
            ),
          ],
          onProgress: (completed, total) {
            if (!mounted) return;
            setState(() {
              _uploadCompleted = completed;
              _uploadTotal = total;
            });
          },
        );
        uploadedUrl = urls.first;
      }

      await ref.read(sellersRepositoryProvider).updateProfile(
            UpdateSellerProfileRequest(
              coverUrl: uploadedUrl,
              clearCover: uploadedUrl == null && _removed,
            ),
          );

      ref.invalidate(mySellerApplicationProvider);
      ref.invalidate(sellerPublicProfileProvider(application.id));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            uploadedUrl != null
                ? 'Portada actualizada'
                : 'Portada eliminada',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
      context.pop();
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final application = ref.watch(mySellerApplicationProvider);

    return application.when(
      loading: () => const Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        body: LoadingView(message: 'Cargando portada...'),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        appBar: AppBar(),
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(mySellerApplicationProvider),
        ),
      ),
      data: (data) {
        final hasCover = _hasCover(data);
        return Stack(
          children: [
            TechnicianPanelScaffold(
              title: 'Foto de portada',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _submitting ? null : () => context.pop(),
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  TechnicianPanelCard(
                    child: Text(
                      'Esta foto es el encabezado de tu tienda. Usa una imagen horizontal del local o la vitrina. El logo se queda aparte.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TechnicianPanelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _CoverPreview(
                              file: _pickedFile,
                              imageUrl: _removed ? null : data.coverUrl,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _submitting ? null : _pick,
                          icon: const Icon(Icons.photo_outlined),
                          label: Text(
                            hasCover ? 'Cambiar foto' : 'Elegir foto',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (hasCover) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _submitting ? null : _remove,
                            child: Text(
                              'Quitar portada',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB91C1C),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TechnicianPanelPrimaryButton(
                    label: 'Guardar portada',
                    isLoading: _submitting,
                    icon: Icons.save_outlined,
                    onPressed: _submitting ? null : () => _save(data),
                  ),
                ),
              ),
            ),
            if (_submitting && _uploadTotal > 0)
              UploadProgressOverlay(
                completed: _uploadCompleted,
                total: _uploadTotal,
              ),
          ],
        );
      },
    );
  }
}

class _CoverPreview extends StatelessWidget {
  const _CoverPreview({
    this.file,
    this.imageUrl,
  });

  final File? file;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Image.file(file!, fit: BoxFit.cover);
    }

    return HomeMediaImage.profileCover(
      context: context,
      imageUrl: imageUrl,
      width: MediaQuery.sizeOf(context).width,
      height: 180,
    );
  }
}
