// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UploadedFileModel _$UploadedFileModelFromJson(Map<String, dynamic> json) {
  return _UploadedFileModel.fromJson(json);
}

/// @nodoc
mixin _$UploadedFileModel {
  String? get category => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;
  String? get filename => throw _privateConstructorUsedError;
  String? get originalName => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;

  /// Serializes this UploadedFileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadedFileModelCopyWith<UploadedFileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadedFileModelCopyWith<$Res> {
  factory $UploadedFileModelCopyWith(
    UploadedFileModel value,
    $Res Function(UploadedFileModel) then,
  ) = _$UploadedFileModelCopyWithImpl<$Res, UploadedFileModel>;
  @useResult
  $Res call({
    String? category,
    String url,
    String? path,
    String? filename,
    String? originalName,
    String? mimeType,
    int? size,
  });
}

/// @nodoc
class _$UploadedFileModelCopyWithImpl<$Res, $Val extends UploadedFileModel>
    implements $UploadedFileModelCopyWith<$Res> {
  _$UploadedFileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? url = null,
    Object? path = freezed,
    Object? filename = freezed,
    Object? originalName = freezed,
    Object? mimeType = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _value.copyWith(
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            path: freezed == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String?,
            filename: freezed == filename
                ? _value.filename
                : filename // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalName: freezed == originalName
                ? _value.originalName
                : originalName // ignore: cast_nullable_to_non_nullable
                      as String?,
            mimeType: freezed == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String?,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UploadedFileModelImplCopyWith<$Res>
    implements $UploadedFileModelCopyWith<$Res> {
  factory _$$UploadedFileModelImplCopyWith(
    _$UploadedFileModelImpl value,
    $Res Function(_$UploadedFileModelImpl) then,
  ) = __$$UploadedFileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? category,
    String url,
    String? path,
    String? filename,
    String? originalName,
    String? mimeType,
    int? size,
  });
}

/// @nodoc
class __$$UploadedFileModelImplCopyWithImpl<$Res>
    extends _$UploadedFileModelCopyWithImpl<$Res, _$UploadedFileModelImpl>
    implements _$$UploadedFileModelImplCopyWith<$Res> {
  __$$UploadedFileModelImplCopyWithImpl(
    _$UploadedFileModelImpl _value,
    $Res Function(_$UploadedFileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? url = null,
    Object? path = freezed,
    Object? filename = freezed,
    Object? originalName = freezed,
    Object? mimeType = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _$UploadedFileModelImpl(
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        path: freezed == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String?,
        filename: freezed == filename
            ? _value.filename
            : filename // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalName: freezed == originalName
            ? _value.originalName
            : originalName // ignore: cast_nullable_to_non_nullable
                  as String?,
        mimeType: freezed == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String?,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadedFileModelImpl implements _UploadedFileModel {
  const _$UploadedFileModelImpl({
    this.category,
    required this.url,
    this.path,
    this.filename,
    this.originalName,
    this.mimeType,
    this.size,
  });

  factory _$UploadedFileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadedFileModelImplFromJson(json);

  @override
  final String? category;
  @override
  final String url;
  @override
  final String? path;
  @override
  final String? filename;
  @override
  final String? originalName;
  @override
  final String? mimeType;
  @override
  final int? size;

  @override
  String toString() {
    return 'UploadedFileModel(category: $category, url: $url, path: $path, filename: $filename, originalName: $originalName, mimeType: $mimeType, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadedFileModelImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.originalName, originalName) ||
                other.originalName == originalName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    url,
    path,
    filename,
    originalName,
    mimeType,
    size,
  );

  /// Create a copy of UploadedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadedFileModelImplCopyWith<_$UploadedFileModelImpl> get copyWith =>
      __$$UploadedFileModelImplCopyWithImpl<_$UploadedFileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadedFileModelImplToJson(this);
  }
}

abstract class _UploadedFileModel implements UploadedFileModel {
  const factory _UploadedFileModel({
    final String? category,
    required final String url,
    final String? path,
    final String? filename,
    final String? originalName,
    final String? mimeType,
    final int? size,
  }) = _$UploadedFileModelImpl;

  factory _UploadedFileModel.fromJson(Map<String, dynamic> json) =
      _$UploadedFileModelImpl.fromJson;

  @override
  String? get category;
  @override
  String get url;
  @override
  String? get path;
  @override
  String? get filename;
  @override
  String? get originalName;
  @override
  String? get mimeType;
  @override
  int? get size;

  /// Create a copy of UploadedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadedFileModelImplCopyWith<_$UploadedFileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
