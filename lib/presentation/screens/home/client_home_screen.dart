import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/app_view.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/location/client_location_provider.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home/client_home_header.dart';
import '../../widgets/sellers/product_horizontal_card.dart';
import '../../widgets/technicians/technician_horizontal_card.dart';

class ClientHomeScreen extends ConsumerWidget {
  const ClientHomeScreen({
    super.key,
    required this.user,
    required this.activeView,
  });

  final UserModel? user;
  final AppView activeView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final technicians = ref.watch(techniciansListProvider);
    final products = ref.watch(productsListProvider);

    return ListView(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      children: [
        ClientHomeHeader(
          user: user,
          activeView: activeView,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Técnicos disponibles',
                      style: GoogleFonts.montserrat(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.professionalsBrowse),
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              technicians.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: LoadingView(message: 'Cargando técnicos...'),
                ),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(techniciansListProvider),
                ),
                data: (data) {
                  if (data.technicians.isEmpty) {
                    return const EmptyView(
                      message: 'Aún no hay técnicos publicados en tu zona.',
                    );
                  }

                  final preview = data.technicians.take(10).toList();
                  return SizedBox(
                    height: TechnicianHorizontalCard.cardHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: preview.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final tech = preview[index];
                        return TechnicianHorizontalCard(
                          technician: tech,
                          onTap: () =>
                              context.push('/technicians/${tech.id}'),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Productos',
                      style: GoogleFonts.montserrat(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.productsBrowse),
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              products.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: LoadingView(message: 'Cargando productos...'),
                ),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(productsListProvider),
                ),
                data: (data) {
                  if (data.products.isEmpty) {
                    final hasLocation =
                        ref.watch(activeClientLocationProvider).valueOrNull !=
                            null;
                    return EmptyView(
                      message: hasLocation
                          ? 'No hay materiales de negocios cerca de tu ubicación.'
                          : 'Aún no hay productos publicados.',
                    );
                  }

                  final preview = data.products.take(10).toList();
                  return SizedBox(
                    height: ProductHorizontalCard.cardHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: preview.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final product = preview[index];
                        return ProductHorizontalCard(
                          product: product,
                          onTap: () => context.push(
                            RoutePaths.productDetailPath(product.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
