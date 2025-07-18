import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/post_model.dart';

class ExploreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    posts.bindStream(_fetchAllPosts());
  }

  Stream<List<PostModel>> _fetchAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      isLoading.value = false;
      return snapshot.docs.map((doc) => PostModel.fromMap(doc)).toList();
    });
  }
}