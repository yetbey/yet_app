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
  // Feed'in boş olup olmadığını daha anlamlı bir şekilde takip etmek için
  final RxBool isFeedEmpty = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Kullanıcının oturum durumundaki değişiklikleri dinle
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        // Kullanıcı giriş yapmışsa, onun kişisel feed'ini dinlemeye başla
        postList.bindStream(_fetchPersonalizedFeed(user.uid));
      } else {
        // Kullanıcı çıkış yapmışsa, listeyi temizle ve yüklemeyi durdur
        postList.clear();
        isLoading.value = false;
      }
    });
  }

  Stream<List<PostModel>> _fetchPersonalizedFeed(String userId) {
    isLoading.value = true; // Her yeni dinlemede yüklemeyi başlat
    return _firestore
    // YENİ VE DOĞRU YOL: Kişisel feed koleksiyonu
        .collection('feeds')
        .doc(userId)
        .collection('user_feed_items')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final posts = snapshot.docs.map((doc) => PostModel.fromMap(doc)).toList();
      // Veri geldikten sonra feed'in boş olup olmadığını kontrol et
      isFeedEmpty.value = posts.isEmpty;
      isLoading.value = false; // Yükleme tamamlandı
      return posts;
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.auth);
  }
}