import 'dart:io';

import '../../data/models/uploads/upload_model.dart';
import '../../data/models/uploads/upload_result_model.dart';
import '../../data/models/uploads/upload_session_model.dart';

abstract class UploadsRepository {
  Future<UploadSessionModel> createUploadSession();

  Future<UploadTechnicianFileResult> uploadTechnicianFile({
    required UploadCategory category,
    required File file,
    String? sessionId,
    String? uploadToken,
  });

  Future<UploadedFileModel> uploadCategoryImage(File file);
}
