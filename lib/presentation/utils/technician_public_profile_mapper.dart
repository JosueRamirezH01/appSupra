import '../../data/models/technicians/technician_model.dart';

/// Convierte el perfil completo del técnico al modelo público que ven los clientes.
TechnicianPublicModel technicianApplicationToPublic(
  TechnicianApplicationModel profile,
) {
  return TechnicianPublicModel(
    id: profile.userId ?? profile.id,
    name: profile.name,
    specialty: profile.specialty,
    profilePhotoUrl: profile.profilePhotoUrl,
    profileType: profile.profileType,
    verified: profile.verified,
    verificationStatus: profile.verificationStatus,
    description: profile.description,
    phone: profile.phone,
    address: profile.address,
    location: profile.location,
    coverageRadiusKm: profile.coverageRadiusKm,
    coversAllPeru: profile.coversAllPeru,
    coverageDistricts: profile.coverageDistricts,
    schedule: profile.schedule,
    subcategories: profile.subcategories,
    subSubCategories: profile.subSubCategories,
    pendingServices: profile.pendingServices,
    experienceYears: profile.experienceYears,
    experienceDescription: profile.experienceDescription,
    portfolio: profile.portfolio,
    workPhotos: profile.workPhotos,
    validatedCertifications: profile.validatedCertifications,
    hasValidatedCertifications: profile.hasValidatedCertifications,
    averageRating: profile.averageRating,
    ratingCount: profile.ratingCount,
  );
}
