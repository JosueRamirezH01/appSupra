// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technicians_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$technicianDetailHash() => r'052605a1cbbab1fc7a25fef0a8265b9ba63cafa0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [technicianDetail].
@ProviderFor(technicianDetail)
const technicianDetailProvider = TechnicianDetailFamily();

/// See also [technicianDetail].
class TechnicianDetailFamily extends Family<AsyncValue<TechnicianPublicModel>> {
  /// See also [technicianDetail].
  const TechnicianDetailFamily();

  /// See also [technicianDetail].
  TechnicianDetailProvider call(int userId) {
    return TechnicianDetailProvider(userId);
  }

  @override
  TechnicianDetailProvider getProviderOverride(
    covariant TechnicianDetailProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'technicianDetailProvider';
}

/// See also [technicianDetail].
class TechnicianDetailProvider
    extends AutoDisposeFutureProvider<TechnicianPublicModel> {
  /// See also [technicianDetail].
  TechnicianDetailProvider(int userId)
    : this._internal(
        (ref) => technicianDetail(ref as TechnicianDetailRef, userId),
        from: technicianDetailProvider,
        name: r'technicianDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$technicianDetailHash,
        dependencies: TechnicianDetailFamily._dependencies,
        allTransitiveDependencies:
            TechnicianDetailFamily._allTransitiveDependencies,
        userId: userId,
      );

  TechnicianDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<TechnicianPublicModel> Function(TechnicianDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TechnicianDetailProvider._internal(
        (ref) => create(ref as TechnicianDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TechnicianPublicModel> createElement() {
    return _TechnicianDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianDetailProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TechnicianDetailRef
    on AutoDisposeFutureProviderRef<TechnicianPublicModel> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _TechnicianDetailProviderElement
    extends AutoDisposeFutureProviderElement<TechnicianPublicModel>
    with TechnicianDetailRef {
  _TechnicianDetailProviderElement(super.provider);

  @override
  int get userId => (origin as TechnicianDetailProvider).userId;
}

String _$myTechnicianActivityHash() =>
    r'6549d02a198727d11a75b795524ab66f5b43a0cd';

/// See also [myTechnicianActivity].
@ProviderFor(myTechnicianActivity)
final myTechnicianActivityProvider =
    AutoDisposeFutureProvider<TechnicianActivityStatsModel>.internal(
      myTechnicianActivity,
      name: r'myTechnicianActivityProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myTechnicianActivityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyTechnicianActivityRef =
    AutoDisposeFutureProviderRef<TechnicianActivityStatsModel>;
String _$myTechnicianPerformanceHash() =>
    r'a3f2d63627c9715c01f19e6908f7c13921764cca';

/// See also [myTechnicianPerformance].
@ProviderFor(myTechnicianPerformance)
const myTechnicianPerformanceProvider = MyTechnicianPerformanceFamily();

/// See also [myTechnicianPerformance].
class MyTechnicianPerformanceFamily
    extends Family<AsyncValue<TechnicianPerformanceReportModel>> {
  /// See also [myTechnicianPerformance].
  const MyTechnicianPerformanceFamily();

  /// See also [myTechnicianPerformance].
  MyTechnicianPerformanceProvider call(String period) {
    return MyTechnicianPerformanceProvider(period);
  }

  @override
  MyTechnicianPerformanceProvider getProviderOverride(
    covariant MyTechnicianPerformanceProvider provider,
  ) {
    return call(provider.period);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myTechnicianPerformanceProvider';
}

/// See also [myTechnicianPerformance].
class MyTechnicianPerformanceProvider
    extends AutoDisposeFutureProvider<TechnicianPerformanceReportModel> {
  /// See also [myTechnicianPerformance].
  MyTechnicianPerformanceProvider(String period)
    : this._internal(
        (ref) =>
            myTechnicianPerformance(ref as MyTechnicianPerformanceRef, period),
        from: myTechnicianPerformanceProvider,
        name: r'myTechnicianPerformanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$myTechnicianPerformanceHash,
        dependencies: MyTechnicianPerformanceFamily._dependencies,
        allTransitiveDependencies:
            MyTechnicianPerformanceFamily._allTransitiveDependencies,
        period: period,
      );

  MyTechnicianPerformanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
  }) : super.internal();

  final String period;

  @override
  Override overrideWith(
    FutureOr<TechnicianPerformanceReportModel> Function(
      MyTechnicianPerformanceRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyTechnicianPerformanceProvider._internal(
        (ref) => create(ref as MyTechnicianPerformanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TechnicianPerformanceReportModel>
  createElement() {
    return _MyTechnicianPerformanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyTechnicianPerformanceProvider && other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyTechnicianPerformanceRef
    on AutoDisposeFutureProviderRef<TechnicianPerformanceReportModel> {
  /// The parameter `period` of this provider.
  String get period;
}

class _MyTechnicianPerformanceProviderElement
    extends AutoDisposeFutureProviderElement<TechnicianPerformanceReportModel>
    with MyTechnicianPerformanceRef {
  _MyTechnicianPerformanceProviderElement(super.provider);

  @override
  String get period => (origin as MyTechnicianPerformanceProvider).period;
}

String _$myTechnicianContactLeadsHash() =>
    r'939b4415d5d57014da5e67cdc22d2a38f07fa92c';

/// See also [myTechnicianContactLeads].
@ProviderFor(myTechnicianContactLeads)
const myTechnicianContactLeadsProvider = MyTechnicianContactLeadsFamily();

/// See also [myTechnicianContactLeads].
class MyTechnicianContactLeadsFamily
    extends Family<AsyncValue<TechnicianContactLeadsPageModel>> {
  /// See also [myTechnicianContactLeads].
  const MyTechnicianContactLeadsFamily();

  /// See also [myTechnicianContactLeads].
  MyTechnicianContactLeadsProvider call({int page = 1, int limit = 5}) {
    return MyTechnicianContactLeadsProvider(page: page, limit: limit);
  }

  @override
  MyTechnicianContactLeadsProvider getProviderOverride(
    covariant MyTechnicianContactLeadsProvider provider,
  ) {
    return call(page: provider.page, limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myTechnicianContactLeadsProvider';
}

/// See also [myTechnicianContactLeads].
class MyTechnicianContactLeadsProvider
    extends AutoDisposeFutureProvider<TechnicianContactLeadsPageModel> {
  /// See also [myTechnicianContactLeads].
  MyTechnicianContactLeadsProvider({int page = 1, int limit = 5})
    : this._internal(
        (ref) => myTechnicianContactLeads(
          ref as MyTechnicianContactLeadsRef,
          page: page,
          limit: limit,
        ),
        from: myTechnicianContactLeadsProvider,
        name: r'myTechnicianContactLeadsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$myTechnicianContactLeadsHash,
        dependencies: MyTechnicianContactLeadsFamily._dependencies,
        allTransitiveDependencies:
            MyTechnicianContactLeadsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  MyTechnicianContactLeadsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<TechnicianContactLeadsPageModel> Function(
      MyTechnicianContactLeadsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyTechnicianContactLeadsProvider._internal(
        (ref) => create(ref as MyTechnicianContactLeadsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TechnicianContactLeadsPageModel>
  createElement() {
    return _MyTechnicianContactLeadsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyTechnicianContactLeadsProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyTechnicianContactLeadsRef
    on AutoDisposeFutureProviderRef<TechnicianContactLeadsPageModel> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _MyTechnicianContactLeadsProviderElement
    extends AutoDisposeFutureProviderElement<TechnicianContactLeadsPageModel>
    with MyTechnicianContactLeadsRef {
  _MyTechnicianContactLeadsProviderElement(super.provider);

  @override
  int get page => (origin as MyTechnicianContactLeadsProvider).page;
  @override
  int get limit => (origin as MyTechnicianContactLeadsProvider).limit;
}

String _$adminApplicationDetailHash() =>
    r'389aa1e8d338ba050da705c6be9fecf0b8c199e5';

/// See also [adminApplicationDetail].
@ProviderFor(adminApplicationDetail)
const adminApplicationDetailProvider = AdminApplicationDetailFamily();

/// See also [adminApplicationDetail].
class AdminApplicationDetailFamily
    extends Family<AsyncValue<TechnicianApplicationModel>> {
  /// See also [adminApplicationDetail].
  const AdminApplicationDetailFamily();

  /// See also [adminApplicationDetail].
  AdminApplicationDetailProvider call(int userId) {
    return AdminApplicationDetailProvider(userId);
  }

  @override
  AdminApplicationDetailProvider getProviderOverride(
    covariant AdminApplicationDetailProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adminApplicationDetailProvider';
}

/// See also [adminApplicationDetail].
class AdminApplicationDetailProvider
    extends AutoDisposeFutureProvider<TechnicianApplicationModel> {
  /// See also [adminApplicationDetail].
  AdminApplicationDetailProvider(int userId)
    : this._internal(
        (ref) =>
            adminApplicationDetail(ref as AdminApplicationDetailRef, userId),
        from: adminApplicationDetailProvider,
        name: r'adminApplicationDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$adminApplicationDetailHash,
        dependencies: AdminApplicationDetailFamily._dependencies,
        allTransitiveDependencies:
            AdminApplicationDetailFamily._allTransitiveDependencies,
        userId: userId,
      );

  AdminApplicationDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<TechnicianApplicationModel> Function(
      AdminApplicationDetailRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminApplicationDetailProvider._internal(
        (ref) => create(ref as AdminApplicationDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TechnicianApplicationModel> createElement() {
    return _AdminApplicationDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminApplicationDetailProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdminApplicationDetailRef
    on AutoDisposeFutureProviderRef<TechnicianApplicationModel> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _AdminApplicationDetailProviderElement
    extends AutoDisposeFutureProviderElement<TechnicianApplicationModel>
    with AdminApplicationDetailRef {
  _AdminApplicationDetailProviderElement(super.provider);

  @override
  int get userId => (origin as AdminApplicationDetailProvider).userId;
}

String _$techniciansListHash() => r'd62835a8f9af32805d5ea1d9ffadafdb085accea';

/// See also [TechniciansList].
@ProviderFor(TechniciansList)
final techniciansListProvider =
    AutoDisposeAsyncNotifierProvider<
      TechniciansList,
      ({List<TechnicianPublicModel> technicians, PaginationModel pagination})
    >.internal(
      TechniciansList.new,
      name: r'techniciansListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$techniciansListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TechniciansList =
    AutoDisposeAsyncNotifier<
      ({List<TechnicianPublicModel> technicians, PaginationModel pagination})
    >;
String _$myTechnicianProfileHash() =>
    r'98710acc994fb67b2577b79fde18682b9b9adbd8';

/// See also [MyTechnicianProfile].
@ProviderFor(MyTechnicianProfile)
final myTechnicianProfileProvider =
    AutoDisposeAsyncNotifierProvider<
      MyTechnicianProfile,
      TechnicianApplicationModel
    >.internal(
      MyTechnicianProfile.new,
      name: r'myTechnicianProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myTechnicianProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MyTechnicianProfile =
    AutoDisposeAsyncNotifier<TechnicianApplicationModel>;
String _$myTechnicianApplicationHash() =>
    r'eec725d5f17b0159a62d056e0d4591e9961b941a';

/// See also [MyTechnicianApplication].
@ProviderFor(MyTechnicianApplication)
final myTechnicianApplicationProvider =
    AutoDisposeAsyncNotifierProvider<
      MyTechnicianApplication,
      TechnicianApplicationModel
    >.internal(
      MyTechnicianApplication.new,
      name: r'myTechnicianApplicationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myTechnicianApplicationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MyTechnicianApplication =
    AutoDisposeAsyncNotifier<TechnicianApplicationModel>;
String _$adminApplicationsHash() => r'd3d5b19413010e946bff6bb0d370f9d58ef07db5';

/// See also [AdminApplications].
@ProviderFor(AdminApplications)
final adminApplicationsProvider =
    AutoDisposeAsyncNotifierProvider<
      AdminApplications,
      List<TechnicianApplicationModel>
    >.internal(
      AdminApplications.new,
      name: r'adminApplicationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminApplicationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdminApplications =
    AutoDisposeAsyncNotifier<List<TechnicianApplicationModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
