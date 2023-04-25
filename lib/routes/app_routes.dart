import 'package:flutter/material.dart';
import 'package:noughtplan/presentation/allocate_funds_screen_edit/allocate_funds_screen_edit.dart';
import 'package:noughtplan/presentation/category_discretionary_screen_edit/category_discretionary_screen_edit.dart';
import 'package:noughtplan/presentation/category_necessary_screen_edit/category_necessary_screen_edit.dart';
import 'package:noughtplan/presentation/generator_salary_screen_edit/generator_salary_screen_edit.dart';
import 'package:noughtplan/presentation/splash_screen/splash_screen.dart';
import 'package:noughtplan/presentation/get_started_screen/get_started_screen.dart';
import 'package:noughtplan/presentation/login_page_screen/login_page_screen.dart';
import 'package:noughtplan/presentation/sign_up_email_screen/sign_up_email_screen.dart';
import 'package:noughtplan/presentation/sign_up_phone_number_screen/sign_up_phone_number_screen.dart';
import 'package:noughtplan/presentation/forgot_password_screen/forgot_password_screen.dart';
import 'package:noughtplan/presentation/success_state_new_password_screen/success_state_new_password_screen.dart';
import 'package:noughtplan/presentation/enable_face_id_screen/enable_face_id_screen.dart';
import 'package:noughtplan/presentation/enable_fingerprint_screen/enable_fingerprint_screen.dart';
import 'package:noughtplan/presentation/generator_salary_screen/generator_salary_screen.dart';
import 'package:noughtplan/presentation/category_necessary_screen/category_necessary_screen.dart';
import 'package:noughtplan/presentation/category_discretionary_screen/category_discretionary_screen.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/allocate_funds_screen.dart';
import 'package:noughtplan/presentation/debt_page_screen/debt_page_screen.dart';
import 'package:noughtplan/presentation/cut_back_screen/cut_back_screen.dart';
import 'package:noughtplan/presentation/budget_screen/budget_screen.dart';
import 'package:noughtplan/presentation/budget_details_screen/budget_details_screen.dart';
import 'package:noughtplan/presentation/budget_skeleton_screen/budget_skeleton_screen.dart';
import 'package:noughtplan/presentation/debt_stats_1_screen/debt_stats_1_screen.dart';
import 'package:noughtplan/presentation/push_notifications_settings_screen/push_notifications_settings_screen.dart';
import 'package:noughtplan/presentation/about_app_screen/about_app_screen.dart';
import 'package:noughtplan/presentation/help_center_screen/help_center_screen.dart';
import 'package:noughtplan/presentation/privacy_and_policy_screen/privacy_and_policy_screen.dart';
import 'package:noughtplan/presentation/term_and_condition_screen/term_and_condition_screen.dart';
import 'package:noughtplan/presentation/my_account_screen/my_account_screen.dart';
import 'package:noughtplan/presentation/app_navigation_screen/app_navigation_screen.dart';
import 'package:noughtplan/presentation/home_page_screen/home_page_screen.dart';
import 'package:noughtplan/presentation/expense_tracking_screen/expense_tracking_screen.dart';
import 'package:noughtplan/presentation/main_budget_home_screen/main_budget_home_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';

  static const String getStartedScreen = '/get_started_screen';

  static const String loginPageScreen = '/login_page_screen';

  static const String signUpEmailScreen = '/sign_up_email_screen';

  static const String signUpPhoneNumberScreen = '/sign_up_phone_number_screen';

  static const String forgotPasswordScreen = '/forgot_password_screen';

  static const String successStateNewPasswordScreen =
      '/success_state_new_password_screen';

  static const String enableFaceIdScreen = '/enable_face_id_screen';

  static const String enableFingerprintScreen = '/enable_fingerprint_screen';

  static const String generatorSalaryScreen = '/generator_salary_screen';

  static const String generatorSalaryScreenEdit =
      '/generator_salary_screen_edit';

  static const String categoryNecessaryScreen = '/category_necessary_screen';

  static const String categoryNecessaryScreenEdit =
      '/category_necessary_screen_edit';

  static const String categoryDiscretionaryScreen =
      '/category_discretionary_screen';

  static const String categoryDiscretionaryScreenEdit =
      '/category_discretionary_screen_edit';

  static const String allocateFundsScreen = '/allocate_funds_screen';

  static const String allocateFundsScreenEdit = '/allocate_funds_screen_edit';

  static const String debtPageScreen = '/debt_page_screen';

  static const String cutBackScreen = '/cut_back_screen';

  static const String budgetScreen = '/budget_screen';

  static const String budgetDetailsScreen = '/budget_details_screen';

  static const String budgetSkeletonScreen = '/budget_skeleton_screen';

  static const String debtStatisticsPage = '/debt_statistics_page';

  static const String debtStats1Screen = '/debt_stats_1_screen';

  static const String pyfSavingsPage = '/pyf_savings_page';

  static const String goalSavingsPage = '/goal_savings_page';

  static const String goalSaving1Screen = '/goal_saving_1_screen';

  static const String pushNotificationsSettingsScreen =
      '/push_notifications_settings_screen';

  static const String aboutAppScreen = '/about_app_screen';

  static const String helpCenterScreen = '/help_center_screen';

  static const String privacyAndPolicyScreen = '/privacy_and_policy_screen';

  static const String termAndConditionScreen = '/term_and_condition_screen';

  static const String myAccountScreen = '/my_account_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String homePageScreen = '/home_page_screen';

  static const String expenseTrackingScreen = '/expense_tracking_screen';

  static const String mainBudgetHomeScreen = '/main_budget_home_screen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    getStartedScreen: (context) => GetStartedScreen(),
    loginPageScreen: (context) => LoginPageScreen(),
    signUpEmailScreen: (context) => SignUpEmailScreen(),
    signUpPhoneNumberScreen: (context) => SignUpPhoneNumberScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    successStateNewPasswordScreen: (context) => SuccessStateNewPasswordScreen(),
    enableFaceIdScreen: (context) => EnableFaceIdScreen(),
    enableFingerprintScreen: (context) => EnableFingerprintScreen(),
    generatorSalaryScreen: (context) => GeneratorSalaryScreen(),
    generatorSalaryScreenEdit: (context) => GeneratorSalaryScreenEdit(),
    categoryNecessaryScreen: (context) => CategoryNecessaryScreen(),
    categoryNecessaryScreenEdit: (context) => CategoryNecessaryScreenEdit(),
    categoryDiscretionaryScreen: (context) => CategoryDiscretionaryScreen(),
    categoryDiscretionaryScreenEdit: (context) =>
        CategoryDiscretionaryScreenEdit(),
    allocateFundsScreen: (context) => AllocateFundsScreen(),
    allocateFundsScreenEdit: (context) => AllocateFundsScreenEdit(),
    debtPageScreen: (context) => DebtPageScreen(),
    cutBackScreen: (context) => CutBackScreen(),
    budgetScreen: (context) => BudgetScreen(),
    budgetDetailsScreen: (context) => BudgetDetailsScreen(),
    budgetSkeletonScreen: (context) => BudgetSkeletonScreen(),
    debtStats1Screen: (context) => DebtStats1Screen(),
    pushNotificationsSettingsScreen: (context) =>
        PushNotificationsSettingsScreen(),
    aboutAppScreen: (context) => AboutAppScreen(),
    helpCenterScreen: (context) => HelpCenterScreen(),
    privacyAndPolicyScreen: (context) => PrivacyAndPolicyScreen(),
    termAndConditionScreen: (context) => TermAndConditionScreen(),
    myAccountScreen: (context) => MyAccountScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    homePageScreen: (context) => HomePageScreen(),
    expenseTrackingScreen: (context) => ExpenseTrackingScreen(),
    mainBudgetHomeScreen: (context) => MainBudgetHomeScreen(),
  };
}
