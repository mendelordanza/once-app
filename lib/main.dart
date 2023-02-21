import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/helper/colors.dart';
import 'package:once/helper/route.dart';

import 'firebase_options.dart';
import 'helper/route_strings.dart';
import 'helper/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs.init();

  runApp(ProviderScope(child: OnceApp()));
}

class OnceApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Once',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(
          color: CustomColors.darkColor,
        ),
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: CustomColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: CustomColors.darkColor,
          ),
          foregroundColor: CustomColors.darkColor,
          titleTextStyle: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: CustomColors.darkColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RouteStrings.landing,
    );
  }
}
