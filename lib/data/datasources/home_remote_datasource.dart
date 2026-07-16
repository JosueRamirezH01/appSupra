import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/home/home_content_model.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._dio);

  final Dio _dio;

  Future<HomeContentModel> getHomeContent() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.homeContent);
    final data = response.data?['data'] as Map<String, dynamic>?;
    final content = data?['content'] as Map<String, dynamic>?;

    if (content == null) {
      throw AppException.unknown('Contenido del home no disponible');
    }

    return HomeContentModel.fromJson(content);
  }
}
