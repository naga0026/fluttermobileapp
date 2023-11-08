import 'package:base_project/utility/enums/sign_buttons.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/home/ticket_maker/sign/signs_controller.dart';
import '../../../../controller/store_config/store_config_controller.dart';
import '../../../../model/sbo_field_model.dart';
import '../../../../translations/translation_keys.dart';
import '../../../../ui_controls/custom_text.dart';
import '../../../../ui_controls/sbo_button.dart';
import '../../../../ui_controls/sbo_text_field.dart';
import '../../../base/base_screen.dart';
import '../../../base/widgets/app_bar.dart';

class SignScreen extends BaseScreen {
  const SignScreen({super.key});

  @override
  SignScreenState createState() => SignScreenState();
}

class SignScreenState extends BaseScreenState<SignScreen> {
  final GlobalKey<FormState> _validateSignData = GlobalKey<FormState>();
  final signsController = Get.find<SignsController>();
  final storeConfigController = Get.find<StoreConfigController>();

  @override
  void onInitState() {
    super.onInitState();
    signsController.onClickClear();
    signsController.initialize();
  }

  @override
  void onDispose() {
    signsController.signControllerFields
        .map((e) => e.textEditingController.dispose());
    signsController.subscription.cancel();
    super.onDispose();
  }

  @override
  bool get showCustomAppBar => true;

  @override
  customAppBar() => customizedAppBar(Get.arguments[0] ?? '');

  @override
  bool get showAppBar => false;
  @override
  Widget body() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Form(
          key: _validateSignData,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                15.heightBox,
                scanOrEnter(),
                15.heightBox,
                ...signsController.signControllerFields.map((textFieldObj) {
                  return textFieldObj.sboField != SBOField.uline
                      ? SBOInputField(
                          key: UniqueKey(),
                          sboFieldModel: textFieldObj,
                        )
                      : const SizedBox.shrink();
                }),
                Obx(
                  ()=>Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SBOButtonCustom(
                          title: TranslationKey.enterLabel.tr,
                          onPressed: () {
                            if (_validateSignData.currentState!.validate()) {
                              signsController.onClickEnter(Get.arguments[0]
                                  .toString()
                                  .getSignTypeFromString);
                            }
                          },
                          isEnabled: false,
                          width_: 85,
                          isAppbar: false,
                          isLoading: signsController.isLoading),
                      SBOButtonCustom(
                        title: TranslationKey.clearLabel.tr,
                        onPressed: () {
                          signsController.onClickClear();
                        },
                        isEnabled: false,
                        width_: 85,
                        isAppbar: false,
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
