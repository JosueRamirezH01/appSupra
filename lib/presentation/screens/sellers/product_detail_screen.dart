import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/sellers/product_client_detail_view.dart';
import '../../widgets/sellers/seller_contact_lead_sheet.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  Future<void> _openContactSheet({required BuildContext context, required WidgetRef ref, required ProductPublicModel product, required SellerContactLeadMode mode,}) async {
    final sellerName = product.seller?.businessName ?? 'Vendedor';

    try {
      final seller = await ref.read(sellersRepositoryProvider).getSeller(product.sellerId);

      if (!context.mounted) return;

      final material = product.subSubCategories.isNotEmpty ? product.subSubCategories.first : null;

      await SellerContactLeadSheet.show(
        context: context,
        mode: mode,
        sellerUserId: product.sellerId,
        sellerName: sellerName,
        sellerPhone: seller.phone,
        productId: product.id,
        subcategoryId: product.subcategoryId,
        productTitle: product.title,
        materialName: material?.name,
        contactMetricType: material?.contactMetricType,
      );
    } catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      body: productAsync.when(
        loading: () => const SafeArea(
          child: LoadingView(message: 'Cargando producto...'),
        ),
        error: (e, _) => SafeArea(
          child: ErrorView(
            error: e,
            onRetry: () => ref.invalidate(productDetailProvider(productId)),
          ),
        ),
        data: (product) {
          final content = ProductClientDetailContent.fromProduct(product);

          return ProductClientDetailView(
            content: content,
            onBack: () => context.pop(),
            onViewCatalog: () => context.pop(),
            bottomBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '¿Te interesa este material?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openContactSheet(
                            context: context,
                            ref: ref,
                            product: product,
                            mode: SellerContactLeadMode.phone,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: AppBrandColors.primaryGreen.withValues(alpha: 0.45),
                            ),
                          ),
                          icon: const Icon(Icons.phone_outlined),
                          label: const Text('Llamar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _openContactSheet(
                            context: context,
                            ref: ref,
                            product: product,
                            mode: SellerContactLeadMode.whatsApp,
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppBrandColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('WhatsApp'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
