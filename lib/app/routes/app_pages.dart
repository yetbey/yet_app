import 'package:get/get.dart';
import 'package:yet_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:yet_app/app/modules/auth/views/auth_view.dart';
import 'package:yet_app/app/modules/create_post/bindings/create_post_binding.dart';
import 'package:yet_app/app/modules/create_post/views/create_post_view.dart';
import 'package:yet_app/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:yet_app/app/modules/dashboard/views/dashboard_view.dart';
part 'app_routes.dart';

class AppPages {
  static const initial = Routes.auth;

  static final routes = <GetPage>[
    /// AUTH
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),

    /// DASHBOARD
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.createPost,
      page: () => const CreatePostView(),
      binding: CreatePostBinding(),
    ),
  ];
}
