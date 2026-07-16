import 'dart:io';
import '../../core/utils/media_compress_utils.dart';
import '../../domain/repositories/uploads_repository.dart';
import '../datasources/uploads_remote_datasource.dart';
import '../models/uploads/upload_model.dart';
import '../models/uploads/upload_result_model.dart';
import '../models/uploads/upload_session_model.dart';

class UploadsRepositoryImpl implements UploadsRepository {
  UploadsRepositoryImpl(this._remote);

  final UploadsRemoteDataSource _remote;

  @override
  Future<UploadSessionModel> createUploadSession() {
    return _remote.createUploadSession();
  }

  @override
  Future<UploadTechnicianFileResult> uploadTechnicianFile({
    required UploadCategory category,
    required File file,
    String? sessionId,
    String? uploadToken,
  }) async {
    final prepared = await MediaCompressUtils.prepareForUpload(file);
    return _remote.uploadTechnicianFile(
      category: category,
      file: prepared,
      sessionId: sessionId,
      uploadToken: uploadToken,
    );
  }

  @override
  Future<UploadedFileModel> uploadCategoryImage(File file) async {
    final prepared = await MediaCompressUtils.prepareForUpload(file);
    return _remote.uploadCategoryImage(prepared);
  }
}
