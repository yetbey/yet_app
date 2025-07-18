part of 'app_pages.dart';

abstract class Routes {
  static const auth = '/auth'; // Login and Register Screen
  static const dashboard = '/dashboard'; // Dashboard Screen
  static const transfer = '/transfer'; // Transfer Screen
  static const createPost = '/create_post'; // create post screen
  static const profile = '/profile/:userId';
  static const postDetail = '/post/:postId';
  static const editProfile = '/edit-profile';
}
