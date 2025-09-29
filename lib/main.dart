import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Utils/fade_transition_builder.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeTransitionBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      darkTheme: ThemeData.light(),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}