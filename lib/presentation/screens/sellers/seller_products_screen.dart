import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/navigation_utils.dart';
import '../../../routes/route_paths.dart';
import '../../providers/sellers/my_seller_products_provider.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../utils/seller_product_publish_status.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/sellers/seller_panel_widgets.dart';
import '../../widgets/sellers/seller_product_list_tile.dart';
import '../../widgets/technician/technician_panel_theme.dart';

class SellerProductsScreen extends ConsumerStatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  ConsumerState<SellerProductsScreen> createState() =>
      _SellerProductsScreenState();
}

class _SellerProductsScreenState extends ConsumerState<SellerProductsScreen> {
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
      ref.read(mySellerProductsControllerProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final application = ref.watch(mySellerApplicationProvider);
    final products = ref.watch(mySellerProductsControllerProvider);

    return Scaffold(
      backgroundColor: TechnicianPanelColors.background,
      appBar: AppBar(
        backgroundColor: TechnicianPanelColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goToSellerHome(context, ref),
        ),
        title: Text(
          'Mis productos',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: application.maybeWhen(
        data: (data) => FloatingActionButton.extended(
          onPressed: () => context.push(RoutePaths.sellerProductNew),
          backgroundColor: TechnicianPanelColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Nuevo',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
        ),
        orElse: () => null,
      ),
      body: RefreshIndicator(
        color: TechnicianPanelColors.primary,
        onRefresh: () => runSoftRefresh(context, () async {
          ref.invalidate(mySellerApplicationProvider);
          await ref.read(mySellerProductsControllerProvider.notifier).refresh();
        }),
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            application.when(
              skipLoadingOnReload: true,
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: LoadingView(),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(mySellerApplicationProvider),
              ),
              data: (data) {
                final approved = data.verificationStatus == 'aprobado' ||
                    data.verified;

                return
                  products.when(
                    skipLoadingOnReload: true,
                    loading: () =>
                    const LoadingView(message: 'Cargando productos...'),
                    error: (e, _) =>
                        ErrorView(
                          error: e,
                          onRetry: () =>
                              ref.invalidate(
                                  mySellerProductsControllerProvider),
                        ),
                    data: (state) {
                      if (state.counts.total == 0) {
                        return const EmptyView(
                          message:
                          'Aún no tienes productos. Crea el primero con el botón Nuevo.',
                        );
                      }

                      final items = state.products;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SellerProductStatusFilterBar(
                            counts: myProductsCountsAsFilterMap(state.counts),
                            selectedStatus: state.publishStatus,
                            onSelected: (status) => ref.read(mySellerProductsControllerProvider.notifier).setPublishStatus(status)),
                          const SizedBox(height: 16),
                          if (items.isEmpty)
                            EmptyView(
                              message: switch (state.publishStatus) {
                                SellerProductPublishFilter.published =>
                                'No hay productos publicados',
                                SellerProductPublishFilter.unpublished =>
                                'No hay productos sin publicar',
                                _ => 'No hay productos',
                              },
                            )
                          else
                            Column(
                              children: [
                                for (final product in items) ...[
                                  SellerProductListTile(
                                    product: product,
                                    onTap: () =>
                                        context.push(
                                          RoutePaths.sellerProductEditPath(
                                              product.id),
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                if (state.isLoadingMore)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      );
                    },
                  );
              }
            )
          ]
        ),
      ),
    );
  }
}
