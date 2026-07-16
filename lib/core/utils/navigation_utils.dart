import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums/app_view.dart';
import '../../data/models/auth/user_model.dart';
import '../../routes/route_paths.dart';
import '../../presentation/providers/app_view_notifier.dart';

AppView resolveActiveView(UserModel user, AppView activeView) {
  final available = user.parsedAvailableViews;
  if (available.isEmpty) return AppView.client;
  if (available.contains(activeView)) return activeView;
  return user.preferredDefaultView;
}

String rootPathForView(AppView view) =>
    view == AppView.client ? RoutePaths.home : RoutePaths.panel;

void goToHomeWithView(
  BuildContext context,
  WidgetRef ref,
  AppView view,
) {
  ref.read(activeAppViewProvider.notifier).setView(view);
  context.go(rootPathForView(view));
}

void goToTechnicianHome(BuildContext context, WidgetRef ref) {
  goToHomeWithView(context, ref, AppView.technician);
}

void goToClientHome(BuildContext context, WidgetRef ref) {
  goToHomeWithView(context, ref, AppView.client);
}

void goToSellerHome(BuildContext context, WidgetRef ref) {
  goToHomeWithView(context, ref, AppView.seller);
}
