import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class ViewerIdentityService {
  ViewerIdentityService._();

  static const _storageKey = 'anonymous_viewer_key';

  static Future<String> getViewerKey() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_storageKey);
    if (existing != null && existing.trim().length >= 8) {
      return existing;
    }

    final random = Random();
    final generated =
        'guest_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(999999)}';
    await prefs.setString(_storageKey, generated);
    return generated;
  }
}
