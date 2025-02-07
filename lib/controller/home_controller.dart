import 'package:chat_app/service/auth_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Future<void> signOut() async {
    await AuthService.authService.logOut();
  }
}
