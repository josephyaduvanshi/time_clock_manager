import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/auth_controller.dart';
import '../../gen/assets.gen.dart';
import '../../utils/validator.dart';
import '../../widgets/custom_buuton_with_splash.dart';

class SignUpUI extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SignUpUI({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController.instance;
    return GetBuilder<AuthController>(
        init: authController,
        builder: (controller) {
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: "titleText",
                      child: Material(
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            "Let's get started!"
                                .text
                                .xl3
                                .textStyle(
                                  GoogleFonts.pacifico(
                                    textStyle: const TextStyle(),
                                  ),
                                )
                                .align(TextAlign.center)
                                .make(),
                            5.heightBox,
                            'Begin investing for the future today.'
                                .text
                                .semiBold
                                .textStyle(
                                  GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                )
                                .align(TextAlign.center)
                                .make()
                                .shimmer(
                                  primaryColor:
                                      const Color.fromARGB(255, 116, 151, 168),
                                  secondaryColor: Colors.blueAccent,
                                  duration: 5.seconds,
                                  showAnimation: true,
                                ),
                          ],
                        ),
                      ),
                    ),
                    AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            autofillHints: const [
                              AutofillHints.name,
                            ],
                            autofocus: false,
                            controller: controller.nameControllerForSignUp,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.name,
                            onSaved: (value) {
                              controller.nameControllerForSignUp.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              hintText: 'Enter Your Full Name',
                              filled: true,
                              prefixIcon: Icon(Icons.person_rounded),
                              labelText: 'Full Name',
                            ),
                            validator: Validator().name,
                          ),
                          15.heightBox,
                          TextFormField(
                            autofillHints: const [
                              AutofillHints.email,
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            autofocus: false,
                            controller: controller.emailControllerForSignUp,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              controller.emailControllerForSignUp.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              hintText: 'Enter Your Email',
                              filled: true,
                              prefixIcon: Icon(Icons.message),
                              labelText: 'Email',
                            ),
                            validator: Validator().email,
                          ),
                          15.heightBox,
                          TextFormField(
                            autofillHints: const [AutofillHints.password],
                            obscureText: controller.isPasswordHidden1.value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            autofocus: false,
                            controller: controller.passwordControllerForSignUp,
                            onSaved: (value) {
                              controller.passwordControllerForSignUp.text =
                                  value!;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                              filled: true,
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    controller.togglePasswordVisibility1();
                                  },
                                  child: Icon(controller.isPasswordHidden1.value
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                              hintText: 'Enter Your Password',
                              labelText: 'Password',
                            ),
                            validator: Validator().password,
                          ),
                          15.heightBox,
                          TextFormField(
                            autofillHints: const [AutofillHints.password],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: controller.isPasswordHidden2.value,
                            autofocus: false,
                            controller:
                                controller.confirmPasswordControllerForSignUp,
                            onSaved: (value) {
                              controller.confirmPasswordControllerForSignUp
                                  .text = value!;
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                              filled: true,
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    controller.togglePasswordVisibility2();
                                  },
                                  child: Icon(
                                      controller.isPasswordHidden2.isTrue
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                              hintText: 'Confirm Your Password',
                              labelText: 'Confirm Password',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Password can't be empty.");
                              }
                              if (controller.confirmPasswordControllerForSignUp
                                      .text !=
                                  controller.passwordControllerForSignUp.text) {
                                return "Passwords don't match!";
                              }
                              return null;
                            },
                          ),
                        ],
                      ).px(20).pOnly(top: 12, bottom: 6),
                    ),
                    8.heightBox,
                    !controller.isLoadingForSignUp.isTrue
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: CustomButtonWithSplash(
                              borderRadius: 6.8,
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  await controller.signUp(
                                      email: controller
                                          .emailControllerForSignUp.text,
                                      password: controller
                                          .passwordControllerForSignUp.text,
                                      name: controller
                                          .nameControllerForSignUp.text);
                                }
                              },
                              title: "Sign Up",
                            ),
                          )
                        : Lottie.asset(
                            Assets.animations.verticalLoading,
                            height: 70,
                            fit: BoxFit.fill,
                          ),
                    Hero(
                      tag: "textButton",
                      child: Material(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Already have an account?".text.bold.make(),
                            TextButton(
                              onPressed: (() {
                                controller.changeSlidingValue(0);
                              }),
                              child: 'Sign In'.text.bold.make(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
