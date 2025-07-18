import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yet_app/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:yet_app/app/modules/dashboard/widgets/post_widget.dart';
import 'package:yet_app/app/routes/app_pages.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                Get.toNamed('/profile/$userId');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: 'Çıkış Yap',
                middleText: "Çıkış yapmak istediğinizden emin misiniz?",
                textConfirm: "Evet",
                textCancel: "Hayır",
                onConfirm: () => controller.logout(),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.postList.isEmpty) {
          return const Center(
            child: Text(
              "Henüz hiç gönderi yok.\nİlk gönderiyi sen ekle!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.postList.length,
          itemBuilder: (context, index) {
            final post = controller.postList[index];
            return PostWidget(post: post);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.createPost);
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
