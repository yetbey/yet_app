import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yet_app/app/modules/auth/controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  controller.isLogin.value ? 'Hoşgeldiniz' : 'Hesap Oluşturun',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (!controller.isLogin.value) ...[
                  TextField(
                    controller: controller.usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Ad Soyad',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ],
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-Posta',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (controller.isLogin.value) {
                            controller.login();
                          } else {
                            controller.register();
                          }
                        },
                        child: Text(
                          controller.isLogin.value ? 'Giriş Yap' : 'Kayıt Ol',
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: controller.toggleForm,
                  child: Text(
                    controller.isLogin.value
                        ? 'Hesabınız yok mu? Kayıt Olun!'
                        : 'Zaten hesabınız varsa, Giriş Yap',
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
