// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return _CategoryModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
    CategoryModel value,
    $Res Function(CategoryModel) then,
  ) = _$CategoryModelCopyWithImpl<$Res, CategoryModel>;
  @useResult
  $Res call({
    int id,
    String name,
    bool status,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res, $Val extends CategoryModel>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as bool,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryModelImplCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$$CategoryModelImplCopyWith(
    _$CategoryModelImpl value,
    $Res Function(_$CategoryModelImpl) then,
  ) = __$$CategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    bool status,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CategoryModelImplCopyWithImpl<$Res>
    extends _$CategoryModelCopyWithImpl<$Res, _$CategoryModelImpl>
    implements _$$CategoryModelImplCopyWith<$Res> {
  __$$CategoryModelImplCopyWithImpl(
    _$CategoryModelImpl _value,
    $Res Function(_$CategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryModelImpl implements _CategoryModel {
  const _$CategoryModelImpl({
    required this.id,
    required this.name,
    this.status = true,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory _$CategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey()
  final bool status;
  @override
  final String? imageUrl;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, status: $status, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    status,
    imageUrl,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      __$$CategoryModelImplCopyWithImpl<_$CategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryModelImplToJson(this);
  }
}

abstract class _CategoryModel implements CategoryModel {
  const factory _CategoryModel({
    required final int id,
    required final String name,
    final bool status,
    final String? imageUrl,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CategoryModelImpl;

  factory _CategoryModel.fromJson(Map<String, dynamic> json) =
      _$CategoryModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  bool get status;
  @override
  String? get imageUrl;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubcategoryModel _$SubcategoryModelFromJson(Map<String, dynamic> json) {
  return _SubcategoryModel.fromJson(json);
}

/// @nodoc
mixin _$SubcategoryModel {
  int get id => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get suggestions => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SubcategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubcategoryModelCopyWith<SubcategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubcategoryModelCopyWith<$Res> {
  factory $SubcategoryModelCopyWith(
    SubcategoryModel value,
    $Res Function(SubcategoryModel) then,
  ) = _$SubcategoryModelCopyWithImpl<$Res, SubcategoryModel>;
  @useResult
  $Res call({
    int id,
    int categoryId,
    String name,
    bool status,
    String? imageUrl,
    List<String> suggestions,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$SubcategoryModelCopyWithImpl<$Res, $Val extends SubcategoryModel>
    implements $SubcategoryModelCopyWith<$Res> {
  _$SubcategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? name = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? suggestions = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as bool,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            suggestions: null == suggestions
                ? _value.suggestions
                : suggestions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubcategoryModelImplCopyWith<$Res>
    implements $SubcategoryModelCopyWith<$Res> {
  factory _$$SubcategoryModelImplCopyWith(
    _$SubcategoryModelImpl value,
    $Res Function(_$SubcategoryModelImpl) then,
  ) = __$$SubcategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int categoryId,
    String name,
    bool status,
    String? imageUrl,
    List<String> suggestions,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$SubcategoryModelImplCopyWithImpl<$Res>
    extends _$SubcategoryModelCopyWithImpl<$Res, _$SubcategoryModelImpl>
    implements _$$SubcategoryModelImplCopyWith<$Res> {
  __$$SubcategoryModelImplCopyWithImpl(
    _$SubcategoryModelImpl _value,
    $Res Function(_$SubcategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? name = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? suggestions = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$SubcategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        suggestions: null == suggestions
            ? _value.suggestions
            : suggestions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubcategoryModelImpl implements _SubcategoryModel {
  const _$SubcategoryModelImpl({
    required this.id,
    required this.categoryId,
    required this.name,
    this.status = true,
    this.imageUrl,
    final List<String> suggestions = const [],
    this.createdAt,
    this.updatedAt,
  }) : _suggestions = suggestions;

  factory _$SubcategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubcategoryModelImplFromJson(json);

  @override
  final int id;
  @override
  final int categoryId;
  @override
  final String name;
  @override
  @JsonKey()
  final bool status;
  @override
  final String? imageUrl;
  final List<String> _suggestions;
  @override
  @JsonKey(fromJson: parseProductSubcategorySuggestions)
  List<String> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SubcategoryModel(id: $id, categoryId: $categoryId, name: $name, status: $status, imageUrl: $imageUrl, suggestions: $suggestions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubcategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(
              other._suggestions,
              _suggestions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    categoryId,
    name,
    status,
    imageUrl,
    const DeepCollectionEquality().hash(_suggestions),
    createdAt,
    updatedAt,
  );

  /// Create a copy of SubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubcategoryModelImplCopyWith<_$SubcategoryModelImpl> get copyWith =>
      __$$SubcategoryModelImplCopyWithImpl<_$SubcategoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubcategoryModelImplToJson(this);
  }
}

abstract class _SubcategoryModel implements SubcategoryModel {
  const factory _SubcategoryModel({
    required final int id,
    required final int categoryId,
    required final String name,
    final bool status,
    final String? imageUrl,
    final List<String> suggestions,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$SubcategoryModelImpl;

  factory _SubcategoryModel.fromJson(Map<String, dynamic> json) =
      _$SubcategoryModelImpl.fromJson;

  @override
  int get id;
  @override
  int get categoryId;
  @override
  String get name;
  @override
  bool get status;
  @override
  String? get imageUrl;
  @override
  List<String> get suggestions;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubcategoryModelImplCopyWith<_$SubcategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubSubCategoryModel _$SubSubCategoryModelFromJson(Map<String, dynamic> json) {
  return _SubSubCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$SubSubCategoryModel {
  int get id => throw _privateConstructorUsedError;
  int get subcategoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String get contactMetricType => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SubSubCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubSubCategoryModelCopyWith<SubSubCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubSubCategoryModelCopyWith<$Res> {
  factory $SubSubCategoryModelCopyWith(
    SubSubCategoryModel value,
    $Res Function(SubSubCategoryModel) then,
  ) = _$SubSubCategoryModelCopyWithImpl<$Res, SubSubCategoryModel>;
  @useResult
  $Res call({
    int id,
    int subcategoryId,
    String name,
    bool status,
    String? imageUrl,
    String contactMetricType,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$SubSubCategoryModelCopyWithImpl<$Res, $Val extends SubSubCategoryModel>
    implements $SubSubCategoryModelCopyWith<$Res> {
  _$SubSubCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subcategoryId = null,
    Object? name = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? contactMetricType = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            subcategoryId: null == subcategoryId
                ? _value.subcategoryId
                : subcategoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as bool,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactMetricType: null == contactMetricType
                ? _value.contactMetricType
                : contactMetricType // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubSubCategoryModelImplCopyWith<$Res>
    implements $SubSubCategoryModelCopyWith<$Res> {
  factory _$$SubSubCategoryModelImplCopyWith(
    _$SubSubCategoryModelImpl value,
    $Res Function(_$SubSubCategoryModelImpl) then,
  ) = __$$SubSubCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int subcategoryId,
    String name,
    bool status,
    String? imageUrl,
    String contactMetricType,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$SubSubCategoryModelImplCopyWithImpl<$Res>
    extends _$SubSubCategoryModelCopyWithImpl<$Res, _$SubSubCategoryModelImpl>
    implements _$$SubSubCategoryModelImplCopyWith<$Res> {
  __$$SubSubCategoryModelImplCopyWithImpl(
    _$SubSubCategoryModelImpl _value,
    $Res Function(_$SubSubCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subcategoryId = null,
    Object? name = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? contactMetricType = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$SubSubCategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        subcategoryId: null == subcategoryId
            ? _value.subcategoryId
            : subcategoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactMetricType: null == contactMetricType
            ? _value.contactMetricType
            : contactMetricType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubSubCategoryModelImpl implements _SubSubCategoryModel {
  const _$SubSubCategoryModelImpl({
    required this.id,
    required this.subcategoryId,
    required this.name,
    this.status = true,
    this.imageUrl,
    this.contactMetricType = 'none',
    this.createdAt,
    this.updatedAt,
  });

  factory _$SubSubCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubSubCategoryModelImplFromJson(json);

  @override
  final int id;
  @override
  final int subcategoryId;
  @override
  final String name;
  @override
  @JsonKey()
  final bool status;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final String contactMetricType;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SubSubCategoryModel(id: $id, subcategoryId: $subcategoryId, name: $name, status: $status, imageUrl: $imageUrl, contactMetricType: $contactMetricType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubSubCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.contactMetricType, contactMetricType) ||
                other.contactMetricType == contactMetricType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    subcategoryId,
    name,
    status,
    imageUrl,
    contactMetricType,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubSubCategoryModelImplCopyWith<_$SubSubCategoryModelImpl> get copyWith =>
      __$$SubSubCategoryModelImplCopyWithImpl<_$SubSubCategoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubSubCategoryModelImplToJson(this);
  }
}

abstract class _SubSubCategoryModel implements SubSubCategoryModel {
  const factory _SubSubCategoryModel({
    required final int id,
    required final int subcategoryId,
    required final String name,
    final bool status,
    final String? imageUrl,
    final String contactMetricType,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$SubSubCategoryModelImpl;

  factory _SubSubCategoryModel.fromJson(Map<String, dynamic> json) =
      _$SubSubCategoryModelImpl.fromJson;

  @override
  int get id;
  @override
  int get subcategoryId;
  @override
  String get name;
  @override
  bool get status;
  @override
  String? get imageUrl;
  @override
  String get contactMetricType;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubSubCategoryModelImplCopyWith<_$SubSubCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCategoryRequest _$CreateCategoryRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateCategoryRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateCategoryRequest {
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this CreateCategoryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCategoryRequestCopyWith<CreateCategoryRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCategoryRequestCopyWith<$Res> {
  factory $CreateCategoryRequestCopyWith(
    CreateCategoryRequest value,
    $Res Function(CreateCategoryRequest) then,
  ) = _$CreateCategoryRequestCopyWithImpl<$Res, CreateCategoryRequest>;
  @useResult
  $Res call({String name, String? imageUrl});
}

/// @nodoc
class _$CreateCategoryRequestCopyWithImpl<
  $Res,
  $Val extends CreateCategoryRequest
>
    implements $CreateCategoryRequestCopyWith<$Res> {
  _$CreateCategoryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? imageUrl = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateCategoryRequestImplCopyWith<$Res>
    implements $CreateCategoryRequestCopyWith<$Res> {
  factory _$$CreateCategoryRequestImplCopyWith(
    _$CreateCategoryRequestImpl value,
    $Res Function(_$CreateCategoryRequestImpl) then,
  ) = __$$CreateCategoryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? imageUrl});
}

/// @nodoc
class __$$CreateCategoryRequestImplCopyWithImpl<$Res>
    extends
        _$CreateCategoryRequestCopyWithImpl<$Res, _$CreateCategoryRequestImpl>
    implements _$$CreateCategoryRequestImplCopyWith<$Res> {
  __$$CreateCategoryRequestImplCopyWithImpl(
    _$CreateCategoryRequestImpl _value,
    $Res Function(_$CreateCategoryRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? imageUrl = freezed}) {
    return _then(
      _$CreateCategoryRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCategoryRequestImpl implements _CreateCategoryRequest {
  const _$CreateCategoryRequestImpl({required this.name, this.imageUrl});

  factory _$CreateCategoryRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCategoryRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'CreateCategoryRequest(name: $name, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCategoryRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, imageUrl);

  /// Create a copy of CreateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCategoryRequestImplCopyWith<_$CreateCategoryRequestImpl>
  get copyWith =>
      __$$CreateCategoryRequestImplCopyWithImpl<_$CreateCategoryRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCategoryRequestImplToJson(this);
  }
}

abstract class _CreateCategoryRequest implements CreateCategoryRequest {
  const factory _CreateCategoryRequest({
    required final String name,
    final String? imageUrl,
  }) = _$CreateCategoryRequestImpl;

  factory _CreateCategoryRequest.fromJson(Map<String, dynamic> json) =
      _$CreateCategoryRequestImpl.fromJson;

  @override
  String get name;
  @override
  String? get imageUrl;

  /// Create a copy of CreateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCategoryRequestImplCopyWith<_$CreateCategoryRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UpdateCategoryRequest _$UpdateCategoryRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateCategoryRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateCategoryRequest {
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this UpdateCategoryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCategoryRequestCopyWith<UpdateCategoryRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCategoryRequestCopyWith<$Res> {
  factory $UpdateCategoryRequestCopyWith(
    UpdateCategoryRequest value,
    $Res Function(UpdateCategoryRequest) then,
  ) = _$UpdateCategoryRequestCopyWithImpl<$Res, UpdateCategoryRequest>;
  @useResult
  $Res call({String name, String? imageUrl});
}

/// @nodoc
class _$UpdateCategoryRequestCopyWithImpl<
  $Res,
  $Val extends UpdateCategoryRequest
>
    implements $UpdateCategoryRequestCopyWith<$Res> {
  _$UpdateCategoryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? imageUrl = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateCategoryRequestImplCopyWith<$Res>
    implements $UpdateCategoryRequestCopyWith<$Res> {
  factory _$$UpdateCategoryRequestImplCopyWith(
    _$UpdateCategoryRequestImpl value,
    $Res Function(_$UpdateCategoryRequestImpl) then,
  ) = __$$UpdateCategoryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? imageUrl});
}

/// @nodoc
class __$$UpdateCategoryRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateCategoryRequestCopyWithImpl<$Res, _$UpdateCategoryRequestImpl>
    implements _$$UpdateCategoryRequestImplCopyWith<$Res> {
  __$$UpdateCategoryRequestImplCopyWithImpl(
    _$UpdateCategoryRequestImpl _value,
    $Res Function(_$UpdateCategoryRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? imageUrl = freezed}) {
    return _then(
      _$UpdateCategoryRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCategoryRequestImpl implements _UpdateCategoryRequest {
  const _$UpdateCategoryRequestImpl({required this.name, this.imageUrl});

  factory _$UpdateCategoryRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCategoryRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'UpdateCategoryRequest(name: $name, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCategoryRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, imageUrl);

  /// Create a copy of UpdateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCategoryRequestImplCopyWith<_$UpdateCategoryRequestImpl>
  get copyWith =>
      __$$UpdateCategoryRequestImplCopyWithImpl<_$UpdateCategoryRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCategoryRequestImplToJson(this);
  }
}

abstract class _UpdateCategoryRequest implements UpdateCategoryRequest {
  const factory _UpdateCategoryRequest({
    required final String name,
    final String? imageUrl,
  }) = _$UpdateCategoryRequestImpl;

  factory _UpdateCategoryRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateCategoryRequestImpl.fromJson;

  @override
  String get name;
  @override
  String? get imageUrl;

  /// Create a copy of UpdateCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCategoryRequestImplCopyWith<_$UpdateCategoryRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateSubcategoryRequest _$CreateSubcategoryRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateSubcategoryRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateSubcategoryRequest {
  String get name => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this CreateSubcategoryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateSubcategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSubcategoryRequestCopyWith<CreateSubcategoryRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSubcategoryRequestCopyWith<$Res> {
  factory $CreateSubcategoryRequestCopyWith(
    CreateSubcategoryRequest value,
    $Res Function(CreateSubcategoryRequest) then,
  ) = _$CreateSubcategoryRequestCopyWithImpl<$Res, CreateSubcategoryRequest>;
  @useResult
  $Res call({String name, int categoryId, String? imageUrl});
}

/// @nodoc
class _$CreateSubcategoryRequestCopyWithImpl<
  $Res,
  $Val extends CreateSubcategoryRequest
>
    implements $CreateSubcategoryRequestCopyWith<$Res> {
  _$CreateSubcategoryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSubcategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? categoryId = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateSubcategoryRequestImplCopyWith<$Res>
    implements $CreateSubcategoryRequestCopyWith<$Res> {
  factory _$$CreateSubcategoryRequestImplCopyWith(
    _$CreateSubcategoryRequestImpl value,
    $Res Function(_$CreateSubcategoryRequestImpl) then,
  ) = __$$CreateSubcategoryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int categoryId, String? imageUrl});
}

/// @nodoc
class __$$CreateSubcategoryRequestImplCopyWithImpl<$Res>
    extends
        _$CreateSubcategoryRequestCopyWithImpl<
          $Res,
          _$CreateSubcategoryRequestImpl
        >
    implements _$$CreateSubcategoryRequestImplCopyWith<$Res> {
  __$$CreateSubcategoryRequestImplCopyWithImpl(
    _$CreateSubcategoryRequestImpl _value,
    $Res Function(_$CreateSubcategoryRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateSubcategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? categoryId = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$CreateSubcategoryRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateSubcategoryRequestImpl implements _CreateSubcategoryRequest {
  const _$CreateSubcategoryRequestImpl({
    required this.name,
    required this.categoryId,
    this.imageUrl,
  });

  factory _$CreateSubcategoryRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateSubcategoryRequestImplFromJson(json);

  @override
  final String name;
  @override
  final int categoryId;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'CreateSubcategoryRequest(name: $name, categoryId: $categoryId, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSubcategoryRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, categoryId, imageUrl);

  /// Create a copy of CreateSubcategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSubcategoryRequestImplCopyWith<_$CreateSubcategoryRequestImpl>
  get copyWith =>
      __$$CreateSubcategoryRequestImplCopyWithImpl<
        _$CreateSubcategoryRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateSubcategoryRequestImplToJson(this);
  }
}

abstract class _CreateSubcategoryRequest implements CreateSubcategoryRequest {
  const factory _CreateSubcategoryRequest({
    required final String name,
    required final int categoryId,
    final String? imageUrl,
  }) = _$CreateSubcategoryRequestImpl;

  factory _CreateSubcategoryRequest.fromJson(Map<String, dynamic> json) =
      _$CreateSubcategoryRequestImpl.fromJson;

  @override
  String get name;
  @override
  int get categoryId;
  @override
  String? get imageUrl;

  /// Create a copy of CreateSubcategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSubcategoryRequestImplCopyWith<_$CreateSubcategoryRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateSubSubCategoryRequest _$CreateSubSubCategoryRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateSubSubCategoryRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateSubSubCategoryRequest {
  String get name => throw _privateConstructorUsedError;
  int get subcategoryId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this CreateSubSubCategoryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateSubSubCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSubSubCategoryRequestCopyWith<CreateSubSubCategoryRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSubSubCategoryRequestCopyWith<$Res> {
  factory $CreateSubSubCategoryRequestCopyWith(
    CreateSubSubCategoryRequest value,
    $Res Function(CreateSubSubCategoryRequest) then,
  ) =
      _$CreateSubSubCategoryRequestCopyWithImpl<
        $Res,
        CreateSubSubCategoryRequest
      >;
  @useResult
  $Res call({String name, int subcategoryId, String? imageUrl});
}

/// @nodoc
class _$CreateSubSubCategoryRequestCopyWithImpl<
  $Res,
  $Val extends CreateSubSubCategoryRequest
>
    implements $CreateSubSubCategoryRequestCopyWith<$Res> {
  _$CreateSubSubCategoryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSubSubCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? subcategoryId = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            subcategoryId: null == subcategoryId
                ? _value.subcategoryId
                : subcategoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateSubSubCategoryRequestImplCopyWith<$Res>
    implements $CreateSubSubCategoryRequestCopyWith<$Res> {
  factory _$$CreateSubSubCategoryRequestImplCopyWith(
    _$CreateSubSubCategoryRequestImpl value,
    $Res Function(_$CreateSubSubCategoryRequestImpl) then,
  ) = __$$CreateSubSubCategoryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int subcategoryId, String? imageUrl});
}

/// @nodoc
class __$$CreateSubSubCategoryRequestImplCopyWithImpl<$Res>
    extends
        _$CreateSubSubCategoryRequestCopyWithImpl<
          $Res,
          _$CreateSubSubCategoryRequestImpl
        >
    implements _$$CreateSubSubCategoryRequestImplCopyWith<$Res> {
  __$$CreateSubSubCategoryRequestImplCopyWithImpl(
    _$CreateSubSubCategoryRequestImpl _value,
    $Res Function(_$CreateSubSubCategoryRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateSubSubCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? subcategoryId = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$CreateSubSubCategoryRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        subcategoryId: null == subcategoryId
            ? _value.subcategoryId
            : subcategoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateSubSubCategoryRequestImpl
    implements _CreateSubSubCategoryRequest {
  const _$CreateSubSubCategoryRequestImpl({
    required this.name,
    required this.subcategoryId,
    this.imageUrl,
  });

  factory _$CreateSubSubCategoryRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CreateSubSubCategoryRequestImplFromJson(json);

  @override
  final String name;
  @override
  final int subcategoryId;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'CreateSubSubCategoryRequest(name: $name, subcategoryId: $subcategoryId, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSubSubCategoryRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, subcategoryId, imageUrl);

  /// Create a copy of CreateSubSubCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSubSubCategoryRequestImplCopyWith<_$CreateSubSubCategoryRequestImpl>
  get copyWith =>
      __$$CreateSubSubCategoryRequestImplCopyWithImpl<
        _$CreateSubSubCategoryRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateSubSubCategoryRequestImplToJson(this);
  }
}

abstract class _CreateSubSubCategoryRequest
    implements CreateSubSubCategoryRequest {
  const factory _CreateSubSubCategoryRequest({
    required final String name,
    required final int subcategoryId,
    final String? imageUrl,
  }) = _$CreateSubSubCategoryRequestImpl;

  factory _CreateSubSubCategoryRequest.fromJson(Map<String, dynamic> json) =
      _$CreateSubSubCategoryRequestImpl.fromJson;

  @override
  String get name;
  @override
  int get subcategoryId;
  @override
  String? get imageUrl;

  /// Create a copy of CreateSubSubCategoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSubSubCategoryRequestImplCopyWith<_$CreateSubSubCategoryRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UpdateStatusRequest _$UpdateStatusRequestFromJson(Map<String, dynamic> json) {
  return _UpdateStatusRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateStatusRequest {
  bool get status => throw _privateConstructorUsedError;

  /// Serializes this UpdateStatusRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateStatusRequestCopyWith<UpdateStatusRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateStatusRequestCopyWith<$Res> {
  factory $UpdateStatusRequestCopyWith(
    UpdateStatusRequest value,
    $Res Function(UpdateStatusRequest) then,
  ) = _$UpdateStatusRequestCopyWithImpl<$Res, UpdateStatusRequest>;
  @useResult
  $Res call({bool status});
}

/// @nodoc
class _$UpdateStatusRequestCopyWithImpl<$Res, $Val extends UpdateStatusRequest>
    implements $UpdateStatusRequestCopyWith<$Res> {
  _$UpdateStatusRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateStatusRequestImplCopyWith<$Res>
    implements $UpdateStatusRequestCopyWith<$Res> {
  factory _$$UpdateStatusRequestImplCopyWith(
    _$UpdateStatusRequestImpl value,
    $Res Function(_$UpdateStatusRequestImpl) then,
  ) = __$$UpdateStatusRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool status});
}

/// @nodoc
class __$$UpdateStatusRequestImplCopyWithImpl<$Res>
    extends _$UpdateStatusRequestCopyWithImpl<$Res, _$UpdateStatusRequestImpl>
    implements _$$UpdateStatusRequestImplCopyWith<$Res> {
  __$$UpdateStatusRequestImplCopyWithImpl(
    _$UpdateStatusRequestImpl _value,
    $Res Function(_$UpdateStatusRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _$UpdateStatusRequestImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateStatusRequestImpl implements _UpdateStatusRequest {
  const _$UpdateStatusRequestImpl({required this.status});

  factory _$UpdateStatusRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateStatusRequestImplFromJson(json);

  @override
  final bool status;

  @override
  String toString() {
    return 'UpdateStatusRequest(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStatusRequestImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStatusRequestImplCopyWith<_$UpdateStatusRequestImpl> get copyWith =>
      __$$UpdateStatusRequestImplCopyWithImpl<_$UpdateStatusRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateStatusRequestImplToJson(this);
  }
}

abstract class _UpdateStatusRequest implements UpdateStatusRequest {
  const factory _UpdateStatusRequest({required final bool status}) =
      _$UpdateStatusRequestImpl;

  factory _UpdateStatusRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateStatusRequestImpl.fromJson;

  @override
  bool get status;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStatusRequestImplCopyWith<_$UpdateStatusRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
