// lib/app/modules/splash/views/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller'ı başlatmak için Get.put kullanıyoruz, çünkü bu ilk sayfa olacak
    Get.put(SplashController());

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}