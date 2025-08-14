import 'package:get/get.dart';
import 'package:yet_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:yet_app/app/modules/search/controllers/user_search_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../explore/controllers/explore_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(() => RootController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ExploreController>(() => ExploreController());
    Get.lazyPut<UserSearchController>(() => UserSearchController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}