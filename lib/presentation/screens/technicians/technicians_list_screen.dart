import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/professionals/professional_grid_card.dart';
import '../../widgets/technicians/technician_horizontal_card.dart';

/// Listado clásico de técnicos (misma card visual que home / browse).
class TechniciansListScreen extends ConsumerStatefulWidget {
  const TechniciansListScreen({super.key});

  @override
  ConsumerState<TechniciansListScreen> createState() =>
      _TechniciansListScreenState();
}

class _TechniciansListScreenState extends ConsumerState<TechniciansListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(techniciansListProvider);

    return AppScaffold(
      title: 'Técnicos',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (value) => ref
                        .read(techniciansListProvider.notifier)
                        .search(value.trim().isEmpty ? null : value.trim()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ref.invalidate(techniciansListProvider),
                ),
              ],
            ),
          ),
          Expanded(
            child: result.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(techniciansListProvider),
              ),
              data: (data) {
                if (data.technicians.isEmpty) {
                  return const EmptyView(message: 'No se encontraron técnicos');
                }
                return Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const horizontalPadding = 16.0;
                          const spacing = 10.0;
                          final aspect =
                              TechnicianHorizontalCard.gridAspectRatio(
                            gridInnerWidth:
                                constraints.maxWidth - horizontalPadding * 2,
                            crossAxisSpacing: spacing,
                            verification: TechnicianCardVerification.seal,
                          );

                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: data.technicians.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  childAspectRatio: aspect,
                                ),
                            itemBuilder: (context, index) {
                              final tech = data.technicians[index];
                              return ProfessionalGridCard(
                                technician: tech,
                                onTap: () =>
                                    context.push('/technicians/${tech.id}'),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (data.pagination.totalPages > 1)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: data.pagination.page > 1
                                  ? () => ref
                                      .read(techniciansListProvider.notifier)
                                      .loadPage(data.pagination.page - 1)
                                  : null,
                            ),
                            Text(
                              'Página ${data.pagination.page} de ${data.pagination.totalPages}',
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: data.pagination.page <
                                      data.pagination.totalPages
                                  ? () => ref
                                      .read(techniciansListProvider.notifier)
                                      .loadPage(data.pagination.page + 1)
                                  : null,
                            ),
                          ],
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
  }
}
