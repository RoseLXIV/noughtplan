import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noughtplan/core/auth/providers/auth_state_provider.dart';
import 'package:noughtplan/widgets/custom_text_form_field.dart';

import '../home_page_screen/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';

class HomePageScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
          height: getVerticalSize(100),
          leadingWidth: 48,
          leading: AppbarImage(
            height: getSize(24),
            width: getSize(24),
            svgPath: ImageConstant.imgArrowleft,
            margin: getMargin(left: 24, top: 15, bottom: 10, right: 0),
            onTap: () async {
              await ref.read(authStateProvider.notifier).logOut();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Logged out successfully!',
                    textAlign: TextAlign.center,
                    style: AppStyle.txtHelveticaNowTextBold16WhiteA700.copyWith(
                      letterSpacing: getHorizontalSize(0.3),
                    ),
                  ),
                  backgroundColor: ColorConstant.blue900,
                ),
              );
            },
          ),
          centerTitle: true,
          title: AppbarTitle(text: "Budget Profiles"),
          actions: [
            AppbarImage(
                height: getSize(24),
                width: getSize(24),
                svgPath: ImageConstant.imgPlus,
                margin: getMargin(left: 0, bottom: 2, right: 25),
                onTap: () {
                  Navigator.pushNamed(context, '/generator_salary_screen');
                }),
            AppbarImage(
              height: getSize(24),
              width: getSize(24),
              svgPath: ImageConstant.imgSettings,
              margin: getMargin(left: 0, bottom: 1, right: 25),
            )
          ],
        ),
        body: Container(
          width: double.maxFinite,
          padding: getPadding(left: 24, right: 24, bottom: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: getPadding(bottom: 35),
                child: CustomTextFormField(
                  hintText: 'Search...',
                  prefix: CustomImageView(
                    svgPath: ImageConstant.imgSearch,
                    margin: getMargin(bottom: 1, right: 12, left: 12),
                  ),
                  prefixConstraints: BoxConstraints(
                    maxHeight: getVerticalSize(56),
                  ),
                ),
              ),
              // Padding(
              //   padding: getPadding(top: 25, bottom: 14),
              //   child: Text(
              //     "All Budgets Profiles",
              //     overflow: TextOverflow.ellipsis,
              //     textAlign: TextAlign.left,
              //     style: AppStyle.txtHelveticaNowTextBold16.copyWith(
              //       letterSpacing: getHorizontalSize(0.4),
              //     ),
              //   ),
              // ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      padding: getPadding(top: 10, bottom: 25),
                      // scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: getVerticalSize(16));
                      },
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return ListItemWidget();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }
}
