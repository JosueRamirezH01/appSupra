import '../../data/models/home/home_content_model.dart';

abstract class HomeRepository {
  Future<HomeContentModel> getHomeContent();
}
