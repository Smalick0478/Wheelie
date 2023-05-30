import 'package:flutter/material.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wheelie',
      theme: ThemeData(
        primaryColor: ThemeColors.primaryColor,
        scaffoldBackgroundColor: ThemeColors.scaffoldBgColor,
      ),
      home: SplashScreenPage(),
    );
  }
}
