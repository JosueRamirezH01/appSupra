import 'upload_model.dart';

class UploadTechnicianFileResult {
  const UploadTechnicianFileResult({
    required this.file,
    this.sessionId,
  });

  final UploadedFileModel file;
  final String? sessionId;
}
