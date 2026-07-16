import 'package:freezed_annotation/freezed_annotation.dart';

import 'api_meta_model.dart';

part 'api_error_model.freezed.dart';
part 'api_error_model.g.dart';

@freezed
class ApiErrorModel with _$ApiErrorModel {
  const factory ApiErrorModel({
    required bool success,
    required String message,
    required String code,
    dynamic errors,
    required ApiMetaModel meta,
  }) = _ApiErrorModel;

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);
}
