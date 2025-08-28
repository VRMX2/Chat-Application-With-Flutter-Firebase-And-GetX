import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appchatfl/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Navigate to Login (or Home if logged in) after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.login); // Change to home if already authenticated
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Icon(
              Icons.chat_bubble_outline,
              size: 90,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              "Chat App 2026",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 30),
            // Loading Indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
