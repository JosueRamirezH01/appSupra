import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/technician_recent_contacts_panel.dart';

const _listLimit = 20;

class TechnicianContactLeadsScreen extends ConsumerWidget {
  const TechnicianContactLeadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(
      myTechnicianContactLeadsProvider(limit: _listLimit),
    );

    return TechnicianPanelScaffold(
      title: 'Contactos recientes',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.pop(),
      ),
      body: contacts.when(
        loading: () => const LoadingView(message: 'Cargando contactos...'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(
            myTechnicianContactLeadsProvider(limit: _listLimit),
          ),
        ),
        data: (page) {
          if (page.contacts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Todavía no hay contactos. Cuando un cliente deje sus datos, aparecen aquí.',
                  textAlign: TextAlign.center,
                  style: TechnicianPanelTheme.subtitle,
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: TechnicianPanelColors.primary,
            onRefresh: () async {
              ref.invalidate(
                myTechnicianContactLeadsProvider(limit: _listLimit),
              );
              await ref.read(
                myTechnicianContactLeadsProvider(limit: _listLimit).future,
              );
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: page.contacts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return TechnicianPanelCard(
                  padding: EdgeInsets.zero,
                  child: TechnicianContactLeadRow(
                    contact: page.contacts[index],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
