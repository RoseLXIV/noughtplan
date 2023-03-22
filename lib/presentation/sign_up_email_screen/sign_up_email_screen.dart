import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/auth/controller/authentication_controller.dart';
import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/auth/providers/is_logged_in_provider.dart';
import 'package:noughtplan/core/auth/providers/password_visibility_provider.dart';
import 'package:noughtplan/core/auth/signup/controller/signup_controller.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
import 'package:noughtplan/presentation/generator_salary_screen/generator_salary_screen.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_button_form.dart'
    hide ButtonVariant, ButtonPadding, ButtonFontStyle;
import 'package:noughtplan/widgets/custom_checkbox.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class SignUpEmailScreen extends ConsumerWidget {
  final inputFullnameController = TextEditingController();

  final inputEmailController = TextEditingController();

  final inputPasswordController = TextEditingController();

  final fullNameFocusNode = FocusNode();

  final emailFocusNode = FocusNode();

  final passwordFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final showErrorName = signUpState.name.error;
    final showErrorEmail = signUpState.email.error;
    final showErrorPassword = signUpState.password.error;
    final signUpController = ref.read(signUpProvider.notifier);
    final passwordVisibility = ref.watch(passwordVisibilityProvider);
    final bool isValidated = signUpState.status.isValidated;
    final authenticationState = ref.watch(authProvider);
    if (isLoggedIn) {
      return GeneratorSalaryScreen();
    } else if (authenticationState.status ==
        AuthenticationStatus.authenticated) {
      return GeneratorSalaryScreen();
    }
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Form(
                key: _formKey,
                child: Container(
                    width: double.maxFinite,
                    height: size.height,
                    padding:
                        getPadding(left: 24, top: 24, right: 24, bottom: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomImageView(
                              svgPath: ImageConstant.imgCloseGray900,
                              height: getSize(24),
                              width: getSize(24),
                              onTap: () {
                                onTapImgClose(context);
                              }),
                          Padding(
                              padding: getPadding(top: 42),
                              child: Text("Create your account",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtHelveticaNowTextBold24)),
                          Padding(
                              padding: getPadding(top: 8),
                              child: Text(
                                  "Let’s get started with a free Nought Plan account.",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeRegular14.copyWith(
                                      letterSpacing: getHorizontalSize(0.3)))),
                          CustomTextFormField(
                            focusNode: fullNameFocusNode,
                            controller: inputFullnameController,
                            hintText: "Full Name",
                            errorText: signUpState.name.error != null &&
                                    fullNameFocusNode.hasFocus
                                ? Text(
                                    Name.showNameErrorMessage(showErrorName)
                                        .toString(),
                                  )
                                : null,
                            margin: getMargin(top: 24),
                            onChanged: (name) =>
                                signUpController.onNameChange(name),
                          ),
                          CustomTextFormField(
                            focusNode: emailFocusNode,
                            controller: inputEmailController,
                            hintText: "Email",
                            errorText: signUpState.email.error != null &&
                                    emailFocusNode.hasFocus
                                ? Text(
                                    Email.showEmailErrorMessage(showErrorEmail)
                                        .toString(),
                                  )
                                : null,
                            margin: getMargin(top: 20),
                            textInputType: TextInputType.emailAddress,
                            onChanged: (email) =>
                                signUpController.onEmailChange(email),
                          ),
                          CustomTextFormField(
                            focusNode: passwordFocusNode,
                            controller: inputPasswordController,
                            hintText: "Password",
                            errorText: signUpState.password.error != null &&
                                    passwordFocusNode.hasFocus
                                ? Text(
                                    Password.showPasswordErrorMessage(
                                            showErrorPassword)
                                        .toString(),
                                  )
                                : null,
                            margin: getMargin(top: 20),
                            padding: TextFormFieldPadding.PaddingT16,
                            onChanged: (password) =>
                                signUpController.onPasswordChange(password),
                            // textInputAction: TextInputAction.done,
                            // textInputType: TextInputType.visiblePassword,
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
                                      .read(passwordVisibilityProvider.notifier)
                                      .state = newValue;
                                }),
                            suffixConstraints:
                                BoxConstraints(maxHeight: getVerticalSize(56)),
                            isObscureText:
                                passwordVisibility == PasswordVisibility.hidden,
                          ),
                          Padding(
                              padding: getPadding(top: 20, right: 18),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomCheckbox(
                                      iconSize: getSize(24),
                                      value:
                                          signUpState.termsAndCondition.value,
                                      // fontStyle: CheckboxFontStyle
                                      //     .HelveticaNowTextMedium14,
                                      onChange: (value) => signUpController
                                          .onTermsAndConditionChange(value),
                                    ),
                                    // CustomImageView(
                                    //     svgPath: ImageConstant.imgVideocamera,
                                    //     height: getSize(24),
                                    //     width: getSize(24),
                                    //     margin: getMargin(bottom: 0)),
                                    Expanded(
                                        child: Container(
                                            width: getHorizontalSize(276),
                                            margin: getMargin(left: 8, top: 2),
                                            child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "I agree to the ",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .gray900,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily: 'Manrope',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))),
                                                  TextSpan(
                                                      text: "User Agreement",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .blueA700,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily:
                                                              'Helvetica Now Text ',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))),
                                                  TextSpan(
                                                      text: " and ",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .gray900,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily: 'Manrope',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2))),
                                                  TextSpan(
                                                      text: "Privacy Policy.",
                                                      style: TextStyle(
                                                          color: ColorConstant
                                                              .blueA700,
                                                          fontSize:
                                                              getFontSize(12),
                                                          fontFamily:
                                                              'Helvetica Now Text ',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing:
                                                              getHorizontalSize(
                                                                  0.2)))
                                                ]),
                                                textAlign: TextAlign.left)))
                                  ])),
                          CustomButtonForm(
                            onTap: isValidated
                                ? () async {
                                    await signUpController
                                        .signUpWithEmailAndPassword();
                                    final authState =
                                        ref.watch(authStateProvider);
                                    FocusScope.of(context).unfocus();
                                    if (authState.result ==
                                        AuthResult.failure) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Sign Up Failed',
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16WhiteA700
                                                .copyWith(
                                              letterSpacing:
                                                  getHorizontalSize(0.3),
                                            ),
                                          ),
                                          backgroundColor:
                                              ColorConstant.redA700,
                                        ),
                                      );
                                    } else if (authState.result ==
                                        AuthResult.success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Sign Up Successful!',
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold16WhiteA700
                                                .copyWith(
                                              letterSpacing:
                                                  getHorizontalSize(0.3),
                                            ),
                                          ),
                                          backgroundColor:
                                              ColorConstant.greenA70001,
                                        ),
                                      );
                                    }
                                    print('Auth State: ${authState.result}');
                                  }
                                : null,
                            height: getVerticalSize(56),
                            text: "Sign Up",
                            margin: getMargin(top: 24, bottom: 5),
                            enabled: isValidated,
                          ),

                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: getPadding(top: 19),
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
                                                width: getHorizontalSize(42),
                                                child: Divider(
                                                    color: ColorConstant
                                                        .indigo50))),
                                        Padding(
                                            padding: getPadding(left: 6),
                                            child: Text("Or sign up with  ",
                                                overflow: TextOverflow.ellipsis,
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
                                                width: getHorizontalSize(42),
                                                child: Divider(
                                                    color: ColorConstant
                                                        .indigo50)))
                                      ]))),
                          Padding(
                              padding: getPadding(top: 23),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        onTap: () async {
                                          await ref
                                              .read(authStateProvider.notifier)
                                              .loginWithGoogle();
                                          final authState =
                                              ref.watch(authStateProvider);
                                          if (authState.result ==
                                              AuthResult.failure) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Invalid Email or Password!',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16WhiteA700
                                                      .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(0.3),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColorConstant.redA700,
                                              ),
                                            );
                                          } else if (authState.result ==
                                              AuthResult.success) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Sign In Successful!',
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle
                                                      .txtHelveticaNowTextBold16WhiteA700
                                                      .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(0.3),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColorConstant.greenA70001,
                                              ),
                                            );
                                          }
                                          print(
                                              'Auth State: ${authState.result}');
                                        },
                                        height: getVerticalSize(56),
                                        text: "Google",
                                        margin: getMargin(right: 8),
                                        variant: ButtonVariant.OutlineIndigo50,
                                        padding: ButtonPadding.PaddingT14,
                                        fontStyle: ButtonFontStyle
                                            .HelveticaNowTextBold16Gray900,
                                        prefixWidget: Container(
                                          margin: getMargin(right: 15),
                                          child: CustomImageView(
                                            svgPath: ImageConstant.imgGoogle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: CustomButton(
                                            onTap: () async {
                                              await ref
                                                  .read(authStateProvider
                                                      .notifier)
                                                  .loginWithFacebook();
                                              final authState =
                                                  ref.watch(authStateProvider);
                                              if (authState.result ==
                                                  AuthResult.aborted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Sign In Aborted!',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold16WhiteA700
                                                          .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.3),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        ColorConstant.amberA200,
                                                  ),
                                                );
                                              } else if (authState.result ==
                                                  AuthResult.success) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Sign In Successful!',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyle
                                                          .txtHelveticaNowTextBold16WhiteA700
                                                          .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.3),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        ColorConstant
                                                            .greenA70001,
                                                  ),
                                                );
                                              }
                                              print(
                                                  'Auth State: ${authState.result}');
                                            },
                                            height: getVerticalSize(56),
                                            text: "Facebook",
                                            margin: getMargin(left: 8),
                                            variant:
                                                ButtonVariant.OutlineIndigo50,
                                            padding: ButtonPadding.PaddingT14,
                                            fontStyle: ButtonFontStyle
                                                .HelveticaNowTextBold16Gray900,
                                            prefixWidget: Container(
                                                margin: getMargin(right: 15),
                                                child: CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgFacebook))))
                                  ])),
                          // Align(
                          //     alignment: Alignment.center,
                          //     child: Padding(
                          //         padding: getPadding(top: 73, bottom: 5),
                          //         child: RichText(
                          //             text: TextSpan(children: [
                          //               TextSpan(
                          //                   text: "Already h",
                          //                   style: TextStyle(
                          //                       color:
                          //                           ColorConstant.blueGray500,
                          //                       fontSize: getFontSize(14),
                          //                       fontFamily: 'Manrope',
                          //                       fontWeight: FontWeight.w400,
                          //                       letterSpacing:
                          //                           getHorizontalSize(0.3))),
                          //               TextSpan(
                          //                   text: "ave an account? ",
                          //                   style: TextStyle(
                          //                       color:
                          //                           ColorConstant.blueGray500,
                          //                       fontSize: getFontSize(14),
                          //                       fontFamily: 'Manrope',
                          //                       fontWeight: FontWeight.w400,
                          //                       letterSpacing:
                          //                           getHorizontalSize(0.3))),
                          //               // TextSpan(
                          //               //     text: "Sign In",
                          //               //     style: TextStyle(
                          //               //         color: ColorConstant.blueA700,
                          //               //         fontSize: getFontSize(14),
                          //               //         fontFamily:
                          //               //             'Helvetica Now Text ',
                          //               //         fontWeight: FontWeight.w700,
                          //               //         letterSpacing:
                          //               //             getHorizontalSize(0.3)))
                          //             ]),
                          //             textAlign: TextAlign.left)))
                        ])))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
