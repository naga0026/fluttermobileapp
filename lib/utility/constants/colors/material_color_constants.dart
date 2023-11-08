import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:flutter/material.dart';

// While defining a theme we need to put a material color instead of a Color
// We can define material colors here and then use it whenever needed

class MaterialColorConstants {
  static MaterialColor primarySwatch = MaterialColor(
    0xff880202,
    <int, Color>{
      50: ColorConstants.primaryRedColor.withOpacity(0.1),
      100: ColorConstants.primaryRedColor.withOpacity(0.2),
      200: ColorConstants.primaryRedColor.withOpacity(0.3),
      300: ColorConstants.primaryRedColor.withOpacity(0.4),
      400: ColorConstants.primaryRedColor.withOpacity(0.5),
      500: ColorConstants.primaryRedColor,
      600: ColorConstants.primaryRedColor.withOpacity(0.6),
      700: ColorConstants.primaryRedColor.withOpacity(0.7),
      800: ColorConstants.primaryRedColor.withOpacity(0.8),
      900: ColorConstants.primaryRedColor.withOpacity(0.9),
    },
  );
}
