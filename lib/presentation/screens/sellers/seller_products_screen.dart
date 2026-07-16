import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/navigation_utils.dart';
import '../../../routes/route_paths.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../utils/seller_product_publish_status.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/sellers/seller_panel_widgets.dart';
import '../../widgets/sellers/seller_product_list_tile.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';

class SellerProductsScreen extends ConsumerStatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  ConsumerState<SellerProductsScreen> createState() =>
      _SellerProductsScreenState();
}

class _SellerProductsScreenState extends ConsumerState<SellerProductsScreen> {
  String? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final application = ref.watch(mySellerApplicationProvider);
    final products = ref.watch(mySellerProductsProvider);

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
          icon: const Icon(Icons.add),
          label: const Text('Nuevo'),
        ),
        orElse: () => null,
      ),
      body: RefreshIndicator(
        color: TechnicianPanelColors.primary,
        onRefresh: () async {
          ref.invalidate(mySellerApplicationProvider);
          ref.invalidate(mySellerProductsProvider);
          await ref.read(mySellerProductsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            application.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: LoadingView(),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(mySellerApplicationProvider),
              ),
              data: (data) {
                final approved =
                    data.verificationStatus == 'aprobado' || data.verified;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SellerPanelStatusBanner.fromVerification(
                      status: data.verificationStatus,
                      verified: data.verified,
                      rejectionReason: data.rejectionReason,
                      actionLabel: data.canSubmitVerification
                          ? 'Verificar negocio'
                          : null,
                      onAction: data.canSubmitVerification
                          ? () => context.push(RoutePaths.sellerVerification)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TechnicianPanelCard(
                      child: Text(
                        approved
                            ? 'Publicado: visible para clientes. No publicado: solo lo ve tu empresa.'
                            : 'Puedes crear productos como no publicados. Para publicarlos necesitas negocio verificado.',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: const Color(0xFF4B5563),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            products.when(
              loading: () => const LoadingView(message: 'Cargando productos...'),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(mySellerProductsProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyView(
                    message:
                        'Aún no tienes productos. Crea el primero con el botón Nuevo.',
                  );
                }

                final filtered = filterSellerProductsByStatus(items, _statusFilter);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SellerProductStatusFilterBar(
                      products: items,
                      selectedStatus: _statusFilter,
                      onSelected: (status) => setState(() => _statusFilter = status),
                    ),
                    const SizedBox(height: 16),
                    if (filtered.isEmpty)
                      EmptyView(
                        message: switch (_statusFilter) {
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
                          for (final product in filtered) ...[
                            SellerProductListTile(
                              product: product,
                              onTap: () => context.push(
                                RoutePaths.sellerProductEditPath(product.id),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
