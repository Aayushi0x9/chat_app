import 'package:chat_app/service/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //     // options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //
  // tz.initializeTimeZones();
  //
  // await NotificationService.notificationService.initNotification();

  runApp(
    const MyApp(),
  );
}
