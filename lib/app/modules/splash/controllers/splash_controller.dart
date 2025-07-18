// lib/app/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // Auth durumundaki değişiklikleri dinle
    _auth.authStateChanges().listen((User? user) {
      // Bir sonraki frame'de yönlendirme yaparak UI çakışmalarını önle
      Future.delayed(const Duration(seconds: 1), () {
        if (user == null) {
          // Kullanıcı yoksa giriş ekranına yönlendir
          Get.offAllNamed(Routes.auth);
        } else {
          // Kullanıcı varsa ana sayfaya yönlendir
          Get.offAllNamed(Routes.root);
        }
      });
    });
  }
}