// lib/app/modules/root/controllers/root_controller.dart
import 'package:get/get.dart';

class RootController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}