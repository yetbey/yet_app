import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePostController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final captionController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var selectedImagePath = ''.obs;
  var isLoading = false.obs;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    } else {
      Get.snackbar("Hata", "Resim seçilemedi.");
    }
  }

  Future<void> uploadPost() async {
    if (selectedImagePath.value.isEmpty) {
      Get.snackbar("Eksik Bilgi", "Lütfen bir resim seçin.");
      return;
    }
    if (captionController.text.isEmpty) {
      Get.snackbar("Eksik Bilgi", "Lütfen bir açıklama girin.");
      return;
    }

    isLoading.value = true;

    try {
      // Upload the image to Firebase Storage
      String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(File(selectedImagePath.value));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Get the current user infos
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Kullanıcı Bulunamadı!");
      }

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      String username = userDoc.get('username');
      String? profilePic = userDoc.get('profilePhotoUrl');

      // Save the Post infot to Firebase
      await _firestore.collection('posts').add({
        'authorId': currentUser.uid,
        'authorUsername': username,
        'authorProfilePhotoUrl': profilePic,
        'imageUrl': downloadUrl,
        'caption': captionController.text,
        'likeCount': 0,
        'likes': [], // Beğenenlerin listesi
        'timestamp': Timestamp.now(),
      });
      Get.back();
      Get.snackbar("Başarılı", "Gönderiniz paylaşıldı!");
    } catch (e) {
      Get.snackbar(
        "Hata",
        "Gönderi yüklenirken bir hata oluştu. : ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    captionController.dispose();
    super.onClose();
  }
}
