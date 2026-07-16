import 'dart:io';

sealed class ProductClientImageSource {
  const ProductClientImageSource();

  factory ProductClientImageSource.network(String url) =
      ProductClientNetworkImage;

  factory ProductClientImageSource.local(File file) = ProductClientLocalImage;
}

class ProductClientNetworkImage extends ProductClientImageSource {
  const ProductClientNetworkImage(this.url);

  final String url;
}

class ProductClientLocalImage extends ProductClientImageSource {
  const ProductClientLocalImage(this.file);

  final File file;
}
