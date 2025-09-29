// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  static Color primaryBlueColor = const Color(0xFF3338A0);
  static Color yellowColor = const Color(0xFFFED556);
  static Color darkYellowColor = const Color(0xFFFCC61D);
  static const LinearGradient buttonYellowGradientColor = LinearGradient(
    colors: [ Color(0xFFFED556), Color(0xFFFCC61D),],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.8, 1.0],
  );

}
