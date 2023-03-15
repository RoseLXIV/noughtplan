import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/auth/models/auth_result.dart';

import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/widgets/custom_button.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

class GetStartedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: getVerticalSize(
                  410,
                ),
                width: double.maxFinite,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgTopographic8,
                      height: getVerticalSize(
                        395,
                      ),
                      width: getHorizontalSize(
                        375,
                      ),
                      alignment: Alignment.topCenter,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgTopographic8309x375,
                      height: getVerticalSize(
                        350,
                      ),
                      width: getHorizontalSize(
                        375,
                      ),
                      alignment: Alignment.topCenter,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgMainlogo1,
                      height: getVerticalSize(
                        200,
                      ),
                      width: getHorizontalSize(
                        352,
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              ),
              Text(
                "Get Started",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtHelveticaNowTextBold24,
              ),
              Padding(
                padding: getPadding(
                  top: 7,
                ),
                child: Text(
                  "The Nought Plan - A.I. Powered Budgeting App",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeRegular14.copyWith(
                    letterSpacing: getHorizontalSize(
                      0.3,
                    ),
                  ),
                ),
              ),
              CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, '/login_page_screen');
                },
                height: getVerticalSize(
                  56,
                ),
                fontStyle: ButtonFontStyle.HelveticaNowTextBold16,
                text: "Continue with Email",
                margin: getMargin(
                  left: 24,
                  top: 24,
                  right: 24,
                ),
              ),
              CustomButton(
                onTap: () async {
                  await ref.read(authStateProvider.notifier).loginWithGoogle();
                  final authState = ref.watch(authStateProvider);
                  if (authState.result == AuthResult.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Invalid Email or Password!',
                          textAlign: TextAlign.center,
                          style: AppStyle.txtHelveticaNowTextBold16WhiteA700
                              .copyWith(
                            letterSpacing: getHorizontalSize(0.3),
                          ),
                        ),
                        backgroundColor: ColorConstant.redA700,
                      ),
                    );
                  } else if (authState.result == AuthResult.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sign In Successful!',
                          textAlign: TextAlign.center,
                          style: AppStyle.txtHelveticaNowTextBold16WhiteA700
                              .copyWith(
                            letterSpacing: getHorizontalSize(0.3),
                          ),
                        ),
                        backgroundColor: ColorConstant.greenA70001,
                      ),
                    );
                  }
                  print('Auth State: ${authState.result}');
                },
                height: getVerticalSize(
                  56,
                ),
                text: "Continue with Google",
                margin: getMargin(
                  left: 24,
                  top: 16,
                  right: 24,
                ),
                variant: ButtonVariant.OutlineIndigo50,
                padding: ButtonPadding.PaddingT14,
                fontStyle: ButtonFontStyle.HelveticaNowTextBold16Gray900,
                prefixWidget: Container(
                  margin: getMargin(
                    right: 8,
                  ),
                  child: CustomImageView(
                    svgPath: ImageConstant.imgGoogle,
                  ),
                ),
              ),
              CustomButton(
                onTap: () async {
                  await ref
                      .read(authStateProvider.notifier)
                      .loginWithFacebook();
                  final authState = ref.watch(authStateProvider);
                  if (authState.result == AuthResult.aborted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sign In Aborted!',
                          textAlign: TextAlign.center,
                          style: AppStyle.txtHelveticaNowTextBold16WhiteA700
                              .copyWith(
                            letterSpacing: getHorizontalSize(0.3),
                          ),
                        ),
                        backgroundColor: ColorConstant.amberA200,
                      ),
                    );
                  } else if (authState.result == AuthResult.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sign In Successful!',
                          textAlign: TextAlign.center,
                          style: AppStyle.txtHelveticaNowTextBold16WhiteA700
                              .copyWith(
                            letterSpacing: getHorizontalSize(0.3),
                          ),
                        ),
                        backgroundColor: ColorConstant.greenA70001,
                      ),
                    );
                  }
                  print('Auth State: ${authState.result}');
                },
                height: getVerticalSize(
                  56,
                ),
                text: "Continue with Facebook",
                margin: getMargin(
                  left: 24,
                  top: 16,
                  right: 24,
                ),
                variant: ButtonVariant.OutlineIndigo50,
                padding: ButtonPadding.PaddingT14,
                fontStyle: ButtonFontStyle.HelveticaNowTextBold16Gray900,
                prefixWidget: Container(
                  margin: getMargin(
                    right: 8,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgFacebook,
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  top: 10,
                  bottom: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don’t have an account? ",
                            style: TextStyle(
                              color: ColorConstant.blueGray500,
                              fontSize: getFontSize(
                                14,
                              ),
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              letterSpacing: getHorizontalSize(
                                0.3,
                              ),
                            ),
                          ),
                          // TextSpan(
                          //   text: "Sign Up",
                          //   style: TextStyle(
                          //     color: ColorConstant.blueA700,
                          //     fontSize: getFontSize(
                          //       14,
                          //     ),
                          //     fontFamily: 'Helvetica Now Text ',
                          //     fontWeight: FontWeight.w700,
                          //     letterSpacing: getHorizontalSize(
                          //       0.3,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up_email_screen');
                      },
                      child: Text(
                        "Sign Up",
                        style: AppStyle.txtHelveticaNowTextBold16Blue,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
