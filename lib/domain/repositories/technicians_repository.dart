import '../../data/models/common/pagination_model.dart';
import '../../data/models/technicians/contact_lead_model.dart';
import '../../data/models/technicians/technician_activity_model.dart';
import '../../data/models/technicians/technician_performance_model.dart';
import '../../data/models/technicians/technician_model.dart';

abstract class TechniciansRepository {
  Future<
    ({List<TechnicianPublicModel> technicians, PaginationModel pagination})
  >
  getTechnicians(TechniciansQuery query);
  Future<List<TechnicianPublicModel>> getHomeTechnicians({
    double? lat,
    double? lng,
    int? radiusKm,
  });
  Future<TechnicianPublicModel> getTechnician(int userId);
  Future<TechnicianApplicationModel> getMyProfile();
  Future<TechnicianApplicationModel> getMyApplication();
  Future<TechnicianApplicationModel> updateMyProfile(
    UpdateTechnicianProfileRequest request,
  );
  Future<TechnicianApplicationModel> submitVerification(
    SubmitTechnicianVerificationRequest request,
  );

  Future<TechnicianApplicationModel> submitCertification(
    SubmitTechnicianCertificationRequest request,
  );

  Future<TechnicianApplicationModel> suggestService({
    required int subcategoryId,
    required String proposedName,
  });

  Future<TechnicianApplicationModel> removeServiceSuggestion(int suggestionId);

  Future<TechnicianSubSubCategoryModel> getMyService(int subSubCategoryId);
  Future<TechnicianSubSubCategoryModel> updateMyService(
    int subSubCategoryId,
    UpdateTechnicianServiceRequest request,
  );
  Future<TechnicianSubSubCategoryModel> getPublicService(
    int userId,
    int subSubCategoryId,
  );

  Future<TechnicianContactLeadResult> submitContactLead({
    required int technicianUserId,
    required SubmitTechnicianContactRequest request,
  });

  Future<TechnicianContactLeadsPageModel> getMyContactLeads({
    int page = 1,
    int limit = 10,
  });

  Future<TechnicianActivityStatsModel> getMyActivityStats();

  Future<TechnicianPerformanceReportModel> getMyPerformanceReport({
    required String period,
  });

  Future<RecordTechnicianProfileViewResult> recordProfileView({
    required int technicianUserId,
    required String viewerKey,
  });
}

abstract class AdminRepository {
  Future<List<TechnicianApplicationModel>> getApplications({String? status});
  Future<TechnicianApplicationModel> getApplication(int userId);
  Future<TechnicianApplicationModel> approve(int userId);
  Future<TechnicianApplicationModel> reject(
    int userId,
    RejectApplicationRequest request,
  );
  Future<TechnicianApplicationModel> approveCertification(int userId);
  Future<TechnicianApplicationModel> rejectCertification(int userId);
}
