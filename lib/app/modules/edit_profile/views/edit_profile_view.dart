import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        actions: [
          Obx(() => controller.isLoading.value
              ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
              : IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.saveProfile,
          ))
        ],
      ),
      body: Obx(() {
        if (controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  final newImagePath = controller.newProfileImagePath.value;
                  final existingImageUrl = controller.user.value?.profilePhotoUrl;

                  ImageProvider? backgroundImage;
                  if (newImagePath.isNotEmpty) {
                    backgroundImage = FileImage(File(newImagePath));
                  } else if (existingImageUrl != null) {
                    backgroundImage = NetworkImage(existingImageUrl);
                  }

                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: backgroundImage,
                    child: backgroundImage == null ? const Icon(Icons.person, size: 50) : null,
                  );
                }),
              ),
              const SizedBox(height: 8),
              const Text("Profil Fotoğrafını Değiştir"),
              const SizedBox(height: 24),
              TextField(
                controller: controller.displayNameController,
                decoration: const InputDecoration(labelText: "Görünen Ad"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.bioController,
                decoration: const InputDecoration(labelText: "Biyografi"),
                maxLines: 3,
              ),
            ],
          ),
        );
      }),
    );
  }
}