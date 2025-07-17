import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yet_app/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final usernameController = TextEditingController();
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLogin = true.obs;
  var isLoading = false.obs;

  void toggleForm() {
    isLogin.value = !isLogin.value;
  }

  Future<void> register() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // If registering is successfuil, create a doc on Firebase
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': usernameController.text.trim(),
          'displayName': displayNameController.text.trim(),
          'email': emailController.text.trim(),
          'bio': 'Yeni Hesap',
          'profilePhotoUrl': null,
          'followers': [],
          'following': [],
          'createdAt': Timestamp.now(),
        });
      }

      Get.offAllNamed(Routes.dashboard);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Kayıt Hatası',
        e.message ?? 'Bir Hata Oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(Routes.dashboard);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Giriş Hatası',
        e.message ?? 'Bilinmeyen bir hata oluştu.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
