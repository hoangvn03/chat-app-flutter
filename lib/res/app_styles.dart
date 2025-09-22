import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const String inter = 'Inter';
  static const String regular = 'regular';
  static const String roboto = 'Roboto';

  static const TextStyle textCommon = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.67,
    letterSpacing: 0,
    color: AppColors.black,
  );
}
