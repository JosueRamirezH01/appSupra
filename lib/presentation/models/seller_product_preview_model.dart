import 'dart:io';

/// Datos del formulario de producto para mostrar la vista previa del cliente.
class SellerProductPreviewModel {
  const SellerProductPreviewModel({
    required this.title,
    required this.subcategoryName,
    this.description,
    this.price,
    this.compareAtPrice,
    this.materialLabels = const [],
    required this.images,
    required this.sellerBusinessName,
    this.sellerLogoUrl,
    this.sellerVerified = false,
  });

  final String title;
  final String subcategoryName;
  final String? description;
  final double? price;
  final double? compareAtPrice;
  final List<String> materialLabels;
  final List<SellerProductPreviewImage> images;
  final String sellerBusinessName;
  final String? sellerLogoUrl;
  final bool sellerVerified;
}

class SellerProductPreviewImage {
  const SellerProductPreviewImage.network(this.url) : file = null;

  const SellerProductPreviewImage.local(this.file) : url = null;

  final String? url;
  final File? file;
}
