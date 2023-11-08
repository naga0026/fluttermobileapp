import 'package:base_project/controller/home/transfers/transfers_controller.dart';
import 'package:base_project/services/navigation/navigation_service.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/ui_controls/sbo_text_field.dart';
import 'package:base_project/utility/constants/images_and_icons/icon_constants.dart';
import 'package:base_project/utility/enums/transfers_enum.dart';
import 'package:base_project/utility/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/sbo_field_model.dart';
import '../../../ui_controls/enter_clear_option.dart';

class ReceivingView extends StatelessWidget {
  const ReceivingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransfersController>();
    var transferType = controller.selectedTransferType.value;
    if (transferType == TransferType.receivingStoreToStore) {
      controller.clearStoreToStoreReceivingFields();
      return Column(
        children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              children: controller.storeToStoreReceivingFields
                  .mapWithNextField<Widget, SBOFieldModel>((field, nextField) {
                return SBOInputField(
                  onChange: (value){
                    switch(field.sboField){
                      case SBOField.controlNumber:
                        controller.receivedItemData.controlNumber = value ?? '';
                      case SBOField.storeNumber:
                        controller.receivedItemData.receivingStoreNumber = value ?? '';
                      case SBOField.itemCount:
                        controller.receivedItemData.itemCount = value ?? '';
                      default:
                        break;
                    }
                  },
                  sboFieldModel: field,
                  nextFocusNode: nextField?.focusNode,
                );
              }).toList()),
          EnterAndClearButtons(
            onClickClear: () => controller.clearStoreToStoreReceivingFields(),
            onClickEnter: () async {
              controller.onClickEnter();
            },
          )
        ],
      );
    } else {
      // Else condition
      return const SizedBox();
    }
  }
}
