import 'package:get/get.dart';
import 'package:yet_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:yet_app/app/modules/auth/views/auth_view.dart';
import 'package:yet_app/app/modules/create_post/bindings/create_post_binding.dart';
import 'package:yet_app/app/modules/create_post/views/create_post_view.dart';
import 'package:yet_app/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:yet_app/app/modules/dashboard/views/dashboard_view.dart';
import 'package:yet_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:yet_app/app/modules/profile/views/profile_view.dart';
import 'package:yet_app/app/modules/edit_profile/bindings/edit_profile_binding.dart';
import 'package:yet_app/app/modules/edit_profile/views/edit_profile_view.dart';
import '../modules/post_detail/bindings/post_detail_binding.dart';
import '../modules/post_detail/views/post_detail_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/controller_view.dart';
part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.root,
      page: () => const RootView(),
      binding: RootBinding(),
    ),
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
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.postDetail,
      page: () => PostDetailView(),
      binding: PostDetailBinding(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
  ];
}
