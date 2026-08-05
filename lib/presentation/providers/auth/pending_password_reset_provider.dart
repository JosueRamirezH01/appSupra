import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/auth/password_reset_models.dart';

/// Args del paso "nueva contraseña". Vive fuera de GoRouter para que no se
/// pierdan cuando el authNotifier refresca el router (loading → data).
final pendingPasswordResetProvider =
    StateProvider<PasswordResetNewArgs?>((ref) => null);
