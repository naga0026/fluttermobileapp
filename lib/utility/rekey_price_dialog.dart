import 'package:base_project/model/api_response/markdowns/get_initial_markdown_response.dart';
import 'package:base_project/model/sbo_field_model.dart';
import 'package:base_project/ui_controls/sbo_text_field.dart';
import 'package:base_project/utility/constants/app/size_constants.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../translations/translation_keys.dart';
import 'constants/colors/color_constants.dart';

class ReKeyInputDialog {
  static Future<void> showInputDialog(
      {required MarkdownData markdownData,
      required Function(String) onReKeyPrice,
      bool isMarshallsUsa = false}) async {
    TextEditingController textEditingController = TextEditingController();
    bool isOkButtonEnabled = false;
    await Get.dialog(
        barrierDismissible: false,
        WillPopScope(onWillPop: () async {
          return false;
        }, child: StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(TranslationKey.verificationNeededTitle.tr),
            content: SizedBox(
              width: SizeConstants.kZebraWidth - 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleText(title: TranslationKey.deptTitle.tr),
                      TitleText(title: markdownData.departmentCode ?? '')
                    ],
                  ),
                  isMarshallsUsa
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(title: TranslationKey.uLineTitle.tr),
                            TitleText(title: markdownData.uline ?? '')
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(title: TranslationKey.styleTitle.tr),
                            TitleText(title: markdownData.style ?? '')
                          ],
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleText(title: TranslationKey.filePriceTitle.tr),
                      TitleText(
                          title: (markdownData.fromPrice ?? '')
                              .formattedPriceInStringWithCurrency)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleText(title: TranslationKey.priceTitle.tr),
                      SizedBox(
                        width: 75,
                        child: SBOInputField(
                          onChange: (price) {
                            setState(() {
                              if ((price ?? '0.0').formattedPrice > 1) {
                                isOkButtonEnabled = true;
                              } else {
                                isOkButtonEnabled = false;
                              }
                            });
                          },
                          sboFieldModel: SBOFieldModel(sboField: SBOField.price, textEditingController: textEditingController),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                      onPressed: isOkButtonEnabled ? () {
                        Get.back();
                        onReKeyPrice(
                            textEditingController.text.trim().priceWithoutDot);
                      } : null,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: isOkButtonEnabled ?
                          ColorConstants.primaryRedColor : ColorConstants.primaryRedColor.withOpacity(0.5)),
                      child: Text(
                        TranslationKey.ok.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
              ,
            ],
          );
        })));
  }
}

class TitleText extends StatelessWidget {
  const TitleText({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ));
  }
}
