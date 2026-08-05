class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google';
  static const String refresh = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String forgotPasswordResend = '/auth/forgot-password/resend';
  static const String forgotPasswordVerify = '/auth/forgot-password/verify';
  static const String forgotPasswordReset = '/auth/forgot-password/reset';
  static const String register = '/auth/register';
  static const String registerSendCode = '/auth/register/send-code';
  static const String registerCancelCode = '/auth/register/cancel-code';
  static const String registerClient = '/auth/register/cliente';
  static const String registerTechnician = '/auth/register/tecnico';
  static const String registerSeller = '/auth/register/vendedor';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
  static const String profileClient = '/auth/profile/cliente';
  static const String profileTechnician = '/auth/profile/tecnico';
  static const String profileSeller = '/auth/profile/vendedor';

  // Categories
  static const String categories = '/categories';
  static String category(int id) => '/categories/$id';
  static String categoryStatus(int id) => '/categories/$id/status';
  static String subcategoriesByCategory(int categoryId) =>
      '/categories/$categoryId/subcategories';
  static const String subcategories = '/subcategories';
  static String subcategory(int id) => '/subcategories/$id';
  static String subcategoryStatus(int id) => '/subcategories/$id/status';
  static String subSubCategoriesBySubcategory(int subcategoryId) =>
      '/subcategories/$subcategoryId/sub-subcategories';
  static const String subSubCategories = '/sub-subcategories';
  static String subSubCategory(int id) => '/sub-subcategories/$id';
  static String subSubCategoryStatus(int id) => '/sub-subcategories/$id/status';

  // Home content
  static const String homeContent = '/home/content';
  static const String homeTechnicians = '/home/technicians';

  // Technicians
  static const String technicians = '/technicians';
  static String technician(int userId) => '/technicians/$userId';
  static String technicianContacts(int userId) =>
      '/technicians/$userId/contacts';
  static String technicianProfileViews(int userId) =>
      '/technicians/$userId/profile-views';
  static const String technicianActivityMe = '/technicians/activity/me';
  static const String technicianContactsMe =
      '/technicians/activity/me/contacts';
  static const String technicianPerformanceMe =
      '/technicians/activity/me/performance';
  static const String technicianProfileMe = '/technicians/profile/me';
  static String technicianServiceMe(int subSubCategoryId) =>
      '/technicians/profile/me/services/$subSubCategoryId';
  static String technicianPublicService(int userId, int subSubCategoryId) =>
      '/technicians/$userId/services/$subSubCategoryId';
  static const String technicianApplicationMe = '/technicians/application/me';
  static const String technicianVerificationMe = '/technicians/verification/me';
  static const String technicianCertificationMe =
      '/technicians/certifications/me';
  static const String technicianSuggestService =
      '/technicians/catalog-suggestions/me';
  static String technicianRemoveServiceSuggestion(int suggestionId) =>
      '/technicians/catalog-suggestions/me/$suggestionId';

  // Sellers
  static const String sellerProducts = '/sellers/products';
  static String sellerProduct(int productId) => '/sellers/products/$productId';
  static String seller(int userId) => '/sellers/$userId';
  static String sellerContacts(int userId) => '/sellers/$userId/contacts';
  static const String sellerProfileMe = '/sellers/profile/me';
  static const String sellerApplicationMe = '/sellers/application/me';
  static const String sellerVerificationMe =
      '/sellers/application/verification';
  static const String sellerMyProducts = '/sellers/me/products';
  static String sellerMyProduct(int productId) =>
      '/sellers/me/products/$productId';

  // Admin
  static const String adminApplications = '/admin/technicians/applications';
  static String adminApplication(int userId) =>
      '/admin/technicians/applications/$userId';
  static String adminApprove(int userId) =>
      '/admin/technicians/applications/$userId/approve';
  static String adminReject(int userId) =>
      '/admin/technicians/applications/$userId/reject';
  static String adminApproveCertification(int userId) =>
      '/admin/technicians/applications/$userId/certifications/approve';
  static String adminRejectCertification(int userId) =>
      '/admin/technicians/applications/$userId/certifications/reject';

  // Uploads
  static const String uploadSession = '/uploads/session';
  static String uploadTechnician(String category) =>
      '/uploads/technician/$category';
  static const String uploadCategoryImage = '/uploads/categories/image';

  // Locations
  static const String locationsSearch = '/locations/search';

  // Search
  static const String searchSuggest = '/search/suggest';
  static const String search = '/search';
  static const String searchHistory = '/search/history';
  static String searchHistoryItem(int historyId) =>
      '/search/history/$historyId';

  // Health
  static const String health = '/health';

  // App version
  static const String appVersion = '/app/version';
}
