import 'package:flutter/material.dart';

class AppColors {
  static const backgroundColor = Color(0xFF252525);
  static const primaryColor = Color(0XFFFF0336);
  static const secondaryColor = Color(0xFF050505);
  static const textColor = Color(0xFFFFFFFF);
  static const disabledTextColor = Color(0x6BF9FAFE);
}

class AppTextStyles {
  static const headerStyle = TextStyle(
    color: AppColors.textColor,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );

  static const subHeaderStyle = TextStyle(
    color: AppColors.textColor,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );

  static const bodyStyle = TextStyle(
    color: AppColors.textColor,
    fontSize: 13,
    fontWeight: FontWeight.w300,
    fontFamily: 'Inter',
  );
}