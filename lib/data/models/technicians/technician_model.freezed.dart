// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technician_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DayScheduleModel _$DayScheduleModelFromJson(Map<String, dynamic> json) {
  return _DayScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$DayScheduleModel {
  bool get enabled => throw _privateConstructorUsedError;
  String? get start => throw _privateConstructorUsedError;
  String? get end => throw _privateConstructorUsedError;

  /// Serializes this DayScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DayScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayScheduleModelCopyWith<DayScheduleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayScheduleModelCopyWith<$Res> {
  factory $DayScheduleModelCopyWith(
    DayScheduleModel value,
    $Res Function(DayScheduleModel) then,
  ) = _$DayScheduleModelCopyWithImpl<$Res, DayScheduleModel>;
  @useResult
  $Res call({bool enabled, String? start, String? end});
}

/// @nodoc
class _$DayScheduleModelCopyWithImpl<$Res, $Val extends DayScheduleModel>
    implements $DayScheduleModelCopyWith<$Res> {
  _$DayScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(
      _value.copyWith(
            enabled: null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            start: freezed == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as String?,
            end: freezed == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DayScheduleModelImplCopyWith<$Res>
    implements $DayScheduleModelCopyWith<$Res> {
  factory _$$DayScheduleModelImplCopyWith(
    _$DayScheduleModelImpl value,
    $Res Function(_$DayScheduleModelImpl) then,
  ) = __$$DayScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enabled, String? start, String? end});
}

/// @nodoc
class __$$DayScheduleModelImplCopyWithImpl<$Res>
    extends _$DayScheduleModelCopyWithImpl<$Res, _$DayScheduleModelImpl>
    implements _$$DayScheduleModelImplCopyWith<$Res> {
  __$$DayScheduleModelImplCopyWithImpl(
    _$DayScheduleModelImpl _value,
    $Res Function(_$DayScheduleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DayScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(
      _$DayScheduleModelImpl(
        enabled: null == enabled
            ? _value.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        start: freezed == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as String?,
        end: freezed == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DayScheduleModelImpl implements _DayScheduleModel {
  const _$DayScheduleModelImpl({required this.enabled, this.start, this.end});

  factory _$DayScheduleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayScheduleModelImplFromJson(json);

  @override
  final bool enabled;
  @override
  final String? start;
  @override
  final String? end;

  @override
  String toString() {
    return 'DayScheduleModel(enabled: $enabled, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayScheduleModelImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, start, end);

  /// Create a copy of DayScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayScheduleModelImplCopyWith<_$DayScheduleModelImpl> get copyWith =>
      __$$DayScheduleModelImplCopyWithImpl<_$DayScheduleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DayScheduleModelImplToJson(this);
  }
}

abstract class _DayScheduleModel implements DayScheduleModel {
  const factory _DayScheduleModel({
    required final bool enabled,
    final String? start,
    final String? end,
  }) = _$DayScheduleModelImpl;

  factory _DayScheduleModel.fromJson(Map<String, dynamic> json) =
      _$DayScheduleModelImpl.fromJson;

  @override
  bool get enabled;
  @override
  String? get start;
  @override
  String? get end;

  /// Create a copy of DayScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayScheduleModelImplCopyWith<_$DayScheduleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyScheduleModel _$WeeklyScheduleModelFromJson(Map<String, dynamic> json) {
  return _WeeklyScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$WeeklyScheduleModel {
  DayScheduleModel? get monday => throw _privateConstructorUsedError;
  DayScheduleModel? get tuesday => throw _privateConstructorUsedError;
  DayScheduleModel? get wednesday => throw _privateConstructorUsedError;
  DayScheduleModel? get thursday => throw _privateConstructorUsedError;
  DayScheduleModel? get friday => throw _privateConstructorUsedError;
  DayScheduleModel? get saturday => throw _privateConstructorUsedError;
  DayScheduleModel? get sunday => throw _privateConstructorUsedError;

  /// Serializes this WeeklyScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyScheduleModelCopyWith<WeeklyScheduleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyScheduleModelCopyWith<$Res> {
  factory $WeeklyScheduleModelCopyWith(
    WeeklyScheduleModel value,
    $Res Function(WeeklyScheduleModel) then,
  ) = _$WeeklyScheduleModelCopyWithImpl<$Res, WeeklyScheduleModel>;
  @useResult
  $Res call({
    DayScheduleModel? monday,
    DayScheduleModel? tuesday,
    DayScheduleModel? wednesday,
    DayScheduleModel? thursday,
    DayScheduleModel? friday,
    DayScheduleModel? saturday,
    DayScheduleModel? sunday,
  });

  $DayScheduleModelCopyWith<$Res>? get monday;
  $DayScheduleModelCopyWith<$Res>? get tuesday;
  $DayScheduleModelCopyWith<$Res>? get wednesday;
  $DayScheduleModelCopyWith<$Res>? get thursday;
  $DayScheduleModelCopyWith<$Res>? get friday;
  $DayScheduleModelCopyWith<$Res>? get saturday;
  $DayScheduleModelCopyWith<$Res>? get sunday;
}

/// @nodoc
class _$WeeklyScheduleModelCopyWithImpl<$Res, $Val extends WeeklyScheduleModel>
    implements $WeeklyScheduleModelCopyWith<$Res> {
  _$WeeklyScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monday = freezed,
    Object? tuesday = freezed,
    Object? wednesday = freezed,
    Object? thursday = freezed,
    Object? friday = freezed,
    Object? saturday = freezed,
    Object? sunday = freezed,
  }) {
    return _then(
      _value.copyWith(
            monday: freezed == monday
                ? _value.monday
                : monday // ignore: cast_nullable_to_non_nullable
                      as DayScheduleModel?,
            tuesday: freezed == tuesday
                ? _value.tuesday
                : tuesday // ignore: cast_nullable_to_non_nullable
                      as DayScheduleModel?,
            wednesday: freezed == wednesday
                ? _value.wednesday
                : wednesday // ignore: cast_nullable_to_non_nullable
                      as DayScheduleModel?,
            thursday: freezed == thursday
                ? _value.thursday
                : thursday // ignore: cast_nullable_to_non_nullable
                      as DayScheduleModel?,
            friday: freezed == friday
                ? _value.friday
                : friday // ignore: cast_nullable_to_non_nullable
                      as DayScheduleModel?,
            saturday: freezed == saturday
                ? _value.saturday
                : saturday // ignore: cast_nullable_to_non_nullable
                      as DayScheduleModel?,
            sunday: freezed == sunday
                ? _value.sunday
                : sunday // ignore: cast_nullable_to_non_nullable
                      as DayScheduleModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DayScheduleModelCopyWith<$Res>? get monday {
    if (_value.monday == null) {
      return null;
    }

    return $DayScheduleModelCopyWith<$Res>(_value.monday!, (value) {
      return _then(_value.copyWith(monday: value) as $Val);
    });
  }

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DayScheduleModelCopyWith<$Res>? get tuesday {
    if (_value.tuesday == null) {
      return null;
    }

    return $DayScheduleModelCopyWith<$Res>(_value.tuesday!, (value) {
      return _then(_value.copyWith(tuesday: value) as $Val);
    });
  }

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DayScheduleModelCopyWith<$Res>? get wednesday {
    if (_value.wednesday == null) {
      return null;
    }

    return $DayScheduleModelCopyWith<$Res>(_value.wednesday!, (value) {
      return _then(_value.copyWith(wednesday: value) as $Val);
    });
  }

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DayScheduleModelCopyWith<$Res>? get thursday {
    if (_value.thursday == null) {
      return null;
    }

    return $DayScheduleModelCopyWith<$Res>(_value.thursday!, (value) {
      return _then(_value.copyWith(thursday: value) as $Val);
    });
  }

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DayScheduleModelCopyWith<$Res>? get friday {
    if (_value.friday == null) {
      return null;
    }

    return $DayScheduleModelCopyWith<$Res>(_value.friday!, (value) {
      return _then(_value.copyWith(friday: value) as $Val);
    });
  }

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DayScheduleModelCopyWith<$Res>? get saturday {
    if (_value.saturday == null) {
      return null;
    }

    return $DayScheduleModelCopyWith<$Res>(_value.saturday!, (value) {
      return _then(_value.copyWith(saturday: value) as $Val);
    });
  }

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DayScheduleModelCopyWith<$Res>? get sunday {
    if (_value.sunday == null) {
      return null;
    }

    return $DayScheduleModelCopyWith<$Res>(_value.sunday!, (value) {
      return _then(_value.copyWith(sunday: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WeeklyScheduleModelImplCopyWith<$Res>
    implements $WeeklyScheduleModelCopyWith<$Res> {
  factory _$$WeeklyScheduleModelImplCopyWith(
    _$WeeklyScheduleModelImpl value,
    $Res Function(_$WeeklyScheduleModelImpl) then,
  ) = __$$WeeklyScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DayScheduleModel? monday,
    DayScheduleModel? tuesday,
    DayScheduleModel? wednesday,
    DayScheduleModel? thursday,
    DayScheduleModel? friday,
    DayScheduleModel? saturday,
    DayScheduleModel? sunday,
  });

  @override
  $DayScheduleModelCopyWith<$Res>? get monday;
  @override
  $DayScheduleModelCopyWith<$Res>? get tuesday;
  @override
  $DayScheduleModelCopyWith<$Res>? get wednesday;
  @override
  $DayScheduleModelCopyWith<$Res>? get thursday;
  @override
  $DayScheduleModelCopyWith<$Res>? get friday;
  @override
  $DayScheduleModelCopyWith<$Res>? get saturday;
  @override
  $DayScheduleModelCopyWith<$Res>? get sunday;
}

/// @nodoc
class __$$WeeklyScheduleModelImplCopyWithImpl<$Res>
    extends _$WeeklyScheduleModelCopyWithImpl<$Res, _$WeeklyScheduleModelImpl>
    implements _$$WeeklyScheduleModelImplCopyWith<$Res> {
  __$$WeeklyScheduleModelImplCopyWithImpl(
    _$WeeklyScheduleModelImpl _value,
    $Res Function(_$WeeklyScheduleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monday = freezed,
    Object? tuesday = freezed,
    Object? wednesday = freezed,
    Object? thursday = freezed,
    Object? friday = freezed,
    Object? saturday = freezed,
    Object? sunday = freezed,
  }) {
    return _then(
      _$WeeklyScheduleModelImpl(
        monday: freezed == monday
            ? _value.monday
            : monday // ignore: cast_nullable_to_non_nullable
                  as DayScheduleModel?,
        tuesday: freezed == tuesday
            ? _value.tuesday
            : tuesday // ignore: cast_nullable_to_non_nullable
                  as DayScheduleModel?,
        wednesday: freezed == wednesday
            ? _value.wednesday
            : wednesday // ignore: cast_nullable_to_non_nullable
                  as DayScheduleModel?,
        thursday: freezed == thursday
            ? _value.thursday
            : thursday // ignore: cast_nullable_to_non_nullable
                  as DayScheduleModel?,
        friday: freezed == friday
            ? _value.friday
            : friday // ignore: cast_nullable_to_non_nullable
                  as DayScheduleModel?,
        saturday: freezed == saturday
            ? _value.saturday
            : saturday // ignore: cast_nullable_to_non_nullable
                  as DayScheduleModel?,
        sunday: freezed == sunday
            ? _value.sunday
            : sunday // ignore: cast_nullable_to_non_nullable
                  as DayScheduleModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyScheduleModelImpl implements _WeeklyScheduleModel {
  const _$WeeklyScheduleModelImpl({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory _$WeeklyScheduleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyScheduleModelImplFromJson(json);

  @override
  final DayScheduleModel? monday;
  @override
  final DayScheduleModel? tuesday;
  @override
  final DayScheduleModel? wednesday;
  @override
  final DayScheduleModel? thursday;
  @override
  final DayScheduleModel? friday;
  @override
  final DayScheduleModel? saturday;
  @override
  final DayScheduleModel? sunday;

  @override
  String toString() {
    return 'WeeklyScheduleModel(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyScheduleModelImpl &&
            (identical(other.monday, monday) || other.monday == monday) &&
            (identical(other.tuesday, tuesday) || other.tuesday == tuesday) &&
            (identical(other.wednesday, wednesday) ||
                other.wednesday == wednesday) &&
            (identical(other.thursday, thursday) ||
                other.thursday == thursday) &&
            (identical(other.friday, friday) || other.friday == friday) &&
            (identical(other.saturday, saturday) ||
                other.saturday == saturday) &&
            (identical(other.sunday, sunday) || other.sunday == sunday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  );

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyScheduleModelImplCopyWith<_$WeeklyScheduleModelImpl> get copyWith =>
      __$$WeeklyScheduleModelImplCopyWithImpl<_$WeeklyScheduleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyScheduleModelImplToJson(this);
  }
}

abstract class _WeeklyScheduleModel implements WeeklyScheduleModel {
  const factory _WeeklyScheduleModel({
    final DayScheduleModel? monday,
    final DayScheduleModel? tuesday,
    final DayScheduleModel? wednesday,
    final DayScheduleModel? thursday,
    final DayScheduleModel? friday,
    final DayScheduleModel? saturday,
    final DayScheduleModel? sunday,
  }) = _$WeeklyScheduleModelImpl;

  factory _WeeklyScheduleModel.fromJson(Map<String, dynamic> json) =
      _$WeeklyScheduleModelImpl.fromJson;

  @override
  DayScheduleModel? get monday;
  @override
  DayScheduleModel? get tuesday;
  @override
  DayScheduleModel? get wednesday;
  @override
  DayScheduleModel? get thursday;
  @override
  DayScheduleModel? get friday;
  @override
  DayScheduleModel? get saturday;
  @override
  DayScheduleModel? get sunday;

  /// Create a copy of WeeklyScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyScheduleModelImplCopyWith<_$WeeklyScheduleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) {
  return _LocationModel.fromJson(json);
}

/// @nodoc
mixin _$LocationModel {
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this LocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationModelCopyWith<LocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationModelCopyWith<$Res> {
  factory $LocationModelCopyWith(
    LocationModel value,
    $Res Function(LocationModel) then,
  ) = _$LocationModelCopyWithImpl<$Res, LocationModel>;
  @useResult
  $Res call({double lat, double lng, String? address});
}

/// @nodoc
class _$LocationModelCopyWithImpl<$Res, $Val extends LocationModel>
    implements $LocationModelCopyWith<$Res> {
  _$LocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? address = freezed,
  }) {
    return _then(
      _value.copyWith(
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationModelImplCopyWith<$Res>
    implements $LocationModelCopyWith<$Res> {
  factory _$$LocationModelImplCopyWith(
    _$LocationModelImpl value,
    $Res Function(_$LocationModelImpl) then,
  ) = __$$LocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lng, String? address});
}

/// @nodoc
class __$$LocationModelImplCopyWithImpl<$Res>
    extends _$LocationModelCopyWithImpl<$Res, _$LocationModelImpl>
    implements _$$LocationModelImplCopyWith<$Res> {
  __$$LocationModelImplCopyWithImpl(
    _$LocationModelImpl _value,
    $Res Function(_$LocationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? address = freezed,
  }) {
    return _then(
      _$LocationModelImpl(
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationModelImpl implements _LocationModel {
  const _$LocationModelImpl({
    required this.lat,
    required this.lng,
    this.address,
  });

  factory _$LocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationModelImplFromJson(json);

  @override
  final double lat;
  @override
  final double lng;
  @override
  final String? address;

  @override
  String toString() {
    return 'LocationModel(lat: $lat, lng: $lng, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationModelImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng, address);

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      __$$LocationModelImplCopyWithImpl<_$LocationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationModelImplToJson(this);
  }
}

abstract class _LocationModel implements LocationModel {
  const factory _LocationModel({
    required final double lat,
    required final double lng,
    final String? address,
  }) = _$LocationModelImpl;

  factory _LocationModel.fromJson(Map<String, dynamic> json) =
      _$LocationModelImpl.fromJson;

  @override
  double get lat;
  @override
  double get lng;
  @override
  String? get address;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TechnicianSubcategoryModel _$TechnicianSubcategoryModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianSubcategoryModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianSubcategoryModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  double? get priceMin => throw _privateConstructorUsedError;
  double? get priceMax => throw _privateConstructorUsedError;
  String? get priceUnit => throw _privateConstructorUsedError;

  /// Serializes this TechnicianSubcategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianSubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianSubcategoryModelCopyWith<TechnicianSubcategoryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianSubcategoryModelCopyWith<$Res> {
  factory $TechnicianSubcategoryModelCopyWith(
    TechnicianSubcategoryModel value,
    $Res Function(TechnicianSubcategoryModel) then,
  ) =
      _$TechnicianSubcategoryModelCopyWithImpl<
        $Res,
        TechnicianSubcategoryModel
      >;
  @useResult
  $Res call({
    int id,
    String name,
    int categoryId,
    String categoryName,
    double? priceMin,
    double? priceMax,
    String? priceUnit,
  });
}

/// @nodoc
class _$TechnicianSubcategoryModelCopyWithImpl<
  $Res,
  $Val extends TechnicianSubcategoryModel
>
    implements $TechnicianSubcategoryModelCopyWith<$Res> {
  _$TechnicianSubcategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianSubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? priceUnit = freezed,
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
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            priceMin: freezed == priceMin
                ? _value.priceMin
                : priceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            priceMax: freezed == priceMax
                ? _value.priceMax
                : priceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            priceUnit: freezed == priceUnit
                ? _value.priceUnit
                : priceUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianSubcategoryModelImplCopyWith<$Res>
    implements $TechnicianSubcategoryModelCopyWith<$Res> {
  factory _$$TechnicianSubcategoryModelImplCopyWith(
    _$TechnicianSubcategoryModelImpl value,
    $Res Function(_$TechnicianSubcategoryModelImpl) then,
  ) = __$$TechnicianSubcategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    int categoryId,
    String categoryName,
    double? priceMin,
    double? priceMax,
    String? priceUnit,
  });
}

/// @nodoc
class __$$TechnicianSubcategoryModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianSubcategoryModelCopyWithImpl<
          $Res,
          _$TechnicianSubcategoryModelImpl
        >
    implements _$$TechnicianSubcategoryModelImplCopyWith<$Res> {
  __$$TechnicianSubcategoryModelImplCopyWithImpl(
    _$TechnicianSubcategoryModelImpl _value,
    $Res Function(_$TechnicianSubcategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianSubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? priceUnit = freezed,
  }) {
    return _then(
      _$TechnicianSubcategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        priceMin: freezed == priceMin
            ? _value.priceMin
            : priceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        priceMax: freezed == priceMax
            ? _value.priceMax
            : priceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        priceUnit: freezed == priceUnit
            ? _value.priceUnit
            : priceUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianSubcategoryModelImpl implements _TechnicianSubcategoryModel {
  const _$TechnicianSubcategoryModelImpl({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    this.priceMin,
    this.priceMax,
    this.priceUnit,
  });

  factory _$TechnicianSubcategoryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianSubcategoryModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int categoryId;
  @override
  final String categoryName;
  @override
  final double? priceMin;
  @override
  final double? priceMax;
  @override
  final String? priceUnit;

  @override
  String toString() {
    return 'TechnicianSubcategoryModel(id: $id, name: $name, categoryId: $categoryId, categoryName: $categoryName, priceMin: $priceMin, priceMax: $priceMax, priceUnit: $priceUnit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianSubcategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.priceUnit, priceUnit) ||
                other.priceUnit == priceUnit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    categoryId,
    categoryName,
    priceMin,
    priceMax,
    priceUnit,
  );

  /// Create a copy of TechnicianSubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianSubcategoryModelImplCopyWith<_$TechnicianSubcategoryModelImpl>
  get copyWith =>
      __$$TechnicianSubcategoryModelImplCopyWithImpl<
        _$TechnicianSubcategoryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianSubcategoryModelImplToJson(this);
  }
}

abstract class _TechnicianSubcategoryModel
    implements TechnicianSubcategoryModel {
  const factory _TechnicianSubcategoryModel({
    required final int id,
    required final String name,
    required final int categoryId,
    required final String categoryName,
    final double? priceMin,
    final double? priceMax,
    final String? priceUnit,
  }) = _$TechnicianSubcategoryModelImpl;

  factory _TechnicianSubcategoryModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianSubcategoryModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get categoryId;
  @override
  String get categoryName;
  @override
  double? get priceMin;
  @override
  double? get priceMax;
  @override
  String? get priceUnit;

  /// Create a copy of TechnicianSubcategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianSubcategoryModelImplCopyWith<_$TechnicianSubcategoryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SubcategoryPricingInputModel _$SubcategoryPricingInputModelFromJson(
  Map<String, dynamic> json,
) {
  return _SubcategoryPricingInputModel.fromJson(json);
}

/// @nodoc
mixin _$SubcategoryPricingInputModel {
  int get subcategoryId => throw _privateConstructorUsedError;
  double? get priceMin => throw _privateConstructorUsedError;
  double? get priceMax => throw _privateConstructorUsedError;

  /// Serializes this SubcategoryPricingInputModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubcategoryPricingInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubcategoryPricingInputModelCopyWith<SubcategoryPricingInputModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubcategoryPricingInputModelCopyWith<$Res> {
  factory $SubcategoryPricingInputModelCopyWith(
    SubcategoryPricingInputModel value,
    $Res Function(SubcategoryPricingInputModel) then,
  ) =
      _$SubcategoryPricingInputModelCopyWithImpl<
        $Res,
        SubcategoryPricingInputModel
      >;
  @useResult
  $Res call({int subcategoryId, double? priceMin, double? priceMax});
}

/// @nodoc
class _$SubcategoryPricingInputModelCopyWithImpl<
  $Res,
  $Val extends SubcategoryPricingInputModel
>
    implements $SubcategoryPricingInputModelCopyWith<$Res> {
  _$SubcategoryPricingInputModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubcategoryPricingInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subcategoryId = null,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
  }) {
    return _then(
      _value.copyWith(
            subcategoryId: null == subcategoryId
                ? _value.subcategoryId
                : subcategoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            priceMin: freezed == priceMin
                ? _value.priceMin
                : priceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            priceMax: freezed == priceMax
                ? _value.priceMax
                : priceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubcategoryPricingInputModelImplCopyWith<$Res>
    implements $SubcategoryPricingInputModelCopyWith<$Res> {
  factory _$$SubcategoryPricingInputModelImplCopyWith(
    _$SubcategoryPricingInputModelImpl value,
    $Res Function(_$SubcategoryPricingInputModelImpl) then,
  ) = __$$SubcategoryPricingInputModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int subcategoryId, double? priceMin, double? priceMax});
}

/// @nodoc
class __$$SubcategoryPricingInputModelImplCopyWithImpl<$Res>
    extends
        _$SubcategoryPricingInputModelCopyWithImpl<
          $Res,
          _$SubcategoryPricingInputModelImpl
        >
    implements _$$SubcategoryPricingInputModelImplCopyWith<$Res> {
  __$$SubcategoryPricingInputModelImplCopyWithImpl(
    _$SubcategoryPricingInputModelImpl _value,
    $Res Function(_$SubcategoryPricingInputModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubcategoryPricingInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subcategoryId = null,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
  }) {
    return _then(
      _$SubcategoryPricingInputModelImpl(
        subcategoryId: null == subcategoryId
            ? _value.subcategoryId
            : subcategoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        priceMin: freezed == priceMin
            ? _value.priceMin
            : priceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        priceMax: freezed == priceMax
            ? _value.priceMax
            : priceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubcategoryPricingInputModelImpl
    implements _SubcategoryPricingInputModel {
  const _$SubcategoryPricingInputModelImpl({
    required this.subcategoryId,
    this.priceMin,
    this.priceMax,
  });

  factory _$SubcategoryPricingInputModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$SubcategoryPricingInputModelImplFromJson(json);

  @override
  final int subcategoryId;
  @override
  final double? priceMin;
  @override
  final double? priceMax;

  @override
  String toString() {
    return 'SubcategoryPricingInputModel(subcategoryId: $subcategoryId, priceMin: $priceMin, priceMax: $priceMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubcategoryPricingInputModelImpl &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, subcategoryId, priceMin, priceMax);

  /// Create a copy of SubcategoryPricingInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubcategoryPricingInputModelImplCopyWith<
    _$SubcategoryPricingInputModelImpl
  >
  get copyWith =>
      __$$SubcategoryPricingInputModelImplCopyWithImpl<
        _$SubcategoryPricingInputModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubcategoryPricingInputModelImplToJson(this);
  }
}

abstract class _SubcategoryPricingInputModel
    implements SubcategoryPricingInputModel {
  const factory _SubcategoryPricingInputModel({
    required final int subcategoryId,
    final double? priceMin,
    final double? priceMax,
  }) = _$SubcategoryPricingInputModelImpl;

  factory _SubcategoryPricingInputModel.fromJson(Map<String, dynamic> json) =
      _$SubcategoryPricingInputModelImpl.fromJson;

  @override
  int get subcategoryId;
  @override
  double? get priceMin;
  @override
  double? get priceMax;

  /// Create a copy of SubcategoryPricingInputModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubcategoryPricingInputModelImplCopyWith<
    _$SubcategoryPricingInputModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianSubSubCategoryModel _$TechnicianSubSubCategoryModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianSubSubCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianSubSubCategoryModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get subcategoryId => throw _privateConstructorUsedError;
  String get subcategoryName => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get contactMetricType => throw _privateConstructorUsedError;

  /// Modo de precio del catálogo: both | labor | turnkey.
  String get pricingMode => throw _privateConstructorUsedError;

  /// Imagen del catálogo (sub-subcategoría), independiente del portafolio del técnico.
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get experienceYears => throw _privateConstructorUsedError;

  /// Alias de mano de obra (compat API).
  double? get priceMin => throw _privateConstructorUsedError;
  double? get priceMax => throw _privateConstructorUsedError;
  double? get laborPriceMin => throw _privateConstructorUsedError;
  double? get laborPriceMax => throw _privateConstructorUsedError;
  double? get turnkeyPriceMin => throw _privateConstructorUsedError;
  double? get turnkeyPriceMax => throw _privateConstructorUsedError;

  /// Precio a mostrar en el carrusel del perfil: labor | turnkey.
  String get profilePriceDisplay => throw _privateConstructorUsedError;

  /// 1ª foto del portafolio de este servicio, o [imageUrl] del catálogo como fallback.
  String? get previewImageUrl => throw _privateConstructorUsedError;
  bool get hasPortfolio => throw _privateConstructorUsedError;
  List<TechnicianWorkPhotoModel> get workPhotos =>
      throw _privateConstructorUsedError;

  /// Serializes this TechnicianSubSubCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianSubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianSubSubCategoryModelCopyWith<TechnicianSubSubCategoryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianSubSubCategoryModelCopyWith<$Res> {
  factory $TechnicianSubSubCategoryModelCopyWith(
    TechnicianSubSubCategoryModel value,
    $Res Function(TechnicianSubSubCategoryModel) then,
  ) =
      _$TechnicianSubSubCategoryModelCopyWithImpl<
        $Res,
        TechnicianSubSubCategoryModel
      >;
  @useResult
  $Res call({
    int id,
    String name,
    int subcategoryId,
    String subcategoryName,
    int categoryId,
    String categoryName,
    String contactMetricType,
    String pricingMode,
    String? imageUrl,
    String? description,
    int? experienceYears,
    double? priceMin,
    double? priceMax,
    double? laborPriceMin,
    double? laborPriceMax,
    double? turnkeyPriceMin,
    double? turnkeyPriceMax,
    String profilePriceDisplay,
    String? previewImageUrl,
    bool hasPortfolio,
    List<TechnicianWorkPhotoModel> workPhotos,
  });
}

/// @nodoc
class _$TechnicianSubSubCategoryModelCopyWithImpl<
  $Res,
  $Val extends TechnicianSubSubCategoryModel
>
    implements $TechnicianSubSubCategoryModelCopyWith<$Res> {
  _$TechnicianSubSubCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianSubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subcategoryId = null,
    Object? subcategoryName = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? contactMetricType = null,
    Object? pricingMode = null,
    Object? imageUrl = freezed,
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? laborPriceMin = freezed,
    Object? laborPriceMax = freezed,
    Object? turnkeyPriceMin = freezed,
    Object? turnkeyPriceMax = freezed,
    Object? profilePriceDisplay = null,
    Object? previewImageUrl = freezed,
    Object? hasPortfolio = null,
    Object? workPhotos = null,
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
            subcategoryId: null == subcategoryId
                ? _value.subcategoryId
                : subcategoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            subcategoryName: null == subcategoryName
                ? _value.subcategoryName
                : subcategoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            contactMetricType: null == contactMetricType
                ? _value.contactMetricType
                : contactMetricType // ignore: cast_nullable_to_non_nullable
                      as String,
            pricingMode: null == pricingMode
                ? _value.pricingMode
                : pricingMode // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            priceMin: freezed == priceMin
                ? _value.priceMin
                : priceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            priceMax: freezed == priceMax
                ? _value.priceMax
                : priceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            laborPriceMin: freezed == laborPriceMin
                ? _value.laborPriceMin
                : laborPriceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            laborPriceMax: freezed == laborPriceMax
                ? _value.laborPriceMax
                : laborPriceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            turnkeyPriceMin: freezed == turnkeyPriceMin
                ? _value.turnkeyPriceMin
                : turnkeyPriceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            turnkeyPriceMax: freezed == turnkeyPriceMax
                ? _value.turnkeyPriceMax
                : turnkeyPriceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            profilePriceDisplay: null == profilePriceDisplay
                ? _value.profilePriceDisplay
                : profilePriceDisplay // ignore: cast_nullable_to_non_nullable
                      as String,
            previewImageUrl: freezed == previewImageUrl
                ? _value.previewImageUrl
                : previewImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasPortfolio: null == hasPortfolio
                ? _value.hasPortfolio
                : hasPortfolio // ignore: cast_nullable_to_non_nullable
                      as bool,
            workPhotos: null == workPhotos
                ? _value.workPhotos
                : workPhotos // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianWorkPhotoModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianSubSubCategoryModelImplCopyWith<$Res>
    implements $TechnicianSubSubCategoryModelCopyWith<$Res> {
  factory _$$TechnicianSubSubCategoryModelImplCopyWith(
    _$TechnicianSubSubCategoryModelImpl value,
    $Res Function(_$TechnicianSubSubCategoryModelImpl) then,
  ) = __$$TechnicianSubSubCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    int subcategoryId,
    String subcategoryName,
    int categoryId,
    String categoryName,
    String contactMetricType,
    String pricingMode,
    String? imageUrl,
    String? description,
    int? experienceYears,
    double? priceMin,
    double? priceMax,
    double? laborPriceMin,
    double? laborPriceMax,
    double? turnkeyPriceMin,
    double? turnkeyPriceMax,
    String profilePriceDisplay,
    String? previewImageUrl,
    bool hasPortfolio,
    List<TechnicianWorkPhotoModel> workPhotos,
  });
}

/// @nodoc
class __$$TechnicianSubSubCategoryModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianSubSubCategoryModelCopyWithImpl<
          $Res,
          _$TechnicianSubSubCategoryModelImpl
        >
    implements _$$TechnicianSubSubCategoryModelImplCopyWith<$Res> {
  __$$TechnicianSubSubCategoryModelImplCopyWithImpl(
    _$TechnicianSubSubCategoryModelImpl _value,
    $Res Function(_$TechnicianSubSubCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianSubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subcategoryId = null,
    Object? subcategoryName = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? contactMetricType = null,
    Object? pricingMode = null,
    Object? imageUrl = freezed,
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? laborPriceMin = freezed,
    Object? laborPriceMax = freezed,
    Object? turnkeyPriceMin = freezed,
    Object? turnkeyPriceMax = freezed,
    Object? profilePriceDisplay = null,
    Object? previewImageUrl = freezed,
    Object? hasPortfolio = null,
    Object? workPhotos = null,
  }) {
    return _then(
      _$TechnicianSubSubCategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        subcategoryId: null == subcategoryId
            ? _value.subcategoryId
            : subcategoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        subcategoryName: null == subcategoryName
            ? _value.subcategoryName
            : subcategoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        contactMetricType: null == contactMetricType
            ? _value.contactMetricType
            : contactMetricType // ignore: cast_nullable_to_non_nullable
                  as String,
        pricingMode: null == pricingMode
            ? _value.pricingMode
            : pricingMode // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        priceMin: freezed == priceMin
            ? _value.priceMin
            : priceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        priceMax: freezed == priceMax
            ? _value.priceMax
            : priceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        laborPriceMin: freezed == laborPriceMin
            ? _value.laborPriceMin
            : laborPriceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        laborPriceMax: freezed == laborPriceMax
            ? _value.laborPriceMax
            : laborPriceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        turnkeyPriceMin: freezed == turnkeyPriceMin
            ? _value.turnkeyPriceMin
            : turnkeyPriceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        turnkeyPriceMax: freezed == turnkeyPriceMax
            ? _value.turnkeyPriceMax
            : turnkeyPriceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        profilePriceDisplay: null == profilePriceDisplay
            ? _value.profilePriceDisplay
            : profilePriceDisplay // ignore: cast_nullable_to_non_nullable
                  as String,
        previewImageUrl: freezed == previewImageUrl
            ? _value.previewImageUrl
            : previewImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasPortfolio: null == hasPortfolio
            ? _value.hasPortfolio
            : hasPortfolio // ignore: cast_nullable_to_non_nullable
                  as bool,
        workPhotos: null == workPhotos
            ? _value._workPhotos
            : workPhotos // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianWorkPhotoModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianSubSubCategoryModelImpl
    implements _TechnicianSubSubCategoryModel {
  const _$TechnicianSubSubCategoryModelImpl({
    required this.id,
    required this.name,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.categoryId,
    required this.categoryName,
    this.contactMetricType = 'none',
    this.pricingMode = 'both',
    this.imageUrl,
    this.description,
    this.experienceYears,
    this.priceMin,
    this.priceMax,
    this.laborPriceMin,
    this.laborPriceMax,
    this.turnkeyPriceMin,
    this.turnkeyPriceMax,
    this.profilePriceDisplay = 'labor',
    this.previewImageUrl,
    this.hasPortfolio = false,
    final List<TechnicianWorkPhotoModel> workPhotos = const [],
  }) : _workPhotos = workPhotos;

  factory _$TechnicianSubSubCategoryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianSubSubCategoryModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int subcategoryId;
  @override
  final String subcategoryName;
  @override
  final int categoryId;
  @override
  final String categoryName;
  @override
  @JsonKey()
  final String contactMetricType;

  /// Modo de precio del catálogo: both | labor | turnkey.
  @override
  @JsonKey()
  final String pricingMode;

  /// Imagen del catálogo (sub-subcategoría), independiente del portafolio del técnico.
  @override
  final String? imageUrl;
  @override
  final String? description;
  @override
  final int? experienceYears;

  /// Alias de mano de obra (compat API).
  @override
  final double? priceMin;
  @override
  final double? priceMax;
  @override
  final double? laborPriceMin;
  @override
  final double? laborPriceMax;
  @override
  final double? turnkeyPriceMin;
  @override
  final double? turnkeyPriceMax;

  /// Precio a mostrar en el carrusel del perfil: labor | turnkey.
  @override
  @JsonKey()
  final String profilePriceDisplay;

  /// 1ª foto del portafolio de este servicio, o [imageUrl] del catálogo como fallback.
  @override
  final String? previewImageUrl;
  @override
  @JsonKey()
  final bool hasPortfolio;
  final List<TechnicianWorkPhotoModel> _workPhotos;
  @override
  @JsonKey()
  List<TechnicianWorkPhotoModel> get workPhotos {
    if (_workPhotos is EqualUnmodifiableListView) return _workPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workPhotos);
  }

  @override
  String toString() {
    return 'TechnicianSubSubCategoryModel(id: $id, name: $name, subcategoryId: $subcategoryId, subcategoryName: $subcategoryName, categoryId: $categoryId, categoryName: $categoryName, contactMetricType: $contactMetricType, pricingMode: $pricingMode, imageUrl: $imageUrl, description: $description, experienceYears: $experienceYears, priceMin: $priceMin, priceMax: $priceMax, laborPriceMin: $laborPriceMin, laborPriceMax: $laborPriceMax, turnkeyPriceMin: $turnkeyPriceMin, turnkeyPriceMax: $turnkeyPriceMax, profilePriceDisplay: $profilePriceDisplay, previewImageUrl: $previewImageUrl, hasPortfolio: $hasPortfolio, workPhotos: $workPhotos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianSubSubCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.contactMetricType, contactMetricType) ||
                other.contactMetricType == contactMetricType) &&
            (identical(other.pricingMode, pricingMode) ||
                other.pricingMode == pricingMode) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.laborPriceMin, laborPriceMin) ||
                other.laborPriceMin == laborPriceMin) &&
            (identical(other.laborPriceMax, laborPriceMax) ||
                other.laborPriceMax == laborPriceMax) &&
            (identical(other.turnkeyPriceMin, turnkeyPriceMin) ||
                other.turnkeyPriceMin == turnkeyPriceMin) &&
            (identical(other.turnkeyPriceMax, turnkeyPriceMax) ||
                other.turnkeyPriceMax == turnkeyPriceMax) &&
            (identical(other.profilePriceDisplay, profilePriceDisplay) ||
                other.profilePriceDisplay == profilePriceDisplay) &&
            (identical(other.previewImageUrl, previewImageUrl) ||
                other.previewImageUrl == previewImageUrl) &&
            (identical(other.hasPortfolio, hasPortfolio) ||
                other.hasPortfolio == hasPortfolio) &&
            const DeepCollectionEquality().equals(
              other._workPhotos,
              _workPhotos,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    subcategoryId,
    subcategoryName,
    categoryId,
    categoryName,
    contactMetricType,
    pricingMode,
    imageUrl,
    description,
    experienceYears,
    priceMin,
    priceMax,
    laborPriceMin,
    laborPriceMax,
    turnkeyPriceMin,
    turnkeyPriceMax,
    profilePriceDisplay,
    previewImageUrl,
    hasPortfolio,
    const DeepCollectionEquality().hash(_workPhotos),
  ]);

  /// Create a copy of TechnicianSubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianSubSubCategoryModelImplCopyWith<
    _$TechnicianSubSubCategoryModelImpl
  >
  get copyWith =>
      __$$TechnicianSubSubCategoryModelImplCopyWithImpl<
        _$TechnicianSubSubCategoryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianSubSubCategoryModelImplToJson(this);
  }
}

abstract class _TechnicianSubSubCategoryModel
    implements TechnicianSubSubCategoryModel {
  const factory _TechnicianSubSubCategoryModel({
    required final int id,
    required final String name,
    required final int subcategoryId,
    required final String subcategoryName,
    required final int categoryId,
    required final String categoryName,
    final String contactMetricType,
    final String pricingMode,
    final String? imageUrl,
    final String? description,
    final int? experienceYears,
    final double? priceMin,
    final double? priceMax,
    final double? laborPriceMin,
    final double? laborPriceMax,
    final double? turnkeyPriceMin,
    final double? turnkeyPriceMax,
    final String profilePriceDisplay,
    final String? previewImageUrl,
    final bool hasPortfolio,
    final List<TechnicianWorkPhotoModel> workPhotos,
  }) = _$TechnicianSubSubCategoryModelImpl;

  factory _TechnicianSubSubCategoryModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianSubSubCategoryModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get subcategoryId;
  @override
  String get subcategoryName;
  @override
  int get categoryId;
  @override
  String get categoryName;
  @override
  String get contactMetricType;

  /// Modo de precio del catálogo: both | labor | turnkey.
  @override
  String get pricingMode;

  /// Imagen del catálogo (sub-subcategoría), independiente del portafolio del técnico.
  @override
  String? get imageUrl;
  @override
  String? get description;
  @override
  int? get experienceYears;

  /// Alias de mano de obra (compat API).
  @override
  double? get priceMin;
  @override
  double? get priceMax;
  @override
  double? get laborPriceMin;
  @override
  double? get laborPriceMax;
  @override
  double? get turnkeyPriceMin;
  @override
  double? get turnkeyPriceMax;

  /// Precio a mostrar en el carrusel del perfil: labor | turnkey.
  @override
  String get profilePriceDisplay;

  /// 1ª foto del portafolio de este servicio, o [imageUrl] del catálogo como fallback.
  @override
  String? get previewImageUrl;
  @override
  bool get hasPortfolio;
  @override
  List<TechnicianWorkPhotoModel> get workPhotos;

  /// Create a copy of TechnicianSubSubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianSubSubCategoryModelImplCopyWith<
    _$TechnicianSubSubCategoryModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianPendingServiceModel _$TechnicianPendingServiceModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianPendingServiceModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianPendingServiceModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get subcategoryId => throw _privateConstructorUsedError;

  /// Serializes this TechnicianPendingServiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianPendingServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianPendingServiceModelCopyWith<TechnicianPendingServiceModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianPendingServiceModelCopyWith<$Res> {
  factory $TechnicianPendingServiceModelCopyWith(
    TechnicianPendingServiceModel value,
    $Res Function(TechnicianPendingServiceModel) then,
  ) =
      _$TechnicianPendingServiceModelCopyWithImpl<
        $Res,
        TechnicianPendingServiceModel
      >;
  @useResult
  $Res call({int id, String name, int subcategoryId});
}

/// @nodoc
class _$TechnicianPendingServiceModelCopyWithImpl<
  $Res,
  $Val extends TechnicianPendingServiceModel
>
    implements $TechnicianPendingServiceModelCopyWith<$Res> {
  _$TechnicianPendingServiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianPendingServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subcategoryId = null,
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
            subcategoryId: null == subcategoryId
                ? _value.subcategoryId
                : subcategoryId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianPendingServiceModelImplCopyWith<$Res>
    implements $TechnicianPendingServiceModelCopyWith<$Res> {
  factory _$$TechnicianPendingServiceModelImplCopyWith(
    _$TechnicianPendingServiceModelImpl value,
    $Res Function(_$TechnicianPendingServiceModelImpl) then,
  ) = __$$TechnicianPendingServiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, int subcategoryId});
}

/// @nodoc
class __$$TechnicianPendingServiceModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianPendingServiceModelCopyWithImpl<
          $Res,
          _$TechnicianPendingServiceModelImpl
        >
    implements _$$TechnicianPendingServiceModelImplCopyWith<$Res> {
  __$$TechnicianPendingServiceModelImplCopyWithImpl(
    _$TechnicianPendingServiceModelImpl _value,
    $Res Function(_$TechnicianPendingServiceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianPendingServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subcategoryId = null,
  }) {
    return _then(
      _$TechnicianPendingServiceModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        subcategoryId: null == subcategoryId
            ? _value.subcategoryId
            : subcategoryId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianPendingServiceModelImpl
    implements _TechnicianPendingServiceModel {
  const _$TechnicianPendingServiceModelImpl({
    required this.id,
    required this.name,
    required this.subcategoryId,
  });

  factory _$TechnicianPendingServiceModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianPendingServiceModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int subcategoryId;

  @override
  String toString() {
    return 'TechnicianPendingServiceModel(id: $id, name: $name, subcategoryId: $subcategoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianPendingServiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, subcategoryId);

  /// Create a copy of TechnicianPendingServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianPendingServiceModelImplCopyWith<
    _$TechnicianPendingServiceModelImpl
  >
  get copyWith =>
      __$$TechnicianPendingServiceModelImplCopyWithImpl<
        _$TechnicianPendingServiceModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianPendingServiceModelImplToJson(this);
  }
}

abstract class _TechnicianPendingServiceModel
    implements TechnicianPendingServiceModel {
  const factory _TechnicianPendingServiceModel({
    required final int id,
    required final String name,
    required final int subcategoryId,
  }) = _$TechnicianPendingServiceModelImpl;

  factory _TechnicianPendingServiceModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianPendingServiceModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get subcategoryId;

  /// Create a copy of TechnicianPendingServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianPendingServiceModelImplCopyWith<
    _$TechnicianPendingServiceModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianPortfolioImageModel _$TechnicianPortfolioImageModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianPortfolioImageModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianPortfolioImageModel {
  int get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this TechnicianPortfolioImageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianPortfolioImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianPortfolioImageModelCopyWith<TechnicianPortfolioImageModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianPortfolioImageModelCopyWith<$Res> {
  factory $TechnicianPortfolioImageModelCopyWith(
    TechnicianPortfolioImageModel value,
    $Res Function(TechnicianPortfolioImageModel) then,
  ) =
      _$TechnicianPortfolioImageModelCopyWithImpl<
        $Res,
        TechnicianPortfolioImageModel
      >;
  @useResult
  $Res call({int id, String imageUrl, int sortOrder});
}

/// @nodoc
class _$TechnicianPortfolioImageModelCopyWithImpl<
  $Res,
  $Val extends TechnicianPortfolioImageModel
>
    implements $TechnicianPortfolioImageModelCopyWith<$Res> {
  _$TechnicianPortfolioImageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianPortfolioImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
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
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianPortfolioImageModelImplCopyWith<$Res>
    implements $TechnicianPortfolioImageModelCopyWith<$Res> {
  factory _$$TechnicianPortfolioImageModelImplCopyWith(
    _$TechnicianPortfolioImageModelImpl value,
    $Res Function(_$TechnicianPortfolioImageModelImpl) then,
  ) = __$$TechnicianPortfolioImageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String imageUrl, int sortOrder});
}

/// @nodoc
class __$$TechnicianPortfolioImageModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianPortfolioImageModelCopyWithImpl<
          $Res,
          _$TechnicianPortfolioImageModelImpl
        >
    implements _$$TechnicianPortfolioImageModelImplCopyWith<$Res> {
  __$$TechnicianPortfolioImageModelImplCopyWithImpl(
    _$TechnicianPortfolioImageModelImpl _value,
    $Res Function(_$TechnicianPortfolioImageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianPortfolioImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$TechnicianPortfolioImageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianPortfolioImageModelImpl
    implements _TechnicianPortfolioImageModel {
  const _$TechnicianPortfolioImageModelImpl({
    required this.id,
    required this.imageUrl,
    this.sortOrder = 0,
  });

  factory _$TechnicianPortfolioImageModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianPortfolioImageModelImplFromJson(json);

  @override
  final int id;
  @override
  final String imageUrl;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'TechnicianPortfolioImageModel(id: $id, imageUrl: $imageUrl, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianPortfolioImageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageUrl, sortOrder);

  /// Create a copy of TechnicianPortfolioImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianPortfolioImageModelImplCopyWith<
    _$TechnicianPortfolioImageModelImpl
  >
  get copyWith =>
      __$$TechnicianPortfolioImageModelImplCopyWithImpl<
        _$TechnicianPortfolioImageModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianPortfolioImageModelImplToJson(this);
  }
}

abstract class _TechnicianPortfolioImageModel
    implements TechnicianPortfolioImageModel {
  const factory _TechnicianPortfolioImageModel({
    required final int id,
    required final String imageUrl,
    final int sortOrder,
  }) = _$TechnicianPortfolioImageModelImpl;

  factory _TechnicianPortfolioImageModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianPortfolioImageModelImpl.fromJson;

  @override
  int get id;
  @override
  String get imageUrl;
  @override
  int get sortOrder;

  /// Create a copy of TechnicianPortfolioImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianPortfolioImageModelImplCopyWith<
    _$TechnicianPortfolioImageModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianPortfolioItemModel _$TechnicianPortfolioItemModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianPortfolioItemModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianPortfolioItemModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<TechnicianPortfolioImageModel> get images =>
      throw _privateConstructorUsedError;
  String? get linkUrl => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this TechnicianPortfolioItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianPortfolioItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianPortfolioItemModelCopyWith<TechnicianPortfolioItemModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianPortfolioItemModelCopyWith<$Res> {
  factory $TechnicianPortfolioItemModelCopyWith(
    TechnicianPortfolioItemModel value,
    $Res Function(TechnicianPortfolioItemModel) then,
  ) =
      _$TechnicianPortfolioItemModelCopyWithImpl<
        $Res,
        TechnicianPortfolioItemModel
      >;
  @useResult
  $Res call({
    int id,
    String title,
    String? location,
    String? description,
    String? imageUrl,
    List<TechnicianPortfolioImageModel> images,
    String? linkUrl,
    int sortOrder,
  });
}

/// @nodoc
class _$TechnicianPortfolioItemModelCopyWithImpl<
  $Res,
  $Val extends TechnicianPortfolioItemModel
>
    implements $TechnicianPortfolioItemModelCopyWith<$Res> {
  _$TechnicianPortfolioItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianPortfolioItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? images = null,
    Object? linkUrl = freezed,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianPortfolioImageModel>,
            linkUrl: freezed == linkUrl
                ? _value.linkUrl
                : linkUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianPortfolioItemModelImplCopyWith<$Res>
    implements $TechnicianPortfolioItemModelCopyWith<$Res> {
  factory _$$TechnicianPortfolioItemModelImplCopyWith(
    _$TechnicianPortfolioItemModelImpl value,
    $Res Function(_$TechnicianPortfolioItemModelImpl) then,
  ) = __$$TechnicianPortfolioItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String? location,
    String? description,
    String? imageUrl,
    List<TechnicianPortfolioImageModel> images,
    String? linkUrl,
    int sortOrder,
  });
}

/// @nodoc
class __$$TechnicianPortfolioItemModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianPortfolioItemModelCopyWithImpl<
          $Res,
          _$TechnicianPortfolioItemModelImpl
        >
    implements _$$TechnicianPortfolioItemModelImplCopyWith<$Res> {
  __$$TechnicianPortfolioItemModelImplCopyWithImpl(
    _$TechnicianPortfolioItemModelImpl _value,
    $Res Function(_$TechnicianPortfolioItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianPortfolioItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? images = null,
    Object? linkUrl = freezed,
    Object? sortOrder = null,
  }) {
    return _then(
      _$TechnicianPortfolioItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianPortfolioImageModel>,
        linkUrl: freezed == linkUrl
            ? _value.linkUrl
            : linkUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianPortfolioItemModelImpl
    implements _TechnicianPortfolioItemModel {
  const _$TechnicianPortfolioItemModelImpl({
    required this.id,
    required this.title,
    this.location,
    this.description,
    this.imageUrl,
    final List<TechnicianPortfolioImageModel> images = const [],
    this.linkUrl,
    this.sortOrder = 0,
  }) : _images = images;

  factory _$TechnicianPortfolioItemModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianPortfolioItemModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? location;
  @override
  final String? description;
  @override
  final String? imageUrl;
  final List<TechnicianPortfolioImageModel> _images;
  @override
  @JsonKey()
  List<TechnicianPortfolioImageModel> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? linkUrl;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'TechnicianPortfolioItemModel(id: $id, title: $title, location: $location, description: $description, imageUrl: $imageUrl, images: $images, linkUrl: $linkUrl, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianPortfolioItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    location,
    description,
    imageUrl,
    const DeepCollectionEquality().hash(_images),
    linkUrl,
    sortOrder,
  );

  /// Create a copy of TechnicianPortfolioItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianPortfolioItemModelImplCopyWith<
    _$TechnicianPortfolioItemModelImpl
  >
  get copyWith =>
      __$$TechnicianPortfolioItemModelImplCopyWithImpl<
        _$TechnicianPortfolioItemModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianPortfolioItemModelImplToJson(this);
  }
}

abstract class _TechnicianPortfolioItemModel
    implements TechnicianPortfolioItemModel {
  const factory _TechnicianPortfolioItemModel({
    required final int id,
    required final String title,
    final String? location,
    final String? description,
    final String? imageUrl,
    final List<TechnicianPortfolioImageModel> images,
    final String? linkUrl,
    final int sortOrder,
  }) = _$TechnicianPortfolioItemModelImpl;

  factory _TechnicianPortfolioItemModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianPortfolioItemModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get location;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  List<TechnicianPortfolioImageModel> get images;
  @override
  String? get linkUrl;
  @override
  int get sortOrder;

  /// Create a copy of TechnicianPortfolioItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianPortfolioItemModelImplCopyWith<
    _$TechnicianPortfolioItemModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

PortfolioImageInputModel _$PortfolioImageInputModelFromJson(
  Map<String, dynamic> json,
) {
  return _PortfolioImageInputModel.fromJson(json);
}

/// @nodoc
mixin _$PortfolioImageInputModel {
  String get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this PortfolioImageInputModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioImageInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioImageInputModelCopyWith<PortfolioImageInputModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioImageInputModelCopyWith<$Res> {
  factory $PortfolioImageInputModelCopyWith(
    PortfolioImageInputModel value,
    $Res Function(PortfolioImageInputModel) then,
  ) = _$PortfolioImageInputModelCopyWithImpl<$Res, PortfolioImageInputModel>;
  @useResult
  $Res call({String imageUrl});
}

/// @nodoc
class _$PortfolioImageInputModelCopyWithImpl<
  $Res,
  $Val extends PortfolioImageInputModel
>
    implements $PortfolioImageInputModelCopyWith<$Res> {
  _$PortfolioImageInputModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortfolioImageInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? imageUrl = null}) {
    return _then(
      _value.copyWith(
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PortfolioImageInputModelImplCopyWith<$Res>
    implements $PortfolioImageInputModelCopyWith<$Res> {
  factory _$$PortfolioImageInputModelImplCopyWith(
    _$PortfolioImageInputModelImpl value,
    $Res Function(_$PortfolioImageInputModelImpl) then,
  ) = __$$PortfolioImageInputModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String imageUrl});
}

/// @nodoc
class __$$PortfolioImageInputModelImplCopyWithImpl<$Res>
    extends
        _$PortfolioImageInputModelCopyWithImpl<
          $Res,
          _$PortfolioImageInputModelImpl
        >
    implements _$$PortfolioImageInputModelImplCopyWith<$Res> {
  __$$PortfolioImageInputModelImplCopyWithImpl(
    _$PortfolioImageInputModelImpl _value,
    $Res Function(_$PortfolioImageInputModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PortfolioImageInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? imageUrl = null}) {
    return _then(
      _$PortfolioImageInputModelImpl(
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioImageInputModelImpl implements _PortfolioImageInputModel {
  const _$PortfolioImageInputModelImpl({required this.imageUrl});

  factory _$PortfolioImageInputModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioImageInputModelImplFromJson(json);

  @override
  final String imageUrl;

  @override
  String toString() {
    return 'PortfolioImageInputModel(imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioImageInputModelImpl &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, imageUrl);

  /// Create a copy of PortfolioImageInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioImageInputModelImplCopyWith<_$PortfolioImageInputModelImpl>
  get copyWith =>
      __$$PortfolioImageInputModelImplCopyWithImpl<
        _$PortfolioImageInputModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioImageInputModelImplToJson(this);
  }
}

abstract class _PortfolioImageInputModel implements PortfolioImageInputModel {
  const factory _PortfolioImageInputModel({required final String imageUrl}) =
      _$PortfolioImageInputModelImpl;

  factory _PortfolioImageInputModel.fromJson(Map<String, dynamic> json) =
      _$PortfolioImageInputModelImpl.fromJson;

  @override
  String get imageUrl;

  /// Create a copy of PortfolioImageInputModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioImageInputModelImplCopyWith<_$PortfolioImageInputModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PortfolioItemInputModel _$PortfolioItemInputModelFromJson(
  Map<String, dynamic> json,
) {
  return _PortfolioItemInputModel.fromJson(json);
}

/// @nodoc
mixin _$PortfolioItemInputModel {
  String? get title => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<PortfolioImageInputModel> get images =>
      throw _privateConstructorUsedError;

  /// Serializes this PortfolioItemInputModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortfolioItemInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortfolioItemInputModelCopyWith<PortfolioItemInputModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortfolioItemInputModelCopyWith<$Res> {
  factory $PortfolioItemInputModelCopyWith(
    PortfolioItemInputModel value,
    $Res Function(PortfolioItemInputModel) then,
  ) = _$PortfolioItemInputModelCopyWithImpl<$Res, PortfolioItemInputModel>;
  @useResult
  $Res call({
    String? title,
    String location,
    String? description,
    List<PortfolioImageInputModel> images,
  });
}

/// @nodoc
class _$PortfolioItemInputModelCopyWithImpl<
  $Res,
  $Val extends PortfolioItemInputModel
>
    implements $PortfolioItemInputModelCopyWith<$Res> {
  _$PortfolioItemInputModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortfolioItemInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? location = null,
    Object? description = freezed,
    Object? images = null,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<PortfolioImageInputModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PortfolioItemInputModelImplCopyWith<$Res>
    implements $PortfolioItemInputModelCopyWith<$Res> {
  factory _$$PortfolioItemInputModelImplCopyWith(
    _$PortfolioItemInputModelImpl value,
    $Res Function(_$PortfolioItemInputModelImpl) then,
  ) = __$$PortfolioItemInputModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? title,
    String location,
    String? description,
    List<PortfolioImageInputModel> images,
  });
}

/// @nodoc
class __$$PortfolioItemInputModelImplCopyWithImpl<$Res>
    extends
        _$PortfolioItemInputModelCopyWithImpl<
          $Res,
          _$PortfolioItemInputModelImpl
        >
    implements _$$PortfolioItemInputModelImplCopyWith<$Res> {
  __$$PortfolioItemInputModelImplCopyWithImpl(
    _$PortfolioItemInputModelImpl _value,
    $Res Function(_$PortfolioItemInputModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PortfolioItemInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? location = null,
    Object? description = freezed,
    Object? images = null,
  }) {
    return _then(
      _$PortfolioItemInputModelImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<PortfolioImageInputModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PortfolioItemInputModelImpl implements _PortfolioItemInputModel {
  const _$PortfolioItemInputModelImpl({
    this.title,
    required this.location,
    this.description,
    final List<PortfolioImageInputModel> images = const [],
  }) : _images = images;

  factory _$PortfolioItemInputModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortfolioItemInputModelImplFromJson(json);

  @override
  final String? title;
  @override
  final String location;
  @override
  final String? description;
  final List<PortfolioImageInputModel> _images;
  @override
  @JsonKey()
  List<PortfolioImageInputModel> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'PortfolioItemInputModel(title: $title, location: $location, description: $description, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortfolioItemInputModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    location,
    description,
    const DeepCollectionEquality().hash(_images),
  );

  /// Create a copy of PortfolioItemInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortfolioItemInputModelImplCopyWith<_$PortfolioItemInputModelImpl>
  get copyWith =>
      __$$PortfolioItemInputModelImplCopyWithImpl<
        _$PortfolioItemInputModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortfolioItemInputModelImplToJson(this);
  }
}

abstract class _PortfolioItemInputModel implements PortfolioItemInputModel {
  const factory _PortfolioItemInputModel({
    final String? title,
    required final String location,
    final String? description,
    final List<PortfolioImageInputModel> images,
  }) = _$PortfolioItemInputModelImpl;

  factory _PortfolioItemInputModel.fromJson(Map<String, dynamic> json) =
      _$PortfolioItemInputModelImpl.fromJson;

  @override
  String? get title;
  @override
  String get location;
  @override
  String? get description;
  @override
  List<PortfolioImageInputModel> get images;

  /// Create a copy of PortfolioItemInputModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortfolioItemInputModelImplCopyWith<_$PortfolioItemInputModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianWorkPhotoModel _$TechnicianWorkPhotoModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianWorkPhotoModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianWorkPhotoModel {
  int get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  double? get estimatedCost => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this TechnicianWorkPhotoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianWorkPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianWorkPhotoModelCopyWith<TechnicianWorkPhotoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianWorkPhotoModelCopyWith<$Res> {
  factory $TechnicianWorkPhotoModelCopyWith(
    TechnicianWorkPhotoModel value,
    $Res Function(TechnicianWorkPhotoModel) then,
  ) = _$TechnicianWorkPhotoModelCopyWithImpl<$Res, TechnicianWorkPhotoModel>;
  @useResult
  $Res call({
    int id,
    String imageUrl,
    String? caption,
    double? estimatedCost,
    int sortOrder,
  });
}

/// @nodoc
class _$TechnicianWorkPhotoModelCopyWithImpl<
  $Res,
  $Val extends TechnicianWorkPhotoModel
>
    implements $TechnicianWorkPhotoModelCopyWith<$Res> {
  _$TechnicianWorkPhotoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianWorkPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? estimatedCost = freezed,
    Object? sortOrder = null,
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
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedCost: freezed == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianWorkPhotoModelImplCopyWith<$Res>
    implements $TechnicianWorkPhotoModelCopyWith<$Res> {
  factory _$$TechnicianWorkPhotoModelImplCopyWith(
    _$TechnicianWorkPhotoModelImpl value,
    $Res Function(_$TechnicianWorkPhotoModelImpl) then,
  ) = __$$TechnicianWorkPhotoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String imageUrl,
    String? caption,
    double? estimatedCost,
    int sortOrder,
  });
}

/// @nodoc
class __$$TechnicianWorkPhotoModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianWorkPhotoModelCopyWithImpl<
          $Res,
          _$TechnicianWorkPhotoModelImpl
        >
    implements _$$TechnicianWorkPhotoModelImplCopyWith<$Res> {
  __$$TechnicianWorkPhotoModelImplCopyWithImpl(
    _$TechnicianWorkPhotoModelImpl _value,
    $Res Function(_$TechnicianWorkPhotoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianWorkPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? estimatedCost = freezed,
    Object? sortOrder = null,
  }) {
    return _then(
      _$TechnicianWorkPhotoModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedCost: freezed == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianWorkPhotoModelImpl implements _TechnicianWorkPhotoModel {
  const _$TechnicianWorkPhotoModelImpl({
    required this.id,
    required this.imageUrl,
    this.caption,
    this.estimatedCost,
    this.sortOrder = 0,
  });

  factory _$TechnicianWorkPhotoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TechnicianWorkPhotoModelImplFromJson(json);

  @override
  final int id;
  @override
  final String imageUrl;
  @override
  final String? caption;
  @override
  final double? estimatedCost;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'TechnicianWorkPhotoModel(id: $id, imageUrl: $imageUrl, caption: $caption, estimatedCost: $estimatedCost, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianWorkPhotoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, imageUrl, caption, estimatedCost, sortOrder);

  /// Create a copy of TechnicianWorkPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianWorkPhotoModelImplCopyWith<_$TechnicianWorkPhotoModelImpl>
  get copyWith =>
      __$$TechnicianWorkPhotoModelImplCopyWithImpl<
        _$TechnicianWorkPhotoModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianWorkPhotoModelImplToJson(this);
  }
}

abstract class _TechnicianWorkPhotoModel implements TechnicianWorkPhotoModel {
  const factory _TechnicianWorkPhotoModel({
    required final int id,
    required final String imageUrl,
    final String? caption,
    final double? estimatedCost,
    final int sortOrder,
  }) = _$TechnicianWorkPhotoModelImpl;

  factory _TechnicianWorkPhotoModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianWorkPhotoModelImpl.fromJson;

  @override
  int get id;
  @override
  String get imageUrl;
  @override
  String? get caption;
  @override
  double? get estimatedCost;
  @override
  int get sortOrder;

  /// Create a copy of TechnicianWorkPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianWorkPhotoModelImplCopyWith<_$TechnicianWorkPhotoModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

WorkPhotoInputModel _$WorkPhotoInputModelFromJson(Map<String, dynamic> json) {
  return _WorkPhotoInputModel.fromJson(json);
}

/// @nodoc
mixin _$WorkPhotoInputModel {
  String get imageUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  double? get estimatedCost => throw _privateConstructorUsedError;

  /// Serializes this WorkPhotoInputModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkPhotoInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkPhotoInputModelCopyWith<WorkPhotoInputModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkPhotoInputModelCopyWith<$Res> {
  factory $WorkPhotoInputModelCopyWith(
    WorkPhotoInputModel value,
    $Res Function(WorkPhotoInputModel) then,
  ) = _$WorkPhotoInputModelCopyWithImpl<$Res, WorkPhotoInputModel>;
  @useResult
  $Res call({String imageUrl, String? caption, double? estimatedCost});
}

/// @nodoc
class _$WorkPhotoInputModelCopyWithImpl<$Res, $Val extends WorkPhotoInputModel>
    implements $WorkPhotoInputModelCopyWith<$Res> {
  _$WorkPhotoInputModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkPhotoInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? estimatedCost = freezed,
  }) {
    return _then(
      _value.copyWith(
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedCost: freezed == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkPhotoInputModelImplCopyWith<$Res>
    implements $WorkPhotoInputModelCopyWith<$Res> {
  factory _$$WorkPhotoInputModelImplCopyWith(
    _$WorkPhotoInputModelImpl value,
    $Res Function(_$WorkPhotoInputModelImpl) then,
  ) = __$$WorkPhotoInputModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String imageUrl, String? caption, double? estimatedCost});
}

/// @nodoc
class __$$WorkPhotoInputModelImplCopyWithImpl<$Res>
    extends _$WorkPhotoInputModelCopyWithImpl<$Res, _$WorkPhotoInputModelImpl>
    implements _$$WorkPhotoInputModelImplCopyWith<$Res> {
  __$$WorkPhotoInputModelImplCopyWithImpl(
    _$WorkPhotoInputModelImpl _value,
    $Res Function(_$WorkPhotoInputModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkPhotoInputModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? estimatedCost = freezed,
  }) {
    return _then(
      _$WorkPhotoInputModelImpl(
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedCost: freezed == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkPhotoInputModelImpl implements _WorkPhotoInputModel {
  const _$WorkPhotoInputModelImpl({
    required this.imageUrl,
    this.caption,
    this.estimatedCost,
  });

  factory _$WorkPhotoInputModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkPhotoInputModelImplFromJson(json);

  @override
  final String imageUrl;
  @override
  final String? caption;
  @override
  final double? estimatedCost;

  @override
  String toString() {
    return 'WorkPhotoInputModel(imageUrl: $imageUrl, caption: $caption, estimatedCost: $estimatedCost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkPhotoInputModelImpl &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imageUrl, caption, estimatedCost);

  /// Create a copy of WorkPhotoInputModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkPhotoInputModelImplCopyWith<_$WorkPhotoInputModelImpl> get copyWith =>
      __$$WorkPhotoInputModelImplCopyWithImpl<_$WorkPhotoInputModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkPhotoInputModelImplToJson(this);
  }
}

abstract class _WorkPhotoInputModel implements WorkPhotoInputModel {
  const factory _WorkPhotoInputModel({
    required final String imageUrl,
    final String? caption,
    final double? estimatedCost,
  }) = _$WorkPhotoInputModelImpl;

  factory _WorkPhotoInputModel.fromJson(Map<String, dynamic> json) =
      _$WorkPhotoInputModelImpl.fromJson;

  @override
  String get imageUrl;
  @override
  String? get caption;
  @override
  double? get estimatedCost;

  /// Create a copy of WorkPhotoInputModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkPhotoInputModelImplCopyWith<_$WorkPhotoInputModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TechnicianLicenseModel _$TechnicianLicenseModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianLicenseModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianLicenseModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get licenseNumber => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;

  /// Serializes this TechnicianLicenseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianLicenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianLicenseModelCopyWith<TechnicianLicenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianLicenseModelCopyWith<$Res> {
  factory $TechnicianLicenseModelCopyWith(
    TechnicianLicenseModel value,
    $Res Function(TechnicianLicenseModel) then,
  ) = _$TechnicianLicenseModelCopyWithImpl<$Res, TechnicianLicenseModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String? licenseNumber,
    String? imageUrl,
    bool verified,
  });
}

/// @nodoc
class _$TechnicianLicenseModelCopyWithImpl<
  $Res,
  $Val extends TechnicianLicenseModel
>
    implements $TechnicianLicenseModelCopyWith<$Res> {
  _$TechnicianLicenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianLicenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? licenseNumber = freezed,
    Object? imageUrl = freezed,
    Object? verified = null,
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
            licenseNumber: freezed == licenseNumber
                ? _value.licenseNumber
                : licenseNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianLicenseModelImplCopyWith<$Res>
    implements $TechnicianLicenseModelCopyWith<$Res> {
  factory _$$TechnicianLicenseModelImplCopyWith(
    _$TechnicianLicenseModelImpl value,
    $Res Function(_$TechnicianLicenseModelImpl) then,
  ) = __$$TechnicianLicenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? licenseNumber,
    String? imageUrl,
    bool verified,
  });
}

/// @nodoc
class __$$TechnicianLicenseModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianLicenseModelCopyWithImpl<$Res, _$TechnicianLicenseModelImpl>
    implements _$$TechnicianLicenseModelImplCopyWith<$Res> {
  __$$TechnicianLicenseModelImplCopyWithImpl(
    _$TechnicianLicenseModelImpl _value,
    $Res Function(_$TechnicianLicenseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianLicenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? licenseNumber = freezed,
    Object? imageUrl = freezed,
    Object? verified = null,
  }) {
    return _then(
      _$TechnicianLicenseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        licenseNumber: freezed == licenseNumber
            ? _value.licenseNumber
            : licenseNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianLicenseModelImpl implements _TechnicianLicenseModel {
  const _$TechnicianLicenseModelImpl({
    required this.id,
    required this.name,
    this.licenseNumber,
    this.imageUrl,
    this.verified = false,
  });

  factory _$TechnicianLicenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TechnicianLicenseModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? licenseNumber;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool verified;

  @override
  String toString() {
    return 'TechnicianLicenseModel(id: $id, name: $name, licenseNumber: $licenseNumber, imageUrl: $imageUrl, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianLicenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, licenseNumber, imageUrl, verified);

  /// Create a copy of TechnicianLicenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianLicenseModelImplCopyWith<_$TechnicianLicenseModelImpl>
  get copyWith =>
      __$$TechnicianLicenseModelImplCopyWithImpl<_$TechnicianLicenseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianLicenseModelImplToJson(this);
  }
}

abstract class _TechnicianLicenseModel implements TechnicianLicenseModel {
  const factory _TechnicianLicenseModel({
    required final int id,
    required final String name,
    final String? licenseNumber,
    final String? imageUrl,
    final bool verified,
  }) = _$TechnicianLicenseModelImpl;

  factory _TechnicianLicenseModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianLicenseModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get licenseNumber;
  @override
  String? get imageUrl;
  @override
  bool get verified;

  /// Create a copy of TechnicianLicenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianLicenseModelImplCopyWith<_$TechnicianLicenseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianCertificationModel _$TechnicianCertificationModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianCertificationModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianCertificationModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get issuer => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;

  /// Serializes this TechnicianCertificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianCertificationModelCopyWith<TechnicianCertificationModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianCertificationModelCopyWith<$Res> {
  factory $TechnicianCertificationModelCopyWith(
    TechnicianCertificationModel value,
    $Res Function(TechnicianCertificationModel) then,
  ) =
      _$TechnicianCertificationModelCopyWithImpl<
        $Res,
        TechnicianCertificationModel
      >;
  @useResult
  $Res call({
    int id,
    String name,
    String? issuer,
    String? imageUrl,
    bool verified,
  });
}

/// @nodoc
class _$TechnicianCertificationModelCopyWithImpl<
  $Res,
  $Val extends TechnicianCertificationModel
>
    implements $TechnicianCertificationModelCopyWith<$Res> {
  _$TechnicianCertificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? issuer = freezed,
    Object? imageUrl = freezed,
    Object? verified = null,
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
            issuer: freezed == issuer
                ? _value.issuer
                : issuer // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianCertificationModelImplCopyWith<$Res>
    implements $TechnicianCertificationModelCopyWith<$Res> {
  factory _$$TechnicianCertificationModelImplCopyWith(
    _$TechnicianCertificationModelImpl value,
    $Res Function(_$TechnicianCertificationModelImpl) then,
  ) = __$$TechnicianCertificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? issuer,
    String? imageUrl,
    bool verified,
  });
}

/// @nodoc
class __$$TechnicianCertificationModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianCertificationModelCopyWithImpl<
          $Res,
          _$TechnicianCertificationModelImpl
        >
    implements _$$TechnicianCertificationModelImplCopyWith<$Res> {
  __$$TechnicianCertificationModelImplCopyWithImpl(
    _$TechnicianCertificationModelImpl _value,
    $Res Function(_$TechnicianCertificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? issuer = freezed,
    Object? imageUrl = freezed,
    Object? verified = null,
  }) {
    return _then(
      _$TechnicianCertificationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        issuer: freezed == issuer
            ? _value.issuer
            : issuer // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianCertificationModelImpl
    implements _TechnicianCertificationModel {
  const _$TechnicianCertificationModelImpl({
    required this.id,
    required this.name,
    this.issuer,
    this.imageUrl,
    this.verified = false,
  });

  factory _$TechnicianCertificationModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianCertificationModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? issuer;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool verified;

  @override
  String toString() {
    return 'TechnicianCertificationModel(id: $id, name: $name, issuer: $issuer, imageUrl: $imageUrl, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianCertificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.issuer, issuer) || other.issuer == issuer) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, issuer, imageUrl, verified);

  /// Create a copy of TechnicianCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianCertificationModelImplCopyWith<
    _$TechnicianCertificationModelImpl
  >
  get copyWith =>
      __$$TechnicianCertificationModelImplCopyWithImpl<
        _$TechnicianCertificationModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianCertificationModelImplToJson(this);
  }
}

abstract class _TechnicianCertificationModel
    implements TechnicianCertificationModel {
  const factory _TechnicianCertificationModel({
    required final int id,
    required final String name,
    final String? issuer,
    final String? imageUrl,
    final bool verified,
  }) = _$TechnicianCertificationModelImpl;

  factory _TechnicianCertificationModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianCertificationModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get issuer;
  @override
  String? get imageUrl;
  @override
  bool get verified;

  /// Create a copy of TechnicianCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianCertificationModelImplCopyWith<
    _$TechnicianCertificationModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianCoverageDistrictModel _$TechnicianCoverageDistrictModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianCoverageDistrictModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianCoverageDistrictModel {
  int get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;

  /// Serializes this TechnicianCoverageDistrictModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianCoverageDistrictModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianCoverageDistrictModelCopyWith<TechnicianCoverageDistrictModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianCoverageDistrictModelCopyWith<$Res> {
  factory $TechnicianCoverageDistrictModelCopyWith(
    TechnicianCoverageDistrictModel value,
    $Res Function(TechnicianCoverageDistrictModel) then,
  ) =
      _$TechnicianCoverageDistrictModelCopyWithImpl<
        $Res,
        TechnicianCoverageDistrictModel
      >;
  @useResult
  $Res call({int id, String label, double lat, double lng, bool isPrimary});
}

/// @nodoc
class _$TechnicianCoverageDistrictModelCopyWithImpl<
  $Res,
  $Val extends TechnicianCoverageDistrictModel
>
    implements $TechnicianCoverageDistrictModelCopyWith<$Res> {
  _$TechnicianCoverageDistrictModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianCoverageDistrictModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? lat = null,
    Object? lng = null,
    Object? isPrimary = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            isPrimary: null == isPrimary
                ? _value.isPrimary
                : isPrimary // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianCoverageDistrictModelImplCopyWith<$Res>
    implements $TechnicianCoverageDistrictModelCopyWith<$Res> {
  factory _$$TechnicianCoverageDistrictModelImplCopyWith(
    _$TechnicianCoverageDistrictModelImpl value,
    $Res Function(_$TechnicianCoverageDistrictModelImpl) then,
  ) = __$$TechnicianCoverageDistrictModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String label, double lat, double lng, bool isPrimary});
}

/// @nodoc
class __$$TechnicianCoverageDistrictModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianCoverageDistrictModelCopyWithImpl<
          $Res,
          _$TechnicianCoverageDistrictModelImpl
        >
    implements _$$TechnicianCoverageDistrictModelImplCopyWith<$Res> {
  __$$TechnicianCoverageDistrictModelImplCopyWithImpl(
    _$TechnicianCoverageDistrictModelImpl _value,
    $Res Function(_$TechnicianCoverageDistrictModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianCoverageDistrictModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? lat = null,
    Object? lng = null,
    Object? isPrimary = null,
  }) {
    return _then(
      _$TechnicianCoverageDistrictModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        isPrimary: null == isPrimary
            ? _value.isPrimary
            : isPrimary // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianCoverageDistrictModelImpl
    implements _TechnicianCoverageDistrictModel {
  const _$TechnicianCoverageDistrictModelImpl({
    required this.id,
    required this.label,
    required this.lat,
    required this.lng,
    this.isPrimary = false,
  });

  factory _$TechnicianCoverageDistrictModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianCoverageDistrictModelImplFromJson(json);

  @override
  final int id;
  @override
  final String label;
  @override
  final double lat;
  @override
  final double lng;
  @override
  @JsonKey()
  final bool isPrimary;

  @override
  String toString() {
    return 'TechnicianCoverageDistrictModel(id: $id, label: $label, lat: $lat, lng: $lng, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianCoverageDistrictModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, lat, lng, isPrimary);

  /// Create a copy of TechnicianCoverageDistrictModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianCoverageDistrictModelImplCopyWith<
    _$TechnicianCoverageDistrictModelImpl
  >
  get copyWith =>
      __$$TechnicianCoverageDistrictModelImplCopyWithImpl<
        _$TechnicianCoverageDistrictModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianCoverageDistrictModelImplToJson(this);
  }
}

abstract class _TechnicianCoverageDistrictModel
    implements TechnicianCoverageDistrictModel {
  const factory _TechnicianCoverageDistrictModel({
    required final int id,
    required final String label,
    required final double lat,
    required final double lng,
    final bool isPrimary,
  }) = _$TechnicianCoverageDistrictModelImpl;

  factory _TechnicianCoverageDistrictModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianCoverageDistrictModelImpl.fromJson;

  @override
  int get id;
  @override
  String get label;
  @override
  double get lat;
  @override
  double get lng;
  @override
  bool get isPrimary;

  /// Create a copy of TechnicianCoverageDistrictModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianCoverageDistrictModelImplCopyWith<
    _$TechnicianCoverageDistrictModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianPublicModel _$TechnicianPublicModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianPublicModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianPublicModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Razón social (empresa). Null en independiente.
  String? get businessName => throw _privateConstructorUsedError;

  /// Nombre público preferido del API (empresa → razón social).
  String? get displayName => throw _privateConstructorUsedError;
  String? get specialty => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;

  /// Logo de empresa (cards / perfil público).
  String? get companyLogoUrl => throw _privateConstructorUsedError;
  String get profileType => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  String? get verificationStatus => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Cotización mínima referencial del perfil (piso comercial).
  double? get minimumQuote => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  LocationModel? get location => throw _privateConstructorUsedError;
  int get coverageRadiusKm => throw _privateConstructorUsedError;
  bool get coversAllPeru => throw _privateConstructorUsedError;
  List<TechnicianCoverageDistrictModel> get coverageDistricts =>
      throw _privateConstructorUsedError;
  WeeklyScheduleModel? get schedule => throw _privateConstructorUsedError;
  List<TechnicianSubcategoryModel> get subcategories =>
      throw _privateConstructorUsedError;
  List<TechnicianSubSubCategoryModel> get subSubCategories =>
      throw _privateConstructorUsedError;
  List<TechnicianPendingServiceModel> get pendingServices =>
      throw _privateConstructorUsedError;
  int? get experienceYears => throw _privateConstructorUsedError;
  String? get experienceDescription => throw _privateConstructorUsedError;
  List<TechnicianPortfolioItemModel> get portfolio =>
      throw _privateConstructorUsedError;
  List<TechnicianWorkPhotoModel> get workPhotos =>
      throw _privateConstructorUsedError;
  List<TechnicianCertificationModel> get validatedCertifications =>
      throw _privateConstructorUsedError;
  bool get hasValidatedCertifications => throw _privateConstructorUsedError;
  double? get averageRating => throw _privateConstructorUsedError;
  int get ratingCount => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;
  String get placement => throw _privateConstructorUsedError;

  /// Serializes this TechnicianPublicModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianPublicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianPublicModelCopyWith<TechnicianPublicModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianPublicModelCopyWith<$Res> {
  factory $TechnicianPublicModelCopyWith(
    TechnicianPublicModel value,
    $Res Function(TechnicianPublicModel) then,
  ) = _$TechnicianPublicModelCopyWithImpl<$Res, TechnicianPublicModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String? businessName,
    String? displayName,
    String? specialty,
    String? profilePhotoUrl,
    String? companyLogoUrl,
    String profileType,
    bool verified,
    String? verificationStatus,
    String? description,
    double? minimumQuote,
    String? phone,
    String? address,
    LocationModel? location,
    int coverageRadiusKm,
    bool coversAllPeru,
    List<TechnicianCoverageDistrictModel> coverageDistricts,
    WeeklyScheduleModel? schedule,
    List<TechnicianSubcategoryModel> subcategories,
    List<TechnicianSubSubCategoryModel> subSubCategories,
    List<TechnicianPendingServiceModel> pendingServices,
    int? experienceYears,
    String? experienceDescription,
    List<TechnicianPortfolioItemModel> portfolio,
    List<TechnicianWorkPhotoModel> workPhotos,
    List<TechnicianCertificationModel> validatedCertifications,
    bool hasValidatedCertifications,
    double? averageRating,
    int ratingCount,
    double? distanceKm,
    String placement,
  });

  $LocationModelCopyWith<$Res>? get location;
  $WeeklyScheduleModelCopyWith<$Res>? get schedule;
}

/// @nodoc
class _$TechnicianPublicModelCopyWithImpl<
  $Res,
  $Val extends TechnicianPublicModel
>
    implements $TechnicianPublicModelCopyWith<$Res> {
  _$TechnicianPublicModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianPublicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? businessName = freezed,
    Object? displayName = freezed,
    Object? specialty = freezed,
    Object? profilePhotoUrl = freezed,
    Object? companyLogoUrl = freezed,
    Object? profileType = null,
    Object? verified = null,
    Object? verificationStatus = freezed,
    Object? description = freezed,
    Object? minimumQuote = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? coverageRadiusKm = null,
    Object? coversAllPeru = null,
    Object? coverageDistricts = null,
    Object? schedule = freezed,
    Object? subcategories = null,
    Object? subSubCategories = null,
    Object? pendingServices = null,
    Object? experienceYears = freezed,
    Object? experienceDescription = freezed,
    Object? portfolio = null,
    Object? workPhotos = null,
    Object? validatedCertifications = null,
    Object? hasValidatedCertifications = null,
    Object? averageRating = freezed,
    Object? ratingCount = null,
    Object? distanceKm = freezed,
    Object? placement = null,
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
            businessName: freezed == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            specialty: freezed == specialty
                ? _value.specialty
                : specialty // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyLogoUrl: freezed == companyLogoUrl
                ? _value.companyLogoUrl
                : companyLogoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileType: null == profileType
                ? _value.profileType
                : profileType // ignore: cast_nullable_to_non_nullable
                      as String,
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
            verificationStatus: freezed == verificationStatus
                ? _value.verificationStatus
                : verificationStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            minimumQuote: freezed == minimumQuote
                ? _value.minimumQuote
                : minimumQuote // ignore: cast_nullable_to_non_nullable
                      as double?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as LocationModel?,
            coverageRadiusKm: null == coverageRadiusKm
                ? _value.coverageRadiusKm
                : coverageRadiusKm // ignore: cast_nullable_to_non_nullable
                      as int,
            coversAllPeru: null == coversAllPeru
                ? _value.coversAllPeru
                : coversAllPeru // ignore: cast_nullable_to_non_nullable
                      as bool,
            coverageDistricts: null == coverageDistricts
                ? _value.coverageDistricts
                : coverageDistricts // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianCoverageDistrictModel>,
            schedule: freezed == schedule
                ? _value.schedule
                : schedule // ignore: cast_nullable_to_non_nullable
                      as WeeklyScheduleModel?,
            subcategories: null == subcategories
                ? _value.subcategories
                : subcategories // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianSubcategoryModel>,
            subSubCategories: null == subSubCategories
                ? _value.subSubCategories
                : subSubCategories // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianSubSubCategoryModel>,
            pendingServices: null == pendingServices
                ? _value.pendingServices
                : pendingServices // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianPendingServiceModel>,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            experienceDescription: freezed == experienceDescription
                ? _value.experienceDescription
                : experienceDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            portfolio: null == portfolio
                ? _value.portfolio
                : portfolio // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianPortfolioItemModel>,
            workPhotos: null == workPhotos
                ? _value.workPhotos
                : workPhotos // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianWorkPhotoModel>,
            validatedCertifications: null == validatedCertifications
                ? _value.validatedCertifications
                : validatedCertifications // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianCertificationModel>,
            hasValidatedCertifications: null == hasValidatedCertifications
                ? _value.hasValidatedCertifications
                : hasValidatedCertifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            averageRating: freezed == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double?,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            placement: null == placement
                ? _value.placement
                : placement // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of TechnicianPublicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationModelCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationModelCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of TechnicianPublicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklyScheduleModelCopyWith<$Res>? get schedule {
    if (_value.schedule == null) {
      return null;
    }

    return $WeeklyScheduleModelCopyWith<$Res>(_value.schedule!, (value) {
      return _then(_value.copyWith(schedule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TechnicianPublicModelImplCopyWith<$Res>
    implements $TechnicianPublicModelCopyWith<$Res> {
  factory _$$TechnicianPublicModelImplCopyWith(
    _$TechnicianPublicModelImpl value,
    $Res Function(_$TechnicianPublicModelImpl) then,
  ) = __$$TechnicianPublicModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? businessName,
    String? displayName,
    String? specialty,
    String? profilePhotoUrl,
    String? companyLogoUrl,
    String profileType,
    bool verified,
    String? verificationStatus,
    String? description,
    double? minimumQuote,
    String? phone,
    String? address,
    LocationModel? location,
    int coverageRadiusKm,
    bool coversAllPeru,
    List<TechnicianCoverageDistrictModel> coverageDistricts,
    WeeklyScheduleModel? schedule,
    List<TechnicianSubcategoryModel> subcategories,
    List<TechnicianSubSubCategoryModel> subSubCategories,
    List<TechnicianPendingServiceModel> pendingServices,
    int? experienceYears,
    String? experienceDescription,
    List<TechnicianPortfolioItemModel> portfolio,
    List<TechnicianWorkPhotoModel> workPhotos,
    List<TechnicianCertificationModel> validatedCertifications,
    bool hasValidatedCertifications,
    double? averageRating,
    int ratingCount,
    double? distanceKm,
    String placement,
  });

  @override
  $LocationModelCopyWith<$Res>? get location;
  @override
  $WeeklyScheduleModelCopyWith<$Res>? get schedule;
}

/// @nodoc
class __$$TechnicianPublicModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianPublicModelCopyWithImpl<$Res, _$TechnicianPublicModelImpl>
    implements _$$TechnicianPublicModelImplCopyWith<$Res> {
  __$$TechnicianPublicModelImplCopyWithImpl(
    _$TechnicianPublicModelImpl _value,
    $Res Function(_$TechnicianPublicModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianPublicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? businessName = freezed,
    Object? displayName = freezed,
    Object? specialty = freezed,
    Object? profilePhotoUrl = freezed,
    Object? companyLogoUrl = freezed,
    Object? profileType = null,
    Object? verified = null,
    Object? verificationStatus = freezed,
    Object? description = freezed,
    Object? minimumQuote = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? coverageRadiusKm = null,
    Object? coversAllPeru = null,
    Object? coverageDistricts = null,
    Object? schedule = freezed,
    Object? subcategories = null,
    Object? subSubCategories = null,
    Object? pendingServices = null,
    Object? experienceYears = freezed,
    Object? experienceDescription = freezed,
    Object? portfolio = null,
    Object? workPhotos = null,
    Object? validatedCertifications = null,
    Object? hasValidatedCertifications = null,
    Object? averageRating = freezed,
    Object? ratingCount = null,
    Object? distanceKm = freezed,
    Object? placement = null,
  }) {
    return _then(
      _$TechnicianPublicModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        businessName: freezed == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        specialty: freezed == specialty
            ? _value.specialty
            : specialty // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyLogoUrl: freezed == companyLogoUrl
            ? _value.companyLogoUrl
            : companyLogoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileType: null == profileType
            ? _value.profileType
            : profileType // ignore: cast_nullable_to_non_nullable
                  as String,
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
        verificationStatus: freezed == verificationStatus
            ? _value.verificationStatus
            : verificationStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        minimumQuote: freezed == minimumQuote
            ? _value.minimumQuote
            : minimumQuote // ignore: cast_nullable_to_non_nullable
                  as double?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as LocationModel?,
        coverageRadiusKm: null == coverageRadiusKm
            ? _value.coverageRadiusKm
            : coverageRadiusKm // ignore: cast_nullable_to_non_nullable
                  as int,
        coversAllPeru: null == coversAllPeru
            ? _value.coversAllPeru
            : coversAllPeru // ignore: cast_nullable_to_non_nullable
                  as bool,
        coverageDistricts: null == coverageDistricts
            ? _value._coverageDistricts
            : coverageDistricts // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianCoverageDistrictModel>,
        schedule: freezed == schedule
            ? _value.schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as WeeklyScheduleModel?,
        subcategories: null == subcategories
            ? _value._subcategories
            : subcategories // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianSubcategoryModel>,
        subSubCategories: null == subSubCategories
            ? _value._subSubCategories
            : subSubCategories // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianSubSubCategoryModel>,
        pendingServices: null == pendingServices
            ? _value._pendingServices
            : pendingServices // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianPendingServiceModel>,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        experienceDescription: freezed == experienceDescription
            ? _value.experienceDescription
            : experienceDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        portfolio: null == portfolio
            ? _value._portfolio
            : portfolio // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianPortfolioItemModel>,
        workPhotos: null == workPhotos
            ? _value._workPhotos
            : workPhotos // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianWorkPhotoModel>,
        validatedCertifications: null == validatedCertifications
            ? _value._validatedCertifications
            : validatedCertifications // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianCertificationModel>,
        hasValidatedCertifications: null == hasValidatedCertifications
            ? _value.hasValidatedCertifications
            : hasValidatedCertifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        averageRating: freezed == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double?,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        placement: null == placement
            ? _value.placement
            : placement // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianPublicModelImpl implements _TechnicianPublicModel {
  const _$TechnicianPublicModelImpl({
    required this.id,
    required this.name,
    this.businessName,
    this.displayName,
    this.specialty,
    this.profilePhotoUrl,
    this.companyLogoUrl,
    this.profileType = 'independiente',
    this.verified = false,
    this.verificationStatus,
    this.description,
    this.minimumQuote,
    this.phone,
    this.address,
    this.location,
    this.coverageRadiusKm = 10,
    this.coversAllPeru = false,
    final List<TechnicianCoverageDistrictModel> coverageDistricts = const [],
    this.schedule,
    final List<TechnicianSubcategoryModel> subcategories = const [],
    final List<TechnicianSubSubCategoryModel> subSubCategories = const [],
    final List<TechnicianPendingServiceModel> pendingServices = const [],
    this.experienceYears,
    this.experienceDescription,
    final List<TechnicianPortfolioItemModel> portfolio = const [],
    final List<TechnicianWorkPhotoModel> workPhotos = const [],
    final List<TechnicianCertificationModel> validatedCertifications = const [],
    this.hasValidatedCertifications = false,
    this.averageRating,
    this.ratingCount = 0,
    this.distanceKm,
    this.placement = 'organic',
  }) : _coverageDistricts = coverageDistricts,
       _subcategories = subcategories,
       _subSubCategories = subSubCategories,
       _pendingServices = pendingServices,
       _portfolio = portfolio,
       _workPhotos = workPhotos,
       _validatedCertifications = validatedCertifications;

  factory _$TechnicianPublicModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TechnicianPublicModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  /// Razón social (empresa). Null en independiente.
  @override
  final String? businessName;

  /// Nombre público preferido del API (empresa → razón social).
  @override
  final String? displayName;
  @override
  final String? specialty;
  @override
  final String? profilePhotoUrl;

  /// Logo de empresa (cards / perfil público).
  @override
  final String? companyLogoUrl;
  @override
  @JsonKey()
  final String profileType;
  @override
  @JsonKey()
  final bool verified;
  @override
  final String? verificationStatus;
  @override
  final String? description;

  /// Cotización mínima referencial del perfil (piso comercial).
  @override
  final double? minimumQuote;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final LocationModel? location;
  @override
  @JsonKey()
  final int coverageRadiusKm;
  @override
  @JsonKey()
  final bool coversAllPeru;
  final List<TechnicianCoverageDistrictModel> _coverageDistricts;
  @override
  @JsonKey()
  List<TechnicianCoverageDistrictModel> get coverageDistricts {
    if (_coverageDistricts is EqualUnmodifiableListView)
      return _coverageDistricts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coverageDistricts);
  }

  @override
  final WeeklyScheduleModel? schedule;
  final List<TechnicianSubcategoryModel> _subcategories;
  @override
  @JsonKey()
  List<TechnicianSubcategoryModel> get subcategories {
    if (_subcategories is EqualUnmodifiableListView) return _subcategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategories);
  }

  final List<TechnicianSubSubCategoryModel> _subSubCategories;
  @override
  @JsonKey()
  List<TechnicianSubSubCategoryModel> get subSubCategories {
    if (_subSubCategories is EqualUnmodifiableListView)
      return _subSubCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subSubCategories);
  }

  final List<TechnicianPendingServiceModel> _pendingServices;
  @override
  @JsonKey()
  List<TechnicianPendingServiceModel> get pendingServices {
    if (_pendingServices is EqualUnmodifiableListView) return _pendingServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingServices);
  }

  @override
  final int? experienceYears;
  @override
  final String? experienceDescription;
  final List<TechnicianPortfolioItemModel> _portfolio;
  @override
  @JsonKey()
  List<TechnicianPortfolioItemModel> get portfolio {
    if (_portfolio is EqualUnmodifiableListView) return _portfolio;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_portfolio);
  }

  final List<TechnicianWorkPhotoModel> _workPhotos;
  @override
  @JsonKey()
  List<TechnicianWorkPhotoModel> get workPhotos {
    if (_workPhotos is EqualUnmodifiableListView) return _workPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workPhotos);
  }

  final List<TechnicianCertificationModel> _validatedCertifications;
  @override
  @JsonKey()
  List<TechnicianCertificationModel> get validatedCertifications {
    if (_validatedCertifications is EqualUnmodifiableListView)
      return _validatedCertifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_validatedCertifications);
  }

  @override
  @JsonKey()
  final bool hasValidatedCertifications;
  @override
  final double? averageRating;
  @override
  @JsonKey()
  final int ratingCount;
  @override
  final double? distanceKm;
  @override
  @JsonKey()
  final String placement;

  @override
  String toString() {
    return 'TechnicianPublicModel(id: $id, name: $name, businessName: $businessName, displayName: $displayName, specialty: $specialty, profilePhotoUrl: $profilePhotoUrl, companyLogoUrl: $companyLogoUrl, profileType: $profileType, verified: $verified, verificationStatus: $verificationStatus, description: $description, minimumQuote: $minimumQuote, phone: $phone, address: $address, location: $location, coverageRadiusKm: $coverageRadiusKm, coversAllPeru: $coversAllPeru, coverageDistricts: $coverageDistricts, schedule: $schedule, subcategories: $subcategories, subSubCategories: $subSubCategories, pendingServices: $pendingServices, experienceYears: $experienceYears, experienceDescription: $experienceDescription, portfolio: $portfolio, workPhotos: $workPhotos, validatedCertifications: $validatedCertifications, hasValidatedCertifications: $hasValidatedCertifications, averageRating: $averageRating, ratingCount: $ratingCount, distanceKm: $distanceKm, placement: $placement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianPublicModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.specialty, specialty) ||
                other.specialty == specialty) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.companyLogoUrl, companyLogoUrl) ||
                other.companyLogoUrl == companyLogoUrl) &&
            (identical(other.profileType, profileType) ||
                other.profileType == profileType) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.minimumQuote, minimumQuote) ||
                other.minimumQuote == minimumQuote) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.coverageRadiusKm, coverageRadiusKm) ||
                other.coverageRadiusKm == coverageRadiusKm) &&
            (identical(other.coversAllPeru, coversAllPeru) ||
                other.coversAllPeru == coversAllPeru) &&
            const DeepCollectionEquality().equals(
              other._coverageDistricts,
              _coverageDistricts,
            ) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            const DeepCollectionEquality().equals(
              other._subcategories,
              _subcategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._subSubCategories,
              _subSubCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._pendingServices,
              _pendingServices,
            ) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.experienceDescription, experienceDescription) ||
                other.experienceDescription == experienceDescription) &&
            const DeepCollectionEquality().equals(
              other._portfolio,
              _portfolio,
            ) &&
            const DeepCollectionEquality().equals(
              other._workPhotos,
              _workPhotos,
            ) &&
            const DeepCollectionEquality().equals(
              other._validatedCertifications,
              _validatedCertifications,
            ) &&
            (identical(
                  other.hasValidatedCertifications,
                  hasValidatedCertifications,
                ) ||
                other.hasValidatedCertifications ==
                    hasValidatedCertifications) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.placement, placement) ||
                other.placement == placement));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    businessName,
    displayName,
    specialty,
    profilePhotoUrl,
    companyLogoUrl,
    profileType,
    verified,
    verificationStatus,
    description,
    minimumQuote,
    phone,
    address,
    location,
    coverageRadiusKm,
    coversAllPeru,
    const DeepCollectionEquality().hash(_coverageDistricts),
    schedule,
    const DeepCollectionEquality().hash(_subcategories),
    const DeepCollectionEquality().hash(_subSubCategories),
    const DeepCollectionEquality().hash(_pendingServices),
    experienceYears,
    experienceDescription,
    const DeepCollectionEquality().hash(_portfolio),
    const DeepCollectionEquality().hash(_workPhotos),
    const DeepCollectionEquality().hash(_validatedCertifications),
    hasValidatedCertifications,
    averageRating,
    ratingCount,
    distanceKm,
    placement,
  ]);

  /// Create a copy of TechnicianPublicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianPublicModelImplCopyWith<_$TechnicianPublicModelImpl>
  get copyWith =>
      __$$TechnicianPublicModelImplCopyWithImpl<_$TechnicianPublicModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianPublicModelImplToJson(this);
  }
}

abstract class _TechnicianPublicModel implements TechnicianPublicModel {
  const factory _TechnicianPublicModel({
    required final int id,
    required final String name,
    final String? businessName,
    final String? displayName,
    final String? specialty,
    final String? profilePhotoUrl,
    final String? companyLogoUrl,
    final String profileType,
    final bool verified,
    final String? verificationStatus,
    final String? description,
    final double? minimumQuote,
    final String? phone,
    final String? address,
    final LocationModel? location,
    final int coverageRadiusKm,
    final bool coversAllPeru,
    final List<TechnicianCoverageDistrictModel> coverageDistricts,
    final WeeklyScheduleModel? schedule,
    final List<TechnicianSubcategoryModel> subcategories,
    final List<TechnicianSubSubCategoryModel> subSubCategories,
    final List<TechnicianPendingServiceModel> pendingServices,
    final int? experienceYears,
    final String? experienceDescription,
    final List<TechnicianPortfolioItemModel> portfolio,
    final List<TechnicianWorkPhotoModel> workPhotos,
    final List<TechnicianCertificationModel> validatedCertifications,
    final bool hasValidatedCertifications,
    final double? averageRating,
    final int ratingCount,
    final double? distanceKm,
    final String placement,
  }) = _$TechnicianPublicModelImpl;

  factory _TechnicianPublicModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianPublicModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;

  /// Razón social (empresa). Null en independiente.
  @override
  String? get businessName;

  /// Nombre público preferido del API (empresa → razón social).
  @override
  String? get displayName;
  @override
  String? get specialty;
  @override
  String? get profilePhotoUrl;

  /// Logo de empresa (cards / perfil público).
  @override
  String? get companyLogoUrl;
  @override
  String get profileType;
  @override
  bool get verified;
  @override
  String? get verificationStatus;
  @override
  String? get description;

  /// Cotización mínima referencial del perfil (piso comercial).
  @override
  double? get minimumQuote;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  LocationModel? get location;
  @override
  int get coverageRadiusKm;
  @override
  bool get coversAllPeru;
  @override
  List<TechnicianCoverageDistrictModel> get coverageDistricts;
  @override
  WeeklyScheduleModel? get schedule;
  @override
  List<TechnicianSubcategoryModel> get subcategories;
  @override
  List<TechnicianSubSubCategoryModel> get subSubCategories;
  @override
  List<TechnicianPendingServiceModel> get pendingServices;
  @override
  int? get experienceYears;
  @override
  String? get experienceDescription;
  @override
  List<TechnicianPortfolioItemModel> get portfolio;
  @override
  List<TechnicianWorkPhotoModel> get workPhotos;
  @override
  List<TechnicianCertificationModel> get validatedCertifications;
  @override
  bool get hasValidatedCertifications;
  @override
  double? get averageRating;
  @override
  int get ratingCount;
  @override
  double? get distanceKm;
  @override
  String get placement;

  /// Create a copy of TechnicianPublicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianPublicModelImplCopyWith<_$TechnicianPublicModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TechnicianApplicationModel _$TechnicianApplicationModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianApplicationModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianApplicationModel {
  @JsonKey(readValue: _technicianEntityId)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get specialty => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Cotización mínima referencial del perfil (piso comercial).
  double? get minimumQuote => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get documentType => throw _privateConstructorUsedError;
  String? get documentNumber => throw _privateConstructorUsedError;
  String? get documentImageUrl => throw _privateConstructorUsedError;
  String? get documentFrontImageUrl => throw _privateConstructorUsedError;
  String? get documentBackImageUrl => throw _privateConstructorUsedError;
  String? get facePhotoUrl => throw _privateConstructorUsedError;
  String? get rucDocumentUrl => throw _privateConstructorUsedError;
  String? get companyLogoUrl => throw _privateConstructorUsedError;
  String? get legalRepresentativeDocumentUrl =>
      throw _privateConstructorUsedError;
  String? get legalRepresentativeDocumentFrontUrl =>
      throw _privateConstructorUsedError;
  String? get legalRepresentativeDocumentBackUrl =>
      throw _privateConstructorUsedError;
  String get profileType => throw _privateConstructorUsedError;
  String? get ruc => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get legalRepresentativeName => throw _privateConstructorUsedError;
  String? get backgroundDeclaration => throw _privateConstructorUsedError;
  bool get backgroundVerified => throw _privateConstructorUsedError;
  LocationModel? get location => throw _privateConstructorUsedError;
  int get coverageRadiusKm => throw _privateConstructorUsedError;
  bool get coversAllPeru => throw _privateConstructorUsedError;
  List<TechnicianCoverageDistrictModel> get coverageDistricts =>
      throw _privateConstructorUsedError;
  bool get hasServiceArea => throw _privateConstructorUsedError;
  WeeklyScheduleModel? get schedule => throw _privateConstructorUsedError;
  List<TechnicianSubcategoryModel> get subcategories =>
      throw _privateConstructorUsedError;
  List<TechnicianSubSubCategoryModel> get subSubCategories =>
      throw _privateConstructorUsedError;
  List<TechnicianPendingServiceModel> get pendingServices =>
      throw _privateConstructorUsedError;
  int? get experienceYears => throw _privateConstructorUsedError;
  String? get experienceDescription => throw _privateConstructorUsedError;
  List<TechnicianPortfolioItemModel> get portfolio =>
      throw _privateConstructorUsedError;
  List<TechnicianWorkPhotoModel> get workPhotos =>
      throw _privateConstructorUsedError;
  List<TechnicianLicenseModel> get licenses =>
      throw _privateConstructorUsedError;
  List<TechnicianCertificationModel> get certifications =>
      throw _privateConstructorUsedError;
  List<TechnicianCertificationModel> get validatedCertifications =>
      throw _privateConstructorUsedError;
  String? get verificationStatus => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  bool get canEditProfile => throw _privateConstructorUsedError;
  bool get canResubmit => throw _privateConstructorUsedError;
  bool get canSubmitVerification => throw _privateConstructorUsedError;
  bool get canSubmitCertification => throw _privateConstructorUsedError;
  bool get certificationPending => throw _privateConstructorUsedError;
  bool get hasValidatedCertifications => throw _privateConstructorUsedError;
  double? get averageRating => throw _privateConstructorUsedError;
  int get ratingCount => throw _privateConstructorUsedError;

  /// Serializes this TechnicianApplicationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianApplicationModelCopyWith<TechnicianApplicationModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianApplicationModelCopyWith<$Res> {
  factory $TechnicianApplicationModelCopyWith(
    TechnicianApplicationModel value,
    $Res Function(TechnicianApplicationModel) then,
  ) =
      _$TechnicianApplicationModelCopyWithImpl<
        $Res,
        TechnicianApplicationModel
      >;
  @useResult
  $Res call({
    @JsonKey(readValue: _technicianEntityId) int id,
    String name,
    int? userId,
    String? email,
    String? specialty,
    String? profilePhotoUrl,
    String? description,
    double? minimumQuote,
    String? phone,
    String? address,
    String? documentType,
    String? documentNumber,
    String? documentImageUrl,
    String? documentFrontImageUrl,
    String? documentBackImageUrl,
    String? facePhotoUrl,
    String? rucDocumentUrl,
    String? companyLogoUrl,
    String? legalRepresentativeDocumentUrl,
    String? legalRepresentativeDocumentFrontUrl,
    String? legalRepresentativeDocumentBackUrl,
    String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
    String? backgroundDeclaration,
    bool backgroundVerified,
    LocationModel? location,
    int coverageRadiusKm,
    bool coversAllPeru,
    List<TechnicianCoverageDistrictModel> coverageDistricts,
    bool hasServiceArea,
    WeeklyScheduleModel? schedule,
    List<TechnicianSubcategoryModel> subcategories,
    List<TechnicianSubSubCategoryModel> subSubCategories,
    List<TechnicianPendingServiceModel> pendingServices,
    int? experienceYears,
    String? experienceDescription,
    List<TechnicianPortfolioItemModel> portfolio,
    List<TechnicianWorkPhotoModel> workPhotos,
    List<TechnicianLicenseModel> licenses,
    List<TechnicianCertificationModel> certifications,
    List<TechnicianCertificationModel> validatedCertifications,
    String? verificationStatus,
    bool verified,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    bool canEditProfile,
    bool canResubmit,
    bool canSubmitVerification,
    bool canSubmitCertification,
    bool certificationPending,
    bool hasValidatedCertifications,
    double? averageRating,
    int ratingCount,
  });

  $LocationModelCopyWith<$Res>? get location;
  $WeeklyScheduleModelCopyWith<$Res>? get schedule;
}

/// @nodoc
class _$TechnicianApplicationModelCopyWithImpl<
  $Res,
  $Val extends TechnicianApplicationModel
>
    implements $TechnicianApplicationModelCopyWith<$Res> {
  _$TechnicianApplicationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userId = freezed,
    Object? email = freezed,
    Object? specialty = freezed,
    Object? profilePhotoUrl = freezed,
    Object? description = freezed,
    Object? minimumQuote = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? documentType = freezed,
    Object? documentNumber = freezed,
    Object? documentImageUrl = freezed,
    Object? documentFrontImageUrl = freezed,
    Object? documentBackImageUrl = freezed,
    Object? facePhotoUrl = freezed,
    Object? rucDocumentUrl = freezed,
    Object? companyLogoUrl = freezed,
    Object? legalRepresentativeDocumentUrl = freezed,
    Object? legalRepresentativeDocumentFrontUrl = freezed,
    Object? legalRepresentativeDocumentBackUrl = freezed,
    Object? profileType = null,
    Object? ruc = freezed,
    Object? businessName = freezed,
    Object? legalRepresentativeName = freezed,
    Object? backgroundDeclaration = freezed,
    Object? backgroundVerified = null,
    Object? location = freezed,
    Object? coverageRadiusKm = null,
    Object? coversAllPeru = null,
    Object? coverageDistricts = null,
    Object? hasServiceArea = null,
    Object? schedule = freezed,
    Object? subcategories = null,
    Object? subSubCategories = null,
    Object? pendingServices = null,
    Object? experienceYears = freezed,
    Object? experienceDescription = freezed,
    Object? portfolio = null,
    Object? workPhotos = null,
    Object? licenses = null,
    Object? certifications = null,
    Object? validatedCertifications = null,
    Object? verificationStatus = freezed,
    Object? verified = null,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? canEditProfile = null,
    Object? canResubmit = null,
    Object? canSubmitVerification = null,
    Object? canSubmitCertification = null,
    Object? certificationPending = null,
    Object? hasValidatedCertifications = null,
    Object? averageRating = freezed,
    Object? ratingCount = null,
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
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            specialty: freezed == specialty
                ? _value.specialty
                : specialty // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            minimumQuote: freezed == minimumQuote
                ? _value.minimumQuote
                : minimumQuote // ignore: cast_nullable_to_non_nullable
                      as double?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentType: freezed == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentNumber: freezed == documentNumber
                ? _value.documentNumber
                : documentNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentImageUrl: freezed == documentImageUrl
                ? _value.documentImageUrl
                : documentImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentFrontImageUrl: freezed == documentFrontImageUrl
                ? _value.documentFrontImageUrl
                : documentFrontImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentBackImageUrl: freezed == documentBackImageUrl
                ? _value.documentBackImageUrl
                : documentBackImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            facePhotoUrl: freezed == facePhotoUrl
                ? _value.facePhotoUrl
                : facePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rucDocumentUrl: freezed == rucDocumentUrl
                ? _value.rucDocumentUrl
                : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyLogoUrl: freezed == companyLogoUrl
                ? _value.companyLogoUrl
                : companyLogoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalRepresentativeDocumentUrl:
                freezed == legalRepresentativeDocumentUrl
                ? _value.legalRepresentativeDocumentUrl
                : legalRepresentativeDocumentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalRepresentativeDocumentFrontUrl:
                freezed == legalRepresentativeDocumentFrontUrl
                ? _value.legalRepresentativeDocumentFrontUrl
                : legalRepresentativeDocumentFrontUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalRepresentativeDocumentBackUrl:
                freezed == legalRepresentativeDocumentBackUrl
                ? _value.legalRepresentativeDocumentBackUrl
                : legalRepresentativeDocumentBackUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileType: null == profileType
                ? _value.profileType
                : profileType // ignore: cast_nullable_to_non_nullable
                      as String,
            ruc: freezed == ruc
                ? _value.ruc
                : ruc // ignore: cast_nullable_to_non_nullable
                      as String?,
            businessName: freezed == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalRepresentativeName: freezed == legalRepresentativeName
                ? _value.legalRepresentativeName
                : legalRepresentativeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            backgroundDeclaration: freezed == backgroundDeclaration
                ? _value.backgroundDeclaration
                : backgroundDeclaration // ignore: cast_nullable_to_non_nullable
                      as String?,
            backgroundVerified: null == backgroundVerified
                ? _value.backgroundVerified
                : backgroundVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as LocationModel?,
            coverageRadiusKm: null == coverageRadiusKm
                ? _value.coverageRadiusKm
                : coverageRadiusKm // ignore: cast_nullable_to_non_nullable
                      as int,
            coversAllPeru: null == coversAllPeru
                ? _value.coversAllPeru
                : coversAllPeru // ignore: cast_nullable_to_non_nullable
                      as bool,
            coverageDistricts: null == coverageDistricts
                ? _value.coverageDistricts
                : coverageDistricts // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianCoverageDistrictModel>,
            hasServiceArea: null == hasServiceArea
                ? _value.hasServiceArea
                : hasServiceArea // ignore: cast_nullable_to_non_nullable
                      as bool,
            schedule: freezed == schedule
                ? _value.schedule
                : schedule // ignore: cast_nullable_to_non_nullable
                      as WeeklyScheduleModel?,
            subcategories: null == subcategories
                ? _value.subcategories
                : subcategories // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianSubcategoryModel>,
            subSubCategories: null == subSubCategories
                ? _value.subSubCategories
                : subSubCategories // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianSubSubCategoryModel>,
            pendingServices: null == pendingServices
                ? _value.pendingServices
                : pendingServices // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianPendingServiceModel>,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            experienceDescription: freezed == experienceDescription
                ? _value.experienceDescription
                : experienceDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            portfolio: null == portfolio
                ? _value.portfolio
                : portfolio // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianPortfolioItemModel>,
            workPhotos: null == workPhotos
                ? _value.workPhotos
                : workPhotos // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianWorkPhotoModel>,
            licenses: null == licenses
                ? _value.licenses
                : licenses // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianLicenseModel>,
            certifications: null == certifications
                ? _value.certifications
                : certifications // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianCertificationModel>,
            validatedCertifications: null == validatedCertifications
                ? _value.validatedCertifications
                : validatedCertifications // ignore: cast_nullable_to_non_nullable
                      as List<TechnicianCertificationModel>,
            verificationStatus: freezed == verificationStatus
                ? _value.verificationStatus
                : verificationStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reviewedAt: freezed == reviewedAt
                ? _value.reviewedAt
                : reviewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            canEditProfile: null == canEditProfile
                ? _value.canEditProfile
                : canEditProfile // ignore: cast_nullable_to_non_nullable
                      as bool,
            canResubmit: null == canResubmit
                ? _value.canResubmit
                : canResubmit // ignore: cast_nullable_to_non_nullable
                      as bool,
            canSubmitVerification: null == canSubmitVerification
                ? _value.canSubmitVerification
                : canSubmitVerification // ignore: cast_nullable_to_non_nullable
                      as bool,
            canSubmitCertification: null == canSubmitCertification
                ? _value.canSubmitCertification
                : canSubmitCertification // ignore: cast_nullable_to_non_nullable
                      as bool,
            certificationPending: null == certificationPending
                ? _value.certificationPending
                : certificationPending // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasValidatedCertifications: null == hasValidatedCertifications
                ? _value.hasValidatedCertifications
                : hasValidatedCertifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            averageRating: freezed == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double?,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of TechnicianApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationModelCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationModelCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of TechnicianApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklyScheduleModelCopyWith<$Res>? get schedule {
    if (_value.schedule == null) {
      return null;
    }

    return $WeeklyScheduleModelCopyWith<$Res>(_value.schedule!, (value) {
      return _then(_value.copyWith(schedule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TechnicianApplicationModelImplCopyWith<$Res>
    implements $TechnicianApplicationModelCopyWith<$Res> {
  factory _$$TechnicianApplicationModelImplCopyWith(
    _$TechnicianApplicationModelImpl value,
    $Res Function(_$TechnicianApplicationModelImpl) then,
  ) = __$$TechnicianApplicationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(readValue: _technicianEntityId) int id,
    String name,
    int? userId,
    String? email,
    String? specialty,
    String? profilePhotoUrl,
    String? description,
    double? minimumQuote,
    String? phone,
    String? address,
    String? documentType,
    String? documentNumber,
    String? documentImageUrl,
    String? documentFrontImageUrl,
    String? documentBackImageUrl,
    String? facePhotoUrl,
    String? rucDocumentUrl,
    String? companyLogoUrl,
    String? legalRepresentativeDocumentUrl,
    String? legalRepresentativeDocumentFrontUrl,
    String? legalRepresentativeDocumentBackUrl,
    String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
    String? backgroundDeclaration,
    bool backgroundVerified,
    LocationModel? location,
    int coverageRadiusKm,
    bool coversAllPeru,
    List<TechnicianCoverageDistrictModel> coverageDistricts,
    bool hasServiceArea,
    WeeklyScheduleModel? schedule,
    List<TechnicianSubcategoryModel> subcategories,
    List<TechnicianSubSubCategoryModel> subSubCategories,
    List<TechnicianPendingServiceModel> pendingServices,
    int? experienceYears,
    String? experienceDescription,
    List<TechnicianPortfolioItemModel> portfolio,
    List<TechnicianWorkPhotoModel> workPhotos,
    List<TechnicianLicenseModel> licenses,
    List<TechnicianCertificationModel> certifications,
    List<TechnicianCertificationModel> validatedCertifications,
    String? verificationStatus,
    bool verified,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    bool canEditProfile,
    bool canResubmit,
    bool canSubmitVerification,
    bool canSubmitCertification,
    bool certificationPending,
    bool hasValidatedCertifications,
    double? averageRating,
    int ratingCount,
  });

  @override
  $LocationModelCopyWith<$Res>? get location;
  @override
  $WeeklyScheduleModelCopyWith<$Res>? get schedule;
}

/// @nodoc
class __$$TechnicianApplicationModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianApplicationModelCopyWithImpl<
          $Res,
          _$TechnicianApplicationModelImpl
        >
    implements _$$TechnicianApplicationModelImplCopyWith<$Res> {
  __$$TechnicianApplicationModelImplCopyWithImpl(
    _$TechnicianApplicationModelImpl _value,
    $Res Function(_$TechnicianApplicationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userId = freezed,
    Object? email = freezed,
    Object? specialty = freezed,
    Object? profilePhotoUrl = freezed,
    Object? description = freezed,
    Object? minimumQuote = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? documentType = freezed,
    Object? documentNumber = freezed,
    Object? documentImageUrl = freezed,
    Object? documentFrontImageUrl = freezed,
    Object? documentBackImageUrl = freezed,
    Object? facePhotoUrl = freezed,
    Object? rucDocumentUrl = freezed,
    Object? companyLogoUrl = freezed,
    Object? legalRepresentativeDocumentUrl = freezed,
    Object? legalRepresentativeDocumentFrontUrl = freezed,
    Object? legalRepresentativeDocumentBackUrl = freezed,
    Object? profileType = null,
    Object? ruc = freezed,
    Object? businessName = freezed,
    Object? legalRepresentativeName = freezed,
    Object? backgroundDeclaration = freezed,
    Object? backgroundVerified = null,
    Object? location = freezed,
    Object? coverageRadiusKm = null,
    Object? coversAllPeru = null,
    Object? coverageDistricts = null,
    Object? hasServiceArea = null,
    Object? schedule = freezed,
    Object? subcategories = null,
    Object? subSubCategories = null,
    Object? pendingServices = null,
    Object? experienceYears = freezed,
    Object? experienceDescription = freezed,
    Object? portfolio = null,
    Object? workPhotos = null,
    Object? licenses = null,
    Object? certifications = null,
    Object? validatedCertifications = null,
    Object? verificationStatus = freezed,
    Object? verified = null,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? canEditProfile = null,
    Object? canResubmit = null,
    Object? canSubmitVerification = null,
    Object? canSubmitCertification = null,
    Object? certificationPending = null,
    Object? hasValidatedCertifications = null,
    Object? averageRating = freezed,
    Object? ratingCount = null,
  }) {
    return _then(
      _$TechnicianApplicationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        specialty: freezed == specialty
            ? _value.specialty
            : specialty // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        minimumQuote: freezed == minimumQuote
            ? _value.minimumQuote
            : minimumQuote // ignore: cast_nullable_to_non_nullable
                  as double?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentType: freezed == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentNumber: freezed == documentNumber
            ? _value.documentNumber
            : documentNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentImageUrl: freezed == documentImageUrl
            ? _value.documentImageUrl
            : documentImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentFrontImageUrl: freezed == documentFrontImageUrl
            ? _value.documentFrontImageUrl
            : documentFrontImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentBackImageUrl: freezed == documentBackImageUrl
            ? _value.documentBackImageUrl
            : documentBackImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        facePhotoUrl: freezed == facePhotoUrl
            ? _value.facePhotoUrl
            : facePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rucDocumentUrl: freezed == rucDocumentUrl
            ? _value.rucDocumentUrl
            : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyLogoUrl: freezed == companyLogoUrl
            ? _value.companyLogoUrl
            : companyLogoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalRepresentativeDocumentUrl:
            freezed == legalRepresentativeDocumentUrl
            ? _value.legalRepresentativeDocumentUrl
            : legalRepresentativeDocumentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalRepresentativeDocumentFrontUrl:
            freezed == legalRepresentativeDocumentFrontUrl
            ? _value.legalRepresentativeDocumentFrontUrl
            : legalRepresentativeDocumentFrontUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalRepresentativeDocumentBackUrl:
            freezed == legalRepresentativeDocumentBackUrl
            ? _value.legalRepresentativeDocumentBackUrl
            : legalRepresentativeDocumentBackUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileType: null == profileType
            ? _value.profileType
            : profileType // ignore: cast_nullable_to_non_nullable
                  as String,
        ruc: freezed == ruc
            ? _value.ruc
            : ruc // ignore: cast_nullable_to_non_nullable
                  as String?,
        businessName: freezed == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalRepresentativeName: freezed == legalRepresentativeName
            ? _value.legalRepresentativeName
            : legalRepresentativeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        backgroundDeclaration: freezed == backgroundDeclaration
            ? _value.backgroundDeclaration
            : backgroundDeclaration // ignore: cast_nullable_to_non_nullable
                  as String?,
        backgroundVerified: null == backgroundVerified
            ? _value.backgroundVerified
            : backgroundVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as LocationModel?,
        coverageRadiusKm: null == coverageRadiusKm
            ? _value.coverageRadiusKm
            : coverageRadiusKm // ignore: cast_nullable_to_non_nullable
                  as int,
        coversAllPeru: null == coversAllPeru
            ? _value.coversAllPeru
            : coversAllPeru // ignore: cast_nullable_to_non_nullable
                  as bool,
        coverageDistricts: null == coverageDistricts
            ? _value._coverageDistricts
            : coverageDistricts // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianCoverageDistrictModel>,
        hasServiceArea: null == hasServiceArea
            ? _value.hasServiceArea
            : hasServiceArea // ignore: cast_nullable_to_non_nullable
                  as bool,
        schedule: freezed == schedule
            ? _value.schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as WeeklyScheduleModel?,
        subcategories: null == subcategories
            ? _value._subcategories
            : subcategories // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianSubcategoryModel>,
        subSubCategories: null == subSubCategories
            ? _value._subSubCategories
            : subSubCategories // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianSubSubCategoryModel>,
        pendingServices: null == pendingServices
            ? _value._pendingServices
            : pendingServices // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianPendingServiceModel>,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        experienceDescription: freezed == experienceDescription
            ? _value.experienceDescription
            : experienceDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        portfolio: null == portfolio
            ? _value._portfolio
            : portfolio // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianPortfolioItemModel>,
        workPhotos: null == workPhotos
            ? _value._workPhotos
            : workPhotos // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianWorkPhotoModel>,
        licenses: null == licenses
            ? _value._licenses
            : licenses // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianLicenseModel>,
        certifications: null == certifications
            ? _value._certifications
            : certifications // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianCertificationModel>,
        validatedCertifications: null == validatedCertifications
            ? _value._validatedCertifications
            : validatedCertifications // ignore: cast_nullable_to_non_nullable
                  as List<TechnicianCertificationModel>,
        verificationStatus: freezed == verificationStatus
            ? _value.verificationStatus
            : verificationStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewedAt: freezed == reviewedAt
            ? _value.reviewedAt
            : reviewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        canEditProfile: null == canEditProfile
            ? _value.canEditProfile
            : canEditProfile // ignore: cast_nullable_to_non_nullable
                  as bool,
        canResubmit: null == canResubmit
            ? _value.canResubmit
            : canResubmit // ignore: cast_nullable_to_non_nullable
                  as bool,
        canSubmitVerification: null == canSubmitVerification
            ? _value.canSubmitVerification
            : canSubmitVerification // ignore: cast_nullable_to_non_nullable
                  as bool,
        canSubmitCertification: null == canSubmitCertification
            ? _value.canSubmitCertification
            : canSubmitCertification // ignore: cast_nullable_to_non_nullable
                  as bool,
        certificationPending: null == certificationPending
            ? _value.certificationPending
            : certificationPending // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasValidatedCertifications: null == hasValidatedCertifications
            ? _value.hasValidatedCertifications
            : hasValidatedCertifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        averageRating: freezed == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double?,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianApplicationModelImpl implements _TechnicianApplicationModel {
  const _$TechnicianApplicationModelImpl({
    @JsonKey(readValue: _technicianEntityId) required this.id,
    required this.name,
    this.userId,
    this.email,
    this.specialty,
    this.profilePhotoUrl,
    this.description,
    this.minimumQuote,
    this.phone,
    this.address,
    this.documentType,
    this.documentNumber,
    this.documentImageUrl,
    this.documentFrontImageUrl,
    this.documentBackImageUrl,
    this.facePhotoUrl,
    this.rucDocumentUrl,
    this.companyLogoUrl,
    this.legalRepresentativeDocumentUrl,
    this.legalRepresentativeDocumentFrontUrl,
    this.legalRepresentativeDocumentBackUrl,
    this.profileType = 'independiente',
    this.ruc,
    this.businessName,
    this.legalRepresentativeName,
    this.backgroundDeclaration,
    this.backgroundVerified = false,
    this.location,
    this.coverageRadiusKm = 10,
    this.coversAllPeru = false,
    final List<TechnicianCoverageDistrictModel> coverageDistricts = const [],
    this.hasServiceArea = false,
    this.schedule,
    final List<TechnicianSubcategoryModel> subcategories = const [],
    final List<TechnicianSubSubCategoryModel> subSubCategories = const [],
    final List<TechnicianPendingServiceModel> pendingServices = const [],
    this.experienceYears,
    this.experienceDescription,
    final List<TechnicianPortfolioItemModel> portfolio = const [],
    final List<TechnicianWorkPhotoModel> workPhotos = const [],
    final List<TechnicianLicenseModel> licenses = const [],
    final List<TechnicianCertificationModel> certifications = const [],
    final List<TechnicianCertificationModel> validatedCertifications = const [],
    this.verificationStatus,
    this.verified = false,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    this.canEditProfile = false,
    this.canResubmit = false,
    this.canSubmitVerification = false,
    this.canSubmitCertification = false,
    this.certificationPending = false,
    this.hasValidatedCertifications = false,
    this.averageRating,
    this.ratingCount = 0,
  }) : _coverageDistricts = coverageDistricts,
       _subcategories = subcategories,
       _subSubCategories = subSubCategories,
       _pendingServices = pendingServices,
       _portfolio = portfolio,
       _workPhotos = workPhotos,
       _licenses = licenses,
       _certifications = certifications,
       _validatedCertifications = validatedCertifications;

  factory _$TechnicianApplicationModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianApplicationModelImplFromJson(json);

  @override
  @JsonKey(readValue: _technicianEntityId)
  final int id;
  @override
  final String name;
  @override
  final int? userId;
  @override
  final String? email;
  @override
  final String? specialty;
  @override
  final String? profilePhotoUrl;
  @override
  final String? description;

  /// Cotización mínima referencial del perfil (piso comercial).
  @override
  final double? minimumQuote;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String? documentType;
  @override
  final String? documentNumber;
  @override
  final String? documentImageUrl;
  @override
  final String? documentFrontImageUrl;
  @override
  final String? documentBackImageUrl;
  @override
  final String? facePhotoUrl;
  @override
  final String? rucDocumentUrl;
  @override
  final String? companyLogoUrl;
  @override
  final String? legalRepresentativeDocumentUrl;
  @override
  final String? legalRepresentativeDocumentFrontUrl;
  @override
  final String? legalRepresentativeDocumentBackUrl;
  @override
  @JsonKey()
  final String profileType;
  @override
  final String? ruc;
  @override
  final String? businessName;
  @override
  final String? legalRepresentativeName;
  @override
  final String? backgroundDeclaration;
  @override
  @JsonKey()
  final bool backgroundVerified;
  @override
  final LocationModel? location;
  @override
  @JsonKey()
  final int coverageRadiusKm;
  @override
  @JsonKey()
  final bool coversAllPeru;
  final List<TechnicianCoverageDistrictModel> _coverageDistricts;
  @override
  @JsonKey()
  List<TechnicianCoverageDistrictModel> get coverageDistricts {
    if (_coverageDistricts is EqualUnmodifiableListView)
      return _coverageDistricts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coverageDistricts);
  }

  @override
  @JsonKey()
  final bool hasServiceArea;
  @override
  final WeeklyScheduleModel? schedule;
  final List<TechnicianSubcategoryModel> _subcategories;
  @override
  @JsonKey()
  List<TechnicianSubcategoryModel> get subcategories {
    if (_subcategories is EqualUnmodifiableListView) return _subcategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategories);
  }

  final List<TechnicianSubSubCategoryModel> _subSubCategories;
  @override
  @JsonKey()
  List<TechnicianSubSubCategoryModel> get subSubCategories {
    if (_subSubCategories is EqualUnmodifiableListView)
      return _subSubCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subSubCategories);
  }

  final List<TechnicianPendingServiceModel> _pendingServices;
  @override
  @JsonKey()
  List<TechnicianPendingServiceModel> get pendingServices {
    if (_pendingServices is EqualUnmodifiableListView) return _pendingServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingServices);
  }

  @override
  final int? experienceYears;
  @override
  final String? experienceDescription;
  final List<TechnicianPortfolioItemModel> _portfolio;
  @override
  @JsonKey()
  List<TechnicianPortfolioItemModel> get portfolio {
    if (_portfolio is EqualUnmodifiableListView) return _portfolio;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_portfolio);
  }

  final List<TechnicianWorkPhotoModel> _workPhotos;
  @override
  @JsonKey()
  List<TechnicianWorkPhotoModel> get workPhotos {
    if (_workPhotos is EqualUnmodifiableListView) return _workPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workPhotos);
  }

  final List<TechnicianLicenseModel> _licenses;
  @override
  @JsonKey()
  List<TechnicianLicenseModel> get licenses {
    if (_licenses is EqualUnmodifiableListView) return _licenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_licenses);
  }

  final List<TechnicianCertificationModel> _certifications;
  @override
  @JsonKey()
  List<TechnicianCertificationModel> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  final List<TechnicianCertificationModel> _validatedCertifications;
  @override
  @JsonKey()
  List<TechnicianCertificationModel> get validatedCertifications {
    if (_validatedCertifications is EqualUnmodifiableListView)
      return _validatedCertifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_validatedCertifications);
  }

  @override
  final String? verificationStatus;
  @override
  @JsonKey()
  final bool verified;
  @override
  final String? rejectionReason;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? reviewedAt;
  @override
  @JsonKey()
  final bool canEditProfile;
  @override
  @JsonKey()
  final bool canResubmit;
  @override
  @JsonKey()
  final bool canSubmitVerification;
  @override
  @JsonKey()
  final bool canSubmitCertification;
  @override
  @JsonKey()
  final bool certificationPending;
  @override
  @JsonKey()
  final bool hasValidatedCertifications;
  @override
  final double? averageRating;
  @override
  @JsonKey()
  final int ratingCount;

  @override
  String toString() {
    return 'TechnicianApplicationModel(id: $id, name: $name, userId: $userId, email: $email, specialty: $specialty, profilePhotoUrl: $profilePhotoUrl, description: $description, minimumQuote: $minimumQuote, phone: $phone, address: $address, documentType: $documentType, documentNumber: $documentNumber, documentImageUrl: $documentImageUrl, documentFrontImageUrl: $documentFrontImageUrl, documentBackImageUrl: $documentBackImageUrl, facePhotoUrl: $facePhotoUrl, rucDocumentUrl: $rucDocumentUrl, companyLogoUrl: $companyLogoUrl, legalRepresentativeDocumentUrl: $legalRepresentativeDocumentUrl, legalRepresentativeDocumentFrontUrl: $legalRepresentativeDocumentFrontUrl, legalRepresentativeDocumentBackUrl: $legalRepresentativeDocumentBackUrl, profileType: $profileType, ruc: $ruc, businessName: $businessName, legalRepresentativeName: $legalRepresentativeName, backgroundDeclaration: $backgroundDeclaration, backgroundVerified: $backgroundVerified, location: $location, coverageRadiusKm: $coverageRadiusKm, coversAllPeru: $coversAllPeru, coverageDistricts: $coverageDistricts, hasServiceArea: $hasServiceArea, schedule: $schedule, subcategories: $subcategories, subSubCategories: $subSubCategories, pendingServices: $pendingServices, experienceYears: $experienceYears, experienceDescription: $experienceDescription, portfolio: $portfolio, workPhotos: $workPhotos, licenses: $licenses, certifications: $certifications, validatedCertifications: $validatedCertifications, verificationStatus: $verificationStatus, verified: $verified, rejectionReason: $rejectionReason, submittedAt: $submittedAt, reviewedAt: $reviewedAt, canEditProfile: $canEditProfile, canResubmit: $canResubmit, canSubmitVerification: $canSubmitVerification, canSubmitCertification: $canSubmitCertification, certificationPending: $certificationPending, hasValidatedCertifications: $hasValidatedCertifications, averageRating: $averageRating, ratingCount: $ratingCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianApplicationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.specialty, specialty) ||
                other.specialty == specialty) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.minimumQuote, minimumQuote) ||
                other.minimumQuote == minimumQuote) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.documentImageUrl, documentImageUrl) ||
                other.documentImageUrl == documentImageUrl) &&
            (identical(other.documentFrontImageUrl, documentFrontImageUrl) ||
                other.documentFrontImageUrl == documentFrontImageUrl) &&
            (identical(other.documentBackImageUrl, documentBackImageUrl) ||
                other.documentBackImageUrl == documentBackImageUrl) &&
            (identical(other.facePhotoUrl, facePhotoUrl) ||
                other.facePhotoUrl == facePhotoUrl) &&
            (identical(other.rucDocumentUrl, rucDocumentUrl) ||
                other.rucDocumentUrl == rucDocumentUrl) &&
            (identical(other.companyLogoUrl, companyLogoUrl) ||
                other.companyLogoUrl == companyLogoUrl) &&
            (identical(
                  other.legalRepresentativeDocumentUrl,
                  legalRepresentativeDocumentUrl,
                ) ||
                other.legalRepresentativeDocumentUrl ==
                    legalRepresentativeDocumentUrl) &&
            (identical(
                  other.legalRepresentativeDocumentFrontUrl,
                  legalRepresentativeDocumentFrontUrl,
                ) ||
                other.legalRepresentativeDocumentFrontUrl ==
                    legalRepresentativeDocumentFrontUrl) &&
            (identical(
                  other.legalRepresentativeDocumentBackUrl,
                  legalRepresentativeDocumentBackUrl,
                ) ||
                other.legalRepresentativeDocumentBackUrl ==
                    legalRepresentativeDocumentBackUrl) &&
            (identical(other.profileType, profileType) ||
                other.profileType == profileType) &&
            (identical(other.ruc, ruc) || other.ruc == ruc) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(
                  other.legalRepresentativeName,
                  legalRepresentativeName,
                ) ||
                other.legalRepresentativeName == legalRepresentativeName) &&
            (identical(other.backgroundDeclaration, backgroundDeclaration) ||
                other.backgroundDeclaration == backgroundDeclaration) &&
            (identical(other.backgroundVerified, backgroundVerified) ||
                other.backgroundVerified == backgroundVerified) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.coverageRadiusKm, coverageRadiusKm) ||
                other.coverageRadiusKm == coverageRadiusKm) &&
            (identical(other.coversAllPeru, coversAllPeru) ||
                other.coversAllPeru == coversAllPeru) &&
            const DeepCollectionEquality().equals(
              other._coverageDistricts,
              _coverageDistricts,
            ) &&
            (identical(other.hasServiceArea, hasServiceArea) ||
                other.hasServiceArea == hasServiceArea) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            const DeepCollectionEquality().equals(
              other._subcategories,
              _subcategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._subSubCategories,
              _subSubCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._pendingServices,
              _pendingServices,
            ) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.experienceDescription, experienceDescription) ||
                other.experienceDescription == experienceDescription) &&
            const DeepCollectionEquality().equals(
              other._portfolio,
              _portfolio,
            ) &&
            const DeepCollectionEquality().equals(
              other._workPhotos,
              _workPhotos,
            ) &&
            const DeepCollectionEquality().equals(other._licenses, _licenses) &&
            const DeepCollectionEquality().equals(
              other._certifications,
              _certifications,
            ) &&
            const DeepCollectionEquality().equals(
              other._validatedCertifications,
              _validatedCertifications,
            ) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.canEditProfile, canEditProfile) ||
                other.canEditProfile == canEditProfile) &&
            (identical(other.canResubmit, canResubmit) ||
                other.canResubmit == canResubmit) &&
            (identical(other.canSubmitVerification, canSubmitVerification) ||
                other.canSubmitVerification == canSubmitVerification) &&
            (identical(other.canSubmitCertification, canSubmitCertification) ||
                other.canSubmitCertification == canSubmitCertification) &&
            (identical(other.certificationPending, certificationPending) ||
                other.certificationPending == certificationPending) &&
            (identical(
                  other.hasValidatedCertifications,
                  hasValidatedCertifications,
                ) ||
                other.hasValidatedCertifications ==
                    hasValidatedCertifications) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    userId,
    email,
    specialty,
    profilePhotoUrl,
    description,
    minimumQuote,
    phone,
    address,
    documentType,
    documentNumber,
    documentImageUrl,
    documentFrontImageUrl,
    documentBackImageUrl,
    facePhotoUrl,
    rucDocumentUrl,
    companyLogoUrl,
    legalRepresentativeDocumentUrl,
    legalRepresentativeDocumentFrontUrl,
    legalRepresentativeDocumentBackUrl,
    profileType,
    ruc,
    businessName,
    legalRepresentativeName,
    backgroundDeclaration,
    backgroundVerified,
    location,
    coverageRadiusKm,
    coversAllPeru,
    const DeepCollectionEquality().hash(_coverageDistricts),
    hasServiceArea,
    schedule,
    const DeepCollectionEquality().hash(_subcategories),
    const DeepCollectionEquality().hash(_subSubCategories),
    const DeepCollectionEquality().hash(_pendingServices),
    experienceYears,
    experienceDescription,
    const DeepCollectionEquality().hash(_portfolio),
    const DeepCollectionEquality().hash(_workPhotos),
    const DeepCollectionEquality().hash(_licenses),
    const DeepCollectionEquality().hash(_certifications),
    const DeepCollectionEquality().hash(_validatedCertifications),
    verificationStatus,
    verified,
    rejectionReason,
    submittedAt,
    reviewedAt,
    canEditProfile,
    canResubmit,
    canSubmitVerification,
    canSubmitCertification,
    certificationPending,
    hasValidatedCertifications,
    averageRating,
    ratingCount,
  ]);

  /// Create a copy of TechnicianApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianApplicationModelImplCopyWith<_$TechnicianApplicationModelImpl>
  get copyWith =>
      __$$TechnicianApplicationModelImplCopyWithImpl<
        _$TechnicianApplicationModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianApplicationModelImplToJson(this);
  }
}

abstract class _TechnicianApplicationModel
    implements TechnicianApplicationModel {
  const factory _TechnicianApplicationModel({
    @JsonKey(readValue: _technicianEntityId) required final int id,
    required final String name,
    final int? userId,
    final String? email,
    final String? specialty,
    final String? profilePhotoUrl,
    final String? description,
    final double? minimumQuote,
    final String? phone,
    final String? address,
    final String? documentType,
    final String? documentNumber,
    final String? documentImageUrl,
    final String? documentFrontImageUrl,
    final String? documentBackImageUrl,
    final String? facePhotoUrl,
    final String? rucDocumentUrl,
    final String? companyLogoUrl,
    final String? legalRepresentativeDocumentUrl,
    final String? legalRepresentativeDocumentFrontUrl,
    final String? legalRepresentativeDocumentBackUrl,
    final String profileType,
    final String? ruc,
    final String? businessName,
    final String? legalRepresentativeName,
    final String? backgroundDeclaration,
    final bool backgroundVerified,
    final LocationModel? location,
    final int coverageRadiusKm,
    final bool coversAllPeru,
    final List<TechnicianCoverageDistrictModel> coverageDistricts,
    final bool hasServiceArea,
    final WeeklyScheduleModel? schedule,
    final List<TechnicianSubcategoryModel> subcategories,
    final List<TechnicianSubSubCategoryModel> subSubCategories,
    final List<TechnicianPendingServiceModel> pendingServices,
    final int? experienceYears,
    final String? experienceDescription,
    final List<TechnicianPortfolioItemModel> portfolio,
    final List<TechnicianWorkPhotoModel> workPhotos,
    final List<TechnicianLicenseModel> licenses,
    final List<TechnicianCertificationModel> certifications,
    final List<TechnicianCertificationModel> validatedCertifications,
    final String? verificationStatus,
    final bool verified,
    final String? rejectionReason,
    final DateTime? submittedAt,
    final DateTime? reviewedAt,
    final bool canEditProfile,
    final bool canResubmit,
    final bool canSubmitVerification,
    final bool canSubmitCertification,
    final bool certificationPending,
    final bool hasValidatedCertifications,
    final double? averageRating,
    final int ratingCount,
  }) = _$TechnicianApplicationModelImpl;

  factory _TechnicianApplicationModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianApplicationModelImpl.fromJson;

  @override
  @JsonKey(readValue: _technicianEntityId)
  int get id;
  @override
  String get name;
  @override
  int? get userId;
  @override
  String? get email;
  @override
  String? get specialty;
  @override
  String? get profilePhotoUrl;
  @override
  String? get description;

  /// Cotización mínima referencial del perfil (piso comercial).
  @override
  double? get minimumQuote;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String? get documentType;
  @override
  String? get documentNumber;
  @override
  String? get documentImageUrl;
  @override
  String? get documentFrontImageUrl;
  @override
  String? get documentBackImageUrl;
  @override
  String? get facePhotoUrl;
  @override
  String? get rucDocumentUrl;
  @override
  String? get companyLogoUrl;
  @override
  String? get legalRepresentativeDocumentUrl;
  @override
  String? get legalRepresentativeDocumentFrontUrl;
  @override
  String? get legalRepresentativeDocumentBackUrl;
  @override
  String get profileType;
  @override
  String? get ruc;
  @override
  String? get businessName;
  @override
  String? get legalRepresentativeName;
  @override
  String? get backgroundDeclaration;
  @override
  bool get backgroundVerified;
  @override
  LocationModel? get location;
  @override
  int get coverageRadiusKm;
  @override
  bool get coversAllPeru;
  @override
  List<TechnicianCoverageDistrictModel> get coverageDistricts;
  @override
  bool get hasServiceArea;
  @override
  WeeklyScheduleModel? get schedule;
  @override
  List<TechnicianSubcategoryModel> get subcategories;
  @override
  List<TechnicianSubSubCategoryModel> get subSubCategories;
  @override
  List<TechnicianPendingServiceModel> get pendingServices;
  @override
  int? get experienceYears;
  @override
  String? get experienceDescription;
  @override
  List<TechnicianPortfolioItemModel> get portfolio;
  @override
  List<TechnicianWorkPhotoModel> get workPhotos;
  @override
  List<TechnicianLicenseModel> get licenses;
  @override
  List<TechnicianCertificationModel> get certifications;
  @override
  List<TechnicianCertificationModel> get validatedCertifications;
  @override
  String? get verificationStatus;
  @override
  bool get verified;
  @override
  String? get rejectionReason;
  @override
  DateTime? get submittedAt;
  @override
  DateTime? get reviewedAt;
  @override
  bool get canEditProfile;
  @override
  bool get canResubmit;
  @override
  bool get canSubmitVerification;
  @override
  bool get canSubmitCertification;
  @override
  bool get certificationPending;
  @override
  bool get hasValidatedCertifications;
  @override
  double? get averageRating;
  @override
  int get ratingCount;

  /// Create a copy of TechnicianApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianApplicationModelImplCopyWith<_$TechnicianApplicationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UpdateTechnicianProfileRequest _$UpdateTechnicianProfileRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateTechnicianProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateTechnicianProfileRequest {
  String? get name => throw _privateConstructorUsedError;
  String? get specialty => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Cotización mínima. Enviar número como texto; '' limpia el valor en API.
  /// Null = no actualizar (includeIfNull: false + sanitize).
  @JsonKey(includeIfNull: false)
  String? get minimumQuote => throw _privateConstructorUsedError;
  int? get experienceYears => throw _privateConstructorUsedError;
  String? get experienceDescription => throw _privateConstructorUsedError;
  LocationModel? get location => throw _privateConstructorUsedError;
  int? get coverageRadiusKm => throw _privateConstructorUsedError;
  bool? get coversAllPeru => throw _privateConstructorUsedError;
  List<int>? get coveragePlaceIds => throw _privateConstructorUsedError;
  int? get primaryCoveragePlaceId => throw _privateConstructorUsedError;
  WeeklyScheduleModel? get schedule => throw _privateConstructorUsedError;
  List<int>? get subcategoryIds => throw _privateConstructorUsedError;
  List<SubcategoryPricingInputModel>? get subcategoryPricing =>
      throw _privateConstructorUsedError;
  List<int>? get subSubCategoryIds => throw _privateConstructorUsedError;
  List<WorkPhotoInputModel>? get workPhotos =>
      throw _privateConstructorUsedError;
  List<PortfolioItemInputModel>? get portfolio =>
      throw _privateConstructorUsedError;

  /// Serializes this UpdateTechnicianProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateTechnicianProfileRequestCopyWith<UpdateTechnicianProfileRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTechnicianProfileRequestCopyWith<$Res> {
  factory $UpdateTechnicianProfileRequestCopyWith(
    UpdateTechnicianProfileRequest value,
    $Res Function(UpdateTechnicianProfileRequest) then,
  ) =
      _$UpdateTechnicianProfileRequestCopyWithImpl<
        $Res,
        UpdateTechnicianProfileRequest
      >;
  @useResult
  $Res call({
    String? name,
    String? specialty,
    String? phone,
    String? address,
    String? profilePhotoUrl,
    String? description,
    @JsonKey(includeIfNull: false) String? minimumQuote,
    int? experienceYears,
    String? experienceDescription,
    LocationModel? location,
    int? coverageRadiusKm,
    bool? coversAllPeru,
    List<int>? coveragePlaceIds,
    int? primaryCoveragePlaceId,
    WeeklyScheduleModel? schedule,
    List<int>? subcategoryIds,
    List<SubcategoryPricingInputModel>? subcategoryPricing,
    List<int>? subSubCategoryIds,
    List<WorkPhotoInputModel>? workPhotos,
    List<PortfolioItemInputModel>? portfolio,
  });

  $LocationModelCopyWith<$Res>? get location;
  $WeeklyScheduleModelCopyWith<$Res>? get schedule;
}

/// @nodoc
class _$UpdateTechnicianProfileRequestCopyWithImpl<
  $Res,
  $Val extends UpdateTechnicianProfileRequest
>
    implements $UpdateTechnicianProfileRequestCopyWith<$Res> {
  _$UpdateTechnicianProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? specialty = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? profilePhotoUrl = freezed,
    Object? description = freezed,
    Object? minimumQuote = freezed,
    Object? experienceYears = freezed,
    Object? experienceDescription = freezed,
    Object? location = freezed,
    Object? coverageRadiusKm = freezed,
    Object? coversAllPeru = freezed,
    Object? coveragePlaceIds = freezed,
    Object? primaryCoveragePlaceId = freezed,
    Object? schedule = freezed,
    Object? subcategoryIds = freezed,
    Object? subcategoryPricing = freezed,
    Object? subSubCategoryIds = freezed,
    Object? workPhotos = freezed,
    Object? portfolio = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            specialty: freezed == specialty
                ? _value.specialty
                : specialty // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            minimumQuote: freezed == minimumQuote
                ? _value.minimumQuote
                : minimumQuote // ignore: cast_nullable_to_non_nullable
                      as String?,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            experienceDescription: freezed == experienceDescription
                ? _value.experienceDescription
                : experienceDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as LocationModel?,
            coverageRadiusKm: freezed == coverageRadiusKm
                ? _value.coverageRadiusKm
                : coverageRadiusKm // ignore: cast_nullable_to_non_nullable
                      as int?,
            coversAllPeru: freezed == coversAllPeru
                ? _value.coversAllPeru
                : coversAllPeru // ignore: cast_nullable_to_non_nullable
                      as bool?,
            coveragePlaceIds: freezed == coveragePlaceIds
                ? _value.coveragePlaceIds
                : coveragePlaceIds // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            primaryCoveragePlaceId: freezed == primaryCoveragePlaceId
                ? _value.primaryCoveragePlaceId
                : primaryCoveragePlaceId // ignore: cast_nullable_to_non_nullable
                      as int?,
            schedule: freezed == schedule
                ? _value.schedule
                : schedule // ignore: cast_nullable_to_non_nullable
                      as WeeklyScheduleModel?,
            subcategoryIds: freezed == subcategoryIds
                ? _value.subcategoryIds
                : subcategoryIds // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            subcategoryPricing: freezed == subcategoryPricing
                ? _value.subcategoryPricing
                : subcategoryPricing // ignore: cast_nullable_to_non_nullable
                      as List<SubcategoryPricingInputModel>?,
            subSubCategoryIds: freezed == subSubCategoryIds
                ? _value.subSubCategoryIds
                : subSubCategoryIds // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            workPhotos: freezed == workPhotos
                ? _value.workPhotos
                : workPhotos // ignore: cast_nullable_to_non_nullable
                      as List<WorkPhotoInputModel>?,
            portfolio: freezed == portfolio
                ? _value.portfolio
                : portfolio // ignore: cast_nullable_to_non_nullable
                      as List<PortfolioItemInputModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of UpdateTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationModelCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationModelCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of UpdateTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklyScheduleModelCopyWith<$Res>? get schedule {
    if (_value.schedule == null) {
      return null;
    }

    return $WeeklyScheduleModelCopyWith<$Res>(_value.schedule!, (value) {
      return _then(_value.copyWith(schedule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateTechnicianProfileRequestImplCopyWith<$Res>
    implements $UpdateTechnicianProfileRequestCopyWith<$Res> {
  factory _$$UpdateTechnicianProfileRequestImplCopyWith(
    _$UpdateTechnicianProfileRequestImpl value,
    $Res Function(_$UpdateTechnicianProfileRequestImpl) then,
  ) = __$$UpdateTechnicianProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    String? specialty,
    String? phone,
    String? address,
    String? profilePhotoUrl,
    String? description,
    @JsonKey(includeIfNull: false) String? minimumQuote,
    int? experienceYears,
    String? experienceDescription,
    LocationModel? location,
    int? coverageRadiusKm,
    bool? coversAllPeru,
    List<int>? coveragePlaceIds,
    int? primaryCoveragePlaceId,
    WeeklyScheduleModel? schedule,
    List<int>? subcategoryIds,
    List<SubcategoryPricingInputModel>? subcategoryPricing,
    List<int>? subSubCategoryIds,
    List<WorkPhotoInputModel>? workPhotos,
    List<PortfolioItemInputModel>? portfolio,
  });

  @override
  $LocationModelCopyWith<$Res>? get location;
  @override
  $WeeklyScheduleModelCopyWith<$Res>? get schedule;
}

/// @nodoc
class __$$UpdateTechnicianProfileRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateTechnicianProfileRequestCopyWithImpl<
          $Res,
          _$UpdateTechnicianProfileRequestImpl
        >
    implements _$$UpdateTechnicianProfileRequestImplCopyWith<$Res> {
  __$$UpdateTechnicianProfileRequestImplCopyWithImpl(
    _$UpdateTechnicianProfileRequestImpl _value,
    $Res Function(_$UpdateTechnicianProfileRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? specialty = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? profilePhotoUrl = freezed,
    Object? description = freezed,
    Object? minimumQuote = freezed,
    Object? experienceYears = freezed,
    Object? experienceDescription = freezed,
    Object? location = freezed,
    Object? coverageRadiusKm = freezed,
    Object? coversAllPeru = freezed,
    Object? coveragePlaceIds = freezed,
    Object? primaryCoveragePlaceId = freezed,
    Object? schedule = freezed,
    Object? subcategoryIds = freezed,
    Object? subcategoryPricing = freezed,
    Object? subSubCategoryIds = freezed,
    Object? workPhotos = freezed,
    Object? portfolio = freezed,
  }) {
    return _then(
      _$UpdateTechnicianProfileRequestImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        specialty: freezed == specialty
            ? _value.specialty
            : specialty // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        minimumQuote: freezed == minimumQuote
            ? _value.minimumQuote
            : minimumQuote // ignore: cast_nullable_to_non_nullable
                  as String?,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        experienceDescription: freezed == experienceDescription
            ? _value.experienceDescription
            : experienceDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as LocationModel?,
        coverageRadiusKm: freezed == coverageRadiusKm
            ? _value.coverageRadiusKm
            : coverageRadiusKm // ignore: cast_nullable_to_non_nullable
                  as int?,
        coversAllPeru: freezed == coversAllPeru
            ? _value.coversAllPeru
            : coversAllPeru // ignore: cast_nullable_to_non_nullable
                  as bool?,
        coveragePlaceIds: freezed == coveragePlaceIds
            ? _value._coveragePlaceIds
            : coveragePlaceIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        primaryCoveragePlaceId: freezed == primaryCoveragePlaceId
            ? _value.primaryCoveragePlaceId
            : primaryCoveragePlaceId // ignore: cast_nullable_to_non_nullable
                  as int?,
        schedule: freezed == schedule
            ? _value.schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as WeeklyScheduleModel?,
        subcategoryIds: freezed == subcategoryIds
            ? _value._subcategoryIds
            : subcategoryIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        subcategoryPricing: freezed == subcategoryPricing
            ? _value._subcategoryPricing
            : subcategoryPricing // ignore: cast_nullable_to_non_nullable
                  as List<SubcategoryPricingInputModel>?,
        subSubCategoryIds: freezed == subSubCategoryIds
            ? _value._subSubCategoryIds
            : subSubCategoryIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        workPhotos: freezed == workPhotos
            ? _value._workPhotos
            : workPhotos // ignore: cast_nullable_to_non_nullable
                  as List<WorkPhotoInputModel>?,
        portfolio: freezed == portfolio
            ? _value._portfolio
            : portfolio // ignore: cast_nullable_to_non_nullable
                  as List<PortfolioItemInputModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateTechnicianProfileRequestImpl
    implements _UpdateTechnicianProfileRequest {
  const _$UpdateTechnicianProfileRequestImpl({
    this.name,
    this.specialty,
    this.phone,
    this.address,
    this.profilePhotoUrl,
    this.description,
    @JsonKey(includeIfNull: false) this.minimumQuote,
    this.experienceYears,
    this.experienceDescription,
    this.location,
    this.coverageRadiusKm,
    this.coversAllPeru,
    final List<int>? coveragePlaceIds,
    this.primaryCoveragePlaceId,
    this.schedule,
    final List<int>? subcategoryIds,
    final List<SubcategoryPricingInputModel>? subcategoryPricing,
    final List<int>? subSubCategoryIds,
    final List<WorkPhotoInputModel>? workPhotos,
    final List<PortfolioItemInputModel>? portfolio,
  }) : _coveragePlaceIds = coveragePlaceIds,
       _subcategoryIds = subcategoryIds,
       _subcategoryPricing = subcategoryPricing,
       _subSubCategoryIds = subSubCategoryIds,
       _workPhotos = workPhotos,
       _portfolio = portfolio;

  factory _$UpdateTechnicianProfileRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$UpdateTechnicianProfileRequestImplFromJson(json);

  @override
  final String? name;
  @override
  final String? specialty;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String? profilePhotoUrl;
  @override
  final String? description;

  /// Cotización mínima. Enviar número como texto; '' limpia el valor en API.
  /// Null = no actualizar (includeIfNull: false + sanitize).
  @override
  @JsonKey(includeIfNull: false)
  final String? minimumQuote;
  @override
  final int? experienceYears;
  @override
  final String? experienceDescription;
  @override
  final LocationModel? location;
  @override
  final int? coverageRadiusKm;
  @override
  final bool? coversAllPeru;
  final List<int>? _coveragePlaceIds;
  @override
  List<int>? get coveragePlaceIds {
    final value = _coveragePlaceIds;
    if (value == null) return null;
    if (_coveragePlaceIds is EqualUnmodifiableListView)
      return _coveragePlaceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? primaryCoveragePlaceId;
  @override
  final WeeklyScheduleModel? schedule;
  final List<int>? _subcategoryIds;
  @override
  List<int>? get subcategoryIds {
    final value = _subcategoryIds;
    if (value == null) return null;
    if (_subcategoryIds is EqualUnmodifiableListView) return _subcategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SubcategoryPricingInputModel>? _subcategoryPricing;
  @override
  List<SubcategoryPricingInputModel>? get subcategoryPricing {
    final value = _subcategoryPricing;
    if (value == null) return null;
    if (_subcategoryPricing is EqualUnmodifiableListView)
      return _subcategoryPricing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _subSubCategoryIds;
  @override
  List<int>? get subSubCategoryIds {
    final value = _subSubCategoryIds;
    if (value == null) return null;
    if (_subSubCategoryIds is EqualUnmodifiableListView)
      return _subSubCategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<WorkPhotoInputModel>? _workPhotos;
  @override
  List<WorkPhotoInputModel>? get workPhotos {
    final value = _workPhotos;
    if (value == null) return null;
    if (_workPhotos is EqualUnmodifiableListView) return _workPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PortfolioItemInputModel>? _portfolio;
  @override
  List<PortfolioItemInputModel>? get portfolio {
    final value = _portfolio;
    if (value == null) return null;
    if (_portfolio is EqualUnmodifiableListView) return _portfolio;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UpdateTechnicianProfileRequest(name: $name, specialty: $specialty, phone: $phone, address: $address, profilePhotoUrl: $profilePhotoUrl, description: $description, minimumQuote: $minimumQuote, experienceYears: $experienceYears, experienceDescription: $experienceDescription, location: $location, coverageRadiusKm: $coverageRadiusKm, coversAllPeru: $coversAllPeru, coveragePlaceIds: $coveragePlaceIds, primaryCoveragePlaceId: $primaryCoveragePlaceId, schedule: $schedule, subcategoryIds: $subcategoryIds, subcategoryPricing: $subcategoryPricing, subSubCategoryIds: $subSubCategoryIds, workPhotos: $workPhotos, portfolio: $portfolio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateTechnicianProfileRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.specialty, specialty) ||
                other.specialty == specialty) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.minimumQuote, minimumQuote) ||
                other.minimumQuote == minimumQuote) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.experienceDescription, experienceDescription) ||
                other.experienceDescription == experienceDescription) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.coverageRadiusKm, coverageRadiusKm) ||
                other.coverageRadiusKm == coverageRadiusKm) &&
            (identical(other.coversAllPeru, coversAllPeru) ||
                other.coversAllPeru == coversAllPeru) &&
            const DeepCollectionEquality().equals(
              other._coveragePlaceIds,
              _coveragePlaceIds,
            ) &&
            (identical(other.primaryCoveragePlaceId, primaryCoveragePlaceId) ||
                other.primaryCoveragePlaceId == primaryCoveragePlaceId) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            const DeepCollectionEquality().equals(
              other._subcategoryIds,
              _subcategoryIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._subcategoryPricing,
              _subcategoryPricing,
            ) &&
            const DeepCollectionEquality().equals(
              other._subSubCategoryIds,
              _subSubCategoryIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._workPhotos,
              _workPhotos,
            ) &&
            const DeepCollectionEquality().equals(
              other._portfolio,
              _portfolio,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    name,
    specialty,
    phone,
    address,
    profilePhotoUrl,
    description,
    minimumQuote,
    experienceYears,
    experienceDescription,
    location,
    coverageRadiusKm,
    coversAllPeru,
    const DeepCollectionEquality().hash(_coveragePlaceIds),
    primaryCoveragePlaceId,
    schedule,
    const DeepCollectionEquality().hash(_subcategoryIds),
    const DeepCollectionEquality().hash(_subcategoryPricing),
    const DeepCollectionEquality().hash(_subSubCategoryIds),
    const DeepCollectionEquality().hash(_workPhotos),
    const DeepCollectionEquality().hash(_portfolio),
  ]);

  /// Create a copy of UpdateTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateTechnicianProfileRequestImplCopyWith<
    _$UpdateTechnicianProfileRequestImpl
  >
  get copyWith =>
      __$$UpdateTechnicianProfileRequestImplCopyWithImpl<
        _$UpdateTechnicianProfileRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateTechnicianProfileRequestImplToJson(this);
  }
}

abstract class _UpdateTechnicianProfileRequest
    implements UpdateTechnicianProfileRequest {
  const factory _UpdateTechnicianProfileRequest({
    final String? name,
    final String? specialty,
    final String? phone,
    final String? address,
    final String? profilePhotoUrl,
    final String? description,
    @JsonKey(includeIfNull: false) final String? minimumQuote,
    final int? experienceYears,
    final String? experienceDescription,
    final LocationModel? location,
    final int? coverageRadiusKm,
    final bool? coversAllPeru,
    final List<int>? coveragePlaceIds,
    final int? primaryCoveragePlaceId,
    final WeeklyScheduleModel? schedule,
    final List<int>? subcategoryIds,
    final List<SubcategoryPricingInputModel>? subcategoryPricing,
    final List<int>? subSubCategoryIds,
    final List<WorkPhotoInputModel>? workPhotos,
    final List<PortfolioItemInputModel>? portfolio,
  }) = _$UpdateTechnicianProfileRequestImpl;

  factory _UpdateTechnicianProfileRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateTechnicianProfileRequestImpl.fromJson;

  @override
  String? get name;
  @override
  String? get specialty;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String? get profilePhotoUrl;
  @override
  String? get description;

  /// Cotización mínima. Enviar número como texto; '' limpia el valor en API.
  /// Null = no actualizar (includeIfNull: false + sanitize).
  @override
  @JsonKey(includeIfNull: false)
  String? get minimumQuote;
  @override
  int? get experienceYears;
  @override
  String? get experienceDescription;
  @override
  LocationModel? get location;
  @override
  int? get coverageRadiusKm;
  @override
  bool? get coversAllPeru;
  @override
  List<int>? get coveragePlaceIds;
  @override
  int? get primaryCoveragePlaceId;
  @override
  WeeklyScheduleModel? get schedule;
  @override
  List<int>? get subcategoryIds;
  @override
  List<SubcategoryPricingInputModel>? get subcategoryPricing;
  @override
  List<int>? get subSubCategoryIds;
  @override
  List<WorkPhotoInputModel>? get workPhotos;
  @override
  List<PortfolioItemInputModel>? get portfolio;

  /// Create a copy of UpdateTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateTechnicianProfileRequestImplCopyWith<
    _$UpdateTechnicianProfileRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

UpdateTechnicianServiceRequest _$UpdateTechnicianServiceRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateTechnicianServiceRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateTechnicianServiceRequest {
  /// Si es null no se envía (no borra en backend). Para limpiar, enviar ''.
  @JsonKey(includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get experienceYears => throw _privateConstructorUsedError;

  /// Alias mano de obra (compat). Se envían siempre desde el editor.
  double? get priceMin => throw _privateConstructorUsedError;
  double? get priceMax => throw _privateConstructorUsedError;
  double? get laborPriceMin => throw _privateConstructorUsedError;
  double? get laborPriceMax => throw _privateConstructorUsedError;
  double? get turnkeyPriceMin => throw _privateConstructorUsedError;
  double? get turnkeyPriceMax => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get profilePriceDisplay => throw _privateConstructorUsedError;
  List<WorkPhotoInputModel> get workPhotos =>
      throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get uploadSessionId => throw _privateConstructorUsedError;

  /// Serializes this UpdateTechnicianServiceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateTechnicianServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateTechnicianServiceRequestCopyWith<UpdateTechnicianServiceRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTechnicianServiceRequestCopyWith<$Res> {
  factory $UpdateTechnicianServiceRequestCopyWith(
    UpdateTechnicianServiceRequest value,
    $Res Function(UpdateTechnicianServiceRequest) then,
  ) =
      _$UpdateTechnicianServiceRequestCopyWithImpl<
        $Res,
        UpdateTechnicianServiceRequest
      >;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? description,
    @JsonKey(includeIfNull: false) int? experienceYears,
    double? priceMin,
    double? priceMax,
    double? laborPriceMin,
    double? laborPriceMax,
    double? turnkeyPriceMin,
    double? turnkeyPriceMax,
    @JsonKey(includeIfNull: false) String? profilePriceDisplay,
    List<WorkPhotoInputModel> workPhotos,
    @JsonKey(includeIfNull: false) String? uploadSessionId,
  });
}

/// @nodoc
class _$UpdateTechnicianServiceRequestCopyWithImpl<
  $Res,
  $Val extends UpdateTechnicianServiceRequest
>
    implements $UpdateTechnicianServiceRequestCopyWith<$Res> {
  _$UpdateTechnicianServiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateTechnicianServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? laborPriceMin = freezed,
    Object? laborPriceMax = freezed,
    Object? turnkeyPriceMin = freezed,
    Object? turnkeyPriceMax = freezed,
    Object? profilePriceDisplay = freezed,
    Object? workPhotos = null,
    Object? uploadSessionId = freezed,
  }) {
    return _then(
      _value.copyWith(
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            priceMin: freezed == priceMin
                ? _value.priceMin
                : priceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            priceMax: freezed == priceMax
                ? _value.priceMax
                : priceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            laborPriceMin: freezed == laborPriceMin
                ? _value.laborPriceMin
                : laborPriceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            laborPriceMax: freezed == laborPriceMax
                ? _value.laborPriceMax
                : laborPriceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            turnkeyPriceMin: freezed == turnkeyPriceMin
                ? _value.turnkeyPriceMin
                : turnkeyPriceMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            turnkeyPriceMax: freezed == turnkeyPriceMax
                ? _value.turnkeyPriceMax
                : turnkeyPriceMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            profilePriceDisplay: freezed == profilePriceDisplay
                ? _value.profilePriceDisplay
                : profilePriceDisplay // ignore: cast_nullable_to_non_nullable
                      as String?,
            workPhotos: null == workPhotos
                ? _value.workPhotos
                : workPhotos // ignore: cast_nullable_to_non_nullable
                      as List<WorkPhotoInputModel>,
            uploadSessionId: freezed == uploadSessionId
                ? _value.uploadSessionId
                : uploadSessionId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateTechnicianServiceRequestImplCopyWith<$Res>
    implements $UpdateTechnicianServiceRequestCopyWith<$Res> {
  factory _$$UpdateTechnicianServiceRequestImplCopyWith(
    _$UpdateTechnicianServiceRequestImpl value,
    $Res Function(_$UpdateTechnicianServiceRequestImpl) then,
  ) = __$$UpdateTechnicianServiceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? description,
    @JsonKey(includeIfNull: false) int? experienceYears,
    double? priceMin,
    double? priceMax,
    double? laborPriceMin,
    double? laborPriceMax,
    double? turnkeyPriceMin,
    double? turnkeyPriceMax,
    @JsonKey(includeIfNull: false) String? profilePriceDisplay,
    List<WorkPhotoInputModel> workPhotos,
    @JsonKey(includeIfNull: false) String? uploadSessionId,
  });
}

/// @nodoc
class __$$UpdateTechnicianServiceRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateTechnicianServiceRequestCopyWithImpl<
          $Res,
          _$UpdateTechnicianServiceRequestImpl
        >
    implements _$$UpdateTechnicianServiceRequestImplCopyWith<$Res> {
  __$$UpdateTechnicianServiceRequestImplCopyWithImpl(
    _$UpdateTechnicianServiceRequestImpl _value,
    $Res Function(_$UpdateTechnicianServiceRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateTechnicianServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? laborPriceMin = freezed,
    Object? laborPriceMax = freezed,
    Object? turnkeyPriceMin = freezed,
    Object? turnkeyPriceMax = freezed,
    Object? profilePriceDisplay = freezed,
    Object? workPhotos = null,
    Object? uploadSessionId = freezed,
  }) {
    return _then(
      _$UpdateTechnicianServiceRequestImpl(
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        priceMin: freezed == priceMin
            ? _value.priceMin
            : priceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        priceMax: freezed == priceMax
            ? _value.priceMax
            : priceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        laborPriceMin: freezed == laborPriceMin
            ? _value.laborPriceMin
            : laborPriceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        laborPriceMax: freezed == laborPriceMax
            ? _value.laborPriceMax
            : laborPriceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        turnkeyPriceMin: freezed == turnkeyPriceMin
            ? _value.turnkeyPriceMin
            : turnkeyPriceMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        turnkeyPriceMax: freezed == turnkeyPriceMax
            ? _value.turnkeyPriceMax
            : turnkeyPriceMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        profilePriceDisplay: freezed == profilePriceDisplay
            ? _value.profilePriceDisplay
            : profilePriceDisplay // ignore: cast_nullable_to_non_nullable
                  as String?,
        workPhotos: null == workPhotos
            ? _value._workPhotos
            : workPhotos // ignore: cast_nullable_to_non_nullable
                  as List<WorkPhotoInputModel>,
        uploadSessionId: freezed == uploadSessionId
            ? _value.uploadSessionId
            : uploadSessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateTechnicianServiceRequestImpl
    implements _UpdateTechnicianServiceRequest {
  const _$UpdateTechnicianServiceRequestImpl({
    @JsonKey(includeIfNull: false) this.description,
    @JsonKey(includeIfNull: false) this.experienceYears,
    this.priceMin,
    this.priceMax,
    this.laborPriceMin,
    this.laborPriceMax,
    this.turnkeyPriceMin,
    this.turnkeyPriceMax,
    @JsonKey(includeIfNull: false) this.profilePriceDisplay,
    final List<WorkPhotoInputModel> workPhotos = const [],
    @JsonKey(includeIfNull: false) this.uploadSessionId,
  }) : _workPhotos = workPhotos;

  factory _$UpdateTechnicianServiceRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$UpdateTechnicianServiceRequestImplFromJson(json);

  /// Si es null no se envía (no borra en backend). Para limpiar, enviar ''.
  @override
  @JsonKey(includeIfNull: false)
  final String? description;
  @override
  @JsonKey(includeIfNull: false)
  final int? experienceYears;

  /// Alias mano de obra (compat). Se envían siempre desde el editor.
  @override
  final double? priceMin;
  @override
  final double? priceMax;
  @override
  final double? laborPriceMin;
  @override
  final double? laborPriceMax;
  @override
  final double? turnkeyPriceMin;
  @override
  final double? turnkeyPriceMax;
  @override
  @JsonKey(includeIfNull: false)
  final String? profilePriceDisplay;
  final List<WorkPhotoInputModel> _workPhotos;
  @override
  @JsonKey()
  List<WorkPhotoInputModel> get workPhotos {
    if (_workPhotos is EqualUnmodifiableListView) return _workPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workPhotos);
  }

  @override
  @JsonKey(includeIfNull: false)
  final String? uploadSessionId;

  @override
  String toString() {
    return 'UpdateTechnicianServiceRequest(description: $description, experienceYears: $experienceYears, priceMin: $priceMin, priceMax: $priceMax, laborPriceMin: $laborPriceMin, laborPriceMax: $laborPriceMax, turnkeyPriceMin: $turnkeyPriceMin, turnkeyPriceMax: $turnkeyPriceMax, profilePriceDisplay: $profilePriceDisplay, workPhotos: $workPhotos, uploadSessionId: $uploadSessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateTechnicianServiceRequestImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.laborPriceMin, laborPriceMin) ||
                other.laborPriceMin == laborPriceMin) &&
            (identical(other.laborPriceMax, laborPriceMax) ||
                other.laborPriceMax == laborPriceMax) &&
            (identical(other.turnkeyPriceMin, turnkeyPriceMin) ||
                other.turnkeyPriceMin == turnkeyPriceMin) &&
            (identical(other.turnkeyPriceMax, turnkeyPriceMax) ||
                other.turnkeyPriceMax == turnkeyPriceMax) &&
            (identical(other.profilePriceDisplay, profilePriceDisplay) ||
                other.profilePriceDisplay == profilePriceDisplay) &&
            const DeepCollectionEquality().equals(
              other._workPhotos,
              _workPhotos,
            ) &&
            (identical(other.uploadSessionId, uploadSessionId) ||
                other.uploadSessionId == uploadSessionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    description,
    experienceYears,
    priceMin,
    priceMax,
    laborPriceMin,
    laborPriceMax,
    turnkeyPriceMin,
    turnkeyPriceMax,
    profilePriceDisplay,
    const DeepCollectionEquality().hash(_workPhotos),
    uploadSessionId,
  );

  /// Create a copy of UpdateTechnicianServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateTechnicianServiceRequestImplCopyWith<
    _$UpdateTechnicianServiceRequestImpl
  >
  get copyWith =>
      __$$UpdateTechnicianServiceRequestImplCopyWithImpl<
        _$UpdateTechnicianServiceRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateTechnicianServiceRequestImplToJson(this);
  }
}

abstract class _UpdateTechnicianServiceRequest
    implements UpdateTechnicianServiceRequest {
  const factory _UpdateTechnicianServiceRequest({
    @JsonKey(includeIfNull: false) final String? description,
    @JsonKey(includeIfNull: false) final int? experienceYears,
    final double? priceMin,
    final double? priceMax,
    final double? laborPriceMin,
    final double? laborPriceMax,
    final double? turnkeyPriceMin,
    final double? turnkeyPriceMax,
    @JsonKey(includeIfNull: false) final String? profilePriceDisplay,
    final List<WorkPhotoInputModel> workPhotos,
    @JsonKey(includeIfNull: false) final String? uploadSessionId,
  }) = _$UpdateTechnicianServiceRequestImpl;

  factory _UpdateTechnicianServiceRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateTechnicianServiceRequestImpl.fromJson;

  /// Si es null no se envía (no borra en backend). Para limpiar, enviar ''.
  @override
  @JsonKey(includeIfNull: false)
  String? get description;
  @override
  @JsonKey(includeIfNull: false)
  int? get experienceYears;

  /// Alias mano de obra (compat). Se envían siempre desde el editor.
  @override
  double? get priceMin;
  @override
  double? get priceMax;
  @override
  double? get laborPriceMin;
  @override
  double? get laborPriceMax;
  @override
  double? get turnkeyPriceMin;
  @override
  double? get turnkeyPriceMax;
  @override
  @JsonKey(includeIfNull: false)
  String? get profilePriceDisplay;
  @override
  List<WorkPhotoInputModel> get workPhotos;
  @override
  @JsonKey(includeIfNull: false)
  String? get uploadSessionId;

  /// Create a copy of UpdateTechnicianServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateTechnicianServiceRequestImplCopyWith<
    _$UpdateTechnicianServiceRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

RejectApplicationRequest _$RejectApplicationRequestFromJson(
  Map<String, dynamic> json,
) {
  return _RejectApplicationRequest.fromJson(json);
}

/// @nodoc
mixin _$RejectApplicationRequest {
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this RejectApplicationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RejectApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RejectApplicationRequestCopyWith<RejectApplicationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectApplicationRequestCopyWith<$Res> {
  factory $RejectApplicationRequestCopyWith(
    RejectApplicationRequest value,
    $Res Function(RejectApplicationRequest) then,
  ) = _$RejectApplicationRequestCopyWithImpl<$Res, RejectApplicationRequest>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class _$RejectApplicationRequestCopyWithImpl<
  $Res,
  $Val extends RejectApplicationRequest
>
    implements $RejectApplicationRequestCopyWith<$Res> {
  _$RejectApplicationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RejectApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _value.copyWith(
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RejectApplicationRequestImplCopyWith<$Res>
    implements $RejectApplicationRequestCopyWith<$Res> {
  factory _$$RejectApplicationRequestImplCopyWith(
    _$RejectApplicationRequestImpl value,
    $Res Function(_$RejectApplicationRequestImpl) then,
  ) = __$$RejectApplicationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$RejectApplicationRequestImplCopyWithImpl<$Res>
    extends
        _$RejectApplicationRequestCopyWithImpl<
          $Res,
          _$RejectApplicationRequestImpl
        >
    implements _$$RejectApplicationRequestImplCopyWith<$Res> {
  __$$RejectApplicationRequestImplCopyWithImpl(
    _$RejectApplicationRequestImpl _value,
    $Res Function(_$RejectApplicationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RejectApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$RejectApplicationRequestImpl(
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectApplicationRequestImpl implements _RejectApplicationRequest {
  const _$RejectApplicationRequestImpl({required this.reason});

  factory _$RejectApplicationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RejectApplicationRequestImplFromJson(json);

  @override
  final String reason;

  @override
  String toString() {
    return 'RejectApplicationRequest(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectApplicationRequestImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of RejectApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectApplicationRequestImplCopyWith<_$RejectApplicationRequestImpl>
  get copyWith =>
      __$$RejectApplicationRequestImplCopyWithImpl<
        _$RejectApplicationRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectApplicationRequestImplToJson(this);
  }
}

abstract class _RejectApplicationRequest implements RejectApplicationRequest {
  const factory _RejectApplicationRequest({required final String reason}) =
      _$RejectApplicationRequestImpl;

  factory _RejectApplicationRequest.fromJson(Map<String, dynamic> json) =
      _$RejectApplicationRequestImpl.fromJson;

  @override
  String get reason;

  /// Create a copy of RejectApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectApplicationRequestImplCopyWith<_$RejectApplicationRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SubmitTechnicianVerificationRequest
_$SubmitTechnicianVerificationRequestFromJson(Map<String, dynamic> json) {
  return _SubmitTechnicianVerificationRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitTechnicianVerificationRequest {
  String? get documentImageUrl => throw _privateConstructorUsedError;
  String? get documentFrontImageUrl => throw _privateConstructorUsedError;
  String? get documentBackImageUrl => throw _privateConstructorUsedError;
  String? get facePhotoUrl => throw _privateConstructorUsedError;
  String? get rucDocumentUrl => throw _privateConstructorUsedError;
  String? get companyLogoUrl => throw _privateConstructorUsedError;
  String? get legalRepresentativeDocumentUrl =>
      throw _privateConstructorUsedError;
  String? get legalRepresentativeDocumentFrontUrl =>
      throw _privateConstructorUsedError;
  String? get legalRepresentativeDocumentBackUrl =>
      throw _privateConstructorUsedError;
  String? get backgroundDeclaration => throw _privateConstructorUsedError;
  List<WorkPhotoSubmitRequest>? get workPhotos =>
      throw _privateConstructorUsedError;

  /// Serializes this SubmitTechnicianVerificationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitTechnicianVerificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitTechnicianVerificationRequestCopyWith<
    SubmitTechnicianVerificationRequest
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitTechnicianVerificationRequestCopyWith<$Res> {
  factory $SubmitTechnicianVerificationRequestCopyWith(
    SubmitTechnicianVerificationRequest value,
    $Res Function(SubmitTechnicianVerificationRequest) then,
  ) =
      _$SubmitTechnicianVerificationRequestCopyWithImpl<
        $Res,
        SubmitTechnicianVerificationRequest
      >;
  @useResult
  $Res call({
    String? documentImageUrl,
    String? documentFrontImageUrl,
    String? documentBackImageUrl,
    String? facePhotoUrl,
    String? rucDocumentUrl,
    String? companyLogoUrl,
    String? legalRepresentativeDocumentUrl,
    String? legalRepresentativeDocumentFrontUrl,
    String? legalRepresentativeDocumentBackUrl,
    String? backgroundDeclaration,
    List<WorkPhotoSubmitRequest>? workPhotos,
  });
}

/// @nodoc
class _$SubmitTechnicianVerificationRequestCopyWithImpl<
  $Res,
  $Val extends SubmitTechnicianVerificationRequest
>
    implements $SubmitTechnicianVerificationRequestCopyWith<$Res> {
  _$SubmitTechnicianVerificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitTechnicianVerificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentImageUrl = freezed,
    Object? documentFrontImageUrl = freezed,
    Object? documentBackImageUrl = freezed,
    Object? facePhotoUrl = freezed,
    Object? rucDocumentUrl = freezed,
    Object? companyLogoUrl = freezed,
    Object? legalRepresentativeDocumentUrl = freezed,
    Object? legalRepresentativeDocumentFrontUrl = freezed,
    Object? legalRepresentativeDocumentBackUrl = freezed,
    Object? backgroundDeclaration = freezed,
    Object? workPhotos = freezed,
  }) {
    return _then(
      _value.copyWith(
            documentImageUrl: freezed == documentImageUrl
                ? _value.documentImageUrl
                : documentImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentFrontImageUrl: freezed == documentFrontImageUrl
                ? _value.documentFrontImageUrl
                : documentFrontImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentBackImageUrl: freezed == documentBackImageUrl
                ? _value.documentBackImageUrl
                : documentBackImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            facePhotoUrl: freezed == facePhotoUrl
                ? _value.facePhotoUrl
                : facePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rucDocumentUrl: freezed == rucDocumentUrl
                ? _value.rucDocumentUrl
                : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyLogoUrl: freezed == companyLogoUrl
                ? _value.companyLogoUrl
                : companyLogoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalRepresentativeDocumentUrl:
                freezed == legalRepresentativeDocumentUrl
                ? _value.legalRepresentativeDocumentUrl
                : legalRepresentativeDocumentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalRepresentativeDocumentFrontUrl:
                freezed == legalRepresentativeDocumentFrontUrl
                ? _value.legalRepresentativeDocumentFrontUrl
                : legalRepresentativeDocumentFrontUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            legalRepresentativeDocumentBackUrl:
                freezed == legalRepresentativeDocumentBackUrl
                ? _value.legalRepresentativeDocumentBackUrl
                : legalRepresentativeDocumentBackUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            backgroundDeclaration: freezed == backgroundDeclaration
                ? _value.backgroundDeclaration
                : backgroundDeclaration // ignore: cast_nullable_to_non_nullable
                      as String?,
            workPhotos: freezed == workPhotos
                ? _value.workPhotos
                : workPhotos // ignore: cast_nullable_to_non_nullable
                      as List<WorkPhotoSubmitRequest>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubmitTechnicianVerificationRequestImplCopyWith<$Res>
    implements $SubmitTechnicianVerificationRequestCopyWith<$Res> {
  factory _$$SubmitTechnicianVerificationRequestImplCopyWith(
    _$SubmitTechnicianVerificationRequestImpl value,
    $Res Function(_$SubmitTechnicianVerificationRequestImpl) then,
  ) = __$$SubmitTechnicianVerificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? documentImageUrl,
    String? documentFrontImageUrl,
    String? documentBackImageUrl,
    String? facePhotoUrl,
    String? rucDocumentUrl,
    String? companyLogoUrl,
    String? legalRepresentativeDocumentUrl,
    String? legalRepresentativeDocumentFrontUrl,
    String? legalRepresentativeDocumentBackUrl,
    String? backgroundDeclaration,
    List<WorkPhotoSubmitRequest>? workPhotos,
  });
}

/// @nodoc
class __$$SubmitTechnicianVerificationRequestImplCopyWithImpl<$Res>
    extends
        _$SubmitTechnicianVerificationRequestCopyWithImpl<
          $Res,
          _$SubmitTechnicianVerificationRequestImpl
        >
    implements _$$SubmitTechnicianVerificationRequestImplCopyWith<$Res> {
  __$$SubmitTechnicianVerificationRequestImplCopyWithImpl(
    _$SubmitTechnicianVerificationRequestImpl _value,
    $Res Function(_$SubmitTechnicianVerificationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitTechnicianVerificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentImageUrl = freezed,
    Object? documentFrontImageUrl = freezed,
    Object? documentBackImageUrl = freezed,
    Object? facePhotoUrl = freezed,
    Object? rucDocumentUrl = freezed,
    Object? companyLogoUrl = freezed,
    Object? legalRepresentativeDocumentUrl = freezed,
    Object? legalRepresentativeDocumentFrontUrl = freezed,
    Object? legalRepresentativeDocumentBackUrl = freezed,
    Object? backgroundDeclaration = freezed,
    Object? workPhotos = freezed,
  }) {
    return _then(
      _$SubmitTechnicianVerificationRequestImpl(
        documentImageUrl: freezed == documentImageUrl
            ? _value.documentImageUrl
            : documentImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentFrontImageUrl: freezed == documentFrontImageUrl
            ? _value.documentFrontImageUrl
            : documentFrontImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentBackImageUrl: freezed == documentBackImageUrl
            ? _value.documentBackImageUrl
            : documentBackImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        facePhotoUrl: freezed == facePhotoUrl
            ? _value.facePhotoUrl
            : facePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rucDocumentUrl: freezed == rucDocumentUrl
            ? _value.rucDocumentUrl
            : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyLogoUrl: freezed == companyLogoUrl
            ? _value.companyLogoUrl
            : companyLogoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalRepresentativeDocumentUrl:
            freezed == legalRepresentativeDocumentUrl
            ? _value.legalRepresentativeDocumentUrl
            : legalRepresentativeDocumentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalRepresentativeDocumentFrontUrl:
            freezed == legalRepresentativeDocumentFrontUrl
            ? _value.legalRepresentativeDocumentFrontUrl
            : legalRepresentativeDocumentFrontUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        legalRepresentativeDocumentBackUrl:
            freezed == legalRepresentativeDocumentBackUrl
            ? _value.legalRepresentativeDocumentBackUrl
            : legalRepresentativeDocumentBackUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        backgroundDeclaration: freezed == backgroundDeclaration
            ? _value.backgroundDeclaration
            : backgroundDeclaration // ignore: cast_nullable_to_non_nullable
                  as String?,
        workPhotos: freezed == workPhotos
            ? _value._workPhotos
            : workPhotos // ignore: cast_nullable_to_non_nullable
                  as List<WorkPhotoSubmitRequest>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitTechnicianVerificationRequestImpl
    implements _SubmitTechnicianVerificationRequest {
  const _$SubmitTechnicianVerificationRequestImpl({
    this.documentImageUrl,
    this.documentFrontImageUrl,
    this.documentBackImageUrl,
    this.facePhotoUrl,
    this.rucDocumentUrl,
    this.companyLogoUrl,
    this.legalRepresentativeDocumentUrl,
    this.legalRepresentativeDocumentFrontUrl,
    this.legalRepresentativeDocumentBackUrl,
    this.backgroundDeclaration,
    final List<WorkPhotoSubmitRequest>? workPhotos,
  }) : _workPhotos = workPhotos;

  factory _$SubmitTechnicianVerificationRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$SubmitTechnicianVerificationRequestImplFromJson(json);

  @override
  final String? documentImageUrl;
  @override
  final String? documentFrontImageUrl;
  @override
  final String? documentBackImageUrl;
  @override
  final String? facePhotoUrl;
  @override
  final String? rucDocumentUrl;
  @override
  final String? companyLogoUrl;
  @override
  final String? legalRepresentativeDocumentUrl;
  @override
  final String? legalRepresentativeDocumentFrontUrl;
  @override
  final String? legalRepresentativeDocumentBackUrl;
  @override
  final String? backgroundDeclaration;
  final List<WorkPhotoSubmitRequest>? _workPhotos;
  @override
  List<WorkPhotoSubmitRequest>? get workPhotos {
    final value = _workPhotos;
    if (value == null) return null;
    if (_workPhotos is EqualUnmodifiableListView) return _workPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SubmitTechnicianVerificationRequest(documentImageUrl: $documentImageUrl, documentFrontImageUrl: $documentFrontImageUrl, documentBackImageUrl: $documentBackImageUrl, facePhotoUrl: $facePhotoUrl, rucDocumentUrl: $rucDocumentUrl, companyLogoUrl: $companyLogoUrl, legalRepresentativeDocumentUrl: $legalRepresentativeDocumentUrl, legalRepresentativeDocumentFrontUrl: $legalRepresentativeDocumentFrontUrl, legalRepresentativeDocumentBackUrl: $legalRepresentativeDocumentBackUrl, backgroundDeclaration: $backgroundDeclaration, workPhotos: $workPhotos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitTechnicianVerificationRequestImpl &&
            (identical(other.documentImageUrl, documentImageUrl) ||
                other.documentImageUrl == documentImageUrl) &&
            (identical(other.documentFrontImageUrl, documentFrontImageUrl) ||
                other.documentFrontImageUrl == documentFrontImageUrl) &&
            (identical(other.documentBackImageUrl, documentBackImageUrl) ||
                other.documentBackImageUrl == documentBackImageUrl) &&
            (identical(other.facePhotoUrl, facePhotoUrl) ||
                other.facePhotoUrl == facePhotoUrl) &&
            (identical(other.rucDocumentUrl, rucDocumentUrl) ||
                other.rucDocumentUrl == rucDocumentUrl) &&
            (identical(other.companyLogoUrl, companyLogoUrl) ||
                other.companyLogoUrl == companyLogoUrl) &&
            (identical(
                  other.legalRepresentativeDocumentUrl,
                  legalRepresentativeDocumentUrl,
                ) ||
                other.legalRepresentativeDocumentUrl ==
                    legalRepresentativeDocumentUrl) &&
            (identical(
                  other.legalRepresentativeDocumentFrontUrl,
                  legalRepresentativeDocumentFrontUrl,
                ) ||
                other.legalRepresentativeDocumentFrontUrl ==
                    legalRepresentativeDocumentFrontUrl) &&
            (identical(
                  other.legalRepresentativeDocumentBackUrl,
                  legalRepresentativeDocumentBackUrl,
                ) ||
                other.legalRepresentativeDocumentBackUrl ==
                    legalRepresentativeDocumentBackUrl) &&
            (identical(other.backgroundDeclaration, backgroundDeclaration) ||
                other.backgroundDeclaration == backgroundDeclaration) &&
            const DeepCollectionEquality().equals(
              other._workPhotos,
              _workPhotos,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    documentImageUrl,
    documentFrontImageUrl,
    documentBackImageUrl,
    facePhotoUrl,
    rucDocumentUrl,
    companyLogoUrl,
    legalRepresentativeDocumentUrl,
    legalRepresentativeDocumentFrontUrl,
    legalRepresentativeDocumentBackUrl,
    backgroundDeclaration,
    const DeepCollectionEquality().hash(_workPhotos),
  );

  /// Create a copy of SubmitTechnicianVerificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitTechnicianVerificationRequestImplCopyWith<
    _$SubmitTechnicianVerificationRequestImpl
  >
  get copyWith =>
      __$$SubmitTechnicianVerificationRequestImplCopyWithImpl<
        _$SubmitTechnicianVerificationRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitTechnicianVerificationRequestImplToJson(this);
  }
}

abstract class _SubmitTechnicianVerificationRequest
    implements SubmitTechnicianVerificationRequest {
  const factory _SubmitTechnicianVerificationRequest({
    final String? documentImageUrl,
    final String? documentFrontImageUrl,
    final String? documentBackImageUrl,
    final String? facePhotoUrl,
    final String? rucDocumentUrl,
    final String? companyLogoUrl,
    final String? legalRepresentativeDocumentUrl,
    final String? legalRepresentativeDocumentFrontUrl,
    final String? legalRepresentativeDocumentBackUrl,
    final String? backgroundDeclaration,
    final List<WorkPhotoSubmitRequest>? workPhotos,
  }) = _$SubmitTechnicianVerificationRequestImpl;

  factory _SubmitTechnicianVerificationRequest.fromJson(
    Map<String, dynamic> json,
  ) = _$SubmitTechnicianVerificationRequestImpl.fromJson;

  @override
  String? get documentImageUrl;
  @override
  String? get documentFrontImageUrl;
  @override
  String? get documentBackImageUrl;
  @override
  String? get facePhotoUrl;
  @override
  String? get rucDocumentUrl;
  @override
  String? get companyLogoUrl;
  @override
  String? get legalRepresentativeDocumentUrl;
  @override
  String? get legalRepresentativeDocumentFrontUrl;
  @override
  String? get legalRepresentativeDocumentBackUrl;
  @override
  String? get backgroundDeclaration;
  @override
  List<WorkPhotoSubmitRequest>? get workPhotos;

  /// Create a copy of SubmitTechnicianVerificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitTechnicianVerificationRequestImplCopyWith<
    _$SubmitTechnicianVerificationRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

SubmitTechnicianCertificationRequest
_$SubmitTechnicianCertificationRequestFromJson(Map<String, dynamic> json) {
  return _SubmitTechnicianCertificationRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitTechnicianCertificationRequest {
  String get name => throw _privateConstructorUsedError;
  String? get issuer => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this SubmitTechnicianCertificationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitTechnicianCertificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitTechnicianCertificationRequestCopyWith<
    SubmitTechnicianCertificationRequest
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitTechnicianCertificationRequestCopyWith<$Res> {
  factory $SubmitTechnicianCertificationRequestCopyWith(
    SubmitTechnicianCertificationRequest value,
    $Res Function(SubmitTechnicianCertificationRequest) then,
  ) =
      _$SubmitTechnicianCertificationRequestCopyWithImpl<
        $Res,
        SubmitTechnicianCertificationRequest
      >;
  @useResult
  $Res call({String name, String? issuer, String imageUrl});
}

/// @nodoc
class _$SubmitTechnicianCertificationRequestCopyWithImpl<
  $Res,
  $Val extends SubmitTechnicianCertificationRequest
>
    implements $SubmitTechnicianCertificationRequestCopyWith<$Res> {
  _$SubmitTechnicianCertificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitTechnicianCertificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? issuer = freezed,
    Object? imageUrl = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            issuer: freezed == issuer
                ? _value.issuer
                : issuer // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubmitTechnicianCertificationRequestImplCopyWith<$Res>
    implements $SubmitTechnicianCertificationRequestCopyWith<$Res> {
  factory _$$SubmitTechnicianCertificationRequestImplCopyWith(
    _$SubmitTechnicianCertificationRequestImpl value,
    $Res Function(_$SubmitTechnicianCertificationRequestImpl) then,
  ) = __$$SubmitTechnicianCertificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? issuer, String imageUrl});
}

/// @nodoc
class __$$SubmitTechnicianCertificationRequestImplCopyWithImpl<$Res>
    extends
        _$SubmitTechnicianCertificationRequestCopyWithImpl<
          $Res,
          _$SubmitTechnicianCertificationRequestImpl
        >
    implements _$$SubmitTechnicianCertificationRequestImplCopyWith<$Res> {
  __$$SubmitTechnicianCertificationRequestImplCopyWithImpl(
    _$SubmitTechnicianCertificationRequestImpl _value,
    $Res Function(_$SubmitTechnicianCertificationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitTechnicianCertificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? issuer = freezed,
    Object? imageUrl = null,
  }) {
    return _then(
      _$SubmitTechnicianCertificationRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        issuer: freezed == issuer
            ? _value.issuer
            : issuer // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitTechnicianCertificationRequestImpl
    implements _SubmitTechnicianCertificationRequest {
  const _$SubmitTechnicianCertificationRequestImpl({
    required this.name,
    this.issuer,
    required this.imageUrl,
  });

  factory _$SubmitTechnicianCertificationRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$SubmitTechnicianCertificationRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String? issuer;
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'SubmitTechnicianCertificationRequest(name: $name, issuer: $issuer, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitTechnicianCertificationRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.issuer, issuer) || other.issuer == issuer) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, issuer, imageUrl);

  /// Create a copy of SubmitTechnicianCertificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitTechnicianCertificationRequestImplCopyWith<
    _$SubmitTechnicianCertificationRequestImpl
  >
  get copyWith =>
      __$$SubmitTechnicianCertificationRequestImplCopyWithImpl<
        _$SubmitTechnicianCertificationRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitTechnicianCertificationRequestImplToJson(this);
  }
}

abstract class _SubmitTechnicianCertificationRequest
    implements SubmitTechnicianCertificationRequest {
  const factory _SubmitTechnicianCertificationRequest({
    required final String name,
    final String? issuer,
    required final String imageUrl,
  }) = _$SubmitTechnicianCertificationRequestImpl;

  factory _SubmitTechnicianCertificationRequest.fromJson(
    Map<String, dynamic> json,
  ) = _$SubmitTechnicianCertificationRequestImpl.fromJson;

  @override
  String get name;
  @override
  String? get issuer;
  @override
  String get imageUrl;

  /// Create a copy of SubmitTechnicianCertificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitTechnicianCertificationRequestImplCopyWith<
    _$SubmitTechnicianCertificationRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

WorkPhotoSubmitRequest _$WorkPhotoSubmitRequestFromJson(
  Map<String, dynamic> json,
) {
  return _WorkPhotoSubmitRequest.fromJson(json);
}

/// @nodoc
mixin _$WorkPhotoSubmitRequest {
  String get imageUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  double? get estimatedCost => throw _privateConstructorUsedError;

  /// Serializes this WorkPhotoSubmitRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkPhotoSubmitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkPhotoSubmitRequestCopyWith<WorkPhotoSubmitRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkPhotoSubmitRequestCopyWith<$Res> {
  factory $WorkPhotoSubmitRequestCopyWith(
    WorkPhotoSubmitRequest value,
    $Res Function(WorkPhotoSubmitRequest) then,
  ) = _$WorkPhotoSubmitRequestCopyWithImpl<$Res, WorkPhotoSubmitRequest>;
  @useResult
  $Res call({String imageUrl, String? caption, double? estimatedCost});
}

/// @nodoc
class _$WorkPhotoSubmitRequestCopyWithImpl<
  $Res,
  $Val extends WorkPhotoSubmitRequest
>
    implements $WorkPhotoSubmitRequestCopyWith<$Res> {
  _$WorkPhotoSubmitRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkPhotoSubmitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? estimatedCost = freezed,
  }) {
    return _then(
      _value.copyWith(
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedCost: freezed == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkPhotoSubmitRequestImplCopyWith<$Res>
    implements $WorkPhotoSubmitRequestCopyWith<$Res> {
  factory _$$WorkPhotoSubmitRequestImplCopyWith(
    _$WorkPhotoSubmitRequestImpl value,
    $Res Function(_$WorkPhotoSubmitRequestImpl) then,
  ) = __$$WorkPhotoSubmitRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String imageUrl, String? caption, double? estimatedCost});
}

/// @nodoc
class __$$WorkPhotoSubmitRequestImplCopyWithImpl<$Res>
    extends
        _$WorkPhotoSubmitRequestCopyWithImpl<$Res, _$WorkPhotoSubmitRequestImpl>
    implements _$$WorkPhotoSubmitRequestImplCopyWith<$Res> {
  __$$WorkPhotoSubmitRequestImplCopyWithImpl(
    _$WorkPhotoSubmitRequestImpl _value,
    $Res Function(_$WorkPhotoSubmitRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkPhotoSubmitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? estimatedCost = freezed,
  }) {
    return _then(
      _$WorkPhotoSubmitRequestImpl(
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedCost: freezed == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkPhotoSubmitRequestImpl implements _WorkPhotoSubmitRequest {
  const _$WorkPhotoSubmitRequestImpl({
    required this.imageUrl,
    this.caption,
    this.estimatedCost,
  });

  factory _$WorkPhotoSubmitRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkPhotoSubmitRequestImplFromJson(json);

  @override
  final String imageUrl;
  @override
  final String? caption;
  @override
  final double? estimatedCost;

  @override
  String toString() {
    return 'WorkPhotoSubmitRequest(imageUrl: $imageUrl, caption: $caption, estimatedCost: $estimatedCost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkPhotoSubmitRequestImpl &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imageUrl, caption, estimatedCost);

  /// Create a copy of WorkPhotoSubmitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkPhotoSubmitRequestImplCopyWith<_$WorkPhotoSubmitRequestImpl>
  get copyWith =>
      __$$WorkPhotoSubmitRequestImplCopyWithImpl<_$WorkPhotoSubmitRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkPhotoSubmitRequestImplToJson(this);
  }
}

abstract class _WorkPhotoSubmitRequest implements WorkPhotoSubmitRequest {
  const factory _WorkPhotoSubmitRequest({
    required final String imageUrl,
    final String? caption,
    final double? estimatedCost,
  }) = _$WorkPhotoSubmitRequestImpl;

  factory _WorkPhotoSubmitRequest.fromJson(Map<String, dynamic> json) =
      _$WorkPhotoSubmitRequestImpl.fromJson;

  @override
  String get imageUrl;
  @override
  String? get caption;
  @override
  double? get estimatedCost;

  /// Create a copy of WorkPhotoSubmitRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkPhotoSubmitRequestImplCopyWith<_$WorkPhotoSubmitRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TechniciansQuery {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  int? get subcategoryId => throw _privateConstructorUsedError;
  int? get subSubCategoryId => throw _privateConstructorUsedError;
  int? get prioritizeSubSubCategoryId => throw _privateConstructorUsedError;
  String? get search => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  int get radiusKm => throw _privateConstructorUsedError;

  /// Create a copy of TechniciansQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechniciansQueryCopyWith<TechniciansQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechniciansQueryCopyWith<$Res> {
  factory $TechniciansQueryCopyWith(
    TechniciansQuery value,
    $Res Function(TechniciansQuery) then,
  ) = _$TechniciansQueryCopyWithImpl<$Res, TechniciansQuery>;
  @useResult
  $Res call({
    int page,
    int limit,
    int? categoryId,
    int? subcategoryId,
    int? subSubCategoryId,
    int? prioritizeSubSubCategoryId,
    String? search,
    double? lat,
    double? lng,
    int radiusKm,
  });
}

/// @nodoc
class _$TechniciansQueryCopyWithImpl<$Res, $Val extends TechniciansQuery>
    implements $TechniciansQueryCopyWith<$Res> {
  _$TechniciansQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechniciansQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? categoryId = freezed,
    Object? subcategoryId = freezed,
    Object? subSubCategoryId = freezed,
    Object? prioritizeSubSubCategoryId = freezed,
    Object? search = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? radiusKm = null,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int?,
            subcategoryId: freezed == subcategoryId
                ? _value.subcategoryId
                : subcategoryId // ignore: cast_nullable_to_non_nullable
                      as int?,
            subSubCategoryId: freezed == subSubCategoryId
                ? _value.subSubCategoryId
                : subSubCategoryId // ignore: cast_nullable_to_non_nullable
                      as int?,
            prioritizeSubSubCategoryId: freezed == prioritizeSubSubCategoryId
                ? _value.prioritizeSubSubCategoryId
                : prioritizeSubSubCategoryId // ignore: cast_nullable_to_non_nullable
                      as int?,
            search: freezed == search
                ? _value.search
                : search // ignore: cast_nullable_to_non_nullable
                      as String?,
            lat: freezed == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double?,
            lng: freezed == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double?,
            radiusKm: null == radiusKm
                ? _value.radiusKm
                : radiusKm // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechniciansQueryImplCopyWith<$Res>
    implements $TechniciansQueryCopyWith<$Res> {
  factory _$$TechniciansQueryImplCopyWith(
    _$TechniciansQueryImpl value,
    $Res Function(_$TechniciansQueryImpl) then,
  ) = __$$TechniciansQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int page,
    int limit,
    int? categoryId,
    int? subcategoryId,
    int? subSubCategoryId,
    int? prioritizeSubSubCategoryId,
    String? search,
    double? lat,
    double? lng,
    int radiusKm,
  });
}

/// @nodoc
class __$$TechniciansQueryImplCopyWithImpl<$Res>
    extends _$TechniciansQueryCopyWithImpl<$Res, _$TechniciansQueryImpl>
    implements _$$TechniciansQueryImplCopyWith<$Res> {
  __$$TechniciansQueryImplCopyWithImpl(
    _$TechniciansQueryImpl _value,
    $Res Function(_$TechniciansQueryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechniciansQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? categoryId = freezed,
    Object? subcategoryId = freezed,
    Object? subSubCategoryId = freezed,
    Object? prioritizeSubSubCategoryId = freezed,
    Object? search = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? radiusKm = null,
  }) {
    return _then(
      _$TechniciansQueryImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int?,
        subcategoryId: freezed == subcategoryId
            ? _value.subcategoryId
            : subcategoryId // ignore: cast_nullable_to_non_nullable
                  as int?,
        subSubCategoryId: freezed == subSubCategoryId
            ? _value.subSubCategoryId
            : subSubCategoryId // ignore: cast_nullable_to_non_nullable
                  as int?,
        prioritizeSubSubCategoryId: freezed == prioritizeSubSubCategoryId
            ? _value.prioritizeSubSubCategoryId
            : prioritizeSubSubCategoryId // ignore: cast_nullable_to_non_nullable
                  as int?,
        search: freezed == search
            ? _value.search
            : search // ignore: cast_nullable_to_non_nullable
                  as String?,
        lat: freezed == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double?,
        lng: freezed == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double?,
        radiusKm: null == radiusKm
            ? _value.radiusKm
            : radiusKm // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TechniciansQueryImpl implements _TechniciansQuery {
  const _$TechniciansQueryImpl({
    this.page = 1,
    this.limit = 20,
    this.categoryId,
    this.subcategoryId,
    this.subSubCategoryId,
    this.prioritizeSubSubCategoryId,
    this.search,
    this.lat,
    this.lng,
    this.radiusKm = 15,
  });

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  final int? categoryId;
  @override
  final int? subcategoryId;
  @override
  final int? subSubCategoryId;
  @override
  final int? prioritizeSubSubCategoryId;
  @override
  final String? search;
  @override
  final double? lat;
  @override
  final double? lng;
  @override
  @JsonKey()
  final int radiusKm;

  @override
  String toString() {
    return 'TechniciansQuery(page: $page, limit: $limit, categoryId: $categoryId, subcategoryId: $subcategoryId, subSubCategoryId: $subSubCategoryId, prioritizeSubSubCategoryId: $prioritizeSubSubCategoryId, search: $search, lat: $lat, lng: $lng, radiusKm: $radiusKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechniciansQueryImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.subSubCategoryId, subSubCategoryId) ||
                other.subSubCategoryId == subSubCategoryId) &&
            (identical(
                  other.prioritizeSubSubCategoryId,
                  prioritizeSubSubCategoryId,
                ) ||
                other.prioritizeSubSubCategoryId ==
                    prioritizeSubSubCategoryId) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.radiusKm, radiusKm) ||
                other.radiusKm == radiusKm));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    limit,
    categoryId,
    subcategoryId,
    subSubCategoryId,
    prioritizeSubSubCategoryId,
    search,
    lat,
    lng,
    radiusKm,
  );

  /// Create a copy of TechniciansQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechniciansQueryImplCopyWith<_$TechniciansQueryImpl> get copyWith =>
      __$$TechniciansQueryImplCopyWithImpl<_$TechniciansQueryImpl>(
        this,
        _$identity,
      );
}

abstract class _TechniciansQuery implements TechniciansQuery {
  const factory _TechniciansQuery({
    final int page,
    final int limit,
    final int? categoryId,
    final int? subcategoryId,
    final int? subSubCategoryId,
    final int? prioritizeSubSubCategoryId,
    final String? search,
    final double? lat,
    final double? lng,
    final int radiusKm,
  }) = _$TechniciansQueryImpl;

  @override
  int get page;
  @override
  int get limit;
  @override
  int? get categoryId;
  @override
  int? get subcategoryId;
  @override
  int? get subSubCategoryId;
  @override
  int? get prioritizeSubSubCategoryId;
  @override
  String? get search;
  @override
  double? get lat;
  @override
  double? get lng;
  @override
  int get radiusKm;

  /// Create a copy of TechniciansQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechniciansQueryImplCopyWith<_$TechniciansQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
