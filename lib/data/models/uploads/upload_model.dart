import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_model.freezed.dart';
part 'upload_model.g.dart';

enum UploadCategory {
  profilePhoto('profile_photo'),
  facePhoto('face_photo'),
  companyLogo('company_logo'),
  storeCover('store_cover'),
  document('document'),
  license('license'),
  backgroundCheck('background_check'),
  certification('certification'),
  workPhoto('work_photo'),
  portfolio('portfolio'),
  productImage('product_image');

  const UploadCategory(this.value);
  final String value;
}

@freezed
class UploadedFileModel with _$UploadedFileModel {
  const factory UploadedFileModel({
    String? category,
    required String url,
    String? path,
    String? filename,
    String? originalName,
    String? mimeType,
    int? size,
  }) = _UploadedFileModel;

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) =>
      _$UploadedFileModelFromJson(json);
}
