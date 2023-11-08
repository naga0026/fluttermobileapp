import 'package:base_project/controller/home/sgm/sgm_view_controller.dart';
import 'package:base_project/ui_controls/sbo_button.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/utility/extensions/list_extension.dart';
import 'package:base_project/view/base/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/store_config/store_config_controller.dart';
import '../../../model/sbo_field_model.dart';
import '../../../ui_controls/custom_text.dart';
import '../../../ui_controls/sbo_text_field.dart';
import '../../base/base_screen.dart';

class SGMScreen extends BaseScreen {
  const SGMScreen({super.key});

  @override
  SGMState createState() => SGMState();
}

class SGMState extends BaseScreenState<SGMScreen> {
  final storeConfigController = Get.find<StoreConfigController>();
  final sgmViewController = Get.find<SGMViewController>();
  final GlobalKey<FormState> _sgmValidator = GlobalKey<FormState>();

  @override
  void onInitState() {
    super.onInitState();
    sgmViewController.initialize();
    sgmViewController.onClickClear();
    sgmViewController.reprintLogId.value = null;
    sgmViewController.runCheckStockBeforeMovingInSGM();
  }

  @override
  void onDispose() {
    sgmViewController.controllerTextField
        .map((e) => e.textEditingController.dispose());
    sgmViewController.subscription.cancel();
    super.onDispose();
  }

  @override
  bool get isScanningEnabled => true;

  @override
  bool get showAppBar => false;

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: SingleChildScrollView(
        child: Form(
          key: _sgmValidator,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getOrigin(),
              Obx(() => sgmViewController.selectedOrigin.value != null
                  ? _getReason()
                  : const SizedBox.shrink()),
              Obx(() => sgmViewController.selectedReason.value != null &&
                      sgmViewController.selectedOrigin.value != null
                  ? _scanOrEnter()
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scanOrEnter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        scanOrEnter(),
        20.heightBox,
        sgmViewController.selectedReason.value != null
            ? _getProductInput()
            : const SizedBox.shrink(),
        20.heightBox,
        sgmViewController.selectedReason.value != null
            ? _saveOrClear()
            : const SizedBox.shrink(),
        5.heightBox,
        rePrintButton()
      ],
    );
  }

  Widget _getOrigin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
                width: 100,
                child: Text(
                  "Origin",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )),
            5.widthBox,
            Expanded(
              child: Obx(() {
                return DropDown(
                  value: sgmViewController.selectedOrigin.value,
                  items: sgmViewController.origins.value ?? [],
                  onChange: (origin) {
                    sgmViewController.onOriginChange(origin);
                  },
                );
              }),
            ),
          ],
        ),
        20.heightBox,
      ],
    );
  }

  Widget _getReason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
                width: 100,
                child: Text(
                  "Reason",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )),
            5.widthBox,
            Expanded(
              child: Obx(() {
                return DropDown(
                  value: sgmViewController.selectedReason.value,
                  items: sgmViewController.reasons.value ?? [],
                  onChange: (reason) {
                    sgmViewController.onReasonChange(reason);
                  },
                );
              }),
            ),
          ],
        ),
        20.heightBox,
      ],
    );
  }

  Widget _getProductInput() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(children: [
          ...sgmViewController.controllerTextField
              .mapWithNextField<Widget, SBOFieldModel>(
                  (SBOFieldModel e, SBOFieldModel? nextField) {
            final index = sgmViewController.controllerTextField.indexOf(e);
            return [SBOField.department, SBOField.currentPrice]
                    .contains(e.sboField)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: getField(e, nextField)),
                      10.widthBox,
                      Expanded(
                          child: getField(
                              sgmViewController.controllerTextField[index + 1],
                              nextField)),
                    ],
                  )
                : [
                    SBOField.price,
                    SBOField.uline,
                    SBOField.style,
                    SBOField.quantity
                  ].contains(e.sboField)
                    ? getField(e, nextField)
                    : const SizedBox.shrink();
          })
        ]),
      ),
    );
  }

  Widget _saveOrClear() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SBOButton(
            onPressed: () {
              if (_sgmValidator.currentState!.validate()) {
                sgmViewController.onClickEnter();
              }
            },
            title: "Enter",
            iconName: Icons.print,
          ),
          SBOButton(
            onPressed: () {
              sgmViewController.onClickClear();
            },
            title: "Clear",
            iconName: Icons.clear_all_outlined,
          ),
        ],
      ),
    );
  }

  Widget rePrintButton() {
    return Obx(() => sgmViewController.reprintLogId.value!=null
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SBOButton(
            title: "Re-Print",
            onPressed: () {
              sgmViewController.reprint();
            })
      ],
    )
        : const SizedBox.shrink());
  }

  getField(SBOFieldModel e, SBOFieldModel? nextField) {
    if (e.sboField == SBOField.newPrice &&
        (sgmViewController.getIsZeroPriceForReason())) {
      e.textEditingController.text = "0.00";
    }

    return storeConfigController.isMarshallsUSA() &&
                e.sboField == SBOField.uline ||
            !storeConfigController.isMarshallsUSA() &&
                e.sboField == SBOField.style
        ? SBOInputField(
            sboFieldModel: e,
            nextFocusNode: nextField?.focusNode,
          )
        : e.sboField != SBOField.style && e.sboField != SBOField.uline
            ? SBOInputField(
                enabled: e.sboField == SBOField.newPrice
                    ? !(sgmViewController.getIsZeroPriceForReason())
                    : true,
                sboFieldModel: e,
                nextFocusNode: nextField?.focusNode)
            : const SizedBox.shrink();
  }
}
