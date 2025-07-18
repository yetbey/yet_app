import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/post_model.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<PostModel> postList = <PostModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Kullanıcı giriş yapmış mı kontrol et
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Doğrudan kullanıcının kişisel feed'ini dinle
      postList.bindStream(_fetchPersonalizedFeed(currentUser.uid));
    } else {
      isLoading.value = false;
    }
  }

  Stream<List<PostModel>> _fetchPersonalizedFeed(String userId) {
    return _firestore
    // YENİ SORGUMUZ: Çok daha basit ve performanslı!
        .collection('feeds')
        .doc(userId)
        .collection('user_feed_items')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final posts = snapshot.docs.map((doc) => PostModel.fromMap(doc)).toList();
      isLoading.value = false;
      return posts;
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.auth);
  }
}