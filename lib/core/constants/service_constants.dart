class ServiceConstants {
  ServiceConstants._();

  static const maxServicesPerSpecialty = 8;
  static const minServicesPerSpecialty = 1;
  static const maxRegistrationSpecialties = 5;
  static const minRegistrationSpecialties = 1;

  static int maxTotalServicesForSpecialtyCount(int specialtyCount) =>
      specialtyCount * maxServicesPerSpecialty;

  static int minTotalServicesForSpecialtyCount(int specialtyCount) =>
      specialtyCount * minServicesPerSpecialty;

  static const int customServiceMinLength = 2;
  static const int customServiceMaxLength = 100;
}
