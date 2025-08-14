import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yet_app/app/data/models/post_model.dart';
import 'package:get/get.dart';
import 'package:yet_app/app/modules/dashboard/controllers/post_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../profile/controllers/profile_controller.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.put(PostController(), tag: post.id);
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final bool isLiked = post.likes.contains(currentUserId);
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header - Username and Profile Picture
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.delete<ProfileController>();
                    Get.toNamed('/profile/${post.authorId}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: post.authorProfilePhotoUrl != null
                              ? NetworkImage(post.authorProfilePhotoUrl!)
                              : null,
                          child: post.authorProfilePhotoUrl == null
                              ? const Icon(Icons.person, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          post.authorUsername,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                if (post.authorId == currentUserId)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog(context, controller, post.id);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Sil'),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Post Image
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300, // constant maybe change
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),

          // Explanation
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: '${post.authorUsername} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: post.caption),
                ],
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => controller.toggleLike(post.id, post.likes),
                      icon: Icon(
                        isLiked ? Iconsax.heart: Iconsax.heart,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text(
                      post.likeCount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {
                      Get.toNamed('/post/${post.id}');
                    }, icon: Icon(Iconsax.message)),
                    Text(
                      post.commentCount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(onPressed: () {}, icon: Icon(Iconsax.send_1)),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PostController controller, String postId) {
    Get.defaultDialog(
      title: "Gönderiyi Sil",
      middleText: "Bu gönderiyi kalıcı olarak silmek istediğinizden emin misiniz?",
      textConfirm: "Evet, Sil",
      textCancel: "İptal",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deletePost(postId); // post.id'yi controller'a iletiyoruz
      },
    );
  }

}
