import 'dart:async';
import 'dart:developer';

import 'package:chat_app/route/app_routes.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 10), () {
      log("Current User : ${AuthService.authService.currentUser}");
      (AuthService.authService.currentUser != null)
          ? Get.offNamed(Routes.home)
          : Get.offNamed(Routes.login);
    });
    return Scaffold(
      backgroundColor: const Color(0xfff2f6fa),
      body: Center(
        child: Image.asset(
          'assets/GIF/logo.gif',
        ),
      ),
    );
  }
}
