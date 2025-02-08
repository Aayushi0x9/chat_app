import 'package:chat_app/route/app_routes.dart';
import 'package:chat_app/screen/auth/login.dart';
import 'package:chat_app/screen/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return ScreenUtilInit(
      designSize: Size(width, height),
      builder: (context, _) => ToastificationWrapper(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Routes.pages,
        ),
      ),
    );
  }
}
