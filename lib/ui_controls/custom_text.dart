import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../translations/translation_keys.dart';
import '../utility/constants/colors/color_constants.dart';

Widget scanOrEnter()=> Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      Icons.document_scanner_outlined,
      color: ColorConstants.primaryRedColor,
    ),
    Text(
      TranslationKey.scanOrEnterTitle.tr,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: ColorConstants.primaryRedColor),
    ),
  ],
);