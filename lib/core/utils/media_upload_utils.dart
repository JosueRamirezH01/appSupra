import 'dart:io';

import '../../data/models/uploads/upload_model.dart';
import '../../data/models/uploads/upload_result_model.dart';
import '../../domain/repositories/uploads_repository.dart';
import '../constants/media_upload_constants.dart';
import 'work_portfolio_upload_utils.dart';

class MediaUploadTaskItem {
  const MediaUploadTaskItem({
    required this.file,
    required this.category,
  });

  final File file;
  final UploadCategory category;
}

class MediaUploadUtils {
  MediaUploadUtils._();

  static Future<List<R>> runInParallel<T, R>({
    required List<T> items,
    required Future<R> Function(T item, int index) task,
    int concurrency = MediaUploadConstants.defaultUploadConcurrency,
    void Function(int completed, int total)? onProgress,
  }) async {
    if (items.isEmpty) return [];

    final results = List<R?>.filled(items.length, null);
    var nextIndex = 0;
    var completed = 0;
    final workerCount = concurrency.clamp(1, items.length);

    Future<void> worker() async {
      while (true) {
        if (nextIndex >= items.length) return;
        final index = nextIndex;
        nextIndex++;

        results[index] = await task(items[index], index);
        completed++;
        onProgress?.call(completed, items.length);
      }
    }

    await Future.wait(List.generate(workerCount, (_) => worker()));
    return results.cast<R>();
  }

  static Future<List<UploadTechnicianFileResult>> uploadTechnicianFiles({
    required UploadsRepository repository,
    required UploadCategory category,
    required List<File> files,
    String? sessionId,
    int concurrency = MediaUploadConstants.defaultUploadConcurrency,
    void Function(int completed, int total)? onProgress,
  }) {
    return runInParallel(
      items: files,
      concurrency: concurrency,
      onProgress: onProgress,
      task: (file, _) => repository.uploadTechnicianFile(
        category: category,
        file: file,
        sessionId: sessionId,
      ),
    );
  }

  static Future<List<String>> uploadTechnicianReferences({
    required UploadsRepository repository,
    required UploadCategory category,
    required List<File> files,
    String? sessionId,
    int concurrency = MediaUploadConstants.defaultUploadConcurrency,
    void Function(int completed, int total)? onProgress,
  }) async {
    final uploads = await uploadTechnicianFiles(
      repository: repository,
      category: category,
      files: files,
      sessionId: sessionId,
      concurrency: concurrency,
      onProgress: onProgress,
    );

    return uploads
        .map((item) => WorkPortfolioUploadUtils.resolveReference(item.file))
        .toList();
  }

  static Future<List<String>> uploadMixedReferences({
    required UploadsRepository repository,
    required List<MediaUploadTaskItem> tasks,
    int concurrency = MediaUploadConstants.defaultUploadConcurrency,
    void Function(int completed, int total)? onProgress,
  }) {
    return runInParallel(
      items: tasks,
      concurrency: concurrency,
      onProgress: onProgress,
      task: (task, _) async {
        final result = await repository.uploadTechnicianFile(
          category: task.category,
          file: task.file,
        );
        return WorkPortfolioUploadUtils.resolveReference(result.file);
      },
    );
  }
}
