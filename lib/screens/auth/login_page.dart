import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:time_clock_manager/navigation/route_strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/auth_controller.dart';
import '../../gen/assets.gen.dart';
import '../../utils/validator.dart';
import '../../widgets/custom_buuton_with_splash.dart';

class LoginPage extends StatefulWidget {

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.canvasColor,
      body: GetBuilder<AuthController>(
          init: controller,
          builder: (controller) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: ListView(
                children: [
                  Material(
                    type: MaterialType.transparency,
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 1, 8, 12),
                            blurRadius: 8,
                            offset: const Offset(1, 0),
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: PhysicalModel(
                        color: context.canvasColor,
                        elevation: 8,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        shadowColor: const Color.fromARGB(255, 1, 8, 12),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                12.heightBox,
                                Hero(
                                  tag: "titleText",
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        'Hello There!'
                                            .text
                                            .xl3
                                            .textStyle(
                                              GoogleFonts.pacifico(
                                                textStyle: const TextStyle(),
                                              ),
                                            )
                                            .align(TextAlign.center)
                                            .make(),
                                        3.heightBox,
                                        'Login to continue'
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
                                                  const Color.fromARGB(
                                                      255, 116, 151, 168),
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
                                      Hero(
                                        tag: "emailBox",
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: TextFormField(
                                            autofocus: false,
                                            autofillHints: const [
                                              AutofillHints.email
                                            ],
                                            controller: controller
                                                .emailControllerForLogin,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            onSaved: (value) {
                                              controller.emailControllerForLogin
                                                  .text = value!;
                                            },
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              hintText: 'Enter Your Email',
                                              filled: true,
                                              prefixIcon: Icon(Icons.message),
                                              labelText: 'Email',
                                            ),
                                            validator: Validator().email,
                                          ),
                                        ),
                                      ),
                                      15.heightBox,
                                      Hero(
                                        tag: 'passwordBox',
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: TextFormField(
                                            obscureText: controller
                                                .isPasswordHidden.value,
                                            autofocus: false,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            autofillHints: const [
                                              AutofillHints.password
                                            ],
                                            controller: controller
                                                .passwordControllerForLogin,
                                            onSaved: (value) {
                                              controller
                                                  .passwordControllerForLogin
                                                  .text = value!;
                                            },
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    20.0,
                                                  ),
                                                ),
                                              ),
                                              filled: true,
                                              prefixIcon:
                                                  const Icon(Icons.password),
                                              suffixIcon: Icon(controller
                                                          .isPasswordHidden
                                                          .value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off)
                                                  .onTap(() {
                                                controller
                                                    .togglePasswordVisibility();
                                              }),
                                              hintText: 'Enter Your Password',
                                              labelText: 'Password',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return ("Password can't be Empty");
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: TextButton(
                                          onPressed: () {
                                            Get.toNamed(RouteStrings.login);
                                          },
                                          child: 'Forgot Password?'
                                              .text
                                              .semiBold
                                              .make(),
                                        ),
                                      ),
                                      !controller.isLoadingForLogin.isTrue
                                          ? Hero(
                                              tag: "loginButton",
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: CustomButtonWithSplash(
                                                    borderRadius: 6.8,
                                                    onTap: () async {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        await controller.signIn(
                                                            controller
                                                                .emailControllerForLogin
                                                                .text
                                                                .trim(),
                                                            controller
                                                                .passwordControllerForLogin
                                                                .text);
                                                      }
                                                    },
                                                    title: 'Login'),
                                              ),
                                            )
                                          : Lottie.asset(
                                              Assets.animations.verticalLoading,
                                              height: 70,
                                              fit: BoxFit.fill,
                                            ),
                                      // Hero(
                                      //   tag: "textButton",
                                      //   child: Material(
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         'Don\'t have an account?'
                                      //             .text
                                      //             .bold
                                      //             .make(),
                                      //         TextButton(
                                      //           onPressed: (() {
                                      //             controller
                                      //                 .changeSlidingValue(1);
                                      //           }),
                                      //           child:
                                      //               'Sign Up'.text.bold.make(),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ).px(20).pOnly(top: 12, bottom: 6),
                                ),
                              ]),
                        ),
                      ),
                    ).p(8).px(4),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
