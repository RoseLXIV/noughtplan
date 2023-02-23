import '../debt_stats_details_bottomsheet/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:noughtplan/core/app_export.dart';

class DebtStatsDetailsBottomsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: double.maxFinite,
            child: Container(
                width: double.maxFinite,
                padding: getPadding(top: 17, bottom: 17),
                decoration: AppDecoration.fillWhiteA700
                    .copyWith(borderRadius: BorderRadiusStyle.customBorderTL32),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: getVerticalSize(6),
                          width: getHorizontalSize(40),
                          decoration: BoxDecoration(
                              color: ColorConstant.indigo50,
                              borderRadius:
                                  BorderRadius.circular(getHorizontalSize(3)))),
                      Container(
                          width: double.maxFinite,
                          margin: getMargin(top: 16),
                          padding: getPadding(
                              left: 24, top: 1, right: 24, bottom: 1),
                          decoration: AppDecoration.outlineIndigo50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: getPadding(bottom: 15),
                                    child: Text("All Debt",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtHelveticaNowTextBold16
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.4)))),
                                CustomImageView(
                                    svgPath: ImageConstant.imgCloseBlueGray300,
                                    height: getSize(20),
                                    width: getSize(20),
                                    margin: getMargin(top: 1, bottom: 17),
                                    onTap: () {
                                      onTapImgClose(context);
                                    })
                              ])),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              height: getVerticalSize(173),
                              child: ListView.separated(
                                  padding: getPadding(left: 26, top: 37),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                        height: getVerticalSize(16));
                                  },
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
                                    return ListItemWidget();
                                  }))),
                      Padding(
                          padding: getPadding(
                              left: 26, top: 57, right: 14, bottom: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding:
                                              getPadding(top: 12, bottom: 12),
                                          decoration:
                                              AppDecoration.outlineIndigo50,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: getPadding(top: 1),
                                                    child: Text(
                                                        "Curr. Clear Date",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeRegular12
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2)))),
                                                Padding(
                                                    padding: getPadding(
                                                        left: 13, top: 1),
                                                    child: Text("Oct 2026",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeSemiBold12Gray900
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))))
                                              ])),
                                      Container(
                                          padding:
                                              getPadding(top: 12, bottom: 12),
                                          decoration:
                                              AppDecoration.outlineIndigo50,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: getPadding(top: 1),
                                                    child: Text("Interest Paid",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeRegular12
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2)))),
                                                Padding(
                                                    padding: getPadding(
                                                        left: 11, top: 1),
                                                    child: Text("\$302,298.23",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeSemiBold12Gray900
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.2))))
                                              ]))
                                    ]),
                                Padding(
                                    padding: getPadding(left: 20),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: getPadding(
                                                  top: 11, bottom: 11),
                                              decoration:
                                                  AppDecoration.outlineIndigo50,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            getPadding(top: 4),
                                                        child: Text(
                                                            "Proj. Clear Date",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeRegular12
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2)))),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 13,
                                                            top: 2,
                                                            bottom: 1),
                                                        child: Text("Mar 2026",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeSemiBold12Gray900
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2))))
                                                  ])),
                                          Container(
                                              padding: getPadding(
                                                  top: 11, bottom: 11),
                                              decoration:
                                                  AppDecoration.outlineIndigo50,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            getPadding(top: 4),
                                                        child: Text(
                                                            "Budget Percentage",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeRegular12
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2)))),
                                                    Padding(
                                                        padding: getPadding(
                                                            left: 10,
                                                            top: 2,
                                                            bottom: 1),
                                                        child: Text("25.7%",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeSemiBold12Gray900
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.2))))
                                                  ]))
                                        ]))
                              ]))
                    ]))));
  }

  onTapImgClose(BuildContext context) {
    Navigator.pop(context);
  }
}
