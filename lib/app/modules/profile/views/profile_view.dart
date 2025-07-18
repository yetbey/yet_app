import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yet_app/app/modules/dashboard/widgets/post_widget.dart';
import 'package:yet_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:yet_app/app/modules/profile/widgets/profile_header_widget.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user.value;
      final posts = controller.posts;
      final isLoading = controller.isLoading.value;

      return Scaffold(
        appBar: AppBar(title: Text(user?.username ?? 'Profil'), elevation: 0),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : user == null
            ? const Center(child: Text("Kullanıcı bulunamadı."))
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: ProfileHeaderWidget(
                      user: user,
                      postCount: posts.length,
                    ),
                  ),
                  SliverList.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostWidget(post: post);
                    },
                  ),
                ],
              ),
      );
    });
  }
}
