import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/app_images.dart';
import '../Theme/app_colors.dart';

class XWidget extends StatelessWidget {
  final bool isTapped;

  const XWidget({super.key, required this.isTapped});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isTapped ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.bounceOut,
      child: Container(
        height: 80,
        width: 80,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: AppColors.yellowColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(color: Colors.white, width: 2.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 0, // Shadow blur
              offset: Offset(0, 4), // Shadow offset
            ),
          ],
        ),
        child: SvgPicture.asset(
          AppImages.xIcon,
          fit: BoxFit.cover,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}

class OWidget extends StatelessWidget {
  final bool isTapped;

  const OWidget({super.key, required this.isTapped});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isTapped ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.bounceOut,
      child: Container(
        height: 80,
        width: 80,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(color: Colors.white, width: 2.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 0, // Shadow blur
              offset: Offset(0, 4), // Shadow offset
            ),
          ],
        ),
        child: SvgPicture.asset(
          AppImages.oIcon,
          fit: BoxFit.cover,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}