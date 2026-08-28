class RoutePaths {
  RoutePaths._();
  static const preLogin = '/preLogin';
  static const login = '/login';
  static const register = '/register';
  static const registerClient = '/register/cliente';
  static const registerTechnician = '/register/tecnico';
  static const registerSeller = '/register/vendedor';
  static const registerVerify = '/register/verify';
  static const becomeSeller = '/seller/become';
  static const sellerOnboarding = '/seller/onboarding';
  static const sellerVerification = '/seller/verification';
  static const sellerProfileEdit = '/seller/profile/edit';
  static const sellerCover = '/seller/cover';
  static const sellerLocation = '/seller/location';
  static const sellerLocationMap = '/seller/location/map';
  static const sellerProducts = '/seller/products';
  static const sellerProductNew = '/seller/products/new';
  static String sellerProductNewPath({int? subcategoryId}) {
    if (subcategoryId == null) return sellerProductNew;
    return '$sellerProductNew?subcategoryId=$subcategoryId';
  }
  static const sellerProductPreview = '/seller/products/preview';
  static const sellerProductEdit = '/seller/products/:productId/edit';
  static String sellerProductEditPath(int productId) =>
      '/seller/products/$productId/edit';
  static const technicianOnboarding = '/technician/onboarding';
  static const technicianActivateLocation = '/technician/activate-location';
  static const technicianVerification = '/technician/verification';
  static const technicianCertification = '/technician/certification';
  static const technicianDocuments = '/technician/documents';
  static const technicianWorkPortfolio = '/technician/portfolio';
  static const technicianFeaturedProjects = '/technician/featured-projects';
  static const becomeTechnician = '/technician/become';
  static const technicianServiceArea = '/technician/service-area';
  static const technicianServiceAreaMap = '/technician/service-area/map';
  static const technicianPerformance = '/technician/performance';
  static const technicianContactLeads = '/technician/contacts';
  static const forgotPassword = '/forgot-password';
  static const forgotPasswordVerify = '/forgot-password/verify';
  static const forgotPasswordNew = '/forgot-password/new';
  static const home = '/';
  static const panel = '/panel';
  static const globalSearch = '/search';
  static const globalSearchResults = '/search/results';
  static String globalSearchResultsPath(String query) =>
      '$globalSearchResults?q=${Uri.encodeComponent(query)}';
  static const technicians = '/technicians';
  static const professionalsBrowse = '/professionals';
  static String professionalsBrowsePath({int? subcategoryId}) {
    if (subcategoryId == null) return professionalsBrowse;
    return '$professionalsBrowse?subcategoryId=$subcategoryId';
  }
  static const productsBrowse = '/products';
  static const productOffers = '/products/offers';
  static String productsBrowsePath({int? subcategoryId}) {
    if (subcategoryId == null) return productsBrowse;
    return '$productsBrowse?subcategoryId=$subcategoryId';
  }
  static String technicianDetailPath(
    int userId, {
    int? subcategoryId,
    int? subSubCategoryId,
  }) {
    final base = '/technicians/$userId';
    final params = <String, String>{
      if (subcategoryId != null) 'subcategoryId': '$subcategoryId',
      if (subSubCategoryId != null) 'subSubCategoryId': '$subSubCategoryId',
    };
    if (params.isEmpty) return base;
    return Uri(path: base, queryParameters: params).toString();
  }
  static const technicianServiceDetail =
      '/technicians/:userId/services/:subSubCategoryId';
  static String technicianServiceDetailPath(
    int userId,
    int subSubCategoryId,
  ) => '/technicians/$userId/services/$subSubCategoryId';

  static const technicianServiceMaterials =
      '/technicians/:userId/services/:subSubCategoryId/materials';
  static String technicianServiceMaterialsPath(
    int userId,
    int subSubCategoryId, {
    String? title,
  }) {
    final path = '/technicians/$userId/services/$subSubCategoryId/materials';
    final trimmed = title?.trim();
    if (trimmed == null || trimmed.isEmpty) return path;
    return Uri(path: path, queryParameters: {'title': trimmed}).toString();
  }

  static const technicianServiceCatalog =
      '/technicians/:userId/services/:subSubCategoryId/catalog';
  static String technicianServiceCatalogPath(
    int userId,
    int subSubCategoryId,
  ) => '/technicians/$userId/services/$subSubCategoryId/catalog';
  static const technicianFeaturedProjectDetail =
      '/technicians/:userId/projects/:projectId';
  static String technicianFeaturedProjectPath(int userId, int projectId) =>
      '/technicians/$userId/projects/$projectId';
  static String productDetailPath(int productId) => '/products/$productId';
  static const sellerCatalog = '/sellers/:sellerId/catalog';
  static String sellerCatalogPath(
    int sellerId, {
    int? currentProductId,
  }) {
    final base = '/sellers/$sellerId/catalog';
    if (currentProductId == null) return base;
    return '$base?currentProductId=$currentProductId';
  }
  static const exploreSubcategories = '/explore/categories/:categoryId';
  static String exploreSubcategoriesPath(int categoryId, {String? title}) {
    final base = '/explore/categories/$categoryId';
    if (title == null || title.isEmpty) return base;
    return '$base?title=${Uri.encodeComponent(title)}';
  }
  static const technicianDetail = '/technicians/:userId';
  static const productDetail = '/products/:productId';
  static const myProfile = '/profile';
  static const clientSettings = '/settings/client';
  static const clientEditProfile = '/settings/client/profile';
  static const myApplication = '/application';
  static const categories = '/admin/categories';
  static const subcategories = '/admin/categories/:categoryId/subcategories';
  static const subSubCategories =
      '/admin/categories/:categoryId/subcategories/:subcategoryId/sub-subcategories';
  static const adminApplications = '/admin/applications';
  static const adminApplicationDetail = '/admin/applications/:userId';
}
