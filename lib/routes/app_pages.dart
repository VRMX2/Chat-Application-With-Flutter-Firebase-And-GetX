import 'package:get/get.dart';
import 'package:appchatfl/routes/app_routes.dart';
import 'package:appchatfl/controllers/auth_controller.dart';

// Views
import 'package:appchatfl/views/splash_view.dart';
import 'package:appchatfl/views/auth/login_view.dart';
import 'package:appchatfl/views/auth/register_view.dart';
import 'package:appchatfl/views/home/home_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
        name: AppRoutes.splash,
        page: () => const SplashView()
    ),
    GetPage(
        name: AppRoutes.login,
        page: () => LoginView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AuthController>(() => AuthController());
        })
    ),
    GetPage(
        name: AppRoutes.register,
        page: () => RegisterView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AuthController>(() => AuthController());
        })
    ),
    GetPage(
        name: AppRoutes.home,
        page: () => HomeView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AuthController>(() => AuthController());
        })
    ),
  ];
}