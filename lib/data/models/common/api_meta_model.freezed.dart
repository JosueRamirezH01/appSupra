// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_meta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiMetaModel _$ApiMetaModelFromJson(Map<String, dynamic> json) {
  return _ApiMetaModel.fromJson(json);
}

/// @nodoc
mixin _$ApiMetaModel {
  String? get requestId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ApiMetaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiMetaModelCopyWith<ApiMetaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiMetaModelCopyWith<$Res> {
  factory $ApiMetaModelCopyWith(
    ApiMetaModel value,
    $Res Function(ApiMetaModel) then,
  ) = _$ApiMetaModelCopyWithImpl<$Res, ApiMetaModel>;
  @useResult
  $Res call({String? requestId, DateTime timestamp});
}

/// @nodoc
class _$ApiMetaModelCopyWithImpl<$Res, $Val extends ApiMetaModel>
    implements $ApiMetaModelCopyWith<$Res> {
  _$ApiMetaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? requestId = freezed, Object? timestamp = null}) {
    return _then(
      _value.copyWith(
            requestId: freezed == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiMetaModelImplCopyWith<$Res>
    implements $ApiMetaModelCopyWith<$Res> {
  factory _$$ApiMetaModelImplCopyWith(
    _$ApiMetaModelImpl value,
    $Res Function(_$ApiMetaModelImpl) then,
  ) = __$$ApiMetaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? requestId, DateTime timestamp});
}

/// @nodoc
class __$$ApiMetaModelImplCopyWithImpl<$Res>
    extends _$ApiMetaModelCopyWithImpl<$Res, _$ApiMetaModelImpl>
    implements _$$ApiMetaModelImplCopyWith<$Res> {
  __$$ApiMetaModelImplCopyWithImpl(
    _$ApiMetaModelImpl _value,
    $Res Function(_$ApiMetaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? requestId = freezed, Object? timestamp = null}) {
    return _then(
      _$ApiMetaModelImpl(
        requestId: freezed == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiMetaModelImpl implements _ApiMetaModel {
  const _$ApiMetaModelImpl({this.requestId, required this.timestamp});

  factory _$ApiMetaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiMetaModelImplFromJson(json);

  @override
  final String? requestId;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'ApiMetaModel(requestId: $requestId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiMetaModelImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, requestId, timestamp);

  /// Create a copy of ApiMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiMetaModelImplCopyWith<_$ApiMetaModelImpl> get copyWith =>
      __$$ApiMetaModelImplCopyWithImpl<_$ApiMetaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiMetaModelImplToJson(this);
  }
}

abstract class _ApiMetaModel implements ApiMetaModel {
  const factory _ApiMetaModel({
    final String? requestId,
    required final DateTime timestamp,
  }) = _$ApiMetaModelImpl;

  factory _ApiMetaModel.fromJson(Map<String, dynamic> json) =
      _$ApiMetaModelImpl.fromJson;

  @override
  String? get requestId;
  @override
  DateTime get timestamp;

  /// Create a copy of ApiMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiMetaModelImplCopyWith<_$ApiMetaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
