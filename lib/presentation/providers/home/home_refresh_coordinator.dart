import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../categories/active_categories_provider.dart';
import '../categories/home_catalog_provider.dart';
import '../products/home_featured_products_provider.dart';
import '../products/home_product_offers_provider.dart';
import '../technicians/technicians_notifier.dart';
import 'home_content_notifier.dart';

final homeRefreshCoordinatorProvider = Provider<HomeRefreshCoordinator>(
  HomeRefreshCoordinator.new,
);

/// Coordina la frescura del Home sin lanzar solicitudes duplicadas.
///
/// Técnicos y productos cambian con frecuencia. El contenido editorial y el
/// catálogo usan una vigencia mayor porque invalidarlos cuesta varias consultas.
class HomeRefreshCoordinator {
  HomeRefreshCoordinator(this._ref);

  static const dynamicDataTtl = Duration(minutes: 1);
  static const homeContentTtl = Duration(minutes: 15);
  static const catalogTtl = Duration(minutes: 20);

  final Ref _ref;

  Future<void>? _inFlight;
  bool _initialized = false;
  DateTime? _dynamicDataUpdatedAt;
  DateTime? _homeContentUpdatedAt;
  DateTime? _catalogUpdatedAt;

  Future<void> ensureFresh() => _run(force: false);

  Future<void> refreshManually() => _run(force: true);

  Future<void> _run({required bool force}) {
    final current = _inFlight;
    if (current != null) return current;

    late final Future<void> operation;
    operation = _refresh(force: force).whenComplete(() {
      if (identical(_inFlight, operation)) {
        _inFlight = null;
      }
    });
    _inFlight = operation;
    return operation;
  }

  Future<void> _refresh({required bool force}) async {
    final now = DateTime.now();

    // En la primera entrada los widgets ya iniciaron estas consultas. Esperar
    // sus futures comparte la misma petición en vez de invalidarla y repetirla.
    if (!_initialized && !force) {
      _initialized = true;
      await Future.wait([
        _ref.read(homeContentProvider.future),
        _ref.read(homeCatalogSectionsProvider.future),
        _ref.read(homeTechniciansProvider.future),
        _ref.read(homeProductOffersProvider.future),
        _ref.read(homeFeaturedProductsProvider.future),
      ]);
      _dynamicDataUpdatedAt = now;
      _homeContentUpdatedAt = now;
      _catalogUpdatedAt = now;
      return;
    }

    final refreshes = <Future<void>>[];

    if (force || _isStale(_dynamicDataUpdatedAt, dynamicDataTtl, now)) {
      refreshes.add(_refreshDynamicData(now));
    }
    if (force || _isStale(_homeContentUpdatedAt, homeContentTtl, now)) {
      refreshes.add(_refreshHomeContent(now));
    }
    if (force || _isStale(_catalogUpdatedAt, catalogTtl, now)) {
      refreshes.add(_refreshCatalog(now));
    }

    if (refreshes.isNotEmpty) {
      await Future.wait(refreshes);
    }
    _initialized = true;
  }

  bool _isStale(DateTime? updatedAt, Duration ttl, DateTime now) {
    return updatedAt == null || now.difference(updatedAt) >= ttl;
  }

  Future<void> _refreshDynamicData(DateTime now) async {
    await Future.wait([
      _ref.refresh(homeTechniciansProvider.future),
      _ref.refresh(homeProductOffersProvider.future),
      _ref.refresh(homeFeaturedProductsProvider.future),
    ]);
    _dynamicDataUpdatedAt = now;
  }

  Future<void> _refreshHomeContent(DateTime now) async {
    final _ = await _ref.refresh(homeContentProvider.future);
    _homeContentUpdatedAt = now;
  }

  Future<void> _refreshCatalog(DateTime now) async {
    _ref.invalidate(activeCategoriesProvider);
    final _ = await _ref.read(homeCatalogSectionsProvider.future);
    _catalogUpdatedAt = now;
  }
}
