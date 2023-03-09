import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/auth/providers/is_logged_in_provider.dart';
import 'package:noughtplan/core/auth/providers/password_visibility_provider_signin.dart';
import 'package:noughtplan/presentation/generator_salary_screen/generator_salary_screen.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_button_form.dart'
    hide ButtonVariant, ButtonPadding, ButtonFontStyle;
import 'package:noughtplan/widgets/custom_checkbox.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
import 'package:noughtplan/core/auth/signin/controller/signin_controller.dart';
import 'package:noughtplan/core/forms/form_validators.dart';

// import 'dart:developer' as devtools show log;

// extension Log on Object {
//   void log() => devtools.log(toString());
// }

class LoginPageScreen extends ConsumerWidget {
  final inputEmailController = TextEditingController();

  final inputPasswordController = TextEditingController();

  final emailFocusNode = FocusNode();

  final passwordFocusNode = FocusNode();

  // bool checkbox = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);
    final showErrorEmail = signInState.email.error;
    final showErrorPassword = signInState.password.error;
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final signInController = ref.read(signInProvider.notifier);
    final passwordVisibility = ref.watch(passwordVisibilityProviderSignIn);
    final bool isValidated = signInState.status.isValidated;
    if (isLoggedIn) {
      return GeneratorSalaryScreen();
    }
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Form(
                // key: _formKey,
                child: Container(
                    height: size.height,
                    width: double.maxFinite,
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.maxFinite,
                                    child: Container(
                                        width: double.maxFinite,
                                        padding: getPadding(
                                            left: 24,
                                            top: 16,
                                            right: 24,
                                            bottom: 16),
                                        decoration: AppDecoration.fillWhiteA700,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomImageView(
                                                  svgPath:
                                                      ImageConstant.imgClose,
                                                  height: getSize(24),
                                                  width: getSize(24),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  onTap: () {
                                                    onTapImgClose(context);
                                                  }),
                                              Padding(
                                                  padding: getPadding(top: 160),
                                                  child: Text("Welcome Back!",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold24)),
                                              Padding(
                                                  padding: getPadding(top: 6),
                                                  child: Text(
                                                      "Sign in to your account",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular14Bluegray300
                                                          .copyWith(
                                                              letterSpacing:
                                                                  getHorizontalSize(
                                                                      0.3))))
                                            ]))),
                                CustomTextFormField(
                                  focusNode: emailFocusNode,
                                  controller: inputEmailController,
                                  hintText: "Email",
                                  errorText: signInState.email.error != null &&
                                          emailFocusNode.hasFocus
                                      ? Text(
                                          Email.showEmailErrorMessage(
                                                  showErrorEmail)
                                              .toString(),
                                        )
                                      : null,
                                  margin:
                                      getMargin(left: 24, top: 24, right: 24),
                                  textInputType: TextInputType.emailAddress,
                                  onChanged: (email) =>
                                      signInController.onEmailChange(email),
                                ),
                                CustomTextFormField(
                                  focusNode: passwordFocusNode,
                                  controller: inputPasswordController,
                                  hintText: "Password",
                                  errorText:
                                      signInState.password.error != null &&
                                              passwordFocusNode.hasFocus
                                          ? Text(
                                              PasswordSignIn
                                                      .showPasswordErrorMessage(
                                                          showErrorPassword)
                                                  .toString(),
                                            )
                                          : null,
                                  margin:
                                      getMargin(left: 24, top: 16, right: 24),
                                  padding: TextFormFieldPadding.PaddingT16,
                                  onChanged: (password) => signInController
                                      .onPasswordChange(password),
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisibility ==
                                                PasswordVisibility.hidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        final newValue = passwordVisibility ==
                                                PasswordVisibility.hidden
                                            ? PasswordVisibility.visible
                                            : PasswordVisibility.hidden;
                                        ref
                                            .read(
                                                passwordVisibilityProviderSignIn
                                                    .notifier)
                                            .state = newValue;
                                      }),
                                  suffixConstraints: BoxConstraints(
                                      maxHeight: getVerticalSize(56)),
                                  isObscureText: passwordVisibility ==
                                      PasswordVisibility.hidden,
                                ),
                                Padding(
                                    padding: getPadding(left: 24, right: 24),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // CustomCheckbox(
                                          //     text: "Remember me",
                                          //     iconSize: getHorizontalSize(16),
                                          //     // value: checkbox,
                                          //     margin: getMargin(bottom: 1),
                                          //     fontStyle: CheckboxFontStyle
                                          //         .HelveticaNowTextMedium14,
                                          //     onChange: (value) {
                                          //       // checkbox = value;
                                          //     }),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  '/forgot_password_screen');
                                            },
                                            child: Text('Forget Password?',
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold14
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.3))),
                                          ),
                                        ])),
                                CustomButtonForm(
                                  onTap: isValidated
                                      ? () => signInController
                                          .signInWithEmailAndPassword()
                                      : null,
                                  height: getVerticalSize(56),
                                  text: "Sign In",
                                  margin:
                                      getMargin(left: 24, top: 12, right: 24),
                                  enabled: isValidated,
                                ),
                                Padding(
                                    padding: getPadding(top: 27),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  getPadding(top: 6, bottom: 9),
                                              child: SizedBox(
                                                  width: getHorizontalSize(44),
                                                  child: Divider(
                                                      color: ColorConstant
                                                          .indigo50))),
                                          Padding(
                                              padding: getPadding(left: 12),
                                              child: Text("Or sign in with",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtManropeRegular12
                                                      .copyWith(
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))),
                                          Padding(
                                              padding:
                                                  getPadding(top: 6, bottom: 9),
                                              child: SizedBox(
                                                  width: getHorizontalSize(44),
                                                  child: Divider(
                                                      color: ColorConstant
                                                          .indigo50)))
                                        ])),
                                Padding(
                                    padding: getPadding(
                                        left: 24, top: 15, right: 24),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomButton(
                                              onTap: ref
                                                  .read(authStateProvider
                                                      .notifier)
                                                  .loginWithGoogle,
                                              height: getVerticalSize(55),
                                              width: getHorizontalSize(155),
                                              text: "Google",
                                              variant:
                                                  ButtonVariant.OutlineIndigo50,
                                              padding: ButtonPadding.PaddingT14,
                                              fontStyle: ButtonFontStyle
                                                  .HelveticaNowTextBold16Gray900,
                                              prefixWidget: Container(
                                                  margin: getMargin(right: 15),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgGoogle))),
                                          CustomButton(
                                              onTap: ref
                                                  .read(authStateProvider
                                                      .notifier)
                                                  .loginWithFacebook,
                                              height: getVerticalSize(56),
                                              width: getHorizontalSize(155),
                                              text: "Facebook",
                                              margin: getMargin(left: 16),
                                              variant:
                                                  ButtonVariant.OutlineIndigo50,
                                              padding: ButtonPadding.PaddingT14,
                                              fontStyle: ButtonFontStyle
                                                  .HelveticaNowTextBold16Gray900,
                                              prefixWidget: Container(
                                                  margin: getMargin(right: 15),
                                                  child: CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgFacebook,
                                                  )))
                                        ])),
                                Padding(
                                    padding: getPadding(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "Don’t have an account? ",
                                                  style: TextStyle(
                                                      color: ColorConstant
                                                          .blueGray500,
                                                      fontSize: getFontSize(14),
                                                      fontFamily: 'Manrope',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.3))),
                                              // TextSpan(
                                              //     text: "Sign Up",
                                              //     style: TextStyle(
                                              //         color: ColorConstant
                                              //             .blueA700,
                                              //         fontSize: getFontSize(14),
                                              //         fontFamily:
                                              //             'Helvetica Now Text ',
                                              //         fontWeight:
                                              //             FontWeight.w700,
                                              //         letterSpacing:
                                              //             getHorizontalSize(
                                              //                 0.3)))
                                            ]),
                                            textAlign: TextAlign.left),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                '/sign_up_email_screen');
                                          },
                                          child: Text(
                                            "Sign Up",
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16Blue,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ))
                              ])),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              padding: getPadding(
                                  left: 143, top: 40, right: 143, bottom: 123),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage(ImageConstant.Topographic),
                                      fit: BoxFit.none)),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                        imagePath: ImageConstant.imgGroup182982,
                                        height: getSize(87),
                                        width: getSize(87),
                                        margin: getMargin(top: 52))
                                  ])))
                    ])))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
