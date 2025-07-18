// lib/app/modules/root/bindings/root_binding.dart
import 'package:get/get.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../explore/controllers/explore_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(() => RootController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ExploreController>(() => ExploreController());
  }
}