import 'dart:io';

import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/uploads/upload_model.dart';
import '../models/uploads/upload_result_model.dart';
import '../models/uploads/upload_session_model.dart';

class UploadsRemoteDataSource {
  UploadsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UploadSessionModel> createUploadSession() async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.uploadSession,
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    final session = data?['session'] as Map<String, dynamic>?;
    if (session == null) {
      throw AppException.unknown('No se pudo crear la sesión de subida');
    }

    return UploadSessionModel.fromJson(session);
  }

  Future<UploadTechnicianFileResult> uploadTechnicianFile({
    required UploadCategory category,
    required File file,
    String? sessionId,
    String? uploadToken,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final headers = <String, dynamic>{};
    if (uploadToken != null && uploadToken.isNotEmpty) {
      headers['X-Upload-Token'] = uploadToken;
    }

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.uploadTechnician(category.value),
      data: formData,
      queryParameters:
          sessionId == null ? null : <String, dynamic>{'sessionId': sessionId},
      options: Options(
        contentType: 'multipart/form-data',
        headers: headers.isEmpty ? null : headers,
      ),
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    final uploaded = data?['file'] as Map<String, dynamic>?;
    if (uploaded == null) throw AppException.unknown('Upload fallido');

    return UploadTechnicianFileResult(
      file: UploadedFileModel.fromJson(uploaded),
      sessionId: data?['sessionId'] as String? ?? sessionId,
    );
  }

  Future<UploadedFileModel> uploadCategoryImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.uploadCategoryImage,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    final uploaded = data?['file'] as Map<String, dynamic>?;
    if (uploaded == null) throw AppException.unknown('Upload fallido');

    return UploadedFileModel.fromJson(uploaded);
  }
}
