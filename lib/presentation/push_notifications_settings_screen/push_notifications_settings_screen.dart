import '../push_notifications_settings_screen/widgets/listtrash_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/widgets/app_bar/appbar_image.dart';
import 'package:noughtplan/widgets/app_bar/appbar_title.dart';
import 'package:noughtplan/widgets/app_bar/custom_app_bar.dart';

class PushNotificationsSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
                height: getVerticalSize(56),
                leadingWidth: 48,
                leading: CustomImageView(
                    height: getSize(24),
                    width: getSize(24),
                    svgPath: ImageConstant.imgArrowleft,
                    margin: getMargin(left: 24, top: 15, bottom: 16),
                    onTap: () => onTapArrowleft6(context)),
                centerTitle: true,
                title: AppbarTitle(text: "Notification")),
            body: Padding(
                padding: getPadding(left: 24, top: 23, right: 24),
                child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: getVerticalSize(16));
                    },
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return ListtrashItemWidget();
                    }))));
  }

  onTapArrowleft6(BuildContext context) {
    Navigator.pop(context);
  }
}
