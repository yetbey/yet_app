import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yet_app/app/modules/create_post/controllers/create_post_controller.dart';

class CreatePostView extends GetView<CreatePostController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Gönderi'),
        actions: [
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: controller.uploadPost,
                    child: const Text(
                      'Paylaş',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return controller.selectedImagePath.value.isEmpty
                  ? GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: controller.pickImage,
                      child: Image.file(
                        File(controller.selectedImagePath.value),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
            }),
            const SizedBox(height: 20),
            TextField(
              controller: controller.captionController,
              decoration: const InputDecoration(
                hintText: "Bir şeyler yaz..",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
