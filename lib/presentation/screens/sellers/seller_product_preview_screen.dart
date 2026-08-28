import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../models/seller_product_preview_model.dart';
import '../../widgets/sellers/product_client_detail_view.dart';

class SellerProductPreviewScreen extends StatelessWidget {
  const SellerProductPreviewScreen({super.key, required this.preview});

  final SellerProductPreviewModel preview;

  @override
  Widget build(BuildContext context) {
    final content = ProductClientDetailContent.fromPreview(preview);

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      body: ProductClientDetailView(
        content: content,
        isPreview: true,
        appBarTitle: 'Vista del cliente',
        leadingIcon: Icons.close_rounded,
        onBack: () => context.pop(),
        bottomBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text('Llamar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
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
        ),
      ),
    );
  }
}
