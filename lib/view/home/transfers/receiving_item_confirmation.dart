import 'package:base_project/translations/translation_keys.dart';
import 'package:flutter/material.dart';
import '../../../controller/barcode/scanned_item_model.dart';
import 'package:get/get.dart';
import '../../../model/sbo_field_model.dart';
import '../../../ui_controls/sbo_text_field.dart';

/// Contains a view with number of item in the box
/// with yes/no option to confirm
class ItemConfirmationView extends StatelessWidget {
  const ItemConfirmationView({Key? key, required this.receivedItem}) : super(key: key);
  final ScanOrEnteredTransferReceivingItem receivedItem;

  @override
  Widget build(BuildContext context) {
    String boxHasItem = '${TranslationKey.boxHasLabel.tr} ${int.parse(receivedItem.itemCount)} ${TranslationKey.itemsLabel.tr}';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Control# ${receivedItem.controlNumber}', style: const TextStyle(fontSize: 16),),
        Text(boxHasItem, style: const TextStyle(fontSize: 16),),
        Text(TranslationKey.isCorrectStoreNumberLabel.tr, style: const TextStyle(fontSize: 16),),
      ],
    );
  }
}

/// A view to enter new item count of the receiving box
/// if user enters no in the item confirmation screen
class ItemCountFieldView extends StatelessWidget {
  const ItemCountFieldView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SBOFieldModel itemCountField = SBOFieldModel(
        sboField: SBOField.itemCount,
        textEditingController: TextEditingController());
    return SBOInputField(
      sboFieldModel: itemCountField,
    ).paddingSymmetric(horizontal: 20, vertical: 10);
  }
}

