import 'package:chat_app/controller/login_vontroller.dart';
import 'package:chat_app/extention.dart';
import 'package:chat_app/route/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  var loginKey = GlobalKey<FormState>();

  var controllerLoin = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    print("Build Called Again");
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              "LogIn",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                "assets/login-teddy.riv",
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                    artboard,

                    /// from rive, you can see it in rive editor
                    "Login Machine",
                  );
                  if (controller == null) return;

                  artboard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: loginKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        focusNode: emailFocusNode,
                        controller: emailController,
                        validator: (val) => val!.isEmpty
                            ? "required email.."
                            : (!val.isVerifyEmail())
                                ? "email is not valid"
                                : null,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {
                          numLook?.change(value.length.toDouble());
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Obx(() {
                        return TextFormField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          validator: (val) =>
                              val!.isEmpty ? "required password.." : null,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controllerLoin.changeVisibilityPassword();
                              },
                              icon: Icon(
                                (controllerLoin.isPassword.value)
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (loginKey.currentState!.validate()) {
                            controllerLoin.loginNewUser(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          }
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();

                          final email = emailController.text;
                          final password = passwordController.text;

                          if (mounted) Navigator.pop(context);

                          if (email != null) {
                            trigSuccess?.change(true);
                          } else {
                            trigFail?.change(true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff518cf7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              child: GestureDetector(
                onTap: () {
                  controllerLoin.signInWithGoogle();
                },
                child: Icon(
                  Icons.g_mobiledata_rounded,
                  size: 40.sp,
                  color: Colors.black,
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "Don't have an account ? ",
                children: [
                  TextSpan(
                    text: "Register",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(Routes.register);
                      },
                    style: const TextStyle(
                      color: Color(0xff518cf7),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff518cf7),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
