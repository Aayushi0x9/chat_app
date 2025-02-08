import 'package:chat_app/controller/register_controller.dart';
import 'package:chat_app/extention.dart';
import 'package:chat_app/route/app_routes.dart';
import 'package:chat_app/service/api_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rive/rive.dart';
import 'package:toastification/toastification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode cPasswordFocusNode = FocusNode();
  TextEditingController cPasswordController = TextEditingController();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  TextEditingController userNameContrller = TextEditingController();

  var registerKey = GlobalKey<FormState>();

  var controllerRegister = Get.put(RegisterController());

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    cPasswordFocusNode.addListener(passwordFocus);
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

  void cPasswordFocus() {
    isHandsUp?.change(cPasswordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Text(
              "SIGNUP",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                "asset/rive/login-teddy.riv",
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
                key: registerKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GetBuilder<RegisterController>(builder: (context) {
                            return CircleAvatar(
                              radius: 65.w,
                              foregroundImage:
                                  (controllerRegister.image != null)
                                      ? FileImage(controllerRegister.image!)
                                      : null,
                              child: (controllerRegister.image != null)
                                  ? const Text("")
                                  : Icon(
                                      Icons.person,
                                      size: 45.sp,
                                    ),
                            );
                          }),
                          FloatingActionButton.small(
                            onPressed: () {
                              controllerRegister.pickUserImage();
                            },
                            child: const Icon(Icons.add_a_photo_outlined),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                          textInputAction: TextInputAction.done,
                          focusNode: cPasswordFocusNode,
                          controller: cPasswordController,
                          obscureText: controllerRegister.isCPassword.value,
                          validator: (val) => val!.isEmpty
                              ? "required confirm password.."
                              : null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {},
                        );
                      }),
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
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
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
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Obx(() {
                        return TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          obscureText: controllerRegister.isPassword.value,
                          validator: (val) =>
                              val!.isEmpty ? "required password.." : null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controllerRegister.changeVisibilityPassword();
                              },
                              icon: Icon(
                                (controllerRegister.isPassword.value)
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {},
                        );
                      }),
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
                          textInputAction: TextInputAction.done,
                          focusNode: cPasswordFocusNode,
                          controller: cPasswordController,
                          obscureText: controllerRegister.isCPassword.value,
                          validator: (val) => val!.isEmpty
                              ? "required confirm password.."
                              : null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controllerRegister.changeVisibilityCPassword();
                              },
                              icon: Icon(
                                (controllerRegister.isCPassword.value)
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {},
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () async {
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();
                          cPasswordFocusNode.unfocus();
                          if (registerKey.currentState!.validate() &&
                              controllerRegister.image != null) {
                            trigSuccess?.change(true);
                            String userName = userNameContrller.text.trim();
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
                            String cPassword = cPasswordController.text.trim();

                            if (password == cPassword) {
                              String image = await APIService.apiService
                                  .uploadUserImage(
                                      image: controllerRegister.image!);

                              controllerRegister.registerNewUser(
                                userName: userName,
                                email: email,
                                password: password,
                                image: image,
                              );
                            } else {
                              trigFail?.change(true);
                              toastification.show(
                                title: const Text("ERROR"),
                                description: const Text(
                                  "password and conform password had not matched",
                                ),
                                autoCloseDuration: const Duration(
                                  seconds: 3,
                                ),
                                type: ToastificationType.error,
                                style: ToastificationStyle.flatColored,
                              );
                            }
                          } else {
                            toastification.show(
                              title: const Text("ERROR"),
                              description: const Text(
                                "Image Required",
                              ),
                              autoCloseDuration: const Duration(
                                seconds: 3,
                              ),
                              type: ToastificationType.error,
                              style: ToastificationStyle.flatColored,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Color(0xff4C7690),
                          // Color(0xff518cf7),
                        ),
                        child: Text(
                          "SIGNUP",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Text.rich(
              TextSpan(
                text: "Don't have an account ? ",
                children: [
                  TextSpan(
                    text: "Login",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.back();
                      },
                    style: TextStyle(
                      color: Color(0xff4C7690),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff4C7690),
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
