// lib/app/modules/root/views/root_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../explore/views/explore_view.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Seçili sekmeye göre gövdeyi değiştir
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: const [
          DashboardView(), // Index 0: Ana Akış
          ExploreView(),    // Index 1: Keşfet
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Keşfet',
          ),
        ],
      )),
    );
  }
}