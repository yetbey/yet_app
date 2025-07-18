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

    // Değişikliği UI'da anında göstermek için yerel kullanıcı nesnesini güncelliyoruz.
    final localUser = user.value;
    if (localUser == null) return;

    if (isFollowing.value) {
      // --- Takipten Çıkma İşlemi ---
      isFollowing.value = false;
      localUser.followers.remove(_currentUserId); // Lokal listeden çıkar

      // Arka planda Firestore'u güncelle
      await currentUserRef.update({
        'following': FieldValue.arrayRemove([_userId])
      });

    } else {
      // --- Takip Etme İşlemi ---
      isFollowing.value = true;
      localUser.followers.add(_currentUserId); // Lokal listeye ekle

      // Arka planda Firestore'u güncelle
      await currentUserRef.update({
        'following': FieldValue.arrayUnion([_userId])
      });
    }

    // ÖNEMLİ: GetX'e 'user' nesnesinin içeriğinin değiştiğini bildiriyoruz.
    // Bu komut, 'user'ı dinleyen tüm Obx widget'larının (takipçi sayısı gibi)
    // kendilerini yeniden çizmesini tetikler.
    user.refresh();
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
