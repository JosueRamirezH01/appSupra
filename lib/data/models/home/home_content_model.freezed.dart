// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HomeHeroModel _$HomeHeroModelFromJson(Map<String, dynamic> json) {
  return _HomeHeroModel.fromJson(json);
}

/// @nodoc
mixin _$HomeHeroModel {
  String? get backgroundImageUrl => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this HomeHeroModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeHeroModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeHeroModelCopyWith<HomeHeroModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeHeroModelCopyWith<$Res> {
  factory $HomeHeroModelCopyWith(
    HomeHeroModel value,
    $Res Function(HomeHeroModel) then,
  ) = _$HomeHeroModelCopyWithImpl<$Res, HomeHeroModel>;
  @useResult
  $Res call({String? backgroundImageUrl, DateTime? updatedAt});
}

/// @nodoc
class _$HomeHeroModelCopyWithImpl<$Res, $Val extends HomeHeroModel>
    implements $HomeHeroModelCopyWith<$Res> {
  _$HomeHeroModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeHeroModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundImageUrl = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            backgroundImageUrl: freezed == backgroundImageUrl
                ? _value.backgroundImageUrl
                : backgroundImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$HomeHeroModelImplCopyWith<$Res>
    implements $HomeHeroModelCopyWith<$Res> {
  factory _$$HomeHeroModelImplCopyWith(
    _$HomeHeroModelImpl value,
    $Res Function(_$HomeHeroModelImpl) then,
  ) = __$$HomeHeroModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? backgroundImageUrl, DateTime? updatedAt});
}

/// @nodoc
class __$$HomeHeroModelImplCopyWithImpl<$Res>
    extends _$HomeHeroModelCopyWithImpl<$Res, _$HomeHeroModelImpl>
    implements _$$HomeHeroModelImplCopyWith<$Res> {
  __$$HomeHeroModelImplCopyWithImpl(
    _$HomeHeroModelImpl _value,
    $Res Function(_$HomeHeroModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeHeroModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundImageUrl = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$HomeHeroModelImpl(
        backgroundImageUrl: freezed == backgroundImageUrl
            ? _value.backgroundImageUrl
            : backgroundImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$HomeHeroModelImpl implements _HomeHeroModel {
  const _$HomeHeroModelImpl({this.backgroundImageUrl, this.updatedAt});

  factory _$HomeHeroModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeHeroModelImplFromJson(json);

  @override
  final String? backgroundImageUrl;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'HomeHeroModel(backgroundImageUrl: $backgroundImageUrl, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeHeroModelImpl &&
            (identical(other.backgroundImageUrl, backgroundImageUrl) ||
                other.backgroundImageUrl == backgroundImageUrl) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, backgroundImageUrl, updatedAt);

  /// Create a copy of HomeHeroModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeHeroModelImplCopyWith<_$HomeHeroModelImpl> get copyWith =>
      __$$HomeHeroModelImplCopyWithImpl<_$HomeHeroModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeHeroModelImplToJson(this);
  }
}

abstract class _HomeHeroModel implements HomeHeroModel {
  const factory _HomeHeroModel({
    final String? backgroundImageUrl,
    final DateTime? updatedAt,
  }) = _$HomeHeroModelImpl;

  factory _HomeHeroModel.fromJson(Map<String, dynamic> json) =
      _$HomeHeroModelImpl.fromJson;

  @override
  String? get backgroundImageUrl;
  @override
  DateTime? get updatedAt;

  /// Create a copy of HomeHeroModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeHeroModelImplCopyWith<_$HomeHeroModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeCarouselSlideModel _$HomeCarouselSlideModelFromJson(
  Map<String, dynamic> json,
) {
  return _HomeCarouselSlideModel.fromJson(json);
}

/// @nodoc
mixin _$HomeCarouselSlideModel {
  int get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get buttonLabel => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this HomeCarouselSlideModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeCarouselSlideModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeCarouselSlideModelCopyWith<HomeCarouselSlideModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeCarouselSlideModelCopyWith<$Res> {
  factory $HomeCarouselSlideModelCopyWith(
    HomeCarouselSlideModel value,
    $Res Function(HomeCarouselSlideModel) then,
  ) = _$HomeCarouselSlideModelCopyWithImpl<$Res, HomeCarouselSlideModel>;
  @useResult
  $Res call({
    int id,
    String imageUrl,
    String title,
    String buttonLabel,
    int sortOrder,
    bool status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$HomeCarouselSlideModelCopyWithImpl<
  $Res,
  $Val extends HomeCarouselSlideModel
>
    implements $HomeCarouselSlideModelCopyWith<$Res> {
  _$HomeCarouselSlideModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeCarouselSlideModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? title = null,
    Object? buttonLabel = null,
    Object? sortOrder = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            buttonLabel: null == buttonLabel
                ? _value.buttonLabel
                : buttonLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$HomeCarouselSlideModelImplCopyWith<$Res>
    implements $HomeCarouselSlideModelCopyWith<$Res> {
  factory _$$HomeCarouselSlideModelImplCopyWith(
    _$HomeCarouselSlideModelImpl value,
    $Res Function(_$HomeCarouselSlideModelImpl) then,
  ) = __$$HomeCarouselSlideModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String imageUrl,
    String title,
    String buttonLabel,
    int sortOrder,
    bool status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$HomeCarouselSlideModelImplCopyWithImpl<$Res>
    extends
        _$HomeCarouselSlideModelCopyWithImpl<$Res, _$HomeCarouselSlideModelImpl>
    implements _$$HomeCarouselSlideModelImplCopyWith<$Res> {
  __$$HomeCarouselSlideModelImplCopyWithImpl(
    _$HomeCarouselSlideModelImpl _value,
    $Res Function(_$HomeCarouselSlideModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeCarouselSlideModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? title = null,
    Object? buttonLabel = null,
    Object? sortOrder = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$HomeCarouselSlideModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        buttonLabel: null == buttonLabel
            ? _value.buttonLabel
            : buttonLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$HomeCarouselSlideModelImpl implements _HomeCarouselSlideModel {
  const _$HomeCarouselSlideModelImpl({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.buttonLabel = 'AQUÍ',
    this.sortOrder = 0,
    this.status = true,
    this.createdAt,
    this.updatedAt,
  });

  factory _$HomeCarouselSlideModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeCarouselSlideModelImplFromJson(json);

  @override
  final int id;
  @override
  final String imageUrl;
  @override
  final String title;
  @override
  @JsonKey()
  final String buttonLabel;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'HomeCarouselSlideModel(id: $id, imageUrl: $imageUrl, title: $title, buttonLabel: $buttonLabel, sortOrder: $sortOrder, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeCarouselSlideModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.buttonLabel, buttonLabel) ||
                other.buttonLabel == buttonLabel) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.status, status) || other.status == status) &&
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
    imageUrl,
    title,
    buttonLabel,
    sortOrder,
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of HomeCarouselSlideModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeCarouselSlideModelImplCopyWith<_$HomeCarouselSlideModelImpl>
  get copyWith =>
      __$$HomeCarouselSlideModelImplCopyWithImpl<_$HomeCarouselSlideModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeCarouselSlideModelImplToJson(this);
  }
}

abstract class _HomeCarouselSlideModel implements HomeCarouselSlideModel {
  const factory _HomeCarouselSlideModel({
    required final int id,
    required final String imageUrl,
    required final String title,
    final String buttonLabel,
    final int sortOrder,
    final bool status,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$HomeCarouselSlideModelImpl;

  factory _HomeCarouselSlideModel.fromJson(Map<String, dynamic> json) =
      _$HomeCarouselSlideModelImpl.fromJson;

  @override
  int get id;
  @override
  String get imageUrl;
  @override
  String get title;
  @override
  String get buttonLabel;
  @override
  int get sortOrder;
  @override
  bool get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of HomeCarouselSlideModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeCarouselSlideModelImplCopyWith<_$HomeCarouselSlideModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

HomeContentModel _$HomeContentModelFromJson(Map<String, dynamic> json) {
  return _HomeContentModel.fromJson(json);
}

/// @nodoc
mixin _$HomeContentModel {
  HomeHeroModel get hero => throw _privateConstructorUsedError;
  List<HomeCarouselSlideModel> get carouselSlides =>
      throw _privateConstructorUsedError;

  /// Serializes this HomeContentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeContentModelCopyWith<HomeContentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeContentModelCopyWith<$Res> {
  factory $HomeContentModelCopyWith(
    HomeContentModel value,
    $Res Function(HomeContentModel) then,
  ) = _$HomeContentModelCopyWithImpl<$Res, HomeContentModel>;
  @useResult
  $Res call({HomeHeroModel hero, List<HomeCarouselSlideModel> carouselSlides});

  $HomeHeroModelCopyWith<$Res> get hero;
}

/// @nodoc
class _$HomeContentModelCopyWithImpl<$Res, $Val extends HomeContentModel>
    implements $HomeContentModelCopyWith<$Res> {
  _$HomeContentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hero = null, Object? carouselSlides = null}) {
    return _then(
      _value.copyWith(
            hero: null == hero
                ? _value.hero
                : hero // ignore: cast_nullable_to_non_nullable
                      as HomeHeroModel,
            carouselSlides: null == carouselSlides
                ? _value.carouselSlides
                : carouselSlides // ignore: cast_nullable_to_non_nullable
                      as List<HomeCarouselSlideModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of HomeContentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HomeHeroModelCopyWith<$Res> get hero {
    return $HomeHeroModelCopyWith<$Res>(_value.hero, (value) {
      return _then(_value.copyWith(hero: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeContentModelImplCopyWith<$Res>
    implements $HomeContentModelCopyWith<$Res> {
  factory _$$HomeContentModelImplCopyWith(
    _$HomeContentModelImpl value,
    $Res Function(_$HomeContentModelImpl) then,
  ) = __$$HomeContentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HomeHeroModel hero, List<HomeCarouselSlideModel> carouselSlides});

  @override
  $HomeHeroModelCopyWith<$Res> get hero;
}

/// @nodoc
class __$$HomeContentModelImplCopyWithImpl<$Res>
    extends _$HomeContentModelCopyWithImpl<$Res, _$HomeContentModelImpl>
    implements _$$HomeContentModelImplCopyWith<$Res> {
  __$$HomeContentModelImplCopyWithImpl(
    _$HomeContentModelImpl _value,
    $Res Function(_$HomeContentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hero = null, Object? carouselSlides = null}) {
    return _then(
      _$HomeContentModelImpl(
        hero: null == hero
            ? _value.hero
            : hero // ignore: cast_nullable_to_non_nullable
                  as HomeHeroModel,
        carouselSlides: null == carouselSlides
            ? _value._carouselSlides
            : carouselSlides // ignore: cast_nullable_to_non_nullable
                  as List<HomeCarouselSlideModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeContentModelImpl implements _HomeContentModel {
  const _$HomeContentModelImpl({
    required this.hero,
    final List<HomeCarouselSlideModel> carouselSlides = const [],
  }) : _carouselSlides = carouselSlides;

  factory _$HomeContentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeContentModelImplFromJson(json);

  @override
  final HomeHeroModel hero;
  final List<HomeCarouselSlideModel> _carouselSlides;
  @override
  @JsonKey()
  List<HomeCarouselSlideModel> get carouselSlides {
    if (_carouselSlides is EqualUnmodifiableListView) return _carouselSlides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_carouselSlides);
  }

  @override
  String toString() {
    return 'HomeContentModel(hero: $hero, carouselSlides: $carouselSlides)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeContentModelImpl &&
            (identical(other.hero, hero) || other.hero == hero) &&
            const DeepCollectionEquality().equals(
              other._carouselSlides,
              _carouselSlides,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    hero,
    const DeepCollectionEquality().hash(_carouselSlides),
  );

  /// Create a copy of HomeContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeContentModelImplCopyWith<_$HomeContentModelImpl> get copyWith =>
      __$$HomeContentModelImplCopyWithImpl<_$HomeContentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeContentModelImplToJson(this);
  }
}

abstract class _HomeContentModel implements HomeContentModel {
  const factory _HomeContentModel({
    required final HomeHeroModel hero,
    final List<HomeCarouselSlideModel> carouselSlides,
  }) = _$HomeContentModelImpl;

  factory _HomeContentModel.fromJson(Map<String, dynamic> json) =
      _$HomeContentModelImpl.fromJson;

  @override
  HomeHeroModel get hero;
  @override
  List<HomeCarouselSlideModel> get carouselSlides;

  /// Create a copy of HomeContentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeContentModelImplCopyWith<_$HomeContentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
