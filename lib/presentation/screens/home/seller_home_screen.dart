import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/sellers/my_seller_products_provider.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home/home_media_image.dart';
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
    final products = ref.watch(mySellerProductsPreviewProvider);
    final summary = user.sellerSummary;

    return application.when(
      skipLoadingOnReload: true,
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
          onRefresh: () => runSoftRefresh(context, () async {
            ref.invalidate(mySellerApplicationProvider);
            ref.invalidate(mySellerProductsPreviewProvider);
            await ref.read(mySellerApplicationProvider.future);
          }),
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
                onAction: canVerify ? () => context.push(RoutePaths.sellerVerification) : null,
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
                      icon: Icons.image_outlined,
                      title: 'Foto de portada',
                      subtitle: (data.coverUrl?.trim().isNotEmpty ?? false)
                          ? 'Así se ve el encabezado de tu tienda'
                          : 'Opcional. Foto del local o la vitrina',
                      onTap: () => context.push(RoutePaths.sellerCover),
                    ),
                    TechnicianPanelActionTile(
                      icon: Icons.store,
                      title: 'Mi tienda',
                      subtitle: 'Así aparece tu tienda para los clientes',
                      onTap: () => context.push(
                        RoutePaths.sellerCatalogPath(user.id),
                      ),
                    ),
                    TechnicianPanelActionTile(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación del negocio',
                      subtitle: data.hasLocation ? data.location?.address ?? data.locationAddress ??
                          'Actualiza dónde está tu local' : 'Configúrala al verificar tu negocio',
                      badge: data.hasLocation ? null : 'Pendiente',
                      onTap: () {
                        if (canVerify) {
                          context.push(RoutePaths.sellerVerification);
                          return;
                        }
                        context.push(RoutePaths.sellerLocation);
                      },
                    ),
                    /*TechnicianPanelActionTile(
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
                    ),*/
                  ],
                ),
              ),
              const SizedBox(height: 20),
/*
              TechnicianPanelSection(
                title: 'Vista previa del catálogo',
                subtitle: 'Cada producto muestra si está publicado o no publicado',
                child: products.when(
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(mySellerProductsPreviewProvider),
                  ),
                  data: (result) {
                    final items = result.products;
                    if (items.isEmpty) {
                      return TechnicianPanelCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Tu catálogo está vacío',
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(approved ? 'Agrega tu primer producto y publícalo cuando esté listo.'
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
                              onPressed: () => context.push(RoutePaths.sellerProductNew),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SellerProductStatusSummary(
                          counts: myProductsCountsAsFilterMap(result.counts),
                          onStatusTap: (_) => context.push(RoutePaths.sellerProducts),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: ProductHorizontalCard.cardHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = items[index];
                              return ProductHorizontalCard(
                                product: product,
                                showStatusBadge: true,
                                onTap: () => context.push(RoutePaths.sellerProductEditPath(product.id)),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
*/
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

  static const _coverHeight = 128.0;
  static const _logoSize = 68.0;
  static const _radius = 20.0;

  bool get _isVerified =>
      application.verified || application.verificationStatus == 'aprobado';

  String get _statusLabel {
    if (_isVerified) return 'Verificado';
    return switch (application.verificationStatus) {
      'pendiente' => 'En revisión',
      'rechazado' => 'Rechazado',
      _ => 'Sin verificar',
    };
  }

  IconData get _statusIcon {
    if (_isVerified) return Icons.verified_rounded;
    return switch (application.verificationStatus) {
      'pendiente' => Icons.hourglass_top_rounded,
      'rechazado' => Icons.error_outline_rounded,
      _ => Icons.storefront_outlined,
    };
  }

  Color get _statusForeground {
    if (_isVerified) return const Color(0xFF0F766E);
    return switch (application.verificationStatus) {
      'pendiente' => const Color(0xFFB45309),
      'rechazado' => const Color(0xFFB91C1C),
      _ => AppBrandColors.textMuted,
    };
  }

  Color get _statusBackground {
    if (_isVerified) return const Color(0xFFE6F7F4);
    return switch (application.verificationStatus) {
      'pendiente' => const Color(0xFFFFF7ED),
      'rechazado' => const Color(0xFFFEF2F2),
      _ => AppBrandColors.fieldFill,
    };
  }

  String? get _address {
    if (!application.hasLocation) return null;
    final value =
        (application.location?.address ?? application.locationAddress)?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final productLabel = application.productCount == 1
        ? '1 producto'
        : '${application.productCount} productos';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: const Color(0x140B1C15)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140B1C15),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: _coverHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _SellerHeroCover(coverUrl: application.coverUrl),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00000000),
                              Color(0x590B1C15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: _logoSize + 12),
                          child: Text(
                            application.businessName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: AppBrandColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_address != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: 15,
                                  color: AppBrandColors.primaryGreen,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _address!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    height: 1.35,
                                    color: AppBrandColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          'RUC ${application.ruc}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppBrandColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _SellerHeroChip(
                              icon: _statusIcon,
                              label: _statusLabel,
                              foreground: _statusForeground,
                              background: _statusBackground,
                            ),
                            _SellerHeroChip(
                              icon: Icons.inventory_2_outlined,
                              label: productLabel,
                              foreground: AppBrandColors.textDark,
                              background: AppBrandColors.fieldFill,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              top: _coverHeight - (_logoSize / 2),
              child: _SellerHeroLogo(logoUrl: application.logoUrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellerHeroCover extends StatelessWidget {
  const _SellerHeroCover({this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    final hasCover = coverUrl != null && coverUrl!.trim().isNotEmpty;
    if (hasCover) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return HomeMediaImage.profileCover(
            context: context,
            imageUrl: coverUrl,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
        },
      );
    }

    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C9A28),
            Color(0xFF2F5C18),
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.storefront_rounded,
            size: 72,
            color: Color(0x33FFFFFF),
          ),
        ),
      ),
    );
  }
}

class _SellerHeroLogo extends StatelessWidget {
  const _SellerHeroLogo({this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final image = MediaUrlUtils.networkImage(logoUrl);

    return Container(
      width: _SellerHero._logoSize,
      height: _SellerHero._logoSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x240B1C15),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: image == null
          ? ColoredBox(
              color: AppBrandColors.fieldFill,
              child: Icon(
                Icons.storefront_rounded,
                color: AppBrandColors.primaryGreen.withValues(alpha: 0.9),
                size: 30,
              ),
            )
          : Image(image: image, fit: BoxFit.cover),
    );
  }
}

class _SellerHeroChip extends StatelessWidget {
  const _SellerHeroChip({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
