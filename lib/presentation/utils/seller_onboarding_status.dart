import '../../data/models/sellers/seller_model.dart';

/// Activación post-registro: solo verificación del negocio. El catálogo se gestiona en el panel.
class SellerOnboardingStatus {
  SellerOnboardingStatus._();

  static bool hasSubmittedVerification(SellerApplicationModel profile) {
    return profile.verificationStatus == 'pendiente' ||
        profile.verificationStatus == 'aprobado' ||
        profile.verificationStatus == 'rechazado' ||
        profile.verified;
  }

  static bool isOnboardingComplete(SellerApplicationModel profile) {
    return hasSubmittedVerification(profile);
  }

  /// Solo redirige al wizard si aún no envió la verificación.
  static bool needsOnboarding(SellerApplicationModel profile) {
    return !hasSubmittedVerification(profile);
  }
}
