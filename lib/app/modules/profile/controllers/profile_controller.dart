import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yet_app/app/data/models/post_model.dart';
import 'package:yet_app/app/data/models/user_model.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isFollowing = false.obs;

  late final String _userId;
  late final String _currentUserId;

  @override
  void onInit() {
    super.onInit();
    _userId = Get.parameters['userId']!;
    _currentUserId = _auth.currentUser!.uid;
    fetchUserData();
    fetchUserPosts();
  }

  Future<void> fetchUserData() async {
    try {
      final doc = await _firestore.collection('users').doc(_userId).get();
      if (doc.exists) {
        final fetchedUser = UserModel.fromMap(doc);
        user.value = fetchedUser;
        // Takip durumunu kontrol et
        isFollowing.value = fetchedUser.followers.contains(_currentUserId);
      }
    } catch (e) {
      Get.snackbar("Hata", "Kullanıcı bilgileri alınamadı: $e");
    }
  }

  Future<void> toggleFollow() async {
    final currentUserRef = _firestore.collection('users').doc(_currentUserId);

    if (isFollowing.value) {
      // Takipten Çıkma (Sadece kendi listesinden çıkarır)
      await currentUserRef.update({
        'following': FieldValue.arrayRemove([_userId])
      });
      isFollowing.value = false;
    } else {
      // Takip Etme (Sadece kendi listesine ekler)
      await currentUserRef.update({
        'following': FieldValue.arrayUnion([_userId])
      });
      isFollowing.value = true;
    }
  }

  Future<void> fetchUserPosts() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('authorId', isEqualTo: _userId)
          .orderBy('timestamp', descending: true)
          .get();

      posts.value = snapshot.docs.map((doc) => PostModel.fromMap(doc)).toList();
    } catch (e) {
      Get.snackbar("Hata", "Gönderiler alınamadı: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
