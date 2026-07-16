import '../../data/models/sellers/product_model.dart';
import '../../data/models/sellers/seller_model.dart';

abstract class SellersRepository {
  Future<ProductsListResult> listProducts(ProductsQuery query);
  Future<ProductPublicModel> getProduct(int productId);
  Future<SellerPublicModel> getSeller(int userId);
  Future<SellerApplicationModel> getMyApplication();
  Future<SellerApplicationModel> submitVerification(
    SubmitSellerVerificationRequest request,
  );
  Future<SellerApplicationModel> updateProfile(
    UpdateSellerProfileRequest request,
  );
  Future<List<ProductPublicModel>> listMyProducts();
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
