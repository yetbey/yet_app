import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> toggleLike(String postId, List currentLikes) async {
    final String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;
    bool isLiked = currentLikes.contains(currentUserId);
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    if (isLiked) {
      // Eğer zaten beğenilmişse, beğeniyi geri al
      await postRef.update({
        'likes': FieldValue.arrayRemove([currentUserId]),
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      // Eğer beğenilmemişse, beğen
      await postRef.update({
        'likes': FieldValue.arrayUnion([currentUserId]),
        'likeCount': FieldValue.increment(1),
      });
    }
  }

  Future<void> deletePost(String postId) async {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    try {
      await _firestore.collection('posts').doc(postId).delete();
      Get.snackbar("Başarılı", "Gönderiniz silindi.");
    } catch (e) {
      Get.snackbar("Hata", "Gönderi silinirken bir sorun oluştu.");
    }

  }

}
