import '../../data/models/technicians/technician_model.dart';

enum TechnicianActivationStep {
  serviceArea,
  verification,
  pendingReview,
  complete,
}

enum TechnicianClientBannerStep {
  none,
  inactive,
  verificationPromo,
  pendingReview,
}

/// Estado de activación post-registro: ubicación obligatoria, verificación opcional.
class TechnicianOnboardingStatus {
  TechnicianOnboardingStatus._();

  static bool isFullyActivated(TechnicianApplicationModel profile) {
    return profile.verified ||
        profile.verificationStatus == 'aprobado';
  }

  static bool isTechnicianProfileActive(TechnicianApplicationModel profile) {
    return profile.hasServiceArea;
  }

  static bool needsActivationPanel(TechnicianApplicationModel profile) {
    if (!profile.hasServiceArea) return true;
    if (profile.verificationStatus == 'pendiente') return true;
    if (isFullyActivated(profile)) return false;
    return profile.canSubmitVerification;
  }

  static bool panelIsDismissible(TechnicianApplicationModel profile) {
    if (!profile.hasServiceArea) return false;
    return profile.verificationStatus == 'pendiente' ||
        profile.canSubmitVerification;
  }

  static TechnicianClientBannerStep clientBannerStep(
    TechnicianApplicationModel profile,
  ) {
    if (!profile.hasServiceArea) {
      return TechnicianClientBannerStep.inactive;
    }
    if (profile.verificationStatus == 'pendiente') {
      return TechnicianClientBannerStep.pendingReview;
    }
    if (isFullyActivated(profile)) return TechnicianClientBannerStep.none;
    if (profile.canSubmitVerification) {
      return TechnicianClientBannerStep.verificationPromo;
    }
    return TechnicianClientBannerStep.none;
  }

  static TechnicianActivationStep currentStep(
    TechnicianApplicationModel profile,
  ) {
    if (profile.verificationStatus == 'pendiente') {
      return TechnicianActivationStep.pendingReview;
    }
    if (isFullyActivated(profile)) {
      return TechnicianActivationStep.complete;
    }
    if (!profile.hasServiceArea) {
      return TechnicianActivationStep.serviceArea;
    }
    if (profile.canSubmitVerification) {
      return TechnicianActivationStep.verification;
    }
    return TechnicianActivationStep.complete;
  }

  static int activationProgress(TechnicianApplicationModel profile) {
    final step = currentStep(profile);
    return switch (step) {
      TechnicianActivationStep.serviceArea => 0,
      TechnicianActivationStep.verification => 1,
      TechnicianActivationStep.pendingReview => 2,
      TechnicianActivationStep.complete => 3,
    };
  }

  static const int activationStepsTotal = 2;
}
