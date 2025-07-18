import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/comment_model.dart';
import '../../../data/models/post_model.dart';

class PostDetailController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final commentTextController = TextEditingController();
  final Rx<PostModel?> post = Rx<PostModel?>(null);
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = true.obs;

  late final String _postId;

  @override
  void onInit() {
    super.onInit();
    _postId = Get.parameters['postId']!;
    _fetchPostData();
    comments.bindStream(_fetchComments());
  }

  Future<void> _fetchPostData() async {
    try {
      final doc = await _firestore.collection('posts').doc(_postId).get();
      if (doc.exists) {
        post.value = PostModel.fromMap(doc);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<CommentModel>> _fetchComments() {
    return _firestore
        .collection('posts')
        .doc(_postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => CommentModel.fromMap(doc)).toList(),
        );
  }

  Future<void> addComment() async {
    final text = commentTextController.text.trim();
    if (text.isEmpty) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // Kullanıcının adını almak için users koleksiyonuna bak
    final userDoc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final username = userDoc.data()?['username'] ?? 'bilinmeyen';

    await _firestore
        .collection('posts')
        .doc(_postId)
        .collection('comments')
        .add({
          'text': text,
          'authorId': currentUser.uid,
          'authorUsername': username,
          'timestamp': Timestamp.now(),
        });

    // Ana posttaki yorum sayacını 1 artır
    await _firestore.collection('posts').doc(_postId).update({
      'commentCount': FieldValue.increment(1),
    });

    commentTextController.clear();
  }
}
