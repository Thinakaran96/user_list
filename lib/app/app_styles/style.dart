import 'package:assesment1/app/app_styles/app_color.dart';
import 'package:flutter/material.dart';

class Style {
  static const _font = 'SF-Pro';

  static const TextStyle nameTextStyle = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    letterSpacing: -0.43,
    color: AppColor.primaryLightColor,
  );
  static const TextStyle emailStyle = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    letterSpacing: -0.31,
    color: AppColor.textColor
  );
}
