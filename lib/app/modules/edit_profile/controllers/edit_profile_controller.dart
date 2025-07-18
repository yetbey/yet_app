import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/user_model.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  final displayNameController = TextEditingController();
  final bioController = TextEditingController();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxString newProfileImagePath = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      user.value = UserModel.fromMap(doc);
      // Controller'ları mevcut verilerle doldur
      displayNameController.text = user.value?.displayName ?? '';
      bioController.text = user.value?.bio ?? '';
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      newProfileImagePath.value = image.path;
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      isLoading.value = false;
      return;
    }

    try {
      String? newProfilePhotoUrl;
      // 1. Yeni bir resim seçildiyse, Storage'a yükle
      if (newProfileImagePath.isNotEmpty) {
        final ref = _storage.ref().child('profile_pictures/${currentUser.uid}');
        await ref.putFile(File(newProfileImagePath.value));
        newProfilePhotoUrl = await ref.getDownloadURL();
      }

      // 2. Güncellenecek verileri bir haritada topla
      Map<String, dynamic> dataToUpdate = {};
      if (displayNameController.text != user.value?.displayName) {
        dataToUpdate['displayName'] = displayNameController.text;
      }
      if (bioController.text != user.value?.bio) {
        dataToUpdate['bio'] = bioController.text;
      }
      if (newProfilePhotoUrl != null) {
        dataToUpdate['profilePhotoUrl'] = newProfilePhotoUrl;
      }

      // 3. Sadece değişiklik varsa Firestore'u güncelle
      if (dataToUpdate.isNotEmpty) {
        await _firestore.collection('users').doc(currentUser.uid).update(dataToUpdate);
      }

      Get.back(result: true); // Başarılı sonucuyla bir önceki sayfaya dön
      Get.snackbar("Başarılı", "Profiliniz güncellendi.");

    } catch (e) {
      Get.snackbar("Hata", "Profil güncellenirken bir sorun oluştu.");
    } finally {
      isLoading.value = false;
    }
  }
}