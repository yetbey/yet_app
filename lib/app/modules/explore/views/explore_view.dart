import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşfet'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            // Sadece resmi olan gönderileri göster
            if (post.imageUrl == null) return const SizedBox.shrink();

            return GestureDetector(
              onTap: () => Get.toNamed('/post/${post.id}'),
              child: Image.network(post.imageUrl!, fit: BoxFit.cover),
            );
          },
        );
      }),
    );
  }
}