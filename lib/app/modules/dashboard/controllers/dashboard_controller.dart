import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yet_app/app/data/models/post_model.dart';
import 'package:yet_app/app/routes/app_pages.dart';

class DashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var postList = <PostModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    postList.bindStream(fetchPosts());
  }

  Stream<List<PostModel>> fetchPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true) // From newer to older
        .snapshots()
        .map((snapshot) {
          isLoading.value = false;
          return snapshot.docs.map((doc) => PostModel.fromMap(doc)).toList();
        });
  }

  Future<void> logOut() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.auth);
  }
}
