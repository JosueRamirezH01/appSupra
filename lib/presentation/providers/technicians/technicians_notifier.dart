import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/common/pagination_model.dart';
import '../../../data/models/technicians/contact_lead_model.dart';
import '../../../data/models/technicians/technician_activity_model.dart';
import '../../../data/models/technicians/technician_performance_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../repository_providers.dart';
import '../location/client_location_provider.dart';

part 'technicians_notifier.g.dart';

@riverpod
class TechniciansList extends _$TechniciansList {
  TechniciansQuery _query = const TechniciansQuery();

  @override
  Future<({List<TechnicianPublicModel> technicians, PaginationModel pagination})>
      build() async {
    final clientLocation = await ref.watch(activeClientLocationProvider.future);
    _query = _query.copyWith(
      lat: clientLocation?.lat,
      lng: clientLocation?.lng,
      radiusKm: clientLocation?.radiusKm ?? 15,
    );
    return ref.read(techniciansRepositoryProvider).getTechnicians(_query);
  }

  Future<void> search(String? text) async {
    _query = _query.copyWith(search: text, page: 1);
    ref.invalidateSelf();
  }

  Future<void> filterBySubcategory(int? subcategoryId) async {
    _query = _query.copyWith(subcategoryId: subcategoryId, page: 1);
    ref.invalidateSelf();
  }

  Future<void> loadPage(int page) async {
    _query = _query.copyWith(page: page);
    ref.invalidateSelf();
  }
}

@riverpod
Future<TechnicianPublicModel> technicianDetail(
  TechnicianDetailRef ref,
  int userId,
) {
  return ref.read(techniciansRepositoryProvider).getTechnician(userId);
}

@riverpod
Future<TechnicianActivityStatsModel> myTechnicianActivity(
  MyTechnicianActivityRef ref,
) {
  return ref.read(techniciansRepositoryProvider).getMyActivityStats();
}

@riverpod
Future<TechnicianPerformanceReportModel> myTechnicianPerformance(
  MyTechnicianPerformanceRef ref,
  String period,
) {
  return ref.read(techniciansRepositoryProvider).getMyPerformanceReport(
        period: period,
      );
}

@riverpod
Future<TechnicianContactLeadsPageModel> myTechnicianContactLeads(
  MyTechnicianContactLeadsRef ref, {
  int page = 1,
  int limit = 5,
}) {
  return ref.read(techniciansRepositoryProvider).getMyContactLeads(
        page: page,
        limit: limit,
      );
}

@riverpod
class MyTechnicianProfile extends _$MyTechnicianProfile {
  @override
  Future<TechnicianApplicationModel> build() {
    return ref.read(techniciansRepositoryProvider).getMyProfile();
  }

  Future<TechnicianApplicationModel> updateProfile(
    UpdateTechnicianProfileRequest request,
  ) async {
    final previous = state.valueOrNull;

    try {
      final profile =
          await ref.read(techniciansRepositoryProvider).updateMyProfile(request);
      state = AsyncValue.data(profile);
      return profile;
    } catch (error, stackTrace) {
      if (previous != null) {
        state = AsyncValue.data(previous);
      } else {
        state = AsyncValue.error(error, stackTrace);
      }
      rethrow;
    }
  }

  Future<TechnicianApplicationModel> submitCertification(
    SubmitTechnicianCertificationRequest request,
  ) async {
    final profile =
        await ref.read(techniciansRepositoryProvider).submitCertification(request);
    state = AsyncValue.data(profile);
    return profile;
  }

  void applyProfile(TechnicianApplicationModel profile) {
    state = AsyncValue.data(profile);
  }

  Future<TechnicianApplicationModel> suggestService({
    required int subcategoryId,
    required String proposedName,
  }) async {
    final profile = await ref.read(techniciansRepositoryProvider).suggestService(
          subcategoryId: subcategoryId,
          proposedName: proposedName,
        );
    applyProfile(profile);
    return profile;
  }

  Future<TechnicianApplicationModel> removeServiceSuggestion(
    int suggestionId,
  ) async {
    final profile =
        await ref.read(techniciansRepositoryProvider).removeServiceSuggestion(
              suggestionId,
            );
    applyProfile(profile);
    return profile;
  }
}

@riverpod
class MyTechnicianApplication extends _$MyTechnicianApplication {
  @override
  Future<TechnicianApplicationModel> build() {
    return ref.read(techniciansRepositoryProvider).getMyApplication();
  }
}

@riverpod
class AdminApplications extends _$AdminApplications {
  String? _statusFilter;

  @override
  Future<List<TechnicianApplicationModel>> build() {
    return ref.read(adminRepositoryProvider).getApplications(status: _statusFilter);
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    ref.invalidateSelf();
  }

  Future<void> approve(int userId) async {
    await ref.read(adminRepositoryProvider).approve(userId);
    ref.invalidateSelf();
  }

  Future<void> reject(int userId, String reason) async {
    await ref.read(adminRepositoryProvider).reject(
          userId,
          RejectApplicationRequest(reason: reason),
        );
    ref.invalidateSelf();
  }

  Future<void> approveCertification(int userId) async {
    await ref.read(adminRepositoryProvider).approveCertification(userId);
    ref.invalidate(adminApplicationDetailProvider(userId));
    ref.invalidateSelf();
  }

  Future<void> rejectCertification(int userId) async {
    await ref.read(adminRepositoryProvider).rejectCertification(userId);
    ref.invalidate(adminApplicationDetailProvider(userId));
    ref.invalidateSelf();
  }
}

@riverpod
Future<TechnicianApplicationModel> adminApplicationDetail(
  AdminApplicationDetailRef ref,
  int userId,
) {
  return ref.read(adminRepositoryProvider).getApplication(userId);
}
