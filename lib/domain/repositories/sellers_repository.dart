import '../../data/models/sellers/product_model.dart';
import '../../data/models/sellers/seller_model.dart';

abstract class SellersRepository {
  Future<ProductsListResult> listProducts(ProductsQuery query);
  Future<RelatedProductsResult> listRelatedProducts(RelatedProductsQuery query);
  Future<RelatedProductsResult> listRelatedProductsBySubSub(
    RelatedProductsBySubSubQuery query,
  );
  Future<ProductOffersResult> listProductOffers(ProductOffersQuery query);
  Future<List<ProductPublicModel>> listHomeFeaturedProducts({
    double? lat,
    double? lng,
    int? radiusKm,
  });
  Future<ProductPublicModel> getProduct(int productId);
  Future<SellerPublicModel> getSeller(int userId);
  Future<SellerApplicationModel> getMyApplication();
  Future<SellerApplicationModel> submitVerification(
    SubmitSellerVerificationRequest request,
  );
  Future<SellerApplicationModel> updateProfile(
    UpdateSellerProfileRequest request,
  );
  Future<MyProductsListResult> listMyProducts([MyProductsQuery? query]);
  Future<ProductPublicModel> getMyProduct(int productId);
  Future<ProductPublicModel> createProduct(CreateProductRequest request);
  Future<ProductPublicModel> updateProduct(
    int productId,
    UpdateProductRequest request,
  );
  Future<ProductPublicModel> pauseProduct(int productId);
  Future<SellerContactLeadResult> submitContactLead({
    required int sellerUserId,
    required SubmitSellerContactRequest request,
  });
}
