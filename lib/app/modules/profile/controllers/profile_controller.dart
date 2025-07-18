import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yet_app/app/data/models/post_model.dart';
import 'package:yet_app/app/data/models/user_model.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = true.obs;

  late final String _userId;

  @override
  void onInit() {
    super.onInit();
    _userId = Get.parameters['userId']!;
    fetchUserData();
    fetchUserPosts();
  }

  Future<void> fetchUserData() async {
    try {
      final doc = await _firestore.collection('users').doc(_userId).get();
      if (doc.exists) {
        user.value = UserModel.fromMap(doc);
      }
    } catch (e) {
      Get.snackbar("Hata", "Kullanıcı bilgileri alınamadı: $e");
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
