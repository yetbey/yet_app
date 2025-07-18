import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const YetBank());
}

class YetBank extends StatelessWidget {
  const YetBank({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Yet App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData.light(),
    );
  }
}
