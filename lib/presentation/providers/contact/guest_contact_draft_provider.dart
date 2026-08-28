import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/guest_contact_local_datasource.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/contact/guest_contact_draft.dart';
import '../auth/auth_notifier.dart';
import '../location/client_location_data_providers.dart';

class GuestContactDraftNotifier extends StateNotifier<GuestContactDraft> {
  GuestContactDraftNotifier(this._source) : super(_source.read());

  final GuestContactLocalDataSource _source;

  Future<void> save({
    required String name,
    required String email,
    required String phone,
  }) async {
    final draft = GuestContactDraft(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    state = draft;
    await _source.write(draft);
  }
}

final guestContactDraftProvider =
    StateNotifierProvider<GuestContactDraftNotifier, GuestContactDraft>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).valueOrNull;
  return GuestContactDraftNotifier(GuestContactLocalDataSource(prefs));
});

/// Logueado: perfil. Invitado: último contacto en este teléfono.
GuestContactDraft resolveContactLeadPrefill(WidgetRef ref) {
  final user = ref.read(authNotifierProvider).valueOrNull;
  if (user != null) {
    return GuestContactDraft(
      name: user.name.trim(),
      email: user.email.trim(),
      phone: _clientPhoneOf(user),
    );
  }
  return ref.read(guestContactDraftProvider);
}

Future<void> persistGuestContactDraftIfNeeded(
  WidgetRef ref, {
  required String name,
  required String email,
  required String phone,
}) async {
  final user = ref.read(authNotifierProvider).valueOrNull;
  if (user != null) return;
  await ref.read(guestContactDraftProvider.notifier).save(
        name: name,
        email: email,
        phone: phone,
      );
}

String _clientPhoneOf(UserModel user) {
  return user.views?.client?.phone?.trim() ?? '';
}
