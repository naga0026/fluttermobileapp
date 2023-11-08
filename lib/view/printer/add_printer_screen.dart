import 'package:base_project/controller/printer/add_printer_view_controller.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/ui_controls/sbo_button.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/view/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddPrinterScreen extends BaseScreen {
  const AddPrinterScreen({Key? key}) : super(key: key);

  @override
  AddPrinterScreenState createState() => AddPrinterScreenState();
}

class AddPrinterScreenState extends BaseScreenState<AddPrinterScreen> {
  final _addPrinterController = Get.find<AddPrinterViewController>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode firstFocusNode = FocusNode();

  @override
  bool get showBackButton => true;

  @override
  bool get isScanningEnabled => true;

  @override
  void onDispose() {
    _addPrinterController.subscription.cancel();
    super.onDispose();
  }

  @override
  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TranslationKey.scanOrEnterTitle.tr.toUpperCase(),
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        30.heightBox,
        Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child:
                      _ipTextFormSnippet(_addPrinterController.ipAddress1, 1)),
              Expanded(
                  child:
                      _ipTextFormSnippet(_addPrinterController.ipAddress2, 2)),
              Expanded(
                  child:
                      _ipTextFormSnippet(_addPrinterController.ipAddress3, 3)),
              Expanded(
                  child:
                      _ipTextFormSnippet(_addPrinterController.ipAddress4, 4)),
            ],
          ),
        ),
        60.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: SBOButton(
                    title: TranslationKey.ok.tr.toUpperCase(),
                    onPressed: () => _addPrinterController.onClickOk())),
            20.widthBox,
            Expanded(
                child: SBOButton(
                    title: TranslationKey.clear.tr.toUpperCase(),
                    onPressed: ()=> _addPrinterController.onClickClear()))
          ],
        ).paddingSymmetric(horizontal: 20)
      ],
    );
  }

  Widget _ipTextFormSnippet(TextEditingController controller, int fieldNumber) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(3)],
        validator: (val) {
          if (val!.isEmpty ||
              val.length < 3 ||
              !RegExp(r'^[0-9]*$').hasMatch(val)) {
            return " ";
          }
          return null;
        },
        controller: controller,
        focusNode: fieldNumber == 1 ? firstFocusNode : null,
        onChanged: (val) {
          if (val.length >= 3 && (fieldNumber != 4)) {
            FocusScope.of(context).nextFocus();
          } else if (val.isEmpty && (fieldNumber != 1)) {
            FocusScope.of(context).previousFocus();
          } else if (val.length == 3 && fieldNumber == 4) {
            FocusScope.of(context).unfocus();
          }
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
