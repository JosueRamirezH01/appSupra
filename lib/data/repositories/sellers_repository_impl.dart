import '../../domain/repositories/sellers_repository.dart';
import '../datasources/sellers_remote_datasource.dart';
import '../models/sellers/product_model.dart';
import '../models/sellers/seller_model.dart';

class SellersRepositoryImpl implements SellersRepository {
  SellersRepositoryImpl(this._remote);

  final SellersRemoteDataSource _remote;

  @override
  Future<ProductsListResult> listProducts(ProductsQuery query) {
    return _remote.listProducts(query);
  }

  @override
  Future<RelatedProductsResult> listRelatedProducts(RelatedProductsQuery query) {
    return _remote.listRelatedProducts(query);
  }

  @override
  Future<RelatedProductsResult> listRelatedProductsBySubSub(
    RelatedProductsBySubSubQuery query,
  ) {
    return _remote.listRelatedProductsBySubSub(query);
  }

  @override
  Future<ProductOffersResult> listProductOffers(ProductOffersQuery query) {
    return _remote.listProductOffers(query);
  }

  @override
  Future<List<ProductPublicModel>> listHomeFeaturedProducts({
    double? lat,
    double? lng,
    int? radiusKm,
  }) {
    return _remote.listHomeFeaturedProducts(
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
    );
  }

  @override
  Future<ProductPublicModel> getProduct(int productId) {
    return _remote.getProduct(productId);
  }

  @override
  Future<SellerPublicModel> getSeller(int userId) {
    return _remote.getSeller(userId);
  }

  @override
  Future<SellerApplicationModel> getMyApplication() {
    return _remote.getMyApplication();
  }

  @override
  Future<SellerApplicationModel> submitVerification(
    SubmitSellerVerificationRequest request,
  ) {
    return _remote.submitVerification(request);
  }

  Future<SellerApplicationModel> updateProfile(
    UpdateSellerProfileRequest request,
  ) {
    return _remote.updateProfile(request);
  }

  @override
  Future<MyProductsListResult> listMyProducts([MyProductsQuery? query]) {
    return _remote.listMyProducts(query);
  }

  @override
  Future<ProductPublicModel> getMyProduct(int productId) {
    return _remote.getMyProduct(productId);
  }

  @override
  Future<ProductPublicModel> createProduct(CreateProductRequest request) {
    return _remote.createProduct(request);
  }

  @override
  Future<ProductPublicModel> updateProduct(
    int productId,
    UpdateProductRequest request,
  ) {
    return _remote.updateProduct(productId, request);
  }

  @override
  Future<ProductPublicModel> pauseProduct(int productId) {
    return _remote.pauseProduct(productId);
  }

  @override
  Future<SellerContactLeadResult> submitContactLead({
    required int sellerUserId,
    required SubmitSellerContactRequest request,
  }) {
    return _remote.submitContactLead(
      sellerUserId: sellerUserId,
      request: request,
    );
  }
}
