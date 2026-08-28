import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact/guest_contact_draft.dart';

class GuestContactLocalDataSource {
  GuestContactLocalDataSource(this._prefs);

  static const storageKey = 'guest_contact_draft';

  final SharedPreferences? _prefs;

  GuestContactDraft read() {
    final raw = _prefs?.getString(storageKey);
    if (raw == null || raw.isEmpty) return const GuestContactDraft();

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return GuestContactDraft.fromJson(json);
    } catch (_) {
      return const GuestContactDraft();
    }
  }

  Future<void> write(GuestContactDraft draft) async {
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setString(storageKey, jsonEncode(draft.toJson()));
  }
}
