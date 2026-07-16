// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allActiveSubcategoriesHash() =>
    r'df5a288dc797229f15dac55b8d75c3501b5c5827';

/// See also [allActiveSubcategories].
@ProviderFor(allActiveSubcategories)
final allActiveSubcategoriesProvider =
    FutureProvider<List<SubcategoryModel>>.internal(
      allActiveSubcategories,
      name: r'allActiveSubcategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allActiveSubcategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllActiveSubcategoriesRef = FutureProviderRef<List<SubcategoryModel>>;
String _$professionSubcategoriesHash() =>
    r'8342fe4077768190dc2d8a009a48932eec9b5fad';

/// See also [professionSubcategories].
@ProviderFor(professionSubcategories)
final professionSubcategoriesProvider =
    FutureProvider<List<SubcategoryModel>>.internal(
      professionSubcategories,
      name: r'professionSubcategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$professionSubcategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfessionSubcategoriesRef = FutureProviderRef<List<SubcategoryModel>>;
String _$categoriesListHash() => r'11dff610ca8bd742a241ac8c50986d25e5bf6498';

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

abstract class _$CategoriesList
    extends BuildlessAutoDisposeAsyncNotifier<List<CategoryModel>> {
  late final bool includeInactive;

  FutureOr<List<CategoryModel>> build({bool includeInactive = false});
}

/// See also [CategoriesList].
@ProviderFor(CategoriesList)
const categoriesListProvider = CategoriesListFamily();

/// See also [CategoriesList].
class CategoriesListFamily extends Family<AsyncValue<List<CategoryModel>>> {
  /// See also [CategoriesList].
  const CategoriesListFamily();

  /// See also [CategoriesList].
  CategoriesListProvider call({bool includeInactive = false}) {
    return CategoriesListProvider(includeInactive: includeInactive);
  }

  @override
  CategoriesListProvider getProviderOverride(
    covariant CategoriesListProvider provider,
  ) {
    return call(includeInactive: provider.includeInactive);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoriesListProvider';
}

/// See also [CategoriesList].
class CategoriesListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CategoriesList,
          List<CategoryModel>
        > {
  /// See also [CategoriesList].
  CategoriesListProvider({bool includeInactive = false})
    : this._internal(
        () => CategoriesList()..includeInactive = includeInactive,
        from: categoriesListProvider,
        name: r'categoriesListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoriesListHash,
        dependencies: CategoriesListFamily._dependencies,
        allTransitiveDependencies:
            CategoriesListFamily._allTransitiveDependencies,
        includeInactive: includeInactive,
      );

  CategoriesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.includeInactive,
  }) : super.internal();

  final bool includeInactive;

  @override
  FutureOr<List<CategoryModel>> runNotifierBuild(
    covariant CategoriesList notifier,
  ) {
    return notifier.build(includeInactive: includeInactive);
  }

  @override
  Override overrideWith(CategoriesList Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoriesListProvider._internal(
        () => create()..includeInactive = includeInactive,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        includeInactive: includeInactive,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CategoriesList, List<CategoryModel>>
  createElement() {
    return _CategoriesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesListProvider &&
        other.includeInactive == includeInactive;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, includeInactive.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoriesListRef
    on AutoDisposeAsyncNotifierProviderRef<List<CategoryModel>> {
  /// The parameter `includeInactive` of this provider.
  bool get includeInactive;
}

class _CategoriesListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CategoriesList,
          List<CategoryModel>
        >
    with CategoriesListRef {
  _CategoriesListProviderElement(super.provider);

  @override
  bool get includeInactive =>
      (origin as CategoriesListProvider).includeInactive;
}

String _$subcategoriesListHash() => r'bdd78acb6d0b6f70225f3f83375394839c2efd81';

abstract class _$SubcategoriesList
    extends BuildlessAutoDisposeAsyncNotifier<List<SubcategoryModel>> {
  late final int categoryId;

  FutureOr<List<SubcategoryModel>> build(int categoryId);
}

/// See also [SubcategoriesList].
@ProviderFor(SubcategoriesList)
const subcategoriesListProvider = SubcategoriesListFamily();

/// See also [SubcategoriesList].
class SubcategoriesListFamily
    extends Family<AsyncValue<List<SubcategoryModel>>> {
  /// See also [SubcategoriesList].
  const SubcategoriesListFamily();

  /// See also [SubcategoriesList].
  SubcategoriesListProvider call(int categoryId) {
    return SubcategoriesListProvider(categoryId);
  }

  @override
  SubcategoriesListProvider getProviderOverride(
    covariant SubcategoriesListProvider provider,
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
  String? get name => r'subcategoriesListProvider';
}

/// See also [SubcategoriesList].
class SubcategoriesListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SubcategoriesList,
          List<SubcategoryModel>
        > {
  /// See also [SubcategoriesList].
  SubcategoriesListProvider(int categoryId)
    : this._internal(
        () => SubcategoriesList()..categoryId = categoryId,
        from: subcategoriesListProvider,
        name: r'subcategoriesListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subcategoriesListHash,
        dependencies: SubcategoriesListFamily._dependencies,
        allTransitiveDependencies:
            SubcategoriesListFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  SubcategoriesListProvider._internal(
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
  FutureOr<List<SubcategoryModel>> runNotifierBuild(
    covariant SubcategoriesList notifier,
  ) {
    return notifier.build(categoryId);
  }

  @override
  Override overrideWith(SubcategoriesList Function() create) {
    return ProviderOverride(
      origin: this,
      override: SubcategoriesListProvider._internal(
        () => create()..categoryId = categoryId,
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
  AutoDisposeAsyncNotifierProviderElement<
    SubcategoriesList,
    List<SubcategoryModel>
  >
  createElement() {
    return _SubcategoriesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubcategoriesListProvider && other.categoryId == categoryId;
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
mixin SubcategoriesListRef
    on AutoDisposeAsyncNotifierProviderRef<List<SubcategoryModel>> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _SubcategoriesListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SubcategoriesList,
          List<SubcategoryModel>
        >
    with SubcategoriesListRef {
  _SubcategoriesListProviderElement(super.provider);

  @override
  int get categoryId => (origin as SubcategoriesListProvider).categoryId;
}

String _$subSubCategoriesListHash() =>
    r'18a482d6233f2b7f238301ecc8e553f0ace2ec5b';

abstract class _$SubSubCategoriesList
    extends BuildlessAutoDisposeAsyncNotifier<List<SubSubCategoryModel>> {
  late final int subcategoryId;

  FutureOr<List<SubSubCategoryModel>> build(int subcategoryId);
}

/// See also [SubSubCategoriesList].
@ProviderFor(SubSubCategoriesList)
const subSubCategoriesListProvider = SubSubCategoriesListFamily();

/// See also [SubSubCategoriesList].
class SubSubCategoriesListFamily
    extends Family<AsyncValue<List<SubSubCategoryModel>>> {
  /// See also [SubSubCategoriesList].
  const SubSubCategoriesListFamily();

  /// See also [SubSubCategoriesList].
  SubSubCategoriesListProvider call(int subcategoryId) {
    return SubSubCategoriesListProvider(subcategoryId);
  }

  @override
  SubSubCategoriesListProvider getProviderOverride(
    covariant SubSubCategoriesListProvider provider,
  ) {
    return call(provider.subcategoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subSubCategoriesListProvider';
}

/// See also [SubSubCategoriesList].
class SubSubCategoriesListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SubSubCategoriesList,
          List<SubSubCategoryModel>
        > {
  /// See also [SubSubCategoriesList].
  SubSubCategoriesListProvider(int subcategoryId)
    : this._internal(
        () => SubSubCategoriesList()..subcategoryId = subcategoryId,
        from: subSubCategoriesListProvider,
        name: r'subSubCategoriesListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subSubCategoriesListHash,
        dependencies: SubSubCategoriesListFamily._dependencies,
        allTransitiveDependencies:
            SubSubCategoriesListFamily._allTransitiveDependencies,
        subcategoryId: subcategoryId,
      );

  SubSubCategoriesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subcategoryId,
  }) : super.internal();

  final int subcategoryId;

  @override
  FutureOr<List<SubSubCategoryModel>> runNotifierBuild(
    covariant SubSubCategoriesList notifier,
  ) {
    return notifier.build(subcategoryId);
  }

  @override
  Override overrideWith(SubSubCategoriesList Function() create) {
    return ProviderOverride(
      origin: this,
      override: SubSubCategoriesListProvider._internal(
        () => create()..subcategoryId = subcategoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subcategoryId: subcategoryId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    SubSubCategoriesList,
    List<SubSubCategoryModel>
  >
  createElement() {
    return _SubSubCategoriesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubSubCategoriesListProvider &&
        other.subcategoryId == subcategoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subcategoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubSubCategoriesListRef
    on AutoDisposeAsyncNotifierProviderRef<List<SubSubCategoryModel>> {
  /// The parameter `subcategoryId` of this provider.
  int get subcategoryId;
}

class _SubSubCategoriesListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SubSubCategoriesList,
          List<SubSubCategoryModel>
        >
    with SubSubCategoriesListRef {
  _SubSubCategoriesListProviderElement(super.provider);

  @override
  int get subcategoryId =>
      (origin as SubSubCategoriesListProvider).subcategoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
