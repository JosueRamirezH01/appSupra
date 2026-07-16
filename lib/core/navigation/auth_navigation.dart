import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route_paths.dart';

/// Rutas accesibles sin iniciar sesión (exploración tipo Urbania).
bool isPublicAppRoute(String location) {
  if (location == RoutePaths.home) return true;
  if (location == RoutePaths.preLogin) return true;
  if (location == RoutePaths.technicians || location.startsWith('/technicians/')) {
    return true;
  }
  if (location.startsWith('/products/') || location == RoutePaths.productsBrowse) {
    return true;
  }
  if (location == RoutePaths.professionalsBrowse) return true;
  if (location.startsWith('/explore/')) return true;
  if (location == RoutePaths.globalSearch ||
      location.startsWith('${RoutePaths.globalSearch}/')) {
    return true;
  }
  return isAuthFlowRoute(location);
}

/// Login, registro y recuperación de contraseña.
bool isAuthFlowRoute(String location) {
  return location == RoutePaths.login ||
      location == RoutePaths.register ||
      location == RoutePaths.registerClient ||
      location == RoutePaths.registerTechnician ||
      location == RoutePaths.registerSeller ||
      location == RoutePaths.forgotPassword;
}

void openLogin(BuildContext context) {
  context.push(RoutePaths.login);
}

/// Entra al home como invitado (omitir login).
void exploreWithoutAccount(BuildContext context) {
  context.go(RoutePaths.home);
}

void openRegister(BuildContext context) {
  context.push(RoutePaths.register);
}

void openRegisterClient(BuildContext context) {
  context.push(RoutePaths.registerClient);
}

void openRegisterTechnician(BuildContext context) {
  context.push(RoutePaths.registerTechnician);
}

void openRegisterSeller(BuildContext context) {
  context.push(RoutePaths.registerSeller);
}

/// Pantallas del embudo de bienvenida (sin sesión).
bool isAuthWelcomeRoute(String location) {
  return location == RoutePaths.preLogin || location == RoutePaths.login;
}
