// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiMetaModelImpl _$$ApiMetaModelImplFromJson(Map<String, dynamic> json) =>
    _$ApiMetaModelImpl(
      requestId: json['requestId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ApiMetaModelImplToJson(_$ApiMetaModelImpl instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'timestamp': instance.timestamp.toIso8601String(),
    };
