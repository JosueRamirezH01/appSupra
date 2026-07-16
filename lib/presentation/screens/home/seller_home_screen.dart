import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/auth/user_model.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/sellers/product_horizontal_card.dart';
import '../../widgets/sellers/seller_panel_widgets.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';

class SellerHomeScreen extends ConsumerWidget {
  const SellerHomeScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref.watch(mySellerApplicationProvider);
    final products = ref.watch(mySellerProductsProvider);
    final summary = user.sellerSummary;

    return application.when(
      loading: () => const LoadingView(message: 'Cargando tu negocio...'),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(mySellerApplicationProvider),
      ),
      data: (data) {
        final approved = data.verificationStatus == 'aprobado' || data.verified;
        final canVerify = data.canSubmitVerification;

        return RefreshIndicator(
          color: TechnicianPanelColors.primary,
          onRefresh: () async {
            ref.invalidate(mySellerApplicationProvider);
            ref.invalidate(mySellerProductsProvider);
            await ref.read(mySellerApplicationProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _SellerHero(application: data),
              const SizedBox(height: 16),
              SellerPanelStatusBanner.fromVerification(
                status: data.verificationStatus,
                verified: data.verified || (summary?.verified ?? false),
                rejectionReason: data.rejectionReason ?? summary?.rejectionReason,
                actionLabel: canVerify ? 'Completar verificación' : null,
                onAction: canVerify
                    ? () => context.push(RoutePaths.sellerVerification)
                    : null,
              ),
              const SizedBox(height: 20),
              TechnicianPanelSection(
                title: 'Acciones rápidas',
                child: Column(
                  children: [
                    if (canVerify)
                      TechnicianPanelActionTile(
                        icon: Icons.verified_user_outlined,
                        title: 'Verificar negocio',
                        subtitle: 'Sube tu ficha RUC para publicar en el catálogo',
                        onTap: () => context.push(RoutePaths.sellerVerification),
                      ),
                    TechnicianPanelActionTile(
                      icon: Icons.edit_outlined,
                      title: 'Editar perfil del negocio',
                      subtitle: data.businessName,
                      onTap: () => context.push(RoutePaths.sellerProfileEdit),
                    ),
                    TechnicianPanelActionTile(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación del negocio',
                      subtitle: data.hasLocation
                          ? data.location?.address ??
                              data.locationAddress ??
                              'Actualiza dónde está tu local'
                          : 'Configúrala al verificar tu negocio',
                      badge: data.hasLocation ? null : 'Pendiente',
                      onTap: () {
                        if (canVerify) {
                          context.push(RoutePaths.sellerVerification);
                          return;
                        }
                        context.push(RoutePaths.sellerLocation);
                      },
                    ),
                    TechnicianPanelActionTile(
                      icon: Icons.inventory_2_outlined,
                      title: 'Gestionar productos',
                      subtitle: approved
                          ? 'Publica materiales y productos que vende tu empresa'
                          : 'Prepara tu catálogo mientras se aprueba tu negocio',
                      onTap: () => context.push(RoutePaths.sellerProducts),
                    ),
                    TechnicianPanelActionTile(
                      icon: Icons.add_circle_outline,
                      title: 'Agregar al catálogo',
                      subtitle: 'Registra ladrillos, pinturas, aluzinc y más',
                      onTap: () => context.push(RoutePaths.sellerProductNew),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TechnicianPanelSection(
                title: 'Vista previa del catálogo',
                subtitle: 'Cada producto muestra si está publicado o no publicado',
                child: products.when(
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(mySellerProductsProvider),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return TechnicianPanelCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Tu catálogo está vacío',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              approved
                                  ? 'Agrega tu primer producto y publícalo cuando esté listo.'
                                  : 'Agrega productos como no publicados mientras se aprueba tu negocio.',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF6B7280),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TechnicianPanelPrimaryButton(
                              label: 'Agregar al catálogo',
                              icon: Icons.add_circle_outline,
                              onPressed: () =>
                                  context.push(RoutePaths.sellerProductNew),
                            ),
                          ],
                        ),
                      );
                    }

                    final preview = items.take(8).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SellerProductStatusSummary(
                          products: items,
                          onStatusTap: (_) => context.push(RoutePaths.sellerProducts),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: ProductHorizontalCard.cardHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: preview.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = preview[index];
                              return ProductHorizontalCard(
                                product: product,
                                showStatusBadge: true,
                                onTap: () => context.push(
                                  RoutePaths.sellerProductEditPath(product.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SellerHero extends StatelessWidget {
  const _SellerHero({required this.application});

  final SellerApplicationModel application;

  static String _verificationChipLabel(SellerApplicationModel application) {
    if (application.verified || application.verificationStatus == 'aprobado') {
      return 'Verificado';
    }
    return switch (application.verificationStatus) {
      'pendiente' => 'En revisión',
      'rechazado' => 'Rechazado',
      _ => 'Sin verificar',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TechnicianPanelTheme.heroDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            backgroundImage: application.logoUrl == null
                ? null
                : NetworkImage(application.logoUrl!),
            child: application.logoUrl == null
                ? const Icon(Icons.storefront_outlined, color: Colors.white, size: 32)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application.businessName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                if (application.hasLocation &&
                    (application.location?.address ??
                            application.locationAddress)
                        ?.trim()
                        .isNotEmpty ==
                        true)
                  Text(
                    application.location?.address ??
                        application.locationAddress!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  'RUC ${application.ruc}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TechnicianPanelChip(
                      label: _verificationChipLabel(application),
                      icon: application.verified ||
                              application.verificationStatus == 'aprobado'
                          ? Icons.verified_rounded
                          : application.verificationStatus == 'pendiente'
                              ? Icons.hourglass_top_rounded
                              : Icons.storefront_outlined,
                      tint: Colors.white.withValues(alpha: 0.9),
                    ),
                    TechnicianPanelChip(
                      label: '${application.productCount} productos',
                      icon: Icons.inventory_2_outlined,
                      tint: Colors.white.withValues(alpha: 0.9),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
