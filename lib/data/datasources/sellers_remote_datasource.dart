import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/common/pagination_model.dart';
import '../models/sellers/product_model.dart';
import '../models/sellers/seller_model.dart';

class SellersRemoteDataSource {
  SellersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProductsListResult> listProducts(ProductsQuery query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.sellerProducts,
      queryParameters: {
        'page': query.page,
        'limit': query.limit,
        if (query.search != null && query.search!.isNotEmpty)
          'search': query.search,
        if (query.categoryId != null) 'categoryId': query.categoryId,
        if (query.subcategoryId != null) 'subcategoryId': query.subcategoryId,
        if (query.sellerId != null) 'sellerId': query.sellerId,
        if (query.lat != null && query.lng != null) ...{
          'lat': query.lat,
          'lng': query.lng,
          'radiusKm': query.radiusKm ?? 15,
        },
      },
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) throw AppException.unknown('Respuesta inválida');

    final products = (data['products'] as List<dynamic>)
        .map((e) => ProductPublicModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>,
    );
    final searchSuggestions =
        (data['searchSuggestions'] as List<dynamic>? ?? [])
            .map(
              (e) => ProductSearchSuggestionModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();

    return ProductsListResult(
      products: products,
      pagination: pagination,
      searchSuggestions: searchSuggestions,
    );
  }

  Future<ProductPublicModel> getProduct(int productId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.sellerProduct(productId),
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final product = data?['product'] as Map<String, dynamic>?;
    if (product == null) throw AppException.unknown('Producto no encontrado');
    return ProductPublicModel.fromJson(product);
  }

  Future<SellerPublicModel> getSeller(int userId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.seller(userId),
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final seller = data?['seller'] as Map<String, dynamic>?;
    if (seller == null) throw AppException.unknown('Vendedor no encontrado');
    return SellerPublicModel.fromJson(seller);
  }

  Future<SellerApplicationModel> getMyApplication() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.sellerApplicationMe,
    );
    return _parseApplication(response.data);
  }

  Future<SellerApplicationModel> submitVerification(
    SubmitSellerVerificationRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.sellerVerificationMe,
      data: request.toJson(),
    );
    return _parseApplication(response.data);
  }

  Future<SellerApplicationModel> updateProfile(
    UpdateSellerProfileRequest request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.sellerProfileMe,
      data: request.toJson(),
    );
    return _parseApplication(response.data);
  }

  Future<List<ProductPublicModel>> listMyProducts() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.sellerMyProducts,
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    return (data?['products'] as List<dynamic>? ?? [])
        .map((e) => ProductPublicModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductPublicModel> createProduct(CreateProductRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.sellerMyProducts,
      data: request.toJson(),
    );
    return _parseProduct(response.data);
  }

  Future<ProductPublicModel> updateProduct(
    int productId,
    UpdateProductRequest request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.sellerMyProduct(productId),
      data: request.toJson(),
    );
    return _parseProduct(response.data);
  }

  Future<ProductPublicModel> pauseProduct(int productId) async {
    return updateProduct(
      productId,
      const UpdateProductRequest(status: 'pausado'),
    );
  }

  Future<SellerContactLeadResult> submitContactLead({
    required int sellerUserId,
    required SubmitSellerContactRequest request,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.sellerContacts(sellerUserId),
      data: request.toJson(),
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final contact = data?['contact'] as Map<String, dynamic>?;
    if (contact == null) {
      throw AppException.unknown('No se pudo registrar el contacto');
    }
    return SellerContactLeadResult.fromJson(contact);
  }

  SellerApplicationModel _parseApplication(Map<String, dynamic>? json) {
    final data = json?['data'] as Map<String, dynamic>?;
    final application = data?['application'] as Map<String, dynamic>?;
    if (application == null) {
      throw AppException.unknown('Solicitud no disponible');
    }
    return SellerApplicationModel.fromJson(application);
  }

  ProductPublicModel _parseProduct(Map<String, dynamic>? json) {
    final data = json?['data'] as Map<String, dynamic>?;
    final product = data?['product'] as Map<String, dynamic>?;
    if (product == null) throw AppException.unknown('Producto no disponible');
    return ProductPublicModel.fromJson(product);
  }
}
