import 'package:flutter/material.dart';
import 'dart:async';
import '../Constants/app_images.dart';
import 'menu_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainMenu()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          SvgPicture.asset(
            AppImages.background,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppImages.appLogo,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 100,
                ),
              ),
              Container(
                height: 100,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppImages.ticTacToeText,
                  fit: BoxFit.cover,
                  //width: double.infinity,
                  //height: double.infinity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}