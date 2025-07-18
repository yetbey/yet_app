import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yet_app/app/data/models/user_model.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel user;
  final int postCount;
  const ProfileHeaderWidget({
    super.key,
    required this.user,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: user.profilePhotoUrl != null
                    ? NetworkImage(user.profilePhotoUrl!)
                    : null,
                child: user.profilePhotoUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn("Gönderi", postCount.toString()),
                    _buildStatColumn(
                      "Takiipçi",
                      user.followers.length.toString(),
                    ),
                    _buildStatColumn("Takip", user.following.length.toString()),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.displayName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(user.bio),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            // if-else kontrolünü Obx'in DIŞINA alıyoruz.
            child: (user.id == currentUserId)
            // 1. Kendi profili ise: Normal bir buton, Obx yok.
                ? OutlinedButton(
              onPressed: () async {
                var result = await Get.toNamed(Routes.editProfile);
                if (result == true) {
                  controller.fetchUserData();
                }
              },
              child: const Text("Profili Düzenle"),
            )
            // 2. Başkasının profili ise: Sadece bu butonu Obx ile sarmala.
                : Obx(() {
              return ElevatedButton(
                onPressed: controller.toggleFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isFollowing.value
                      ? Colors.grey
                      : Get.theme.primaryColor,
                ),
                child: Text(controller.isFollowing.value
                    ? "Takipten Çık"
                    : "Takip Et"),
              );
            }),
          )
        ],
      ),
    );
  }

  Column _buildStatColumn(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
