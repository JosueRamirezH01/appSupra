import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_portfolio_utils.dart';
import '../../widgets/common_widgets.dart';
import 'technician_photo_gallery_screen.dart';

/// Detalle de un proyecto destacado: lugar, descripción y galería (hasta 5 fotos).
class TechnicianFeaturedProjectDetailScreen extends ConsumerWidget {
  const TechnicianFeaturedProjectDetailScreen({
    super.key,
    required this.userId,
    required this.projectId,
  });

  final int userId;
  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final technicianAsync = ref.watch(technicianDetailProvider(userId));

    return technicianAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppBrandColors.scaffoldBackground,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: const LoadingView(message: 'Cargando proyecto...'),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppBrandColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppBrandColors.scaffoldBackground,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(technicianDetailProvider(userId)),
        ),
      ),
      data: (technician) {
        TechnicianPortfolioItemModel? project;
        for (final item in technician.portfolio) {
          if (item.id == projectId) {
            project = item;
            break;
          }
        }

        if (project == null) {
          return Scaffold(
            backgroundColor: AppBrandColors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: AppBrandColors.scaffoldBackground,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: const EmptyView(
              message: 'Este proyecto ya no está disponible.',
            ),
          );
        }

        return _ProjectDetailBody(project: project);
      },
    );
  }
}

class _ProjectDetailBody extends StatelessWidget {
  const _ProjectDetailBody({required this.project});

  final TechnicianPortfolioItemModel project;

  void _openGallery(BuildContext context, int index) {
    final urls = project.galleryUrls;
    if (urls.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TechnicianPhotoGalleryScreen(
          title: project.displayLocation,
          imageUrls: urls,
          initialIndex: index.clamp(0, urls.length - 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final description = project.description?.trim();
    final photos = project.galleryUrls;

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppBrandColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppBrandColors.textDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Proyecto',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.place_outlined,
                color: AppBrandColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  project.displayLocation,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Descripción',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14.5,
                height: 1.55,
                color: AppBrandColors.textDark,
              ),
            ),
          ],
          const SizedBox(height: 22),
          Text(
            photos.isEmpty
                ? 'Fotos'
                : 'Fotos (${photos.length})',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          if (photos.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8EAED)),
              ),
              child: Text(
                'Este proyecto no tiene fotos todavía.',
                style: GoogleFonts.poppins(
                  color: AppBrandColors.textMuted,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final provider = MediaUrlUtils.networkImage(photos[index]);
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openGallery(context, index),
                    borderRadius: BorderRadius.circular(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: provider == null
                          ? ColoredBox(
                              color: AppBrandColors.fieldFill,
                              child: const Icon(Icons.broken_image_outlined),
                            )
                          : Image(image: provider, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
