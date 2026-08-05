// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professionals_browse_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$professionCategoryIdHash() =>
    r'1a5acada4c43ab75377c4f167d1a6c80ca069a77';

/// See also [professionCategoryId].
@ProviderFor(professionCategoryId)
final professionCategoryIdProvider = FutureProvider<int?>.internal(
  professionCategoryId,
  name: r'professionCategoryIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$professionCategoryIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfessionCategoryIdRef = FutureProviderRef<int?>;
String _$professionBrowseSubcategoriesHash() =>
    r'e5058392cb9cc1db3de40a08222bfec3b6124178';

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

/// See also [professionBrowseSubcategories].
@ProviderFor(professionBrowseSubcategories)
const professionBrowseSubcategoriesProvider =
    ProfessionBrowseSubcategoriesFamily();

/// See also [professionBrowseSubcategories].
class ProfessionBrowseSubcategoriesFamily
    extends Family<AsyncValue<List<SubcategoryModel>>> {
  /// See also [professionBrowseSubcategories].
  const ProfessionBrowseSubcategoriesFamily();

  /// See also [professionBrowseSubcategories].
  ProfessionBrowseSubcategoriesProvider call(int categoryId) {
    return ProfessionBrowseSubcategoriesProvider(categoryId);
  }

  @override
  ProfessionBrowseSubcategoriesProvider getProviderOverride(
    covariant ProfessionBrowseSubcategoriesProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'professionBrowseSubcategoriesProvider';
}

/// See also [professionBrowseSubcategories].
class ProfessionBrowseSubcategoriesProvider
    extends AutoDisposeFutureProvider<List<SubcategoryModel>> {
  /// See also [professionBrowseSubcategories].
  ProfessionBrowseSubcategoriesProvider(int categoryId)
    : this._internal(
        (ref) => professionBrowseSubcategories(
          ref as ProfessionBrowseSubcategoriesRef,
          categoryId,
        ),
        from: professionBrowseSubcategoriesProvider,
        name: r'professionBrowseSubcategoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$professionBrowseSubcategoriesHash,
        dependencies: ProfessionBrowseSubcategoriesFamily._dependencies,
        allTransitiveDependencies:
            ProfessionBrowseSubcategoriesFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  ProfessionBrowseSubcategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  Override overrideWith(
    FutureOr<List<SubcategoryModel>> Function(
      ProfessionBrowseSubcategoriesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfessionBrowseSubcategoriesProvider._internal(
        (ref) => create(ref as ProfessionBrowseSubcategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SubcategoryModel>> createElement() {
    return _ProfessionBrowseSubcategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfessionBrowseSubcategoriesProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfessionBrowseSubcategoriesRef
    on AutoDisposeFutureProviderRef<List<SubcategoryModel>> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _ProfessionBrowseSubcategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<SubcategoryModel>>
    with ProfessionBrowseSubcategoriesRef {
  _ProfessionBrowseSubcategoriesProviderElement(super.provider);

  @override
  int get categoryId =>
      (origin as ProfessionBrowseSubcategoriesProvider).categoryId;
}

String _$professionalsBrowseControllerHash() =>
    r'a8e709b515d7e9f1352ce5456f7e07c92e542784';

abstract class _$ProfessionalsBrowseController
    extends BuildlessAutoDisposeAsyncNotifier<ProfessionalsBrowseViewState> {
  late final int categoryId;
  late final int? initialSubcategoryId;

  FutureOr<ProfessionalsBrowseViewState> build(
    int categoryId, {
    int? initialSubcategoryId,
  });
}

/// See also [ProfessionalsBrowseController].
@ProviderFor(ProfessionalsBrowseController)
const professionalsBrowseControllerProvider =
    ProfessionalsBrowseControllerFamily();

/// See also [ProfessionalsBrowseController].
class ProfessionalsBrowseControllerFamily
    extends Family<AsyncValue<ProfessionalsBrowseViewState>> {
  /// See also [ProfessionalsBrowseController].
  const ProfessionalsBrowseControllerFamily();

  /// See also [ProfessionalsBrowseController].
  ProfessionalsBrowseControllerProvider call(
    int categoryId, {
    int? initialSubcategoryId,
  }) {
    return ProfessionalsBrowseControllerProvider(
      categoryId,
      initialSubcategoryId: initialSubcategoryId,
    );
  }

  @override
  ProfessionalsBrowseControllerProvider getProviderOverride(
    covariant ProfessionalsBrowseControllerProvider provider,
  ) {
    return call(
      provider.categoryId,
      initialSubcategoryId: provider.initialSubcategoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'professionalsBrowseControllerProvider';
}

/// See also [ProfessionalsBrowseController].
class ProfessionalsBrowseControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProfessionalsBrowseController,
          ProfessionalsBrowseViewState
        > {
  /// See also [ProfessionalsBrowseController].
  ProfessionalsBrowseControllerProvider(
    int categoryId, {
    int? initialSubcategoryId,
  }) : this._internal(
         () => ProfessionalsBrowseController()
           ..categoryId = categoryId
           ..initialSubcategoryId = initialSubcategoryId,
         from: professionalsBrowseControllerProvider,
         name: r'professionalsBrowseControllerProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$professionalsBrowseControllerHash,
         dependencies: ProfessionalsBrowseControllerFamily._dependencies,
         allTransitiveDependencies:
             ProfessionalsBrowseControllerFamily._allTransitiveDependencies,
         categoryId: categoryId,
         initialSubcategoryId: initialSubcategoryId,
       );

  ProfessionalsBrowseControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.initialSubcategoryId,
  }) : super.internal();

  final int categoryId;
  final int? initialSubcategoryId;

  @override
  FutureOr<ProfessionalsBrowseViewState> runNotifierBuild(
    covariant ProfessionalsBrowseController notifier,
  ) {
    return notifier.build(
      categoryId,
      initialSubcategoryId: initialSubcategoryId,
    );
  }

  @override
  Override overrideWith(ProfessionalsBrowseController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfessionalsBrowseControllerProvider._internal(
        () => create()
          ..categoryId = categoryId
          ..initialSubcategoryId = initialSubcategoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        initialSubcategoryId: initialSubcategoryId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ProfessionalsBrowseController,
    ProfessionalsBrowseViewState
  >
  createElement() {
    return _ProfessionalsBrowseControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfessionalsBrowseControllerProvider &&
        other.categoryId == categoryId &&
        other.initialSubcategoryId == initialSubcategoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, initialSubcategoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfessionalsBrowseControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ProfessionalsBrowseViewState> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;

  /// The parameter `initialSubcategoryId` of this provider.
  int? get initialSubcategoryId;
}

class _ProfessionalsBrowseControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProfessionalsBrowseController,
          ProfessionalsBrowseViewState
        >
    with ProfessionalsBrowseControllerRef {
  _ProfessionalsBrowseControllerProviderElement(super.provider);

  @override
  int get categoryId =>
      (origin as ProfessionalsBrowseControllerProvider).categoryId;
  @override
  int? get initialSubcategoryId =>
      (origin as ProfessionalsBrowseControllerProvider).initialSubcategoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
