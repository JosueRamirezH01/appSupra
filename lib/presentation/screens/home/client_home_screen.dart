import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/app_view.dart';
import '../../../core/utils/error_utils.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/home/home_refresh_coordinator.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/home/client_home_header.dart';
import '../../widgets/home/home_product_offers_island.dart';
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
    final technicians = ref.watch(homeTechniciansProvider);

    return RefreshIndicator(
      onRefresh: () => runSoftRefresh(
        context,
        () => ref.read(homeRefreshCoordinatorProvider).refreshManually(),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        clipBehavior: Clip.none,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ClientHomeHeader(user: user, activeView: activeView),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                technicians.when(
                  skipError: true,
                  loading: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _TechniciansSectionHeader(),
                      const SizedBox(height: 8),
                      const SizedBox(
                        height: 36,
                        child: Center(
                          child: SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                  error: (_, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _TechniciansSectionHeader(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'No se pudieron cargar los técnicos.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                ref.invalidate(homeTechniciansProvider),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  data: (technicians) {
                    if (technicians.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final preview = technicians.take(6).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _TechniciansSectionHeader(),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const spacing = 10.0;
                            final cardWidth = (constraints.maxWidth - spacing) / 2;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: preview.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                    childAspectRatio:
                                        TechnicianHorizontalCard.gridAspectRatio(
                                          gridInnerWidth: constraints.maxWidth,
                                          crossAxisSpacing: spacing,
                                          verification:
                                              TechnicianCardVerification.seal,
                                        ),
                                  ),
                              itemBuilder: (context, index) {
                                final tech = preview[index];
                                return TechnicianHorizontalCard(
                                  technician: tech,
                                  width: cardWidth,
                                  verification:
                                      TechnicianCardVerification.seal,
                                  onTap: () => context.push(
                                    '/technicians/${tech.id}',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
                const HomeProductOffersIsland(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechniciansSectionHeader extends StatelessWidget {
  const _TechniciansSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
