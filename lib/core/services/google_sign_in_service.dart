import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_config.dart';

class GoogleSignInService {
  GoogleSignInService()
      : _googleSignIn = GoogleSignIn(
          scopes: const ['email', 'profile'],
          serverClientId: AppConfig.googleServerClientId.isEmpty
              ? null
              : AppConfig.googleServerClientId,
        );

  final GoogleSignIn _googleSignIn;

  bool get isConfigured => AppConfig.googleServerClientId.isNotEmpty;

  Future<String?> signInAndGetIdToken() async {
    if (!isConfigured) {
      throw StateError('Google Sign-In no está configurado en la app');
    }

    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    return auth.idToken;
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
  }
}
