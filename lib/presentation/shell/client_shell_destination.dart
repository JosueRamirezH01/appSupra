import 'package:go_router/go_router.dart';

import '../../routes/route_paths.dart';

/// Destinos del bottom navigation del cliente.
enum ClientShellDestination {
  home,
  technicians,
  products,
  profile;

  String get routePath => switch (this) {
        ClientShellDestination.home => RoutePaths.home,
        ClientShellDestination.technicians => RoutePaths.professionalsBrowse,
        ClientShellDestination.products => RoutePaths.productsBrowse,
        ClientShellDestination.profile => RoutePaths.clientSettings,
      };

  static ClientShellDestination fromRoute(String location) {
    if (location.startsWith(RoutePaths.clientSettings)) {
      return ClientShellDestination.profile;
    }
    if (location.startsWith(RoutePaths.productsBrowse)) {
      return ClientShellDestination.products;
    }
    if (location.startsWith(RoutePaths.professionalsBrowse)) {
      return ClientShellDestination.technicians;
    }
    return ClientShellDestination.home;
  }

  static int indexOf(String location) =>
      fromRoute(location).index;

  static void goTo(GoRouter router, ClientShellDestination destination) {
    router.go(destination.routePath);
  }
}

bool isClientShellLocation(String location) {
  if (isClientShellTabLocation(location)) return true;
  if (location.startsWith(RoutePaths.clientSettings)) return true;
  return false;
}

/// Pestañas del bottom nav (excluye ajustes accesible desde el panel).
bool isClientShellTabLocation(String location) {
  if (location == RoutePaths.home) return true;
  if (location.startsWith(RoutePaths.professionalsBrowse)) return true;
  if (location == RoutePaths.productsBrowse) return true;
  return false;
}
