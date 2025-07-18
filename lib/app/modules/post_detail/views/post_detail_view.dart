import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard/widgets/post_widget.dart';
import '../controllers/post_detail_controller.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gönderi'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.post.value == null) {
          return const Center(child: Text("Gönderi bulunamadı."));
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // 1. Gönderinin kendisi
                  PostWidget(post: controller.post.value!),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Yorumlar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  // 2. Yorumların listesi
                  Obx(() {
                    if (controller.comments.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Henüz yorum yok. İlk yorumu sen yap!"),
                      ));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.comments.length,
                      itemBuilder: (context, index) {
                        final comment = controller.comments[index];
                        return ListTile(
                          title: Text(comment.authorUsername, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(comment.text),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            // 3. Yorum yazma alanı
            _buildCommentInputField(),
          ],
        );
      }),
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 2,
            color: Colors.black.withValues(alpha: 0.1),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.commentTextController,
              decoration: const InputDecoration(
                hintText: "Yorum ekle...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: controller.addComment,
          ),
        ],
      ),
    );
  }

}