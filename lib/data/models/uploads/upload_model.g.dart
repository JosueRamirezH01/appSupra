// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadedFileModelImpl _$$UploadedFileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UploadedFileModelImpl(
  category: json['category'] as String?,
  url: json['url'] as String,
  path: json['path'] as String?,
  filename: json['filename'] as String?,
  originalName: json['originalName'] as String?,
  mimeType: json['mimeType'] as String?,
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$$UploadedFileModelImplToJson(
  _$UploadedFileModelImpl instance,
) => <String, dynamic>{
  'category': instance.category,
  'url': instance.url,
  'path': instance.path,
  'filename': instance.filename,
  'originalName': instance.originalName,
  'mimeType': instance.mimeType,
  'size': instance.size,
};
