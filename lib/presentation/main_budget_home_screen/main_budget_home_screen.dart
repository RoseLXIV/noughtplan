import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:noughtplan/core/app_export.dart';
import 'package:noughtplan/presentation/budget_screen/budget_screen.dart';
import 'package:noughtplan/presentation/expense_tracking_screen/expense_tracking_screen.dart';
import 'package:noughtplan/presentation/home_page_screen/home_page_screen.dart';

class MainBudgetHomeScreen extends StatefulWidget {
  @override
  _MainBudgetHomeScreenState createState() => _MainBudgetHomeScreenState();
}

class _MainBudgetHomeScreenState extends State<MainBudgetHomeScreen> {
  late PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  double _getTranslationValue() {
    switch (_currentIndex) {
      case 0:
        return -MediaQuery.of(context).size.width / 3;
      case 1:
        return 0;
      case 2:
        return MediaQuery.of(context).size.width / 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePageScreen(),
          BudgetScreen(),
          ExpenseTrackingScreen(),
        ],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: getPadding(
                    right: 25,
                  ),
                  icon: CustomImageView(
                    svgPath: ImageConstant.imgMessage,
                    color: _currentIndex == 0
                        ? ColorConstant.blueGray300
                        : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: CustomImageView(
                    svgPath: ImageConstant.imgClockWhiteA700,
                    color: _currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(1),
                ),
                // To leave space for the blue container
                IconButton(
                  padding: getPadding(
                    left: 25,
                  ),
                  icon: CustomImageView(
                    svgPath: ImageConstant.imgVolumeBlueGray300,
                    color: _currentIndex == 2
                        ? ColorConstant.blueGray300
                        : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10, // Adjust the value as needed
            left: 0,
            right: 0,
            child: Center(
              child: Transform.translate(
                offset: Offset(_getTranslationValue(), 0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 1,
                    intensity: 0.7,
                    surfaceIntensity: 0.9,
                    lightSource: LightSource.top,
                    color: ColorConstant.gray50,
                  ),
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: AppDecoration.fillBlueA700.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder12,
                    ),
                    child: _currentIndex == 0
                        ? IconButton(
                            icon: CustomImageView(
                              svgPath: ImageConstant.imgMessage,
                              color: Colors.white,
                            ),
                            onPressed: () => _onItemTapped(0),
                          )
                        : _currentIndex == 1
                            ? IconButton(
                                icon: CustomImageView(
                                  svgPath: ImageConstant.imgClockWhiteA700,
                                  color: Colors.white,
                                ),
                                onPressed: () => _onItemTapped(1),
                              )
                            : IconButton(
                                icon: CustomImageView(
                                  svgPath: ImageConstant.imgVolumeBlueGray300,
                                  color: Colors.white,
                                ),
                                onPressed: () => _onItemTapped(2),
                              ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
