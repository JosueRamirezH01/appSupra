// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ClientProfileCompletionModel _$ClientProfileCompletionModelFromJson(
  Map<String, dynamic> json,
) {
  return _ClientProfileCompletionModel.fromJson(json);
}

/// @nodoc
mixin _$ClientProfileCompletionModel {
  int get percent => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;
  List<String> get missingFields => throw _privateConstructorUsedError;

  /// Serializes this ClientProfileCompletionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClientProfileCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClientProfileCompletionModelCopyWith<ClientProfileCompletionModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientProfileCompletionModelCopyWith<$Res> {
  factory $ClientProfileCompletionModelCopyWith(
    ClientProfileCompletionModel value,
    $Res Function(ClientProfileCompletionModel) then,
  ) =
      _$ClientProfileCompletionModelCopyWithImpl<
        $Res,
        ClientProfileCompletionModel
      >;
  @useResult
  $Res call({int percent, bool isComplete, List<String> missingFields});
}

/// @nodoc
class _$ClientProfileCompletionModelCopyWithImpl<
  $Res,
  $Val extends ClientProfileCompletionModel
>
    implements $ClientProfileCompletionModelCopyWith<$Res> {
  _$ClientProfileCompletionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClientProfileCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? percent = null,
    Object? isComplete = null,
    Object? missingFields = null,
  }) {
    return _then(
      _value.copyWith(
            percent: null == percent
                ? _value.percent
                : percent // ignore: cast_nullable_to_non_nullable
                      as int,
            isComplete: null == isComplete
                ? _value.isComplete
                : isComplete // ignore: cast_nullable_to_non_nullable
                      as bool,
            missingFields: null == missingFields
                ? _value.missingFields
                : missingFields // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClientProfileCompletionModelImplCopyWith<$Res>
    implements $ClientProfileCompletionModelCopyWith<$Res> {
  factory _$$ClientProfileCompletionModelImplCopyWith(
    _$ClientProfileCompletionModelImpl value,
    $Res Function(_$ClientProfileCompletionModelImpl) then,
  ) = __$$ClientProfileCompletionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int percent, bool isComplete, List<String> missingFields});
}

/// @nodoc
class __$$ClientProfileCompletionModelImplCopyWithImpl<$Res>
    extends
        _$ClientProfileCompletionModelCopyWithImpl<
          $Res,
          _$ClientProfileCompletionModelImpl
        >
    implements _$$ClientProfileCompletionModelImplCopyWith<$Res> {
  __$$ClientProfileCompletionModelImplCopyWithImpl(
    _$ClientProfileCompletionModelImpl _value,
    $Res Function(_$ClientProfileCompletionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClientProfileCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? percent = null,
    Object? isComplete = null,
    Object? missingFields = null,
  }) {
    return _then(
      _$ClientProfileCompletionModelImpl(
        percent: null == percent
            ? _value.percent
            : percent // ignore: cast_nullable_to_non_nullable
                  as int,
        isComplete: null == isComplete
            ? _value.isComplete
            : isComplete // ignore: cast_nullable_to_non_nullable
                  as bool,
        missingFields: null == missingFields
            ? _value._missingFields
            : missingFields // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClientProfileCompletionModelImpl
    implements _ClientProfileCompletionModel {
  const _$ClientProfileCompletionModelImpl({
    required this.percent,
    required this.isComplete,
    final List<String> missingFields = const [],
  }) : _missingFields = missingFields;

  factory _$ClientProfileCompletionModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ClientProfileCompletionModelImplFromJson(json);

  @override
  final int percent;
  @override
  final bool isComplete;
  final List<String> _missingFields;
  @override
  @JsonKey()
  List<String> get missingFields {
    if (_missingFields is EqualUnmodifiableListView) return _missingFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingFields);
  }

  @override
  String toString() {
    return 'ClientProfileCompletionModel(percent: $percent, isComplete: $isComplete, missingFields: $missingFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientProfileCompletionModelImpl &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            const DeepCollectionEquality().equals(
              other._missingFields,
              _missingFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    percent,
    isComplete,
    const DeepCollectionEquality().hash(_missingFields),
  );

  /// Create a copy of ClientProfileCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientProfileCompletionModelImplCopyWith<
    _$ClientProfileCompletionModelImpl
  >
  get copyWith =>
      __$$ClientProfileCompletionModelImplCopyWithImpl<
        _$ClientProfileCompletionModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClientProfileCompletionModelImplToJson(this);
  }
}

abstract class _ClientProfileCompletionModel
    implements ClientProfileCompletionModel {
  const factory _ClientProfileCompletionModel({
    required final int percent,
    required final bool isComplete,
    final List<String> missingFields,
  }) = _$ClientProfileCompletionModelImpl;

  factory _ClientProfileCompletionModel.fromJson(Map<String, dynamic> json) =
      _$ClientProfileCompletionModelImpl.fromJson;

  @override
  int get percent;
  @override
  bool get isComplete;
  @override
  List<String> get missingFields;

  /// Create a copy of ClientProfileCompletionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClientProfileCompletionModelImplCopyWith<
    _$ClientProfileCompletionModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

ClientProfileModel _$ClientProfileModelFromJson(Map<String, dynamic> json) {
  return _ClientProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ClientProfileModel {
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this ClientProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClientProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClientProfileModelCopyWith<ClientProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientProfileModelCopyWith<$Res> {
  factory $ClientProfileModelCopyWith(
    ClientProfileModel value,
    $Res Function(ClientProfileModel) then,
  ) = _$ClientProfileModelCopyWithImpl<$Res, ClientProfileModel>;
  @useResult
  $Res call({String? phone, String? address});
}

/// @nodoc
class _$ClientProfileModelCopyWithImpl<$Res, $Val extends ClientProfileModel>
    implements $ClientProfileModelCopyWith<$Res> {
  _$ClientProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClientProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phone = freezed, Object? address = freezed}) {
    return _then(
      _value.copyWith(
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$ClientProfileModelImplCopyWith<$Res>
    implements $ClientProfileModelCopyWith<$Res> {
  factory _$$ClientProfileModelImplCopyWith(
    _$ClientProfileModelImpl value,
    $Res Function(_$ClientProfileModelImpl) then,
  ) = __$$ClientProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? phone, String? address});
}

/// @nodoc
class __$$ClientProfileModelImplCopyWithImpl<$Res>
    extends _$ClientProfileModelCopyWithImpl<$Res, _$ClientProfileModelImpl>
    implements _$$ClientProfileModelImplCopyWith<$Res> {
  __$$ClientProfileModelImplCopyWithImpl(
    _$ClientProfileModelImpl _value,
    $Res Function(_$ClientProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClientProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phone = freezed, Object? address = freezed}) {
    return _then(
      _$ClientProfileModelImpl(
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$ClientProfileModelImpl implements _ClientProfileModel {
  const _$ClientProfileModelImpl({this.phone, this.address});

  factory _$ClientProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClientProfileModelImplFromJson(json);

  @override
  final String? phone;
  @override
  final String? address;

  @override
  String toString() {
    return 'ClientProfileModel(phone: $phone, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientProfileModelImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phone, address);

  /// Create a copy of ClientProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientProfileModelImplCopyWith<_$ClientProfileModelImpl> get copyWith =>
      __$$ClientProfileModelImplCopyWithImpl<_$ClientProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ClientProfileModelImplToJson(this);
  }
}

abstract class _ClientProfileModel implements ClientProfileModel {
  const factory _ClientProfileModel({
    final String? phone,
    final String? address,
  }) = _$ClientProfileModelImpl;

  factory _ClientProfileModel.fromJson(Map<String, dynamic> json) =
      _$ClientProfileModelImpl.fromJson;

  @override
  String? get phone;
  @override
  String? get address;

  /// Create a copy of ClientProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClientProfileModelImplCopyWith<_$ClientProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TechnicianProfileSummaryModel _$TechnicianProfileSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _TechnicianProfileSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicianProfileSummaryModel {
  String? get specialty => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  String? get verificationStatus => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  bool get canResubmit => throw _privateConstructorUsedError;
  bool get canSubmitVerification => throw _privateConstructorUsedError;

  /// Serializes this TechnicianProfileSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TechnicianProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TechnicianProfileSummaryModelCopyWith<TechnicianProfileSummaryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicianProfileSummaryModelCopyWith<$Res> {
  factory $TechnicianProfileSummaryModelCopyWith(
    TechnicianProfileSummaryModel value,
    $Res Function(TechnicianProfileSummaryModel) then,
  ) =
      _$TechnicianProfileSummaryModelCopyWithImpl<
        $Res,
        TechnicianProfileSummaryModel
      >;
  @useResult
  $Res call({
    String? specialty,
    String? phone,
    bool verified,
    String? verificationStatus,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    bool canResubmit,
    bool canSubmitVerification,
  });
}

/// @nodoc
class _$TechnicianProfileSummaryModelCopyWithImpl<
  $Res,
  $Val extends TechnicianProfileSummaryModel
>
    implements $TechnicianProfileSummaryModelCopyWith<$Res> {
  _$TechnicianProfileSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TechnicianProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specialty = freezed,
    Object? phone = freezed,
    Object? verified = null,
    Object? verificationStatus = freezed,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? canResubmit = null,
    Object? canSubmitVerification = null,
  }) {
    return _then(
      _value.copyWith(
            specialty: freezed == specialty
                ? _value.specialty
                : specialty // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
            verificationStatus: freezed == verificationStatus
                ? _value.verificationStatus
                : verificationStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            canResubmit: null == canResubmit
                ? _value.canResubmit
                : canResubmit // ignore: cast_nullable_to_non_nullable
                      as bool,
            canSubmitVerification: null == canSubmitVerification
                ? _value.canSubmitVerification
                : canSubmitVerification // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TechnicianProfileSummaryModelImplCopyWith<$Res>
    implements $TechnicianProfileSummaryModelCopyWith<$Res> {
  factory _$$TechnicianProfileSummaryModelImplCopyWith(
    _$TechnicianProfileSummaryModelImpl value,
    $Res Function(_$TechnicianProfileSummaryModelImpl) then,
  ) = __$$TechnicianProfileSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? specialty,
    String? phone,
    bool verified,
    String? verificationStatus,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    bool canResubmit,
    bool canSubmitVerification,
  });
}

/// @nodoc
class __$$TechnicianProfileSummaryModelImplCopyWithImpl<$Res>
    extends
        _$TechnicianProfileSummaryModelCopyWithImpl<
          $Res,
          _$TechnicianProfileSummaryModelImpl
        >
    implements _$$TechnicianProfileSummaryModelImplCopyWith<$Res> {
  __$$TechnicianProfileSummaryModelImplCopyWithImpl(
    _$TechnicianProfileSummaryModelImpl _value,
    $Res Function(_$TechnicianProfileSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TechnicianProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specialty = freezed,
    Object? phone = freezed,
    Object? verified = null,
    Object? verificationStatus = freezed,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? canResubmit = null,
    Object? canSubmitVerification = null,
  }) {
    return _then(
      _$TechnicianProfileSummaryModelImpl(
        specialty: freezed == specialty
            ? _value.specialty
            : specialty // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
        verificationStatus: freezed == verificationStatus
            ? _value.verificationStatus
            : verificationStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        canResubmit: null == canResubmit
            ? _value.canResubmit
            : canResubmit // ignore: cast_nullable_to_non_nullable
                  as bool,
        canSubmitVerification: null == canSubmitVerification
            ? _value.canSubmitVerification
            : canSubmitVerification // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicianProfileSummaryModelImpl
    implements _TechnicianProfileSummaryModel {
  const _$TechnicianProfileSummaryModelImpl({
    this.specialty,
    this.phone,
    this.verified = false,
    this.verificationStatus,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    this.canResubmit = false,
    this.canSubmitVerification = false,
  });

  factory _$TechnicianProfileSummaryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TechnicianProfileSummaryModelImplFromJson(json);

  @override
  final String? specialty;
  @override
  final String? phone;
  @override
  @JsonKey()
  final bool verified;
  @override
  final String? verificationStatus;
  @override
  final String? rejectionReason;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? reviewedAt;
  @override
  @JsonKey()
  final bool canResubmit;
  @override
  @JsonKey()
  final bool canSubmitVerification;

  @override
  String toString() {
    return 'TechnicianProfileSummaryModel(specialty: $specialty, phone: $phone, verified: $verified, verificationStatus: $verificationStatus, rejectionReason: $rejectionReason, submittedAt: $submittedAt, reviewedAt: $reviewedAt, canResubmit: $canResubmit, canSubmitVerification: $canSubmitVerification)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicianProfileSummaryModelImpl &&
            (identical(other.specialty, specialty) ||
                other.specialty == specialty) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.canResubmit, canResubmit) ||
                other.canResubmit == canResubmit) &&
            (identical(other.canSubmitVerification, canSubmitVerification) ||
                other.canSubmitVerification == canSubmitVerification));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    specialty,
    phone,
    verified,
    verificationStatus,
    rejectionReason,
    submittedAt,
    reviewedAt,
    canResubmit,
    canSubmitVerification,
  );

  /// Create a copy of TechnicianProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicianProfileSummaryModelImplCopyWith<
    _$TechnicianProfileSummaryModelImpl
  >
  get copyWith =>
      __$$TechnicianProfileSummaryModelImplCopyWithImpl<
        _$TechnicianProfileSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicianProfileSummaryModelImplToJson(this);
  }
}

abstract class _TechnicianProfileSummaryModel
    implements TechnicianProfileSummaryModel {
  const factory _TechnicianProfileSummaryModel({
    final String? specialty,
    final String? phone,
    final bool verified,
    final String? verificationStatus,
    final String? rejectionReason,
    final DateTime? submittedAt,
    final DateTime? reviewedAt,
    final bool canResubmit,
    final bool canSubmitVerification,
  }) = _$TechnicianProfileSummaryModelImpl;

  factory _TechnicianProfileSummaryModel.fromJson(Map<String, dynamic> json) =
      _$TechnicianProfileSummaryModelImpl.fromJson;

  @override
  String? get specialty;
  @override
  String? get phone;
  @override
  bool get verified;
  @override
  String? get verificationStatus;
  @override
  String? get rejectionReason;
  @override
  DateTime? get submittedAt;
  @override
  DateTime? get reviewedAt;
  @override
  bool get canResubmit;
  @override
  bool get canSubmitVerification;

  /// Create a copy of TechnicianProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TechnicianProfileSummaryModelImplCopyWith<
    _$TechnicianProfileSummaryModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

SellerProfileSummaryModel _$SellerProfileSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _SellerProfileSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$SellerProfileSummaryModel {
  String get businessName => throw _privateConstructorUsedError;
  String get ruc => throw _privateConstructorUsedError;
  String get legalRepresentativeName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  String? get verificationStatus => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  bool get canSubmitVerification => throw _privateConstructorUsedError;

  /// Serializes this SellerProfileSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerProfileSummaryModelCopyWith<SellerProfileSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerProfileSummaryModelCopyWith<$Res> {
  factory $SellerProfileSummaryModelCopyWith(
    SellerProfileSummaryModel value,
    $Res Function(SellerProfileSummaryModel) then,
  ) = _$SellerProfileSummaryModelCopyWithImpl<$Res, SellerProfileSummaryModel>;
  @useResult
  $Res call({
    String businessName,
    String ruc,
    String legalRepresentativeName,
    String? phone,
    String? description,
    String? logoUrl,
    bool verified,
    String? verificationStatus,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    bool canSubmitVerification,
  });
}

/// @nodoc
class _$SellerProfileSummaryModelCopyWithImpl<
  $Res,
  $Val extends SellerProfileSummaryModel
>
    implements $SellerProfileSummaryModelCopyWith<$Res> {
  _$SellerProfileSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = null,
    Object? ruc = null,
    Object? legalRepresentativeName = null,
    Object? phone = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? verified = null,
    Object? verificationStatus = freezed,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? canSubmitVerification = null,
  }) {
    return _then(
      _value.copyWith(
            businessName: null == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String,
            ruc: null == ruc
                ? _value.ruc
                : ruc // ignore: cast_nullable_to_non_nullable
                      as String,
            legalRepresentativeName: null == legalRepresentativeName
                ? _value.legalRepresentativeName
                : legalRepresentativeName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            verified: null == verified
                ? _value.verified
                : verified // ignore: cast_nullable_to_non_nullable
                      as bool,
            verificationStatus: freezed == verificationStatus
                ? _value.verificationStatus
                : verificationStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            canSubmitVerification: null == canSubmitVerification
                ? _value.canSubmitVerification
                : canSubmitVerification // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SellerProfileSummaryModelImplCopyWith<$Res>
    implements $SellerProfileSummaryModelCopyWith<$Res> {
  factory _$$SellerProfileSummaryModelImplCopyWith(
    _$SellerProfileSummaryModelImpl value,
    $Res Function(_$SellerProfileSummaryModelImpl) then,
  ) = __$$SellerProfileSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String businessName,
    String ruc,
    String legalRepresentativeName,
    String? phone,
    String? description,
    String? logoUrl,
    bool verified,
    String? verificationStatus,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    bool canSubmitVerification,
  });
}

/// @nodoc
class __$$SellerProfileSummaryModelImplCopyWithImpl<$Res>
    extends
        _$SellerProfileSummaryModelCopyWithImpl<
          $Res,
          _$SellerProfileSummaryModelImpl
        >
    implements _$$SellerProfileSummaryModelImplCopyWith<$Res> {
  __$$SellerProfileSummaryModelImplCopyWithImpl(
    _$SellerProfileSummaryModelImpl _value,
    $Res Function(_$SellerProfileSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellerProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = null,
    Object? ruc = null,
    Object? legalRepresentativeName = null,
    Object? phone = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? verified = null,
    Object? verificationStatus = freezed,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? canSubmitVerification = null,
  }) {
    return _then(
      _$SellerProfileSummaryModelImpl(
        businessName: null == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String,
        ruc: null == ruc
            ? _value.ruc
            : ruc // ignore: cast_nullable_to_non_nullable
                  as String,
        legalRepresentativeName: null == legalRepresentativeName
            ? _value.legalRepresentativeName
            : legalRepresentativeName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        verified: null == verified
            ? _value.verified
            : verified // ignore: cast_nullable_to_non_nullable
                  as bool,
        verificationStatus: freezed == verificationStatus
            ? _value.verificationStatus
            : verificationStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        canSubmitVerification: null == canSubmitVerification
            ? _value.canSubmitVerification
            : canSubmitVerification // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerProfileSummaryModelImpl implements _SellerProfileSummaryModel {
  const _$SellerProfileSummaryModelImpl({
    required this.businessName,
    required this.ruc,
    required this.legalRepresentativeName,
    this.phone,
    this.description,
    this.logoUrl,
    this.verified = false,
    this.verificationStatus,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    this.canSubmitVerification = false,
  });

  factory _$SellerProfileSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerProfileSummaryModelImplFromJson(json);

  @override
  final String businessName;
  @override
  final String ruc;
  @override
  final String legalRepresentativeName;
  @override
  final String? phone;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  @JsonKey()
  final bool verified;
  @override
  final String? verificationStatus;
  @override
  final String? rejectionReason;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? reviewedAt;
  @override
  @JsonKey()
  final bool canSubmitVerification;

  @override
  String toString() {
    return 'SellerProfileSummaryModel(businessName: $businessName, ruc: $ruc, legalRepresentativeName: $legalRepresentativeName, phone: $phone, description: $description, logoUrl: $logoUrl, verified: $verified, verificationStatus: $verificationStatus, rejectionReason: $rejectionReason, submittedAt: $submittedAt, reviewedAt: $reviewedAt, canSubmitVerification: $canSubmitVerification)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerProfileSummaryModelImpl &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.ruc, ruc) || other.ruc == ruc) &&
            (identical(
                  other.legalRepresentativeName,
                  legalRepresentativeName,
                ) ||
                other.legalRepresentativeName == legalRepresentativeName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.canSubmitVerification, canSubmitVerification) ||
                other.canSubmitVerification == canSubmitVerification));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    businessName,
    ruc,
    legalRepresentativeName,
    phone,
    description,
    logoUrl,
    verified,
    verificationStatus,
    rejectionReason,
    submittedAt,
    reviewedAt,
    canSubmitVerification,
  );

  /// Create a copy of SellerProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerProfileSummaryModelImplCopyWith<_$SellerProfileSummaryModelImpl>
  get copyWith =>
      __$$SellerProfileSummaryModelImplCopyWithImpl<
        _$SellerProfileSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerProfileSummaryModelImplToJson(this);
  }
}

abstract class _SellerProfileSummaryModel implements SellerProfileSummaryModel {
  const factory _SellerProfileSummaryModel({
    required final String businessName,
    required final String ruc,
    required final String legalRepresentativeName,
    final String? phone,
    final String? description,
    final String? logoUrl,
    final bool verified,
    final String? verificationStatus,
    final String? rejectionReason,
    final DateTime? submittedAt,
    final DateTime? reviewedAt,
    final bool canSubmitVerification,
  }) = _$SellerProfileSummaryModelImpl;

  factory _SellerProfileSummaryModel.fromJson(Map<String, dynamic> json) =
      _$SellerProfileSummaryModelImpl.fromJson;

  @override
  String get businessName;
  @override
  String get ruc;
  @override
  String get legalRepresentativeName;
  @override
  String? get phone;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  bool get verified;
  @override
  String? get verificationStatus;
  @override
  String? get rejectionReason;
  @override
  DateTime? get submittedAt;
  @override
  DateTime? get reviewedAt;
  @override
  bool get canSubmitVerification;

  /// Create a copy of SellerProfileSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerProfileSummaryModelImplCopyWith<_$SellerProfileSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UserNavigationModel _$UserNavigationModelFromJson(Map<String, dynamic> json) {
  return _UserNavigationModel.fromJson(json);
}

/// @nodoc
mixin _$UserNavigationModel {
  List<String> get availableViews => throw _privateConstructorUsedError;
  String? get defaultView => throw _privateConstructorUsedError;
  bool get canBecomeTechnician => throw _privateConstructorUsedError;
  bool get canBecomeSeller => throw _privateConstructorUsedError;
  bool get technicianApplicationPending => throw _privateConstructorUsedError;
  bool get sellerApplicationPending => throw _privateConstructorUsedError;

  /// Serializes this UserNavigationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserNavigationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserNavigationModelCopyWith<UserNavigationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNavigationModelCopyWith<$Res> {
  factory $UserNavigationModelCopyWith(
    UserNavigationModel value,
    $Res Function(UserNavigationModel) then,
  ) = _$UserNavigationModelCopyWithImpl<$Res, UserNavigationModel>;
  @useResult
  $Res call({
    List<String> availableViews,
    String? defaultView,
    bool canBecomeTechnician,
    bool canBecomeSeller,
    bool technicianApplicationPending,
    bool sellerApplicationPending,
  });
}

/// @nodoc
class _$UserNavigationModelCopyWithImpl<$Res, $Val extends UserNavigationModel>
    implements $UserNavigationModelCopyWith<$Res> {
  _$UserNavigationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserNavigationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableViews = null,
    Object? defaultView = freezed,
    Object? canBecomeTechnician = null,
    Object? canBecomeSeller = null,
    Object? technicianApplicationPending = null,
    Object? sellerApplicationPending = null,
  }) {
    return _then(
      _value.copyWith(
            availableViews: null == availableViews
                ? _value.availableViews
                : availableViews // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            defaultView: freezed == defaultView
                ? _value.defaultView
                : defaultView // ignore: cast_nullable_to_non_nullable
                      as String?,
            canBecomeTechnician: null == canBecomeTechnician
                ? _value.canBecomeTechnician
                : canBecomeTechnician // ignore: cast_nullable_to_non_nullable
                      as bool,
            canBecomeSeller: null == canBecomeSeller
                ? _value.canBecomeSeller
                : canBecomeSeller // ignore: cast_nullable_to_non_nullable
                      as bool,
            technicianApplicationPending: null == technicianApplicationPending
                ? _value.technicianApplicationPending
                : technicianApplicationPending // ignore: cast_nullable_to_non_nullable
                      as bool,
            sellerApplicationPending: null == sellerApplicationPending
                ? _value.sellerApplicationPending
                : sellerApplicationPending // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserNavigationModelImplCopyWith<$Res>
    implements $UserNavigationModelCopyWith<$Res> {
  factory _$$UserNavigationModelImplCopyWith(
    _$UserNavigationModelImpl value,
    $Res Function(_$UserNavigationModelImpl) then,
  ) = __$$UserNavigationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> availableViews,
    String? defaultView,
    bool canBecomeTechnician,
    bool canBecomeSeller,
    bool technicianApplicationPending,
    bool sellerApplicationPending,
  });
}

/// @nodoc
class __$$UserNavigationModelImplCopyWithImpl<$Res>
    extends _$UserNavigationModelCopyWithImpl<$Res, _$UserNavigationModelImpl>
    implements _$$UserNavigationModelImplCopyWith<$Res> {
  __$$UserNavigationModelImplCopyWithImpl(
    _$UserNavigationModelImpl _value,
    $Res Function(_$UserNavigationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserNavigationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableViews = null,
    Object? defaultView = freezed,
    Object? canBecomeTechnician = null,
    Object? canBecomeSeller = null,
    Object? technicianApplicationPending = null,
    Object? sellerApplicationPending = null,
  }) {
    return _then(
      _$UserNavigationModelImpl(
        availableViews: null == availableViews
            ? _value._availableViews
            : availableViews // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        defaultView: freezed == defaultView
            ? _value.defaultView
            : defaultView // ignore: cast_nullable_to_non_nullable
                  as String?,
        canBecomeTechnician: null == canBecomeTechnician
            ? _value.canBecomeTechnician
            : canBecomeTechnician // ignore: cast_nullable_to_non_nullable
                  as bool,
        canBecomeSeller: null == canBecomeSeller
            ? _value.canBecomeSeller
            : canBecomeSeller // ignore: cast_nullable_to_non_nullable
                  as bool,
        technicianApplicationPending: null == technicianApplicationPending
            ? _value.technicianApplicationPending
            : technicianApplicationPending // ignore: cast_nullable_to_non_nullable
                  as bool,
        sellerApplicationPending: null == sellerApplicationPending
            ? _value.sellerApplicationPending
            : sellerApplicationPending // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserNavigationModelImpl implements _UserNavigationModel {
  const _$UserNavigationModelImpl({
    final List<String> availableViews = const [],
    this.defaultView,
    this.canBecomeTechnician = false,
    this.canBecomeSeller = false,
    this.technicianApplicationPending = false,
    this.sellerApplicationPending = false,
  }) : _availableViews = availableViews;

  factory _$UserNavigationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserNavigationModelImplFromJson(json);

  final List<String> _availableViews;
  @override
  @JsonKey()
  List<String> get availableViews {
    if (_availableViews is EqualUnmodifiableListView) return _availableViews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableViews);
  }

  @override
  final String? defaultView;
  @override
  @JsonKey()
  final bool canBecomeTechnician;
  @override
  @JsonKey()
  final bool canBecomeSeller;
  @override
  @JsonKey()
  final bool technicianApplicationPending;
  @override
  @JsonKey()
  final bool sellerApplicationPending;

  @override
  String toString() {
    return 'UserNavigationModel(availableViews: $availableViews, defaultView: $defaultView, canBecomeTechnician: $canBecomeTechnician, canBecomeSeller: $canBecomeSeller, technicianApplicationPending: $technicianApplicationPending, sellerApplicationPending: $sellerApplicationPending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNavigationModelImpl &&
            const DeepCollectionEquality().equals(
              other._availableViews,
              _availableViews,
            ) &&
            (identical(other.defaultView, defaultView) ||
                other.defaultView == defaultView) &&
            (identical(other.canBecomeTechnician, canBecomeTechnician) ||
                other.canBecomeTechnician == canBecomeTechnician) &&
            (identical(other.canBecomeSeller, canBecomeSeller) ||
                other.canBecomeSeller == canBecomeSeller) &&
            (identical(
                  other.technicianApplicationPending,
                  technicianApplicationPending,
                ) ||
                other.technicianApplicationPending ==
                    technicianApplicationPending) &&
            (identical(
                  other.sellerApplicationPending,
                  sellerApplicationPending,
                ) ||
                other.sellerApplicationPending == sellerApplicationPending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_availableViews),
    defaultView,
    canBecomeTechnician,
    canBecomeSeller,
    technicianApplicationPending,
    sellerApplicationPending,
  );

  /// Create a copy of UserNavigationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNavigationModelImplCopyWith<_$UserNavigationModelImpl> get copyWith =>
      __$$UserNavigationModelImplCopyWithImpl<_$UserNavigationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserNavigationModelImplToJson(this);
  }
}

abstract class _UserNavigationModel implements UserNavigationModel {
  const factory _UserNavigationModel({
    final List<String> availableViews,
    final String? defaultView,
    final bool canBecomeTechnician,
    final bool canBecomeSeller,
    final bool technicianApplicationPending,
    final bool sellerApplicationPending,
  }) = _$UserNavigationModelImpl;

  factory _UserNavigationModel.fromJson(Map<String, dynamic> json) =
      _$UserNavigationModelImpl.fromJson;

  @override
  List<String> get availableViews;
  @override
  String? get defaultView;
  @override
  bool get canBecomeTechnician;
  @override
  bool get canBecomeSeller;
  @override
  bool get technicianApplicationPending;
  @override
  bool get sellerApplicationPending;

  /// Create a copy of UserNavigationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserNavigationModelImplCopyWith<_$UserNavigationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserViewsModel _$UserViewsModelFromJson(Map<String, dynamic> json) {
  return _UserViewsModel.fromJson(json);
}

/// @nodoc
mixin _$UserViewsModel {
  ClientProfileModel? get client => throw _privateConstructorUsedError;
  TechnicianProfileSummaryModel? get technician =>
      throw _privateConstructorUsedError;
  SellerProfileSummaryModel? get seller => throw _privateConstructorUsedError;

  /// Serializes this UserViewsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserViewsModelCopyWith<UserViewsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserViewsModelCopyWith<$Res> {
  factory $UserViewsModelCopyWith(
    UserViewsModel value,
    $Res Function(UserViewsModel) then,
  ) = _$UserViewsModelCopyWithImpl<$Res, UserViewsModel>;
  @useResult
  $Res call({
    ClientProfileModel? client,
    TechnicianProfileSummaryModel? technician,
    SellerProfileSummaryModel? seller,
  });

  $ClientProfileModelCopyWith<$Res>? get client;
  $TechnicianProfileSummaryModelCopyWith<$Res>? get technician;
  $SellerProfileSummaryModelCopyWith<$Res>? get seller;
}

/// @nodoc
class _$UserViewsModelCopyWithImpl<$Res, $Val extends UserViewsModel>
    implements $UserViewsModelCopyWith<$Res> {
  _$UserViewsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? client = freezed,
    Object? technician = freezed,
    Object? seller = freezed,
  }) {
    return _then(
      _value.copyWith(
            client: freezed == client
                ? _value.client
                : client // ignore: cast_nullable_to_non_nullable
                      as ClientProfileModel?,
            technician: freezed == technician
                ? _value.technician
                : technician // ignore: cast_nullable_to_non_nullable
                      as TechnicianProfileSummaryModel?,
            seller: freezed == seller
                ? _value.seller
                : seller // ignore: cast_nullable_to_non_nullable
                      as SellerProfileSummaryModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClientProfileModelCopyWith<$Res>? get client {
    if (_value.client == null) {
      return null;
    }

    return $ClientProfileModelCopyWith<$Res>(_value.client!, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TechnicianProfileSummaryModelCopyWith<$Res>? get technician {
    if (_value.technician == null) {
      return null;
    }

    return $TechnicianProfileSummaryModelCopyWith<$Res>(_value.technician!, (
      value,
    ) {
      return _then(_value.copyWith(technician: value) as $Val);
    });
  }

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerProfileSummaryModelCopyWith<$Res>? get seller {
    if (_value.seller == null) {
      return null;
    }

    return $SellerProfileSummaryModelCopyWith<$Res>(_value.seller!, (value) {
      return _then(_value.copyWith(seller: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserViewsModelImplCopyWith<$Res>
    implements $UserViewsModelCopyWith<$Res> {
  factory _$$UserViewsModelImplCopyWith(
    _$UserViewsModelImpl value,
    $Res Function(_$UserViewsModelImpl) then,
  ) = __$$UserViewsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ClientProfileModel? client,
    TechnicianProfileSummaryModel? technician,
    SellerProfileSummaryModel? seller,
  });

  @override
  $ClientProfileModelCopyWith<$Res>? get client;
  @override
  $TechnicianProfileSummaryModelCopyWith<$Res>? get technician;
  @override
  $SellerProfileSummaryModelCopyWith<$Res>? get seller;
}

/// @nodoc
class __$$UserViewsModelImplCopyWithImpl<$Res>
    extends _$UserViewsModelCopyWithImpl<$Res, _$UserViewsModelImpl>
    implements _$$UserViewsModelImplCopyWith<$Res> {
  __$$UserViewsModelImplCopyWithImpl(
    _$UserViewsModelImpl _value,
    $Res Function(_$UserViewsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? client = freezed,
    Object? technician = freezed,
    Object? seller = freezed,
  }) {
    return _then(
      _$UserViewsModelImpl(
        client: freezed == client
            ? _value.client
            : client // ignore: cast_nullable_to_non_nullable
                  as ClientProfileModel?,
        technician: freezed == technician
            ? _value.technician
            : technician // ignore: cast_nullable_to_non_nullable
                  as TechnicianProfileSummaryModel?,
        seller: freezed == seller
            ? _value.seller
            : seller // ignore: cast_nullable_to_non_nullable
                  as SellerProfileSummaryModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserViewsModelImpl implements _UserViewsModel {
  const _$UserViewsModelImpl({this.client, this.technician, this.seller});

  factory _$UserViewsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserViewsModelImplFromJson(json);

  @override
  final ClientProfileModel? client;
  @override
  final TechnicianProfileSummaryModel? technician;
  @override
  final SellerProfileSummaryModel? seller;

  @override
  String toString() {
    return 'UserViewsModel(client: $client, technician: $technician, seller: $seller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserViewsModelImpl &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.technician, technician) ||
                other.technician == technician) &&
            (identical(other.seller, seller) || other.seller == seller));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, client, technician, seller);

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserViewsModelImplCopyWith<_$UserViewsModelImpl> get copyWith =>
      __$$UserViewsModelImplCopyWithImpl<_$UserViewsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserViewsModelImplToJson(this);
  }
}

abstract class _UserViewsModel implements UserViewsModel {
  const factory _UserViewsModel({
    final ClientProfileModel? client,
    final TechnicianProfileSummaryModel? technician,
    final SellerProfileSummaryModel? seller,
  }) = _$UserViewsModelImpl;

  factory _UserViewsModel.fromJson(Map<String, dynamic> json) =
      _$UserViewsModelImpl.fromJson;

  @override
  ClientProfileModel? get client;
  @override
  TechnicianProfileSummaryModel? get technician;
  @override
  SellerProfileSummaryModel? get seller;

  /// Create a copy of UserViewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserViewsModelImplCopyWith<_$UserViewsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  UserNavigationModel? get navigation => throw _privateConstructorUsedError;
  UserViewsModel? get views => throw _privateConstructorUsedError;
  ClientProfileCompletionModel? get profileCompletion =>
      throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String email,
    String? profilePhotoUrl,
    List<String> roles,
    UserNavigationModel? navigation,
    UserViewsModel? views,
    ClientProfileCompletionModel? profileCompletion,
    bool active,
    DateTime? createdAt,
  });

  $UserNavigationModelCopyWith<$Res>? get navigation;
  $UserViewsModelCopyWith<$Res>? get views;
  $ClientProfileCompletionModelCopyWith<$Res>? get profileCompletion;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? profilePhotoUrl = freezed,
    Object? roles = null,
    Object? navigation = freezed,
    Object? views = freezed,
    Object? profileCompletion = freezed,
    Object? active = null,
    Object? createdAt = freezed,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            navigation: freezed == navigation
                ? _value.navigation
                : navigation // ignore: cast_nullable_to_non_nullable
                      as UserNavigationModel?,
            views: freezed == views
                ? _value.views
                : views // ignore: cast_nullable_to_non_nullable
                      as UserViewsModel?,
            profileCompletion: freezed == profileCompletion
                ? _value.profileCompletion
                : profileCompletion // ignore: cast_nullable_to_non_nullable
                      as ClientProfileCompletionModel?,
            active: null == active
                ? _value.active
                : active // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserNavigationModelCopyWith<$Res>? get navigation {
    if (_value.navigation == null) {
      return null;
    }

    return $UserNavigationModelCopyWith<$Res>(_value.navigation!, (value) {
      return _then(_value.copyWith(navigation: value) as $Val);
    });
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserViewsModelCopyWith<$Res>? get views {
    if (_value.views == null) {
      return null;
    }

    return $UserViewsModelCopyWith<$Res>(_value.views!, (value) {
      return _then(_value.copyWith(views: value) as $Val);
    });
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClientProfileCompletionModelCopyWith<$Res>? get profileCompletion {
    if (_value.profileCompletion == null) {
      return null;
    }

    return $ClientProfileCompletionModelCopyWith<$Res>(
      _value.profileCompletion!,
      (value) {
        return _then(_value.copyWith(profileCompletion: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String email,
    String? profilePhotoUrl,
    List<String> roles,
    UserNavigationModel? navigation,
    UserViewsModel? views,
    ClientProfileCompletionModel? profileCompletion,
    bool active,
    DateTime? createdAt,
  });

  @override
  $UserNavigationModelCopyWith<$Res>? get navigation;
  @override
  $UserViewsModelCopyWith<$Res>? get views;
  @override
  $ClientProfileCompletionModelCopyWith<$Res>? get profileCompletion;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? profilePhotoUrl = freezed,
    Object? roles = null,
    Object? navigation = freezed,
    Object? views = freezed,
    Object? profileCompletion = freezed,
    Object? active = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        navigation: freezed == navigation
            ? _value.navigation
            : navigation // ignore: cast_nullable_to_non_nullable
                  as UserNavigationModel?,
        views: freezed == views
            ? _value.views
            : views // ignore: cast_nullable_to_non_nullable
                  as UserViewsModel?,
        profileCompletion: freezed == profileCompletion
            ? _value.profileCompletion
            : profileCompletion // ignore: cast_nullable_to_non_nullable
                  as ClientProfileCompletionModel?,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhotoUrl,
    final List<String> roles = const [],
    this.navigation,
    this.views,
    this.profileCompletion,
    this.active = true,
    this.createdAt,
  }) : _roles = roles;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? profilePhotoUrl;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final UserNavigationModel? navigation;
  @override
  final UserViewsModel? views;
  @override
  final ClientProfileCompletionModel? profileCompletion;
  @override
  @JsonKey()
  final bool active;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePhotoUrl: $profilePhotoUrl, roles: $roles, navigation: $navigation, views: $views, profileCompletion: $profileCompletion, active: $active, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.navigation, navigation) ||
                other.navigation == navigation) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.profileCompletion, profileCompletion) ||
                other.profileCompletion == profileCompletion) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    profilePhotoUrl,
    const DeepCollectionEquality().hash(_roles),
    navigation,
    views,
    profileCompletion,
    active,
    createdAt,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final int id,
    required final String name,
    required final String email,
    final String? profilePhotoUrl,
    final List<String> roles,
    final UserNavigationModel? navigation,
    final UserViewsModel? views,
    final ClientProfileCompletionModel? profileCompletion,
    final bool active,
    final DateTime? createdAt,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String? get profilePhotoUrl;
  @override
  List<String> get roles;
  @override
  UserNavigationModel? get navigation;
  @override
  UserViewsModel? get views;
  @override
  ClientProfileCompletionModel? get profileCompletion;
  @override
  bool get active;
  @override
  DateTime? get createdAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
