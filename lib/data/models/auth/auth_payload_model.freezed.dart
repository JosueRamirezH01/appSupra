// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_payload_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthPayloadModel _$AuthPayloadModelFromJson(Map<String, dynamic> json) {
  return _AuthPayloadModel.fromJson(json);
}

/// @nodoc
mixin _$AuthPayloadModel {
  UserModel get user => throw _privateConstructorUsedError;
  SessionModel get session => throw _privateConstructorUsedError;

  /// Serializes this AuthPayloadModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthPayloadModelCopyWith<AuthPayloadModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthPayloadModelCopyWith<$Res> {
  factory $AuthPayloadModelCopyWith(
    AuthPayloadModel value,
    $Res Function(AuthPayloadModel) then,
  ) = _$AuthPayloadModelCopyWithImpl<$Res, AuthPayloadModel>;
  @useResult
  $Res call({UserModel user, SessionModel session});

  $UserModelCopyWith<$Res> get user;
  $SessionModelCopyWith<$Res> get session;
}

/// @nodoc
class _$AuthPayloadModelCopyWithImpl<$Res, $Val extends AuthPayloadModel>
    implements $AuthPayloadModelCopyWith<$Res> {
  _$AuthPayloadModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? session = null}) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            session: null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as SessionModel,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionModelCopyWith<$Res> get session {
    return $SessionModelCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthPayloadModelImplCopyWith<$Res>
    implements $AuthPayloadModelCopyWith<$Res> {
  factory _$$AuthPayloadModelImplCopyWith(
    _$AuthPayloadModelImpl value,
    $Res Function(_$AuthPayloadModelImpl) then,
  ) = __$$AuthPayloadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel user, SessionModel session});

  @override
  $UserModelCopyWith<$Res> get user;
  @override
  $SessionModelCopyWith<$Res> get session;
}

/// @nodoc
class __$$AuthPayloadModelImplCopyWithImpl<$Res>
    extends _$AuthPayloadModelCopyWithImpl<$Res, _$AuthPayloadModelImpl>
    implements _$$AuthPayloadModelImplCopyWith<$Res> {
  __$$AuthPayloadModelImplCopyWithImpl(
    _$AuthPayloadModelImpl _value,
    $Res Function(_$AuthPayloadModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? session = null}) {
    return _then(
      _$AuthPayloadModelImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as SessionModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthPayloadModelImpl implements _AuthPayloadModel {
  const _$AuthPayloadModelImpl({required this.user, required this.session});

  factory _$AuthPayloadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthPayloadModelImplFromJson(json);

  @override
  final UserModel user;
  @override
  final SessionModel session;

  @override
  String toString() {
    return 'AuthPayloadModel(user: $user, session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthPayloadModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.session, session) || other.session == session));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user, session);

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthPayloadModelImplCopyWith<_$AuthPayloadModelImpl> get copyWith =>
      __$$AuthPayloadModelImplCopyWithImpl<_$AuthPayloadModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthPayloadModelImplToJson(this);
  }
}

abstract class _AuthPayloadModel implements AuthPayloadModel {
  const factory _AuthPayloadModel({
    required final UserModel user,
    required final SessionModel session,
  }) = _$AuthPayloadModelImpl;

  factory _AuthPayloadModel.fromJson(Map<String, dynamic> json) =
      _$AuthPayloadModelImpl.fromJson;

  @override
  UserModel get user;
  @override
  SessionModel get session;

  /// Create a copy of AuthPayloadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthPayloadModelImplCopyWith<_$AuthPayloadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
    LoginRequest value,
    $Res Function(LoginRequest) then,
  ) = _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
    _$LoginRequestImpl value,
    $Res Function(_$LoginRequestImpl) then,
  ) = __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
    _$LoginRequestImpl _value,
    $Res Function(_$LoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$LoginRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({required this.email, required this.password});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(this);
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest({
    required final String email,
    required final String password,
  }) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoogleLoginRequest _$GoogleLoginRequestFromJson(Map<String, dynamic> json) {
  return _GoogleLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$GoogleLoginRequest {
  String get idToken => throw _privateConstructorUsedError;

  /// Serializes this GoogleLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoogleLoginRequestCopyWith<GoogleLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleLoginRequestCopyWith<$Res> {
  factory $GoogleLoginRequestCopyWith(
    GoogleLoginRequest value,
    $Res Function(GoogleLoginRequest) then,
  ) = _$GoogleLoginRequestCopyWithImpl<$Res, GoogleLoginRequest>;
  @useResult
  $Res call({String idToken});
}

/// @nodoc
class _$GoogleLoginRequestCopyWithImpl<$Res, $Val extends GoogleLoginRequest>
    implements $GoogleLoginRequestCopyWith<$Res> {
  _$GoogleLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? idToken = null}) {
    return _then(
      _value.copyWith(
            idToken: null == idToken
                ? _value.idToken
                : idToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GoogleLoginRequestImplCopyWith<$Res>
    implements $GoogleLoginRequestCopyWith<$Res> {
  factory _$$GoogleLoginRequestImplCopyWith(
    _$GoogleLoginRequestImpl value,
    $Res Function(_$GoogleLoginRequestImpl) then,
  ) = __$$GoogleLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String idToken});
}

/// @nodoc
class __$$GoogleLoginRequestImplCopyWithImpl<$Res>
    extends _$GoogleLoginRequestCopyWithImpl<$Res, _$GoogleLoginRequestImpl>
    implements _$$GoogleLoginRequestImplCopyWith<$Res> {
  __$$GoogleLoginRequestImplCopyWithImpl(
    _$GoogleLoginRequestImpl _value,
    $Res Function(_$GoogleLoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? idToken = null}) {
    return _then(
      _$GoogleLoginRequestImpl(
        idToken: null == idToken
            ? _value.idToken
            : idToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleLoginRequestImpl implements _GoogleLoginRequest {
  const _$GoogleLoginRequestImpl({required this.idToken});

  factory _$GoogleLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleLoginRequestImplFromJson(json);

  @override
  final String idToken;

  @override
  String toString() {
    return 'GoogleLoginRequest(idToken: $idToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleLoginRequestImpl &&
            (identical(other.idToken, idToken) || other.idToken == idToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idToken);

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleLoginRequestImplCopyWith<_$GoogleLoginRequestImpl> get copyWith =>
      __$$GoogleLoginRequestImplCopyWithImpl<_$GoogleLoginRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleLoginRequestImplToJson(this);
  }
}

abstract class _GoogleLoginRequest implements GoogleLoginRequest {
  const factory _GoogleLoginRequest({required final String idToken}) =
      _$GoogleLoginRequestImpl;

  factory _GoogleLoginRequest.fromJson(Map<String, dynamic> json) =
      _$GoogleLoginRequestImpl.fromJson;

  @override
  String get idToken;

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoogleLoginRequestImplCopyWith<_$GoogleLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefreshRequest _$RefreshRequestFromJson(Map<String, dynamic> json) {
  return _RefreshRequest.fromJson(json);
}

/// @nodoc
mixin _$RefreshRequest {
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this RefreshRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshRequestCopyWith<RefreshRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshRequestCopyWith<$Res> {
  factory $RefreshRequestCopyWith(
    RefreshRequest value,
    $Res Function(RefreshRequest) then,
  ) = _$RefreshRequestCopyWithImpl<$Res, RefreshRequest>;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class _$RefreshRequestCopyWithImpl<$Res, $Val extends RefreshRequest>
    implements $RefreshRequestCopyWith<$Res> {
  _$RefreshRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _value.copyWith(
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefreshRequestImplCopyWith<$Res>
    implements $RefreshRequestCopyWith<$Res> {
  factory _$$RefreshRequestImplCopyWith(
    _$RefreshRequestImpl value,
    $Res Function(_$RefreshRequestImpl) then,
  ) = __$$RefreshRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$$RefreshRequestImplCopyWithImpl<$Res>
    extends _$RefreshRequestCopyWithImpl<$Res, _$RefreshRequestImpl>
    implements _$$RefreshRequestImplCopyWith<$Res> {
  __$$RefreshRequestImplCopyWithImpl(
    _$RefreshRequestImpl _value,
    $Res Function(_$RefreshRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _$RefreshRequestImpl(
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshRequestImpl implements _RefreshRequest {
  const _$RefreshRequestImpl({required this.refreshToken});

  factory _$RefreshRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshRequestImplFromJson(json);

  @override
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshRequest(refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshRequestImplCopyWith<_$RefreshRequestImpl> get copyWith =>
      __$$RefreshRequestImplCopyWithImpl<_$RefreshRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshRequestImplToJson(this);
  }
}

abstract class _RefreshRequest implements RefreshRequest {
  const factory _RefreshRequest({required final String refreshToken}) =
      _$RefreshRequestImpl;

  factory _RefreshRequest.fromJson(Map<String, dynamic> json) =
      _$RefreshRequestImpl.fromJson;

  @override
  String get refreshToken;

  /// Create a copy of RefreshRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshRequestImplCopyWith<_$RefreshRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterClientRequest _$RegisterClientRequestFromJson(
  Map<String, dynamic> json,
) {
  return _RegisterClientRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterClientRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this RegisterClientRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterClientRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterClientRequestCopyWith<RegisterClientRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterClientRequestCopyWith<$Res> {
  factory $RegisterClientRequestCopyWith(
    RegisterClientRequest value,
    $Res Function(RegisterClientRequest) then,
  ) = _$RegisterClientRequestCopyWithImpl<$Res, RegisterClientRequest>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$RegisterClientRequestCopyWithImpl<
  $Res,
  $Val extends RegisterClientRequest
>
    implements $RegisterClientRequestCopyWith<$Res> {
  _$RegisterClientRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterClientRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterClientRequestImplCopyWith<$Res>
    implements $RegisterClientRequestCopyWith<$Res> {
  factory _$$RegisterClientRequestImplCopyWith(
    _$RegisterClientRequestImpl value,
    $Res Function(_$RegisterClientRequestImpl) then,
  ) = __$$RegisterClientRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$RegisterClientRequestImplCopyWithImpl<$Res>
    extends
        _$RegisterClientRequestCopyWithImpl<$Res, _$RegisterClientRequestImpl>
    implements _$$RegisterClientRequestImplCopyWith<$Res> {
  __$$RegisterClientRequestImplCopyWithImpl(
    _$RegisterClientRequestImpl _value,
    $Res Function(_$RegisterClientRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterClientRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$RegisterClientRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterClientRequestImpl implements _RegisterClientRequest {
  const _$RegisterClientRequestImpl({
    required this.email,
    required this.password,
  });

  factory _$RegisterClientRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterClientRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'RegisterClientRequest(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterClientRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of RegisterClientRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterClientRequestImplCopyWith<_$RegisterClientRequestImpl>
  get copyWith =>
      __$$RegisterClientRequestImplCopyWithImpl<_$RegisterClientRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterClientRequestImplToJson(this);
  }
}

abstract class _RegisterClientRequest implements RegisterClientRequest {
  const factory _RegisterClientRequest({
    required final String email,
    required final String password,
  }) = _$RegisterClientRequestImpl;

  factory _RegisterClientRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterClientRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of RegisterClientRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterClientRequestImplCopyWith<_$RegisterClientRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
  Map<String, dynamic> json,
) {
  return _ForgotPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordRequest {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ForgotPasswordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordRequestCopyWith<ForgotPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordRequestCopyWith<$Res> {
  factory $ForgotPasswordRequestCopyWith(
    ForgotPasswordRequest value,
    $Res Function(ForgotPasswordRequest) then,
  ) = _$ForgotPasswordRequestCopyWithImpl<$Res, ForgotPasswordRequest>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$ForgotPasswordRequestCopyWithImpl<
  $Res,
  $Val extends ForgotPasswordRequest
>
    implements $ForgotPasswordRequestCopyWith<$Res> {
  _$ForgotPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForgotPasswordRequestImplCopyWith<$Res>
    implements $ForgotPasswordRequestCopyWith<$Res> {
  factory _$$ForgotPasswordRequestImplCopyWith(
    _$ForgotPasswordRequestImpl value,
    $Res Function(_$ForgotPasswordRequestImpl) then,
  ) = __$$ForgotPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ForgotPasswordRequestImplCopyWithImpl<$Res>
    extends
        _$ForgotPasswordRequestCopyWithImpl<$Res, _$ForgotPasswordRequestImpl>
    implements _$$ForgotPasswordRequestImplCopyWith<$Res> {
  __$$ForgotPasswordRequestImplCopyWithImpl(
    _$ForgotPasswordRequestImpl _value,
    $Res Function(_$ForgotPasswordRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$ForgotPasswordRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordRequestImpl implements _ForgotPasswordRequest {
  const _$ForgotPasswordRequestImpl({required this.email});

  factory _$ForgotPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordRequestImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'ForgotPasswordRequest(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordRequestImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordRequestImplCopyWith<_$ForgotPasswordRequestImpl>
  get copyWith =>
      __$$ForgotPasswordRequestImplCopyWithImpl<_$ForgotPasswordRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordRequestImplToJson(this);
  }
}

abstract class _ForgotPasswordRequest implements ForgotPasswordRequest {
  const factory _ForgotPasswordRequest({required final String email}) =
      _$ForgotPasswordRequestImpl;

  factory _ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordRequestImpl.fromJson;

  @override
  String get email;

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordRequestImplCopyWith<_$ForgotPasswordRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UpdateClientProfileRequest _$UpdateClientProfileRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateClientProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateClientProfileRequest {
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  String? get uploadSessionId => throw _privateConstructorUsedError;

  /// Serializes this UpdateClientProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateClientProfileRequestCopyWith<UpdateClientProfileRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateClientProfileRequestCopyWith<$Res> {
  factory $UpdateClientProfileRequestCopyWith(
    UpdateClientProfileRequest value,
    $Res Function(UpdateClientProfileRequest) then,
  ) =
      _$UpdateClientProfileRequestCopyWithImpl<
        $Res,
        UpdateClientProfileRequest
      >;
  @useResult
  $Res call({
    String? name,
    String? phone,
    String? profilePhotoUrl,
    String? uploadSessionId,
  });
}

/// @nodoc
class _$UpdateClientProfileRequestCopyWithImpl<
  $Res,
  $Val extends UpdateClientProfileRequest
>
    implements $UpdateClientProfileRequestCopyWith<$Res> {
  _$UpdateClientProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? phone = freezed,
    Object? profilePhotoUrl = freezed,
    Object? uploadSessionId = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$UpdateClientProfileRequestImplCopyWith<$Res>
    implements $UpdateClientProfileRequestCopyWith<$Res> {
  factory _$$UpdateClientProfileRequestImplCopyWith(
    _$UpdateClientProfileRequestImpl value,
    $Res Function(_$UpdateClientProfileRequestImpl) then,
  ) = __$$UpdateClientProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    String? phone,
    String? profilePhotoUrl,
    String? uploadSessionId,
  });
}

/// @nodoc
class __$$UpdateClientProfileRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateClientProfileRequestCopyWithImpl<
          $Res,
          _$UpdateClientProfileRequestImpl
        >
    implements _$$UpdateClientProfileRequestImplCopyWith<$Res> {
  __$$UpdateClientProfileRequestImplCopyWithImpl(
    _$UpdateClientProfileRequestImpl _value,
    $Res Function(_$UpdateClientProfileRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? phone = freezed,
    Object? profilePhotoUrl = freezed,
    Object? uploadSessionId = freezed,
  }) {
    return _then(
      _$UpdateClientProfileRequestImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$UpdateClientProfileRequestImpl implements _UpdateClientProfileRequest {
  const _$UpdateClientProfileRequestImpl({
    this.name,
    this.phone,
    this.profilePhotoUrl,
    this.uploadSessionId,
  });

  factory _$UpdateClientProfileRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$UpdateClientProfileRequestImplFromJson(json);

  @override
  final String? name;
  @override
  final String? phone;
  @override
  final String? profilePhotoUrl;
  @override
  final String? uploadSessionId;

  @override
  String toString() {
    return 'UpdateClientProfileRequest(name: $name, phone: $phone, profilePhotoUrl: $profilePhotoUrl, uploadSessionId: $uploadSessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateClientProfileRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.uploadSessionId, uploadSessionId) ||
                other.uploadSessionId == uploadSessionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, phone, profilePhotoUrl, uploadSessionId);

  /// Create a copy of UpdateClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateClientProfileRequestImplCopyWith<_$UpdateClientProfileRequestImpl>
  get copyWith =>
      __$$UpdateClientProfileRequestImplCopyWithImpl<
        _$UpdateClientProfileRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateClientProfileRequestImplToJson(this);
  }
}

abstract class _UpdateClientProfileRequest
    implements UpdateClientProfileRequest {
  const factory _UpdateClientProfileRequest({
    final String? name,
    final String? phone,
    final String? profilePhotoUrl,
    final String? uploadSessionId,
  }) = _$UpdateClientProfileRequestImpl;

  factory _UpdateClientProfileRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateClientProfileRequestImpl.fromJson;

  @override
  String? get name;
  @override
  String? get phone;
  @override
  String? get profilePhotoUrl;
  @override
  String? get uploadSessionId;

  /// Create a copy of UpdateClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateClientProfileRequestImplCopyWith<_$UpdateClientProfileRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AddClientProfileRequest _$AddClientProfileRequestFromJson(
  Map<String, dynamic> json,
) {
  return _AddClientProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$AddClientProfileRequest {
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this AddClientProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddClientProfileRequestCopyWith<AddClientProfileRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddClientProfileRequestCopyWith<$Res> {
  factory $AddClientProfileRequestCopyWith(
    AddClientProfileRequest value,
    $Res Function(AddClientProfileRequest) then,
  ) = _$AddClientProfileRequestCopyWithImpl<$Res, AddClientProfileRequest>;
  @useResult
  $Res call({String? phone, String? address});
}

/// @nodoc
class _$AddClientProfileRequestCopyWithImpl<
  $Res,
  $Val extends AddClientProfileRequest
>
    implements $AddClientProfileRequestCopyWith<$Res> {
  _$AddClientProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddClientProfileRequest
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
abstract class _$$AddClientProfileRequestImplCopyWith<$Res>
    implements $AddClientProfileRequestCopyWith<$Res> {
  factory _$$AddClientProfileRequestImplCopyWith(
    _$AddClientProfileRequestImpl value,
    $Res Function(_$AddClientProfileRequestImpl) then,
  ) = __$$AddClientProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? phone, String? address});
}

/// @nodoc
class __$$AddClientProfileRequestImplCopyWithImpl<$Res>
    extends
        _$AddClientProfileRequestCopyWithImpl<
          $Res,
          _$AddClientProfileRequestImpl
        >
    implements _$$AddClientProfileRequestImplCopyWith<$Res> {
  __$$AddClientProfileRequestImplCopyWithImpl(
    _$AddClientProfileRequestImpl _value,
    $Res Function(_$AddClientProfileRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phone = freezed, Object? address = freezed}) {
    return _then(
      _$AddClientProfileRequestImpl(
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
class _$AddClientProfileRequestImpl implements _AddClientProfileRequest {
  const _$AddClientProfileRequestImpl({this.phone, this.address});

  factory _$AddClientProfileRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddClientProfileRequestImplFromJson(json);

  @override
  final String? phone;
  @override
  final String? address;

  @override
  String toString() {
    return 'AddClientProfileRequest(phone: $phone, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddClientProfileRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phone, address);

  /// Create a copy of AddClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddClientProfileRequestImplCopyWith<_$AddClientProfileRequestImpl>
  get copyWith =>
      __$$AddClientProfileRequestImplCopyWithImpl<
        _$AddClientProfileRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddClientProfileRequestImplToJson(this);
  }
}

abstract class _AddClientProfileRequest implements AddClientProfileRequest {
  const factory _AddClientProfileRequest({
    final String? phone,
    final String? address,
  }) = _$AddClientProfileRequestImpl;

  factory _AddClientProfileRequest.fromJson(Map<String, dynamic> json) =
      _$AddClientProfileRequestImpl.fromJson;

  @override
  String? get phone;
  @override
  String? get address;

  /// Create a copy of AddClientProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddClientProfileRequestImplCopyWith<_$AddClientProfileRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RegisterTechnicianRequest _$RegisterTechnicianRequestFromJson(
  Map<String, dynamic> json,
) {
  return _RegisterTechnicianRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterTechnicianRequest {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  List<int> get subcategoryIds => throw _privateConstructorUsedError;
  String get documentNumber => throw _privateConstructorUsedError;
  String? get specialty => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get documentType => throw _privateConstructorUsedError;
  List<int>? get subSubCategoryIds => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get experienceYears => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  String? get uploadSessionId => throw _privateConstructorUsedError;
  String get profileType => throw _privateConstructorUsedError;
  String? get ruc => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get legalRepresentativeName => throw _privateConstructorUsedError;

  /// Serializes this RegisterTechnicianRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterTechnicianRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterTechnicianRequestCopyWith<RegisterTechnicianRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterTechnicianRequestCopyWith<$Res> {
  factory $RegisterTechnicianRequestCopyWith(
    RegisterTechnicianRequest value,
    $Res Function(RegisterTechnicianRequest) then,
  ) = _$RegisterTechnicianRequestCopyWithImpl<$Res, RegisterTechnicianRequest>;
  @useResult
  $Res call({
    String name,
    String email,
    String password,
    String phone,
    List<int> subcategoryIds,
    String documentNumber,
    String? specialty,
    String? address,
    String documentType,
    List<int>? subSubCategoryIds,
    String? description,
    int? experienceYears,
    String? profilePhotoUrl,
    String? uploadSessionId,
    String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
  });
}

/// @nodoc
class _$RegisterTechnicianRequestCopyWithImpl<
  $Res,
  $Val extends RegisterTechnicianRequest
>
    implements $RegisterTechnicianRequestCopyWith<$Res> {
  _$RegisterTechnicianRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterTechnicianRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? phone = null,
    Object? subcategoryIds = null,
    Object? documentNumber = null,
    Object? specialty = freezed,
    Object? address = freezed,
    Object? documentType = null,
    Object? subSubCategoryIds = freezed,
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? profilePhotoUrl = freezed,
    Object? uploadSessionId = freezed,
    Object? profileType = null,
    Object? ruc = freezed,
    Object? businessName = freezed,
    Object? legalRepresentativeName = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            subcategoryIds: null == subcategoryIds
                ? _value.subcategoryIds
                : subcategoryIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            documentNumber: null == documentNumber
                ? _value.documentNumber
                : documentNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            specialty: freezed == specialty
                ? _value.specialty
                : specialty // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentType: null == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as String,
            subSubCategoryIds: freezed == subSubCategoryIds
                ? _value.subSubCategoryIds
                : subSubCategoryIds // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            uploadSessionId: freezed == uploadSessionId
                ? _value.uploadSessionId
                : uploadSessionId // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterTechnicianRequestImplCopyWith<$Res>
    implements $RegisterTechnicianRequestCopyWith<$Res> {
  factory _$$RegisterTechnicianRequestImplCopyWith(
    _$RegisterTechnicianRequestImpl value,
    $Res Function(_$RegisterTechnicianRequestImpl) then,
  ) = __$$RegisterTechnicianRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String email,
    String password,
    String phone,
    List<int> subcategoryIds,
    String documentNumber,
    String? specialty,
    String? address,
    String documentType,
    List<int>? subSubCategoryIds,
    String? description,
    int? experienceYears,
    String? profilePhotoUrl,
    String? uploadSessionId,
    String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
  });
}

/// @nodoc
class __$$RegisterTechnicianRequestImplCopyWithImpl<$Res>
    extends
        _$RegisterTechnicianRequestCopyWithImpl<
          $Res,
          _$RegisterTechnicianRequestImpl
        >
    implements _$$RegisterTechnicianRequestImplCopyWith<$Res> {
  __$$RegisterTechnicianRequestImplCopyWithImpl(
    _$RegisterTechnicianRequestImpl _value,
    $Res Function(_$RegisterTechnicianRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterTechnicianRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? phone = null,
    Object? subcategoryIds = null,
    Object? documentNumber = null,
    Object? specialty = freezed,
    Object? address = freezed,
    Object? documentType = null,
    Object? subSubCategoryIds = freezed,
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? profilePhotoUrl = freezed,
    Object? uploadSessionId = freezed,
    Object? profileType = null,
    Object? ruc = freezed,
    Object? businessName = freezed,
    Object? legalRepresentativeName = freezed,
  }) {
    return _then(
      _$RegisterTechnicianRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        subcategoryIds: null == subcategoryIds
            ? _value._subcategoryIds
            : subcategoryIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        documentNumber: null == documentNumber
            ? _value.documentNumber
            : documentNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        specialty: freezed == specialty
            ? _value.specialty
            : specialty // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentType: null == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as String,
        subSubCategoryIds: freezed == subSubCategoryIds
            ? _value._subSubCategoryIds
            : subSubCategoryIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        uploadSessionId: freezed == uploadSessionId
            ? _value.uploadSessionId
            : uploadSessionId // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterTechnicianRequestImpl implements _RegisterTechnicianRequest {
  const _$RegisterTechnicianRequestImpl({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required final List<int> subcategoryIds,
    required this.documentNumber,
    this.specialty,
    this.address,
    this.documentType = 'DNI',
    final List<int>? subSubCategoryIds,
    this.description,
    this.experienceYears,
    this.profilePhotoUrl,
    this.uploadSessionId,
    this.profileType = 'independiente',
    this.ruc,
    this.businessName,
    this.legalRepresentativeName,
  }) : _subcategoryIds = subcategoryIds,
       _subSubCategoryIds = subSubCategoryIds;

  factory _$RegisterTechnicianRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterTechnicianRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final String password;
  @override
  final String phone;
  final List<int> _subcategoryIds;
  @override
  List<int> get subcategoryIds {
    if (_subcategoryIds is EqualUnmodifiableListView) return _subcategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategoryIds);
  }

  @override
  final String documentNumber;
  @override
  final String? specialty;
  @override
  final String? address;
  @override
  @JsonKey()
  final String documentType;
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

  @override
  final String? description;
  @override
  final int? experienceYears;
  @override
  final String? profilePhotoUrl;
  @override
  final String? uploadSessionId;
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
  String toString() {
    return 'RegisterTechnicianRequest(name: $name, email: $email, password: $password, phone: $phone, subcategoryIds: $subcategoryIds, documentNumber: $documentNumber, specialty: $specialty, address: $address, documentType: $documentType, subSubCategoryIds: $subSubCategoryIds, description: $description, experienceYears: $experienceYears, profilePhotoUrl: $profilePhotoUrl, uploadSessionId: $uploadSessionId, profileType: $profileType, ruc: $ruc, businessName: $businessName, legalRepresentativeName: $legalRepresentativeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterTechnicianRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            const DeepCollectionEquality().equals(
              other._subcategoryIds,
              _subcategoryIds,
            ) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.specialty, specialty) ||
                other.specialty == specialty) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            const DeepCollectionEquality().equals(
              other._subSubCategoryIds,
              _subSubCategoryIds,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.uploadSessionId, uploadSessionId) ||
                other.uploadSessionId == uploadSessionId) &&
            (identical(other.profileType, profileType) ||
                other.profileType == profileType) &&
            (identical(other.ruc, ruc) || other.ruc == ruc) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(
                  other.legalRepresentativeName,
                  legalRepresentativeName,
                ) ||
                other.legalRepresentativeName == legalRepresentativeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    email,
    password,
    phone,
    const DeepCollectionEquality().hash(_subcategoryIds),
    documentNumber,
    specialty,
    address,
    documentType,
    const DeepCollectionEquality().hash(_subSubCategoryIds),
    description,
    experienceYears,
    profilePhotoUrl,
    uploadSessionId,
    profileType,
    ruc,
    businessName,
    legalRepresentativeName,
  );

  /// Create a copy of RegisterTechnicianRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterTechnicianRequestImplCopyWith<_$RegisterTechnicianRequestImpl>
  get copyWith =>
      __$$RegisterTechnicianRequestImplCopyWithImpl<
        _$RegisterTechnicianRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterTechnicianRequestImplToJson(this);
  }
}

abstract class _RegisterTechnicianRequest implements RegisterTechnicianRequest {
  const factory _RegisterTechnicianRequest({
    required final String name,
    required final String email,
    required final String password,
    required final String phone,
    required final List<int> subcategoryIds,
    required final String documentNumber,
    final String? specialty,
    final String? address,
    final String documentType,
    final List<int>? subSubCategoryIds,
    final String? description,
    final int? experienceYears,
    final String? profilePhotoUrl,
    final String? uploadSessionId,
    final String profileType,
    final String? ruc,
    final String? businessName,
    final String? legalRepresentativeName,
  }) = _$RegisterTechnicianRequestImpl;

  factory _RegisterTechnicianRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterTechnicianRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  String get password;
  @override
  String get phone;
  @override
  List<int> get subcategoryIds;
  @override
  String get documentNumber;
  @override
  String? get specialty;
  @override
  String? get address;
  @override
  String get documentType;
  @override
  List<int>? get subSubCategoryIds;
  @override
  String? get description;
  @override
  int? get experienceYears;
  @override
  String? get profilePhotoUrl;
  @override
  String? get uploadSessionId;
  @override
  String get profileType;
  @override
  String? get ruc;
  @override
  String? get businessName;
  @override
  String? get legalRepresentativeName;

  /// Create a copy of RegisterTechnicianRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterTechnicianRequestImplCopyWith<_$RegisterTechnicianRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AddTechnicianProfileRequest _$AddTechnicianProfileRequestFromJson(
  Map<String, dynamic> json,
) {
  return _AddTechnicianProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$AddTechnicianProfileRequest {
  List<int> get subcategoryIds => throw _privateConstructorUsedError;
  String get documentNumber => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get specialty => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get documentType => throw _privateConstructorUsedError;
  List<int>? get subSubCategoryIds => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get experienceYears => throw _privateConstructorUsedError;
  String? get profilePhotoUrl => throw _privateConstructorUsedError;
  String get profileType => throw _privateConstructorUsedError;
  String? get ruc => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get legalRepresentativeName => throw _privateConstructorUsedError;

  /// Serializes this AddTechnicianProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddTechnicianProfileRequestCopyWith<AddTechnicianProfileRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddTechnicianProfileRequestCopyWith<$Res> {
  factory $AddTechnicianProfileRequestCopyWith(
    AddTechnicianProfileRequest value,
    $Res Function(AddTechnicianProfileRequest) then,
  ) =
      _$AddTechnicianProfileRequestCopyWithImpl<
        $Res,
        AddTechnicianProfileRequest
      >;
  @useResult
  $Res call({
    List<int> subcategoryIds,
    String documentNumber,
    String phone,
    String? specialty,
    String? address,
    String documentType,
    List<int>? subSubCategoryIds,
    String? description,
    int? experienceYears,
    String? profilePhotoUrl,
    String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
  });
}

/// @nodoc
class _$AddTechnicianProfileRequestCopyWithImpl<
  $Res,
  $Val extends AddTechnicianProfileRequest
>
    implements $AddTechnicianProfileRequestCopyWith<$Res> {
  _$AddTechnicianProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subcategoryIds = null,
    Object? documentNumber = null,
    Object? phone = null,
    Object? specialty = freezed,
    Object? address = freezed,
    Object? documentType = null,
    Object? subSubCategoryIds = freezed,
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? profilePhotoUrl = freezed,
    Object? profileType = null,
    Object? ruc = freezed,
    Object? businessName = freezed,
    Object? legalRepresentativeName = freezed,
  }) {
    return _then(
      _value.copyWith(
            subcategoryIds: null == subcategoryIds
                ? _value.subcategoryIds
                : subcategoryIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            documentNumber: null == documentNumber
                ? _value.documentNumber
                : documentNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            specialty: freezed == specialty
                ? _value.specialty
                : specialty // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentType: null == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as String,
            subSubCategoryIds: freezed == subSubCategoryIds
                ? _value.subSubCategoryIds
                : subSubCategoryIds // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            experienceYears: freezed == experienceYears
                ? _value.experienceYears
                : experienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            profilePhotoUrl: freezed == profilePhotoUrl
                ? _value.profilePhotoUrl
                : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddTechnicianProfileRequestImplCopyWith<$Res>
    implements $AddTechnicianProfileRequestCopyWith<$Res> {
  factory _$$AddTechnicianProfileRequestImplCopyWith(
    _$AddTechnicianProfileRequestImpl value,
    $Res Function(_$AddTechnicianProfileRequestImpl) then,
  ) = __$$AddTechnicianProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<int> subcategoryIds,
    String documentNumber,
    String phone,
    String? specialty,
    String? address,
    String documentType,
    List<int>? subSubCategoryIds,
    String? description,
    int? experienceYears,
    String? profilePhotoUrl,
    String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
  });
}

/// @nodoc
class __$$AddTechnicianProfileRequestImplCopyWithImpl<$Res>
    extends
        _$AddTechnicianProfileRequestCopyWithImpl<
          $Res,
          _$AddTechnicianProfileRequestImpl
        >
    implements _$$AddTechnicianProfileRequestImplCopyWith<$Res> {
  __$$AddTechnicianProfileRequestImplCopyWithImpl(
    _$AddTechnicianProfileRequestImpl _value,
    $Res Function(_$AddTechnicianProfileRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subcategoryIds = null,
    Object? documentNumber = null,
    Object? phone = null,
    Object? specialty = freezed,
    Object? address = freezed,
    Object? documentType = null,
    Object? subSubCategoryIds = freezed,
    Object? description = freezed,
    Object? experienceYears = freezed,
    Object? profilePhotoUrl = freezed,
    Object? profileType = null,
    Object? ruc = freezed,
    Object? businessName = freezed,
    Object? legalRepresentativeName = freezed,
  }) {
    return _then(
      _$AddTechnicianProfileRequestImpl(
        subcategoryIds: null == subcategoryIds
            ? _value._subcategoryIds
            : subcategoryIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        documentNumber: null == documentNumber
            ? _value.documentNumber
            : documentNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        specialty: freezed == specialty
            ? _value.specialty
            : specialty // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentType: null == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as String,
        subSubCategoryIds: freezed == subSubCategoryIds
            ? _value._subSubCategoryIds
            : subSubCategoryIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        experienceYears: freezed == experienceYears
            ? _value.experienceYears
            : experienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        profilePhotoUrl: freezed == profilePhotoUrl
            ? _value.profilePhotoUrl
            : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddTechnicianProfileRequestImpl
    implements _AddTechnicianProfileRequest {
  const _$AddTechnicianProfileRequestImpl({
    required final List<int> subcategoryIds,
    required this.documentNumber,
    required this.phone,
    this.specialty,
    this.address,
    this.documentType = 'DNI',
    final List<int>? subSubCategoryIds,
    this.description,
    this.experienceYears,
    this.profilePhotoUrl,
    this.profileType = 'independiente',
    this.ruc,
    this.businessName,
    this.legalRepresentativeName,
  }) : _subcategoryIds = subcategoryIds,
       _subSubCategoryIds = subSubCategoryIds;

  factory _$AddTechnicianProfileRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$AddTechnicianProfileRequestImplFromJson(json);

  final List<int> _subcategoryIds;
  @override
  List<int> get subcategoryIds {
    if (_subcategoryIds is EqualUnmodifiableListView) return _subcategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategoryIds);
  }

  @override
  final String documentNumber;
  @override
  final String phone;
  @override
  final String? specialty;
  @override
  final String? address;
  @override
  @JsonKey()
  final String documentType;
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

  @override
  final String? description;
  @override
  final int? experienceYears;
  @override
  final String? profilePhotoUrl;
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
  String toString() {
    return 'AddTechnicianProfileRequest(subcategoryIds: $subcategoryIds, documentNumber: $documentNumber, phone: $phone, specialty: $specialty, address: $address, documentType: $documentType, subSubCategoryIds: $subSubCategoryIds, description: $description, experienceYears: $experienceYears, profilePhotoUrl: $profilePhotoUrl, profileType: $profileType, ruc: $ruc, businessName: $businessName, legalRepresentativeName: $legalRepresentativeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddTechnicianProfileRequestImpl &&
            const DeepCollectionEquality().equals(
              other._subcategoryIds,
              _subcategoryIds,
            ) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.specialty, specialty) ||
                other.specialty == specialty) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            const DeepCollectionEquality().equals(
              other._subSubCategoryIds,
              _subSubCategoryIds,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.profileType, profileType) ||
                other.profileType == profileType) &&
            (identical(other.ruc, ruc) || other.ruc == ruc) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(
                  other.legalRepresentativeName,
                  legalRepresentativeName,
                ) ||
                other.legalRepresentativeName == legalRepresentativeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_subcategoryIds),
    documentNumber,
    phone,
    specialty,
    address,
    documentType,
    const DeepCollectionEquality().hash(_subSubCategoryIds),
    description,
    experienceYears,
    profilePhotoUrl,
    profileType,
    ruc,
    businessName,
    legalRepresentativeName,
  );

  /// Create a copy of AddTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddTechnicianProfileRequestImplCopyWith<_$AddTechnicianProfileRequestImpl>
  get copyWith =>
      __$$AddTechnicianProfileRequestImplCopyWithImpl<
        _$AddTechnicianProfileRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddTechnicianProfileRequestImplToJson(this);
  }
}

abstract class _AddTechnicianProfileRequest
    implements AddTechnicianProfileRequest {
  const factory _AddTechnicianProfileRequest({
    required final List<int> subcategoryIds,
    required final String documentNumber,
    required final String phone,
    final String? specialty,
    final String? address,
    final String documentType,
    final List<int>? subSubCategoryIds,
    final String? description,
    final int? experienceYears,
    final String? profilePhotoUrl,
    final String profileType,
    final String? ruc,
    final String? businessName,
    final String? legalRepresentativeName,
  }) = _$AddTechnicianProfileRequestImpl;

  factory _AddTechnicianProfileRequest.fromJson(Map<String, dynamic> json) =
      _$AddTechnicianProfileRequestImpl.fromJson;

  @override
  List<int> get subcategoryIds;
  @override
  String get documentNumber;
  @override
  String get phone;
  @override
  String? get specialty;
  @override
  String? get address;
  @override
  String get documentType;
  @override
  List<int>? get subSubCategoryIds;
  @override
  String? get description;
  @override
  int? get experienceYears;
  @override
  String? get profilePhotoUrl;
  @override
  String get profileType;
  @override
  String? get ruc;
  @override
  String? get businessName;
  @override
  String? get legalRepresentativeName;

  /// Create a copy of AddTechnicianProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddTechnicianProfileRequestImplCopyWith<_$AddTechnicianProfileRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RegisterSellerRequest _$RegisterSellerRequestFromJson(
  Map<String, dynamic> json,
) {
  return _RegisterSellerRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterSellerRequest {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get ruc => throw _privateConstructorUsedError;
  String get legalRepresentativeName => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get rucDocumentUrl => throw _privateConstructorUsedError;

  /// Serializes this RegisterSellerRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterSellerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterSellerRequestCopyWith<RegisterSellerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterSellerRequestCopyWith<$Res> {
  factory $RegisterSellerRequestCopyWith(
    RegisterSellerRequest value,
    $Res Function(RegisterSellerRequest) then,
  ) = _$RegisterSellerRequestCopyWithImpl<$Res, RegisterSellerRequest>;
  @useResult
  $Res call({
    String name,
    String email,
    String password,
    String phone,
    String businessName,
    String ruc,
    String legalRepresentativeName,
    String? address,
    String? description,
    String? logoUrl,
    String? rucDocumentUrl,
  });
}

/// @nodoc
class _$RegisterSellerRequestCopyWithImpl<
  $Res,
  $Val extends RegisterSellerRequest
>
    implements $RegisterSellerRequestCopyWith<$Res> {
  _$RegisterSellerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterSellerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? phone = null,
    Object? businessName = null,
    Object? ruc = null,
    Object? legalRepresentativeName = null,
    Object? address = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? rucDocumentUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
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
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rucDocumentUrl: freezed == rucDocumentUrl
                ? _value.rucDocumentUrl
                : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterSellerRequestImplCopyWith<$Res>
    implements $RegisterSellerRequestCopyWith<$Res> {
  factory _$$RegisterSellerRequestImplCopyWith(
    _$RegisterSellerRequestImpl value,
    $Res Function(_$RegisterSellerRequestImpl) then,
  ) = __$$RegisterSellerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String email,
    String password,
    String phone,
    String businessName,
    String ruc,
    String legalRepresentativeName,
    String? address,
    String? description,
    String? logoUrl,
    String? rucDocumentUrl,
  });
}

/// @nodoc
class __$$RegisterSellerRequestImplCopyWithImpl<$Res>
    extends
        _$RegisterSellerRequestCopyWithImpl<$Res, _$RegisterSellerRequestImpl>
    implements _$$RegisterSellerRequestImplCopyWith<$Res> {
  __$$RegisterSellerRequestImplCopyWithImpl(
    _$RegisterSellerRequestImpl _value,
    $Res Function(_$RegisterSellerRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterSellerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? phone = null,
    Object? businessName = null,
    Object? ruc = null,
    Object? legalRepresentativeName = null,
    Object? address = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? rucDocumentUrl = freezed,
  }) {
    return _then(
      _$RegisterSellerRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
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
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rucDocumentUrl: freezed == rucDocumentUrl
            ? _value.rucDocumentUrl
            : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterSellerRequestImpl implements _RegisterSellerRequest {
  const _$RegisterSellerRequestImpl({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.businessName,
    required this.ruc,
    required this.legalRepresentativeName,
    this.address,
    this.description,
    this.logoUrl,
    this.rucDocumentUrl,
  });

  factory _$RegisterSellerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterSellerRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final String password;
  @override
  final String phone;
  @override
  final String businessName;
  @override
  final String ruc;
  @override
  final String legalRepresentativeName;
  @override
  final String? address;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? rucDocumentUrl;

  @override
  String toString() {
    return 'RegisterSellerRequest(name: $name, email: $email, password: $password, phone: $phone, businessName: $businessName, ruc: $ruc, legalRepresentativeName: $legalRepresentativeName, address: $address, description: $description, logoUrl: $logoUrl, rucDocumentUrl: $rucDocumentUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterSellerRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.ruc, ruc) || other.ruc == ruc) &&
            (identical(
                  other.legalRepresentativeName,
                  legalRepresentativeName,
                ) ||
                other.legalRepresentativeName == legalRepresentativeName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.rucDocumentUrl, rucDocumentUrl) ||
                other.rucDocumentUrl == rucDocumentUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    email,
    password,
    phone,
    businessName,
    ruc,
    legalRepresentativeName,
    address,
    description,
    logoUrl,
    rucDocumentUrl,
  );

  /// Create a copy of RegisterSellerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterSellerRequestImplCopyWith<_$RegisterSellerRequestImpl>
  get copyWith =>
      __$$RegisterSellerRequestImplCopyWithImpl<_$RegisterSellerRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterSellerRequestImplToJson(this);
  }
}

abstract class _RegisterSellerRequest implements RegisterSellerRequest {
  const factory _RegisterSellerRequest({
    required final String name,
    required final String email,
    required final String password,
    required final String phone,
    required final String businessName,
    required final String ruc,
    required final String legalRepresentativeName,
    final String? address,
    final String? description,
    final String? logoUrl,
    final String? rucDocumentUrl,
  }) = _$RegisterSellerRequestImpl;

  factory _RegisterSellerRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterSellerRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  String get password;
  @override
  String get phone;
  @override
  String get businessName;
  @override
  String get ruc;
  @override
  String get legalRepresentativeName;
  @override
  String? get address;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  String? get rucDocumentUrl;

  /// Create a copy of RegisterSellerRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterSellerRequestImplCopyWith<_$RegisterSellerRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AddSellerProfileRequest _$AddSellerProfileRequestFromJson(
  Map<String, dynamic> json,
) {
  return _AddSellerProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$AddSellerProfileRequest {
  String get businessName => throw _privateConstructorUsedError;
  String get ruc => throw _privateConstructorUsedError;
  String get legalRepresentativeName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get rucDocumentUrl => throw _privateConstructorUsedError;

  /// Serializes this AddSellerProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddSellerProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddSellerProfileRequestCopyWith<AddSellerProfileRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddSellerProfileRequestCopyWith<$Res> {
  factory $AddSellerProfileRequestCopyWith(
    AddSellerProfileRequest value,
    $Res Function(AddSellerProfileRequest) then,
  ) = _$AddSellerProfileRequestCopyWithImpl<$Res, AddSellerProfileRequest>;
  @useResult
  $Res call({
    String businessName,
    String ruc,
    String legalRepresentativeName,
    String phone,
    String? address,
    String? description,
    String? logoUrl,
    String? rucDocumentUrl,
  });
}

/// @nodoc
class _$AddSellerProfileRequestCopyWithImpl<
  $Res,
  $Val extends AddSellerProfileRequest
>
    implements $AddSellerProfileRequestCopyWith<$Res> {
  _$AddSellerProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddSellerProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = null,
    Object? ruc = null,
    Object? legalRepresentativeName = null,
    Object? phone = null,
    Object? address = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? rucDocumentUrl = freezed,
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
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rucDocumentUrl: freezed == rucDocumentUrl
                ? _value.rucDocumentUrl
                : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddSellerProfileRequestImplCopyWith<$Res>
    implements $AddSellerProfileRequestCopyWith<$Res> {
  factory _$$AddSellerProfileRequestImplCopyWith(
    _$AddSellerProfileRequestImpl value,
    $Res Function(_$AddSellerProfileRequestImpl) then,
  ) = __$$AddSellerProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String businessName,
    String ruc,
    String legalRepresentativeName,
    String phone,
    String? address,
    String? description,
    String? logoUrl,
    String? rucDocumentUrl,
  });
}

/// @nodoc
class __$$AddSellerProfileRequestImplCopyWithImpl<$Res>
    extends
        _$AddSellerProfileRequestCopyWithImpl<
          $Res,
          _$AddSellerProfileRequestImpl
        >
    implements _$$AddSellerProfileRequestImplCopyWith<$Res> {
  __$$AddSellerProfileRequestImplCopyWithImpl(
    _$AddSellerProfileRequestImpl _value,
    $Res Function(_$AddSellerProfileRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddSellerProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = null,
    Object? ruc = null,
    Object? legalRepresentativeName = null,
    Object? phone = null,
    Object? address = freezed,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? rucDocumentUrl = freezed,
  }) {
    return _then(
      _$AddSellerProfileRequestImpl(
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
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rucDocumentUrl: freezed == rucDocumentUrl
            ? _value.rucDocumentUrl
            : rucDocumentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddSellerProfileRequestImpl implements _AddSellerProfileRequest {
  const _$AddSellerProfileRequestImpl({
    required this.businessName,
    required this.ruc,
    required this.legalRepresentativeName,
    required this.phone,
    this.address,
    this.description,
    this.logoUrl,
    this.rucDocumentUrl,
  });

  factory _$AddSellerProfileRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddSellerProfileRequestImplFromJson(json);

  @override
  final String businessName;
  @override
  final String ruc;
  @override
  final String legalRepresentativeName;
  @override
  final String phone;
  @override
  final String? address;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? rucDocumentUrl;

  @override
  String toString() {
    return 'AddSellerProfileRequest(businessName: $businessName, ruc: $ruc, legalRepresentativeName: $legalRepresentativeName, phone: $phone, address: $address, description: $description, logoUrl: $logoUrl, rucDocumentUrl: $rucDocumentUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddSellerProfileRequestImpl &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.ruc, ruc) || other.ruc == ruc) &&
            (identical(
                  other.legalRepresentativeName,
                  legalRepresentativeName,
                ) ||
                other.legalRepresentativeName == legalRepresentativeName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.rucDocumentUrl, rucDocumentUrl) ||
                other.rucDocumentUrl == rucDocumentUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    businessName,
    ruc,
    legalRepresentativeName,
    phone,
    address,
    description,
    logoUrl,
    rucDocumentUrl,
  );

  /// Create a copy of AddSellerProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddSellerProfileRequestImplCopyWith<_$AddSellerProfileRequestImpl>
  get copyWith =>
      __$$AddSellerProfileRequestImplCopyWithImpl<
        _$AddSellerProfileRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddSellerProfileRequestImplToJson(this);
  }
}

abstract class _AddSellerProfileRequest implements AddSellerProfileRequest {
  const factory _AddSellerProfileRequest({
    required final String businessName,
    required final String ruc,
    required final String legalRepresentativeName,
    required final String phone,
    final String? address,
    final String? description,
    final String? logoUrl,
    final String? rucDocumentUrl,
  }) = _$AddSellerProfileRequestImpl;

  factory _AddSellerProfileRequest.fromJson(Map<String, dynamic> json) =
      _$AddSellerProfileRequestImpl.fromJson;

  @override
  String get businessName;
  @override
  String get ruc;
  @override
  String get legalRepresentativeName;
  @override
  String get phone;
  @override
  String? get address;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  String? get rucDocumentUrl;

  /// Create a copy of AddSellerProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddSellerProfileRequestImplCopyWith<_$AddSellerProfileRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
