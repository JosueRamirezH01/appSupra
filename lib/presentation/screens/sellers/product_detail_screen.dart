import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/products/home_featured_products_provider.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../providers/sellers/seller_catalog_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/sellers/product_client_detail_view.dart';
import '../../widgets/sellers/seller_product_field_sheets.dart';
import '../../widgets/sellers/seller_contact_lead_sheet.dart';
import '../../../routes/route_paths.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  Future<void> _openContactSheet({
    required BuildContext context,
    required WidgetRef ref,
    required ProductPublicModel product,
    required SellerContactLeadMode mode,
  }) async {
    final sellerName = product.seller?.businessName ?? 'Vendedor';

    try {
      final seller =
          await ref.read(sellersRepositoryProvider).getSeller(product.sellerId);

      if (!context.mounted) return;

      final material = product.subSubCategories.isNotEmpty
          ? product.subSubCategories.first
          : null;

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
    final userId = ref.watch(authNotifierProvider).valueOrNull?.id;

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
          final isOwner = userId != null && userId == product.sellerId;
          final content = ProductClientDetailContent.fromProduct(product);

          Future<void> refreshAfterEdit() async {
            ref.invalidate(productDetailProvider(productId));
            ref.invalidate(sellerCatalogControllerProvider(product.sellerId));
            ref.invalidate(homeFeaturedProductsProvider);
          }

          Future<void> editPhoto() async {
            const maxImages = 6;
            final existingUrls = product.images.map((e) => e.imageUrl).toList();
            final remaining = maxImages - existingUrls.length;
            if (remaining <= 0) {
              if (!context.mounted) return;
              showErrorSnackBar(context, 'Máximo $maxImages fotos por producto');
              return;
            }

            final files = await ImagePickerUtils.pickMultiplePublicCatalogImages(context);
            if (!context.mounted || files.isEmpty) return;

            final picked = files.take(remaining).toList();
            if (picked.isEmpty) return;

            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(22),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );

            try {
              final uploaded = await MediaUploadUtils.uploadTechnicianReferences(
                repository: ref.read(uploadsRepositoryProvider),
                category: UploadCategory.productImage,
                files: picked,
              );
              final newUrls = [...existingUrls, ...uploaded];

              await ref.read(sellersRepositoryProvider).updateProduct(
                    product.id,
                    UpdateProductRequest(imageUrls: newUrls),
                  );

              if (!context.mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              await refreshAfterEdit();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Fotos actualizadas',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: AppBrandColors.primaryGreen,
                ),
              );
            } catch (e) {
              if (!context.mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              showErrorSnackBar(context, e);
            }
          }

          Future<void> editName() async {
            final suggestions = suggestionsForSubcategory(
              await ref.read(sellerProductSubcategoriesProvider.future),
              product.subcategoryId,
            );
            if (!context.mounted) return;
            final newName = await showProductNameSheet(
              context,
              initialName: product.title,
              suggestions: suggestions,
              subcategoryName: product.subcategoryName,
            );
            if (newName == null || !context.mounted) return;

            try {
              await ref.read(sellersRepositoryProvider).updateProduct(
                    product.id,
                    UpdateProductRequest(title: newName),
                  );
              await refreshAfterEdit();
            } catch (e) {
              if (context.mounted) showErrorSnackBar(context, e);
            }
          }

          Future<void> editPrice() async {
            final result = await showProductPriceSheet(
              context,
              initialPrice: product.price,
              initialCompareAt: product.compareAtPrice,
            );
            if (result == null || !context.mounted) return;

            try {
              await ref.read(sellersRepositoryProvider).updateProduct(
                    product.id,
                    UpdateProductRequest(
                      price: result.price,
                      compareAtPrice: result.compareAt,
                      setPricing: true,
                    ),
                  );
              await refreshAfterEdit();
            } catch (e) {
              if (context.mounted) showErrorSnackBar(context, e);
            }
          }

          Future<void> editDescription() async {
            final newDescription = await showProductDescriptionSheet(
              context,
              initialDescription: product.description,
            );
            if (newDescription == null || !context.mounted) return;

            try {
              await ref.read(sellersRepositoryProvider).updateProduct(
                    product.id,
                    UpdateProductRequest(description: newDescription),
                  );
              await refreshAfterEdit();
            } catch (e) {
              if (context.mounted) showErrorSnackBar(context, e);
            }
          }

          Future<void> toggleStarred() async {
            try {
              await ref.read(sellersRepositoryProvider).updateProduct(
                    product.id,
                    UpdateProductRequest(isStarred: !product.isStarred),
                  );
              await refreshAfterEdit();
            } catch (e) {
              if (context.mounted) showErrorSnackBar(context, e);
            }
          }

          return ProductClientDetailView(
            content: content,
            onBack: () => context.pop(),
            onViewCatalog: () => context.push(
              RoutePaths.sellerCatalogPath(
                product.sellerId,
                currentProductId: product.id,
              ),
            ),
            bottomBar: isOwner
                ? null
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: Row(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: AppBrandColors.primaryGreen
                                    .withValues(alpha: 0.45),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.chat_outlined),
                            label: const Text('WhatsApp'),
                          ),
                        ),
                      ],
                    ),
                  ),
            isOwner: isOwner,
            onEditPhoto: isOwner ? editPhoto : null,
            onEditName: isOwner ? editName : null,
            onEditPrice: isOwner ? editPrice : null,
            onEditDescription: isOwner ? editDescription : null,
            isStarred: product.isStarred,
            onToggleStarred: isOwner ? toggleStarred : null,
          );
        },
      ),
    );
  }
}
