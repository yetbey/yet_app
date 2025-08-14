import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yet_app/app/modules/profile/views/profile_view.dart';
import 'package:yet_app/app/modules/search/views/search_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../explore/views/explore_view.dart';
import '../controllers/root_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: [
          DashboardView(), // Index 0: Feed
          ExploreView(),    // Index 1: Explore
          SearchView(), // Index 2 Search
          ProfileView(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Iconsax.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Keşfet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Iconsax.search_normal),
            label: 'Arama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_2user),
            activeIcon: Icon(Iconsax.search_normal),
            label: 'Profil',
          ),
        ],
      )),
    );
  }
}