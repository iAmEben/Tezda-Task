import 'package:flutter/material.dart';

import 'package:tezda_task/values/sizes.dart';
import 'package:tezda_task/values/strings.dart';

import 'colors.dart';

class Styles {
  static final TextStyle normalTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontFamily: StringConst.FONT_FAMILY,
    fontWeight: FontWeight.w400,
    fontSize: Sizes.TEXT_SIZE_16,
  );

  static TextStyle customTitleTextStyle({
    Color color = AppColors.secondaryText,
    String fontFamily = StringConst.FONT_FAMILY,
    FontWeight fontWeight = FontWeight.w700,
    double fontSize = Sizes.TEXT_SIZE_40,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
    );
  }
}
