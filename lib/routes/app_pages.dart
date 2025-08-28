// routes/app_pages.dart
import 'package:get/get.dart';
import 'package:appchatfl/routes/app_routes.dart';
import 'package:appchatfl/controllers/auth_controller.dart';
import 'package:appchatfl/controllers/chat_controller.dart';

// Views
import 'package:appchatfl/models/user_model.dart';
import 'package:appchatfl/views/splash_view.dart';
import 'package:appchatfl/views/auth/login_view.dart';
import 'package:appchatfl/views/auth/register_view.dart';
import 'package:appchatfl/views/home/home_view.dart';
import 'package:appchatfl/views/chat/contacts_screen.dart';
import 'package:appchatfl/views/chat/chat_screen.dart';
import 'package:appchatfl/views/chat/profile_screen.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
        Get.lazyPut<ChatController>(() => ChatController());
      }),
    ),
    GetPage(
      name: AppRoutes.contacts,
      page: () => ContactsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatController>(() => ChatController());
      }),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () {
        final UserModel user = Get.arguments;
        return ChatScreen(user: user);
      },
		binding: BindingsBuilder(() {
        Get.lazyPut<ChatController>(() => ChatController());
      }),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
  ];
}