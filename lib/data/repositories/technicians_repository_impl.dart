import '../../domain/repositories/technicians_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import '../datasources/technicians_remote_datasource.dart';
import '../models/common/pagination_model.dart';
import '../models/technicians/contact_lead_model.dart';
import '../models/technicians/technician_activity_model.dart';
import '../models/technicians/technician_performance_model.dart';
import '../models/technicians/technician_model.dart';

class TechniciansRepositoryImpl implements TechniciansRepository {
  TechniciansRepositoryImpl(this._remote);

  final TechniciansRemoteDataSource _remote;

  @override
  Future<({List<TechnicianPublicModel> technicians, PaginationModel pagination})>
      getTechnicians(TechniciansQuery query) =>
          _remote.getTechnicians(query);

  @override
  Future<TechnicianPublicModel> getTechnician(int userId) =>
      _remote.getTechnician(userId);

  @override
  Future<TechnicianApplicationModel> getMyProfile() => _remote.getMyProfile();

  @override
  Future<TechnicianApplicationModel> getMyApplication() =>
      _remote.getMyApplication();

  @override
  Future<TechnicianApplicationModel> updateMyProfile(
    UpdateTechnicianProfileRequest request,
  ) =>
      _remote.updateMyProfile(request);

  @override
  Future<TechnicianApplicationModel> submitVerification(
    SubmitTechnicianVerificationRequest request,
  ) =>
      _remote.submitVerification(request);

  @override
  Future<TechnicianApplicationModel> submitCertification(
    SubmitTechnicianCertificationRequest request,
  ) =>
      _remote.submitCertification(request);

  @override
  Future<TechnicianApplicationModel> suggestService({
    required int subcategoryId,
    required String proposedName,
  }) =>
      _remote.suggestService(
        subcategoryId: subcategoryId,
        proposedName: proposedName,
      );

  @override
  Future<TechnicianApplicationModel> removeServiceSuggestion(int suggestionId) =>
      _remote.removeServiceSuggestion(suggestionId);

  @override
  Future<TechnicianContactLeadResult> submitContactLead({
    required int technicianUserId,
    required SubmitTechnicianContactRequest request,
  }) =>
      _remote.submitContactLead(
        technicianUserId: technicianUserId,
        request: request,
      );

  @override
  Future<TechnicianContactLeadsPageModel> getMyContactLeads({
    int page = 1,
    int limit = 10,
  }) =>
      _remote.getMyContactLeads(page: page, limit: limit);

  @override
  Future<TechnicianActivityStatsModel> getMyActivityStats() =>
      _remote.getMyActivityStats();

  @override
  Future<TechnicianPerformanceReportModel> getMyPerformanceReport({
    required String period,
  }) =>
      _remote.getMyPerformanceReport(period: period);

  @override
  Future<RecordTechnicianProfileViewResult> recordProfileView({
    required int technicianUserId,
    required String viewerKey,
  }) =>
      _remote.recordProfileView(
        technicianUserId: technicianUserId,
        viewerKey: viewerKey,
      );
}

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._remote);

  final AdminRemoteDataSource _remote;

  @override
  Future<List<TechnicianApplicationModel>> getApplications({String? status}) =>
      _remote.getApplications(status: status);

  @override
  Future<TechnicianApplicationModel> getApplication(int userId) =>
      _remote.getApplication(userId);

  @override
  Future<TechnicianApplicationModel> approve(int userId) =>
      _remote.approve(userId);

  @override
  Future<TechnicianApplicationModel> reject(
    int userId,
    RejectApplicationRequest request,
  ) =>
      _remote.reject(userId, request);

  @override
  Future<TechnicianApplicationModel> approveCertification(int userId) =>
      _remote.approveCertification(userId);

  @override
  Future<TechnicianApplicationModel> rejectCertification(int userId) =>
      _remote.rejectCertification(userId);
}
