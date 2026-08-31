import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/location/client_location_actions.dart';
import '../../providers/location/client_location_provider.dart';
import '../../providers/products/home_product_offers_provider.dart';
import '../location/client_location_search_sheet.dart';
import '../sellers/product_horizontal_card.dart';

/// Isla de ofertas del home (entre técnicos y productos).
///
/// Con zona: hasta 6 cards cerca (2 por vendedor) + Ver más.
/// Sin zona: pide GPS o distrito; no lista el país.
class HomeProductOffersIsland extends ConsumerStatefulWidget {
  const HomeProductOffersIsland({super.key});

  @override
  ConsumerState<HomeProductOffersIsland> createState() =>
      _HomeProductOffersIslandState();
}

class _HomeProductOffersIslandState
    extends ConsumerState<HomeProductOffersIsland> {
  bool _locating = false;

  Future<void> _useCurrentLocation() async {
    if (_locating) return;
    setState(() => _locating = true);
    try {
      final location = await useCurrentClientLocation(ref);
      if (!mounted || location == null) return;
      showNearbyZoneSnackBar(context, location.label);
    } on CurrentClientLocationException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          action: error.shouldOpenSettings
              ? SnackBarAction(
                  label: 'Ajustes',
                  onPressed: Geolocator.openAppSettings,
                )
              : null,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo usar tu ubicación. Intenta de nuevo.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation =
        ref.watch(activeClientLocationProvider).valueOrNull != null;
    final asyncOffers = ref.watch(homeProductOffersProvider);

    if (!hasLocation) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: _OffersIslandFrame(
          subtitle: 'Elige zona para ver descuentos cerca.',
          child: _OffersNeedLocation(
            locating: _locating,
            onUseCurrent: _useCurrentLocation,
            onPickDistrict: () => showClientLocationSearchSheet(context),
          ),
        ),
      );
    }

    return asyncOffers.when(
      skipError: true,
      skipLoadingOnReload: true,
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: _OffersIslandSkeleton(),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: _OffersIslandFrame(
          child: _OffersMessage(
            text: 'No se pudieron cargar las ofertas.',
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(homeProductOffersProvider),
          ),
        ),
      ),
      data: (result) {
        if (result.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _OffersIslandFrame(
              child: _OffersMessage(
                text: 'No hay descuentos a 15 km.',
                actionLabel: 'Cambiar zona',
                onAction: () => showClientLocationSearchSheet(context),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _OffersIsland(
            products: result.products,
            onSeeMore: result.hasMore
                ? () => context.push(RoutePaths.productOffers)
                : null,
          ),
        );
      },
    );
  }
}

class _OffersIslandFrame extends StatelessWidget {
  const _OffersIslandFrame({
    required this.child,
    this.subtitle = 'Productos con descuento cerca de ti.',
  });

  final Widget child;
  final String subtitle;

  static const _radius = 20.0;
  static const _topRightRadius = 70.0;

  static const islandRadius = BorderRadius.only(
    topLeft: Radius.circular(_radius),
    topRight: Radius.circular(_topRightRadius),
    bottomLeft: Radius.circular(_radius),
    bottomRight: Radius.circular(_radius),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: islandRadius,
      child: ColoredBox(
        color: AppBrandColors.islaHomeOffers,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _OffersIslandTitle(subtitle: subtitle),
            child,
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _OffersIslandTitle extends StatelessWidget {
  const _OffersIslandTitle({
    this.onSeeMore,
    this.subtitle = 'Productos con descuento cerca de ti.',
  });

  final VoidCallback? onSeeMore;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ofertas',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.3,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          if (onSeeMore != null)
            TextButton(
              onPressed: onSeeMore,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppBrandColors.textDark,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver más',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 22),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _OffersNeedLocation extends StatelessWidget {
  const _OffersNeedLocation({
    required this.locating,
    required this.onUseCurrent,
    required this.onPickDistrict,
  });

  final bool locating;
  final VoidCallback onUseCurrent;
  final VoidCallback onPickDistrict;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Elige tu ubicación para ver descuentos cerca de ti.',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              height: 1.35,
              color: AppBrandColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: locating ? null : onUseCurrent,
            style: FilledButton.styleFrom(
              backgroundColor: AppBrandColors.textDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: locating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.my_location_rounded, size: 18),
            label: Text(
              locating ? 'Obteniendo tu posición…' : 'Usar mi ubicación',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: locating ? null : onPickDistrict,
            child: Text(
              'Elegir distrito',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OffersMessage extends StatelessWidget {
  const _OffersMessage({
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              height: 1.35,
              color: AppBrandColors.textDark,
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppBrandColors.textDark,
              ),
              child: Text(
                actionLabel!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class _OffersIsland extends StatelessWidget {
  const _OffersIsland({
    required this.products,
    this.onSeeMore,
  });

  final List<ProductPublicModel> products;
  final VoidCallback? onSeeMore;

  static const _pad = 16.0;
  static const _endPeek = 12.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _OffersIslandFrame.islandRadius,
      child: ColoredBox(
        color: AppBrandColors.islaHomeOffers,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _OffersIslandTitle(onSeeMore: onSeeMore),
            const SizedBox(height: 14),
            SizedBox(
              height: ProductHorizontalCard.cardHeight + _pad,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(_pad, 0, _endPeek, _pad),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductHorizontalCard(
                    product: product,
                    onTap: () => context.push(
                      RoutePaths.sellerCatalogPath(
                        product.sellerId,
                        currentProductId: product.id,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _OffersIslandSkeleton extends StatelessWidget {
  const _OffersIslandSkeleton();

  static const _radius = 20.0;
  static const _topRightRadius = 80.0;
  static const _pad = 16.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_radius),
        topRight: Radius.circular(_topRightRadius),
        bottomLeft: Radius.circular(_radius),
        bottomRight: Radius.circular(_radius),
      ),
      child: ColoredBox(
        color: AppBrandColors.islaHomeOffers,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(_pad, 16, _pad, _pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bar(width: 110, height: 18),
              const SizedBox(height: 8),
              _bar(width: 168, height: 12),
              const SizedBox(height: 14),
              SizedBox(
                height: ProductHorizontalCard.cardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, _) => Container(
                    width: ProductHorizontalCard.cardWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
