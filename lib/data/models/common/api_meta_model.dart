import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_meta_model.freezed.dart';
part 'api_meta_model.g.dart';

@freezed
class ApiMetaModel with _$ApiMetaModel {
  const factory ApiMetaModel({
    String? requestId,
    required DateTime timestamp,
  }) = _ApiMetaModel;

  factory ApiMetaModel.fromJson(Map<String, dynamic> json) =>
      _$ApiMetaModelFromJson(json);
}
