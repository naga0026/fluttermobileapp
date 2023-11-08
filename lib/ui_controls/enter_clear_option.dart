import 'package:flutter/material.dart';
import 'package:base_project/ui_controls/sbo_button.dart';
import '../translations/translation_keys.dart';
import 'package:get/get.dart';

class EnterAndClearButtons extends StatelessWidget {
  const EnterAndClearButtons(
      {Key? key, required this.onClickClear, required this.onClickEnter})
      : super(key: key);
  final VoidCallback onClickClear;
  final VoidCallback onClickEnter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SBOButton(
            onPressed: () => onClickEnter(),
            title: TranslationKey.enterLabel.tr,
          ),
          SBOButton(
            onPressed: () => onClickClear(),
            title: TranslationKey.clear.tr,
          ),
        ],
      ),
    );
  }
}
