import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/widgets/post_widget.dart';
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
        return ListView.builder(
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            // Her bir gönderi için PostWidget'ı çağırıyoruz.
            // PostWidget zaten her türlü gönderiyi (resimli/metin) nasıl göstereceğini biliyor.
            return PostWidget(post: post);
          },
        );
      }),
    );
  }
}