import 'package:base_project/controller/home/transfers/transfers_controller.dart';
import 'package:base_project/ui_controls/sbo_text_field.dart';
import 'package:base_project/utility/constants/custom_dialog/custom_dialogsCLS.dart';
import 'package:base_project/utility/constants/images_and_icons/icon_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui_controls/transfer_item_screen.dart';
import '../../../ui_controls/transfers_chip_control.dart';
import '../../../ui_controls/transfers_segment_control.dart';
import '../../../utility/constants/colors/color_constants.dart';
import '../../../utility/enums/transfers_enum.dart';
import '../../base/base_screen.dart';
import 'receiving_view.dart';

class TransfersScreen extends BaseScreen {
  const TransfersScreen({super.key});

  @override
  TransfersScreenState createState() => TransfersScreenState();
}

class TransfersScreenState extends BaseScreenState<TransfersScreen> {
  final controller = Get.find<TransfersController>();

  @override
  bool get isScanningEnabled => true;

  @override
  void onInitState() {
    controller.onSegmentChange(TransfersDirection.shipping);
    controller.onSwitchClear();
    controller.initializeScan();
    // _handleShippingChange();
    super.onInitState();
  }

  @override
  void onDispose() {
    controller.subscription.cancel();
    controller.selectedShippingAction.close();
    super.onInitState();
  }

  @override
  bool get showAppBar => false;

  //
  // get title1 => controller.currentSegment.value!=null?Text(controller.currentSegment.value!.title):const Text("Transfer Direction");
  // get title2 => controller.selectedTransferType.value!=null?Text(controller.selectedTransferType.value!.title):const Text("Transfer Type");
  // get title3 => controller.selectedShippingAction.value!=null?Text(controller.selectedShippingAction.value!.title):const Text("Transfer Action");
  //
  // late final List<Step> _steps = [
  //   Step(title: title1, content: TransferSegmentControl(
  //     onSegmentChange: (TransfersOption segment) {
  //       //final controller = Get.find<TransfersController>();
  //       controller.clearAllValues();
  //       controller.onSegmentChange(segment);
  //     },
  //   ).paddingOnly(left: 5, right: 5, top: 2),),
  //   Step(title:title2, content: transferTypeSelectionView(),),
  //   Step(title: title3, content:transferTypeActionSelectionView()),
  // ];
  //
  //

  //
  // @override
  // Widget body(){
  //   return Stepper(
  //       steps:_steps,
  //     currentStep: controller.currentStep.value,
  //     onStepTapped: (index){
  //       controller.setCurrentStep(index);
  //     },
  //       type: StepperType.vertical,
  //     );
  // }

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<TransfersDirection?>(
              stream: controller.currentSegment.stream,
              builder: (context, snapshot) {
                return TransferSegmentControl(
                  onSegmentChange: (TransfersDirection segment) {
                    controller.clearAllTextFieldValues();
                    controller.onSegmentChange(segment);
                  },
                  selectedTransfersDirection:
                      snapshot.data ?? TransfersDirection.shipping,
                ).paddingOnly(left: 5, right: 5, top: 2);
              }),
          transferTypeSelectionView(),
          transferTypeActionSelectionView(),
          destinationSelectionView(),
          proceed()
        ],
      ),
    );
  }

  Widget transferTypeSelectionView() {
    return Obx(() {
      return TransferChoiceChipControl<TransferType>(
              key: UniqueKey(),
              chips: controller.currentSegment.value.transferTypes,
              onSelect: (type) async {
                controller.clearAllTextFieldValues();
                controller.onTransferTypeChange(type as TransferType);
                controller.selectedShippingAction.value = null;
              },
            );
    }).paddingSymmetric(horizontal: 10, vertical: 5);
  }

  Widget transferTypeActionSelectionView() {
    return Obx(() {
      if (controller.selectedTransferType.value != null) {
        if (controller.currentSegment.value == TransfersDirection.receiving) {
          return ReceivingView(
            key: UniqueKey(),
          );
        } else {
          return TransferChoiceChipControl<ShippingActions>(
              removeSelection: controller.selectedShippingAction.value == null,
              chips: controller.selectedTransferType.value!.actions,
              onSelect: (action) async {
                _handleShippingChange(action);
                if (controller.selectedTransferType.value ==
                        TransferType.damagedJewelry &&
                    action == ShippingActions.newBox) {
                  final date = await controller.performDamagedJewellery();
                  CustomDialog.showDialogInTransferScreen(
                      title: "Damaged Jewellery",
                      cancelButtonText: "NO",
                      buttonText: "YES",
                      subtitle:
                          "A Damaged Jewellery was done $date \n CONTINUE ?",
                      buttonCallBack: () {
                        controller.createDamagedJewellery();
                        controller.clearSelectedActionButton();
                        Get.back();
                      },
                      icon: IconConstants.warningIcon,
                      showTitle: false,
                      isCancelButtonRequired: true,
                      cancelButtonCallBack: () {
                        controller.clearSelectedActionButton();
                      });
                  controller.onShippingActionChange(action as ShippingActions);
                }
              });
        }
      } else {
        return const SizedBox();
      }
    }).paddingSymmetric(horizontal: 10, vertical: 5);
  }

  Widget destinationSelectionView() {
    return Obx(() => controller.canProceed.value
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SBOInputField(
                    enabled: false,
                    sboFieldModel: controller.storeNumber,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.openPopUpToEnterStoreNumber(() {
                      controller.checkOrValidateStoreNumber();
                      Navigator.of(context).pop();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: ColorConstants.primaryRedColor,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink());
  }

  Widget proceed() {
    return Obx(
      () => controller.canProceed.value
          ? IconTextButtonSGM(
              onPressed: () {
                final String transferType =
                    controller.selectedTransferType.value!.title;
                Get.to(() => const TransferItemScreen(), arguments: {
                  "controlNumber": controller.controlNumberStrValue.value!,
                  "transferType": transferType,
                  "storeAddress": controller.storeAddress,
                  "DJ": controller.selectedTransferType.value ==
                          TransferType.damagedJewelry
                      ? true
                      : false
                });
              },
              title: "Proceed",
              iconName: Icons.navigate_next_sharp,
            )
          : const SizedBox(),
    );
  }

  void _handleShippingChange(ShippingActions shippingAction) {
    switch (shippingAction) {
      case ShippingActions.newBox:
        controller.selectedTransferType.value == TransferType.damagedJewelry
            ? null
            : controller.openPopUpToEnterStoreNumber(() {
                controller.checkOrValidateStoreNumber();
                Get.back();
              });
        break;
      case ShippingActions.endBox:
        controller.canProceed.value = false;
        controller.openPopUpToEnterControlNumber(() {
          controller.checkOrValidateControlNumber(ShippingActions.endBox);
        });
        break;
      case ShippingActions.adjustInquireBox:
        controller.canProceed.value = false;
        controller.openPopUpToEnterControlNumber(() {
          controller
              .checkOrValidateControlNumber(ShippingActions.adjustInquireBox);
          Get.back();
        });
        break;
      case ShippingActions.reprintLabel:
        controller.canProceed.value = false;
        controller.storedControlNumberForReprintPurpose.value != null
            ? controller.showReprintLabelDialog()
            : controller.openPopUpToEnterControlNumber(() {
                controller
                    .checkOrValidateControlNumber(ShippingActions.reprintLabel);
                Get.back();
              });
        break;
      default:
        break;
    }
  }
}

class IconTextButtonSGM extends StatelessWidget {
  const IconTextButtonSGM(
      {Key? key,
      required this.onPressed,
      required this.iconName,
      required this.title})
      : super(key: key);

  final VoidCallback onPressed;
  final IconData iconName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: ColorConstants.primaryRedColor,
            shadowColor: Colors.transparent,
            enableFeedback: true,
          ),
          onPressed: () => onPressed(),
          icon: Icon(
            iconName,
            color: Colors.white,
          ),
          label: Text(
            title,
            style: const TextStyle(color: Colors.white),
          )),
    );
  }
}
