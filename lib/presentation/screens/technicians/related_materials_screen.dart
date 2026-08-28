import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/route_paths.dart';
import '../../providers/sellers/related_products_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/products/product_grid_card.dart';

/// Todos los materiales del mapa de este servicio (sin tope de 8 ni por vendedor).
class RelatedMaterialsScreen extends ConsumerStatefulWidget {
  const RelatedMaterialsScreen({
    super.key,
    required this.technicianUserId,
    required this.professionSubSubCategoryId,
    this.serviceName = '',
  });

  final int technicianUserId;
  final int professionSubSubCategoryId;
  final String serviceName;

  @override
  ConsumerState<RelatedMaterialsScreen> createState() =>
      _RelatedMaterialsScreenState();
}

class _RelatedMaterialsScreenState extends ConsumerState<RelatedMaterialsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 280) {
      ref
          .read(relatedMaterialsCatalogProvider(widget.professionSubSubCategoryId).notifier)
          .loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(
      relatedMaterialsCatalogProvider(widget.professionSubSubCategoryId),
    );
    final title = widget.serviceName.trim().isEmpty
        ? 'Materiales relacionados'
        : widget.serviceName.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F3),
      appBar: AppBar(
        backgroundColor: AppBrandColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppBrandColors.textDark,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: feedAsync.when(
        loading: () => const LoadingView(message: 'Cargando materiales...'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref
              .read(
                relatedMaterialsCatalogProvider(widget.professionSubSubCategoryId)
                    .notifier,
              )
              .retry(),
        ),
        data: (feed) {
          if (feed.products.isEmpty) {
            return const EmptyView(
              message: 'Aún no hay materiales relacionados con este servicio.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  feed.total == 1
                      ? '1 material para este servicio'
                      : '${feed.total} materiales para este servicio',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: ProductGridCard.gridAspectRatio(),
                  ),
                  itemCount: feed.products.length + (feed.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= feed.products.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    final product = feed.products[index];
                    return ProductGridCard(
                      product: product,
                      onTap: () => context.push(
                        RoutePaths.productDetailPath(product.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
