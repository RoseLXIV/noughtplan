import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/core/budget/providers/budget_state_provider.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';
import 'package:noughtplan/widgets/custom_button.dart';
import 'package:noughtplan/widgets/custom_icon_button.dart';
import 'package:noughtplan/widgets/custom_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccountScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: Stack(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgTopographic5,
              height: getVerticalSize(300),
              width: getHorizontalSize(375),
            ),
            Padding(
              padding: getPadding(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomAppBar(
                      height: getVerticalSize(100),
                      leadingWidth: 25,
                      leading: CustomImageView(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        height: getSize(24),
                        width: getSize(24),
                        svgPath: ImageConstant.imgArrowleft,
                      ),
                      centerTitle: true,
                      title: AppbarTitle(text: "Settings Page"),
                      actions: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Welcome to The Nought Plan',
                                    textAlign: TextAlign.center,
                                    style: AppStyle.txtHelveticaNowTextBold16,
                                  ),
                                  content: Text(
                                    'To get started, please enter your monthly salary and select your preferred currency from the dropdown menu below. Our smart algorithms will take care of the rest, providing you with a personalized budget plan to help you save and manage your finances.',
                                    textAlign: TextAlign.center,
                                    style: AppStyle.txtManropeRegular14,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          // height: getSize(24),
                          //     width: getSize(24),
                          //     svgPath: ImageConstant.imgQuestion,
                          //     margin: getMargin(bottom: 1)
                          child: Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: SvgPicture.asset(
                              ImageConstant.imgQuestion,
                              height: 24,
                              width: 24,
                            ),
                          ),
                        )
                      ]),
                ],
              ),
            ),
            Container(
              padding: getPadding(top: 75),
              width: double.maxFinite,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: double.maxFinite,
                      alignment: Alignment.bottomCenter,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: getPadding(left: 29, right: 19),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Settings",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtHelveticaNowTextBold16
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.4))),
                              Container(
                                  margin: getMargin(top: 15),
                                  padding: getPadding(all: 16),
                                  decoration: AppDecoration.outlineIndigo504
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder12),
                                  child: Row(children: [
                                    CustomIconButton(
                                        height: 40,
                                        width: 40,
                                        variant: IconButtonVariant.FillGray50,
                                        child: CustomImageView(
                                            svgPath: ImageConstant
                                                .imgIconsaxlinearmoon)),
                                    Padding(
                                      padding: getPadding(
                                          left: 12, top: 11, bottom: 10),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Dark Mode",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtHelveticaNowTextBold12Gray900
                                                .copyWith(
                                              letterSpacing:
                                                  getHorizontalSize(0.2),
                                            ),
                                          ),
                                          Padding(
                                            padding: getPadding(top: 4),
                                            child: Text(
                                              "Coming Soon",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeRegular10Bluegray500
                                                  .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Switch(value: false, onChanged: (value) {})
                                  ])),
                              Container(
                                  margin: getMargin(top: 16),
                                  padding: getPadding(all: 16),
                                  decoration: AppDecoration.outlineIndigo504
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder12),
                                  child: Row(children: [
                                    CustomIconButton(
                                        height: 40,
                                        width: 40,
                                        variant: IconButtonVariant.FillGray50,
                                        child: CustomImageView(
                                            svgPath:
                                                ImageConstant.imgNotification)),
                                    Padding(
                                      padding: getPadding(left: 12, top: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Push Notifications",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtHelveticaNowTextBold12Gray900
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))),
                                          Padding(
                                            padding: getPadding(top: 4),
                                            child: Text(
                                              "Notification preferences - Coming Soon",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeRegular10Bluegray500
                                                  .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    CustomImageView(
                                        svgPath: ImageConstant.imgArrowright,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10))
                                  ])),
                              Padding(
                                  padding: getPadding(top: 32),
                                  child: Text("Others",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtHelveticaNowTextBold16
                                          .copyWith(
                                              letterSpacing:
                                                  getHorizontalSize(0.4)))),
                              InkWell(
                                onTap: () async {
                                  try {
                                    final Uri emailUri = Uri(
                                        scheme: 'mailto',
                                        path: 'admin@thenoughtplan.com',
                                        queryParameters: {
                                          'subject': 'Help Center'
                                        });
                                    await launchUrl(emailUri);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                  margin: getMargin(top: 16),
                                  padding: getPadding(all: 16),
                                  decoration: AppDecoration.outlineIndigo504
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder12),
                                  child: Row(
                                    children: [
                                      CustomIconButton(
                                          height: 40,
                                          width: 40,
                                          variant: IconButtonVariant.FillGray50,
                                          child: CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgQuestionBlueGray30040x40)),
                                      Padding(
                                        padding: getPadding(left: 12, top: 3),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Help Center - Coming Soon",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold12Gray900
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.2))),
                                            Padding(
                                              padding: getPadding(top: 3),
                                              child: Text(
                                                "Get support",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular10Bluegray500
                                                    .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      CustomImageView(
                                        svgPath: ImageConstant.imgArrowright,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      'https://sites.google.com/view/about-thenoughtplan/home');
                                  if (!await canLaunchUrl(url)) {
                                    throw 'Could not launch $url';
                                  }
                                  await _launchInBrowser(url);
                                },
                                child: Container(
                                  margin: getMargin(top: 16),
                                  padding: getPadding(all: 16),
                                  decoration: AppDecoration.outlineIndigo504
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder12),
                                  child: Row(
                                    children: [
                                      CustomIconButton(
                                          height: 40,
                                          width: 40,
                                          variant: IconButtonVariant.FillGray50,
                                          child: CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgQuestionBlueGray30040x40)),
                                      Padding(
                                          padding: getPadding(left: 12, top: 2),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("About",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold12Gray900
                                                        .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.2))),
                                                Padding(
                                                    padding: getPadding(top: 4),
                                                    child: Text(
                                                        "Learn more about TheNoughtPlan",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeRegular10Bluegray500
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))))
                                              ])),
                                      Spacer(),
                                      CustomImageView(
                                        svgPath: ImageConstant.imgArrowright,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(top: 10, bottom: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      'https://sites.google.com/view/terms-and-conditons-noughtplan/home');
                                  if (!await canLaunchUrl(url)) {
                                    throw 'Could not launch $url';
                                  }
                                  await _launchInBrowser(url);
                                },
                                child: Container(
                                  margin: getMargin(top: 16),
                                  padding: getPadding(all: 16),
                                  decoration: AppDecoration.outlineIndigo504
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder12),
                                  child: Row(
                                    children: [
                                      CustomIconButton(
                                          height: 40,
                                          width: 40,
                                          variant: IconButtonVariant.FillGray50,
                                          child: CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgIcon40x40)),
                                      Padding(
                                        padding: getPadding(
                                            left: 12, top: 2, bottom: 1),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Terms & Conditions",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtHelveticaNowTextBold12Gray900
                                                    .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: getPadding(top: 3),
                                              child: Text(
                                                "Our terms & conditions",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular10Bluegray500
                                                    .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      CustomImageView(
                                          svgPath: ImageConstant.imgArrowright,
                                          height: getSize(20),
                                          width: getSize(20),
                                          margin:
                                              getMargin(top: 10, bottom: 10))
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      'https://sites.google.com/view/privacy-policy-thenoughtplan/home');
                                  if (!await canLaunchUrl(url)) {
                                    throw 'Could not launch $url';
                                  }
                                  await _launchInBrowser(url);
                                },
                                child: Container(
                                  margin: getMargin(top: 16),
                                  padding: getPadding(all: 16),
                                  decoration: AppDecoration.outlineIndigo504
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder12),
                                  child: Row(
                                    children: [
                                      CustomIconButton(
                                          height: 40,
                                          width: 40,
                                          variant: IconButtonVariant.FillGray50,
                                          child: CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgLockBlueGray300)),
                                      Padding(
                                          padding: getPadding(
                                              left: 12, top: 1, bottom: 1),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("Privacy Policy",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtHelveticaNowTextBold12Gray9001
                                                        .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.2))),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                        padding:
                                                            getPadding(top: 2),
                                                        child: Text(
                                                            "Our privacy policy",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeRegular10Bluegray5001
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2)))))
                                              ])),
                                      Spacer(),
                                      CustomImageView(
                                          svgPath: ImageConstant.imgArrowright,
                                          height: getSize(20),
                                          width: getSize(20),
                                          margin:
                                              getMargin(top: 10, bottom: 10))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 16, right: 16),
                      child: CustomButton(
                          onTap: () async {
                            await ref.read(authStateProvider.notifier).logOut();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Logged out successfully!',
                                  textAlign: TextAlign.center,
                                  style: AppStyle
                                      .txtHelveticaNowTextBold16WhiteA700
                                      .copyWith(
                                    letterSpacing: getHorizontalSize(0.3),
                                  ),
                                ),
                                backgroundColor: ColorConstant.blue900,
                              ),
                            );
                          },
                          height: getVerticalSize(56),
                          text: "Log Out",
                          margin: getMargin(left: 24, right: 24),
                          variant: ButtonVariant.FillIndigo5001,
                          fontStyle:
                              ButtonFontStyle.HelveticaNowTextBold16BlueA700),
                    ),
                    Padding(
                      padding:
                          getPadding(top: 16, left: 16, right: 16, bottom: 16),
                      child: CustomButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  // use this to manage the state of the AlertDialog
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text('Delete Account',
                                          style: AppStyle
                                              .txtHelveticaNowTextBold16Gray900
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.3))),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Are you sure you want to delete your account? It's sad to see you go.",
                                            style: AppStyle.txtManropeRegular12
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(0.3)),
                                          ),
                                          SizedBox(height: 10),
                                          TextField(
                                            controller: deleteController,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Type 'DELETE' to confirm ",
                                                hintStyle: AppStyle
                                                    .txtManropeRegular14
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.3))),
                                            onChanged: (value) {
                                              setState(
                                                  () {}); // this will trigger a new build of the AlertDialog
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Confirm'),
                                          onPressed: deleteController.text ==
                                                  'DELETE'
                                              ? () async {
                                                  // Call deleteBudgetsWithNoNameAndUser
                                                  await ref
                                                      .read(budgetStateProvider
                                                          .notifier)
                                                      .deleteBudgetsWithNoNameAndUser();

                                                  // Log the user out
                                                  await ref
                                                      .read(authStateProvider
                                                          .notifier)
                                                      .logOut();

                                                  // Navigate back
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Account deleted successfully',
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
                                                          ColorConstant.blue900,
                                                    ),
                                                  );
                                                }
                                              : null,
                                        ),
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          height: getVerticalSize(56),
                          text: "Delete Account",
                          margin: getMargin(left: 24, right: 24),
                          variant: ButtonVariant.FillRedA700,
                          fontStyle: ButtonFontStyle.HelveticaNowTextBold16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTapArrowleft9(BuildContext context) {
    Navigator.pop(context);
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
