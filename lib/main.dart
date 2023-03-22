import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noughtplan/core/auth/providers/is_logged_in_provider.dart';
import 'package:noughtplan/core/providers/is_loading_provider.dart';
import 'package:noughtplan/presentation/allocate_funds_screen/allocate_funds_screen.dart';
import 'package:noughtplan/presentation/category_necessary_screen/category_necessary_screen.dart';
import 'package:noughtplan/presentation/generator_salary_screen/generator_salary_screen.dart';
import 'package:noughtplan/presentation/get_started_screen/get_started_screen.dart';
import 'package:noughtplan/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noughtplan/views/components/constants/loading/loading_screen.dart';
import 'firebase_options.dart';
import 'presentation/category_discretionary_screen/category_discretionary_screen.dart';
import 'presentation/home_page_screen/home_page_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.standard,
      ),
      title: 'noughtplan',
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          final authIsLoading = ref.watch(isLoadingProvider);
          final budgetIsLoading = ref.watch(budgetIsLoadingProvider);
          final isLoading = authIsLoading || budgetIsLoading;
          ref.listen<bool>(
            isLoadingProvider,
            (_, authIsLoading) {
              if (authIsLoading || budgetIsLoading) {
                LoadingScreen.instance().show(context: context);
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );

          ref.listen<bool>(
            budgetIsLoadingProvider,
            (_, budgetIsLoading) {
              if (authIsLoading || budgetIsLoading) {
                LoadingScreen.instance().show(context: context);
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            isLoggedIn.log();
            return AllocateFundsScreen();
            // HomePageScreen();
          } else {
            isLoggedIn.log();
            return GetStartedScreen();
          }
        },
      ),
      // initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
    );
  }
}
