import 'package:base_project/controller/home/home_view_controller.dart';
import 'package:base_project/controller/home/transfers/transfers_controller.dart';
import 'package:base_project/model/api_response/transfers/store_address_transfers_response.dart';
import 'package:base_project/ui_controls/sbo_button.dart';
import 'package:base_project/ui_controls/sbo_text_field.dart';
import 'package:base_project/utility/constants/custom_dialog/custom_dialogsCLS.dart';
import 'package:base_project/utility/constants/images_and_icons/icon_constants.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/view/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/constants/colors/color_constants.dart';
import '../utility/enums/transfers_enum.dart';

class TransferItemScreen extends BaseScreen {
  const TransferItemScreen({Key? key}) : super(key: key);

  @override
  TransferItemScreenState createState() => TransferItemScreenState();
}

class TransferItemScreenState extends BaseScreenState<TransferItemScreen> {
  final controller = Get.put(TransfersController());

  boldTitle(String title, {bool isColor = false}) => Text(
        title,
        style: TextStyle(
            color: isColor ? ColorConstants.primaryRedColor : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      );
  final controlNumber = Get.arguments["controlNumber"];
  StoreAddressResponse? storeAdd = Get.arguments["storeAddress"];


  @override
  void onDispose() {
    controller.onSwitchClear();
    super.onDispose();
  }

  @override
  bool get showAppBar => false;
  @override
  bool get showCustomAppBar => true;
  final hide = true;
  @override
  AppBar customAppBar() => _appBar();
  @override
  Widget body() {
    return WillPopScope(
      onWillPop: () async {
        controller.onSwitchClear();
        return true;
      },
      // child: Center(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       20.heightBox,
      //       boldTitle(controller.currentSegment.value!.title.toUpperCase()),
      //       controller.selectedTransferType.value != null
      //           ? boldTitle(
      //           controller.selectedTransferType.value!.title.toUpperCase())
      //           : const SizedBox.shrink(),
      //       // boldTitle(controller.isAddItem.value ? "ADD ITEM" : "DELETE ITEM",
      //       //     isColor: true),
      //       20.heightBox,
      //     ],
      //   ),
      // ),
      child: Obx(() {
        return SingleChildScrollView(
          child: Column(children: [
            10.heightBox,
            controller.selectedTransferType.value==TransferType.damagedJewelry?const SizedBox.shrink():RichText(
              text: TextSpan(children: [
                 TextSpan(
                    text: "STORE-ADDRESS:",
                    style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstants.primaryRedColor)),
                TextSpan(
                  text:
                      "${storeAdd?.data?.storeAddress1}\n${storeAdd?.data?.storeAddress2}",
                    style:const TextStyle(color: Colors.black)),

                TextSpan(
                    text:
                        "${storeAdd?.data?.storeAddress3}\n${storeAdd?.data?.postalCode2 == "0000" ?
                        storeAdd?.data?.postalCode1 : storeAdd?.data?.postalCode2}",
                    style:const TextStyle(color: Colors.black)
                ),
              ]),
            ),
            20.heightBox,
            boldTitle(controller.currentSegment.value!.title.toUpperCase()),
            controller.selectedTransferType.value != null
                ? boldTitle(
                    controller.selectedTransferType.value!.title.toUpperCase())
                : const SizedBox.shrink(),
            boldTitle(controller.isAddItem.value ? "ADD ITEM" : "DELETE ITEM",
                isColor: true),
            20.heightBox,
            enterItemPopUpView()
          ]),
        );
      }),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: ListTile(
        title: const Text(
          'Transfers',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('Control #$controlNumber',
            style: const TextStyle(color: Colors.white)),
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          //don't specify icon if you want 3 dot menu
          itemBuilder: (context) => controller.options.map((e) {
            return PopupMenuItem<NewBoxOptions>(
                value: e,
                child: e == controller.selectedBoxMenuItem.value
                    ? Text(
                        e.title.toUpperCase(),
                        style: TextStyle(
                            color: ColorConstants.primaryRedColor,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        e.title.toUpperCase(),
                      ));
          }).toList(),
          onSelected: (item) {
            controller.selectedBoxMenuItem.value = item;
            switch (item) {
              case NewBoxOptions.voidBox:
                _onVoidBoxClick();
                break;
              case NewBoxOptions.addBox:
                controller.isAddItem.value = true;
                break;
              case NewBoxOptions.deleteBox:
                controller.isAddItem.value = false;
                break;
              case NewBoxOptions.inquireBox:
                controller.showInquireBoxDialog(controlNumber);
                break;
              case NewBoxOptions.endBox:
                controller.performEndBoxTransfer(cNum: controlNumber);
                final backOnTransferScreen = Get.find<HomeViewController>();
                backOnTransferScreen.currentTabIndex.value = 3;
                Get.back();
                controller.onSwitchClear();
                break;
            }
          },
        ),
        // IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
      ],
    );
  }

  Widget enterItemPopUpView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ...controller.scanFields.map((e) => SBOInputField(sboFieldModel: e)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SBOButton(title: "Clear", onPressed: () {}),
            20.widthBox,
            SBOButton(
                title: controller.isAddItem.value ? "Add" : "Delete",
                onPressed: () {
                  controller.isAddItem.value
                      ? controller.addItem()
                      : controller.deleteItem();
                }),
          ],
        )
      ]),
    );
  }

  _onVoidBoxClick() {
    CustomDialog.showDialogInTransferScreen(
        title: "Void Box",
        cancelButtonText: "No",
        buttonText: "Yes",
        subtitle: "Do you want to void the current Box,\nAre you sure ?",
        buttonCallBack: () {
          controller.performVoidBox(cNumber: controlNumber);
          Get.back();
        },
        icon: IconConstants.warningIcon,
        showTitle: false,
        isCancelButtonRequired: true, cancelButtonCallBack: () {
      controller.clearSelectedActionButton();
    });
  }
}
