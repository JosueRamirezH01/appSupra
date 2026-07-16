import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/common_widgets.dart';

class AdminApplicationsScreen extends ConsumerWidget {
  const AdminApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(adminApplicationsProvider);

    return AppScaffold(
      title: 'Solicitudes de técnicos',
      actions: [
        PopupMenuButton<String?>(
          onSelected: (status) =>
              ref.read(adminApplicationsProvider.notifier).filterByStatus(status),
          itemBuilder: (_) => const [
            PopupMenuItem(value: null, child: Text('Todas')),
            PopupMenuItem(value: 'pendiente', child: Text('Pendientes')),
            PopupMenuItem(value: 'aprobado', child: Text('Aprobadas')),
            PopupMenuItem(value: 'rechazado', child: Text('Rechazadas')),
          ],
        ),
      ],
      body: applications.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(adminApplicationsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyView(message: 'No hay solicitudes');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final app = items[index];
              return Card(
                child: ListTile(
                  title: Text(app.name),
                  subtitle: Text(
                    '${app.email ?? ''}\nEstado: ${app.verificationStatus ?? 'pendiente'}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/admin/applications/${app.userId ?? app.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AdminApplicationDetailScreen extends ConsumerWidget {
  const AdminApplicationDetailScreen({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref.watch(adminApplicationDetailProvider(userId));

    return AppScaffold(
      title: 'Solicitud #$userId',
      body: application.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(adminApplicationDetailProvider(userId)),
        ),
        data: (app) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(app.name, style: Theme.of(context).textTheme.headlineSmall),
            if (app.email != null) Text(app.email!),
            const SizedBox(height: 8),
            Text('Estado: ${app.verificationStatus ?? 'pendiente'}'),
            if (app.specialty != null) Text('Especialidad: ${app.specialty}'),
            if (app.documentNumber != null)
              Text('Documento: ${app.documentType ?? ''} ${app.documentNumber}'),
            if (app.description != null) ...[
              const SizedBox(height: 16),
              Text(app.description!),
            ],
            const SizedBox(height: 24),
            if (app.verificationStatus == 'pendiente') ...[
              FilledButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(adminApplicationsProvider.notifier)
                        .approve(userId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Identidad aprobada')),
                      );
                      context.pop();
                    }
                  } catch (e) {
                    if (context.mounted) showErrorSnackBar(context, e);
                  }
                },
                child: const Text('Aprobar identidad'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _reject(context, ref),
                child: const Text('Rechazar identidad'),
              ),
            ],
            if (app.certificationPending) ...[
              const SizedBox(height: 24),
              Text('Certificación pendiente', style: Theme.of(context).textTheme.titleMedium),
              if (app.certifications.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(app.certifications.first.name),
                if (app.certifications.first.issuer != null)
                  Text(app.certifications.first.issuer!),
              ],
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(adminApplicationsProvider.notifier)
                        .approveCertification(userId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Certificación aprobada')),
                      );
                      ref.invalidate(adminApplicationDetailProvider(userId));
                    }
                  } catch (e) {
                    if (context.mounted) showErrorSnackBar(context, e);
                  }
                },
                child: const Text('Aprobar certificación'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(adminApplicationsProvider.notifier)
                        .rejectCertification(userId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Certificación rechazada')),
                      );
                      ref.invalidate(adminApplicationDetailProvider(userId));
                    }
                  } catch (e) {
                    if (context.mounted) showErrorSnackBar(context, e);
                  }
                },
                child: const Text('Rechazar certificación'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Motivo de rechazo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Motivo (mín. 10 caracteres)',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );

    if (reason == null || reason.length < 10) return;

    try {
      await ref.read(adminApplicationsProvider.notifier).reject(userId, reason);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud rechazada')),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }
}
