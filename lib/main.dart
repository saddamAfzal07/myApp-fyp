import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:myhoneypott/constant/app_colors.dart';
import 'package:myhoneypott/initial_setup_screen.dart';
import 'package:myhoneypott/screens/auth/login.dart';
import 'package:myhoneypott/screens/loading.dart';
import 'package:myhoneypott/screens/user_profile/user_profile_update.dart';
import 'package:myhoneypott/splash_screen.dart/splash_screen.dart';
import 'package:provider/provider.dart';

import 'controller/expense_controller.dart';
import 'controller/theme_changer.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeChanger(),
          ),
          ChangeNotifierProvider(
            create: (_) => ExpenseController(),
          ),
        ],
        child: Builder(
          builder: ((context) {
            final state = Provider.of<ThemeChanger>(context);
            return GetMaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('zh'),
                Locale('fr'),
                Locale('es'),
                Locale('de'),
                Locale('ru'),
                Locale('ja'),
                Locale('ar'),
                Locale('fa'),
                Locale("es"),
              ],
              debugShowCheckedModeBanner: false,
              themeMode: state.themeMode,
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: createMaterialColor(
                  AppColors.primaryColor,
                ),
              ),
              home:
                  // InitialSetupScreen(),
                  Splash(),
              darkTheme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: Brightness.dark,
              ),
            );
          }),
        ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
