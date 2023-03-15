import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/auth/models/auth_result.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_button_form.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';
import 'package:noughtplan/core/auth/forgot_password/controller/forgot_password_controller.dart';
import 'package:noughtplan/core/forms/form_validators.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ForgotPasswordScreen extends ConsumerWidget {
  TextEditingController inputEmailController = TextEditingController();

  final emailFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final forgotPasswordController = ref.read(forgotPasswordProvider.notifier);
    final showErrorEmail = forgotPasswordState.email.error;
    final status = forgotPasswordState.status;
    final bool isValidated = forgotPasswordState.status.isValidated;
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Form(
                key: _formKey,
                child: Container(
                    width: double.maxFinite,
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
                              padding: getPadding(top: 40),
                              child: Text("Create New Password",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtHelveticaNowTextBold24)),
                          Container(
                              width: getHorizontalSize(361),
                              margin: getMargin(top: 10, right: 20),
                              child: Text(
                                  "Please enter your email address and we'll send you a link to reset your password. If you don't receive an email within a few minutes, please check your spam folder.",
                                  maxLines: null,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeRegular14Bluegray500
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.3)))),
                          CustomTextFormField(
                            focusNode: emailFocusNode,
                            controller: inputEmailController,
                            hintText: "Email",
                            margin: getMargin(top: 17),
                            padding: TextFormFieldPadding.PaddingT16,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.visiblePassword,
                            errorText: forgotPasswordState.email.error !=
                                        null &&
                                    emailFocusNode.hasFocus
                                ? Text(
                                    Email.showEmailErrorMessage(showErrorEmail)
                                        .toString(),
                                  )
                                : null,
                            onChanged: (email) =>
                                forgotPasswordController.onEmailChange(email),
                          ),
                          CustomButtonForm(
                              onTap: status.isSubmissionInProgress ||
                                      status.isSubmissionSuccess
                                  ? null
                                  : () async {
                                      final result = await ref
                                          .read(forgotPasswordProvider.notifier)
                                          .forgotPassword();

                                      FocusScope.of(context).unfocus();

                                      final authState =
                                          ref.watch(authStateProvider);
                                      if (result ==
                                          ForgotPasswordResult.inProgress) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Submitting...',
                                              textAlign: TextAlign.center,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold16WhiteA700
                                                  .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.3),
                                              ),
                                            ),
                                            backgroundColor:
                                                ColorConstant.blueA700,
                                          ),
                                        );
                                      } else if (result ==
                                          ForgotPasswordResult.failure) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Submission failed, please try again later',
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
                                      } else if (result ==
                                          ForgotPasswordResult.success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Submission sent successfully!',
                                              textAlign: TextAlign.center,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold16WhiteA700
                                                  .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.3),
                                              ),
                                            ),
                                            backgroundColor:
                                                ColorConstant.greenA700,
                                          ),
                                        );
                                      }
                                      print('Form Status: ${status}');
                                    },
                              enabled: isValidated,
                              height: getVerticalSize(56),
                              text: "Reset Password",
                              margin: getMargin(top: 33, bottom: 5)),
                        ])))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
