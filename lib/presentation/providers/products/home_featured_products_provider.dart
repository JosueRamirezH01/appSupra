import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/sellers/product_model.dart';
import '../location/client_location_provider.dart';
import '../repository_providers.dart';

/// Isla del home: hasta 6 productos (membresía + estrella, relleno orgánico).
final homeFeaturedProductsProvider =
    FutureProvider.autoDispose<List<ProductPublicModel>>((ref) async {
  final clientLocation = await ref.watch(activeClientLocationProvider.future);
  return ref.read(sellersRepositoryProvider).listHomeFeaturedProducts(
        lat: clientLocation?.lat,
        lng: clientLocation?.lng,
        radiusKm: clientLocation?.radiusKm ?? 15,
      );
});
