import 'package:base_project/model/sbo_field_model.dart';
import 'package:base_project/ui_controls/sbo_button.dart';
import 'package:base_project/utility/enums/division_enum.dart';
import 'package:base_project/utility/enums/sign_buttons.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home/ticket_maker/ticket_maker_controller.dart';
import '../../../controller/store_config/store_config_controller.dart';
import '../../../services/navigation/routes/route_names.dart';
import '../../../services/printing/stock_type_service.dart';
import '../../../translations/translation_keys.dart';
import '../../../ui_controls/custom_text.dart';
import '../../../ui_controls/sbo_text_field.dart';
import '../../../utility/constants/colors/color_constants.dart';
import '../../../utility/enums/printerStatus_enum.dart';
import '../../../utility/enums/stock_type.dart';
import '../../base/base_screen.dart';

class TicketMaker extends BaseScreen {
  const TicketMaker({super.key});

  @override
  TicketMakerState createState() => TicketMakerState();
}

class TicketMakerState extends BaseScreenState<TicketMaker> {
  final getAvailableStocks = Get.find<StockTypeService>();
  final storeConfigController = Get.find<StoreConfigController>();
  final ticketMakerController = Get.find<TicketMakerController>();
  final GlobalKey<FormState> _validateTicketMaker = GlobalKey<FormState>();

  @override
  bool get isScanningEnabled => true;

  @override
  void onInitState() {
    super.onInitState();
    ticketMakerController.initializeScan();
    ticketMakerController.onClickClear();
    ticketMakerController.runCheckStockBeforeMovingInTM();
  }

  @override
  void onDispose() {
    ticketMakerController.subscription.cancel();
    ticketMakerController.onClickClear();
    ticketMakerController.currentIndex.value = 0;
    super.onDispose();
  }

  PrinterStockStatusEnum checkStockBeforeMoving() {
    var (status, _) = ticketMakerController.checkValidStockBeforePrinting();
    return status;
  }

  @override
  bool get showAppBar => false;

  @override
  Widget body() {
    return Row(
      children: [
        Obx(
          () => ticketMakerController.stockList.isEmpty
              ? Container()
              : NavigationRail(
                  backgroundColor: Colors.white,
                  useIndicator: false,
                  selectedLabelTextStyle: TextStyle(
                    color: ColorConstants.primaryRedColor,
                    fontWeight: FontWeight.bold,
                  ),
                  labelType: NavigationRailLabelType.all,
                  destinations: ticketMakerController.stockList
                      .map((element) => NavigationRailDestination(
                            padding: const EdgeInsets.all(4),
                            icon: const SizedBox.shrink(),
                            label: Text(element.ticketMakerName),
                          ))
                      .toList(),
                  onDestinationSelected: (int value) {
                    ticketMakerController
                        .updateNavigationPaneOnSelectedStock(value);
                  },
                  selectedIndex: ticketMakerController.currentIndex.value),
        ),
        const VerticalDivider(
          color: Colors.black,
          thickness: 1,
          width: 1,
        ),
        Expanded(
          child: Obx(() => ticketMakerController.stockList.isNotEmpty
              ? ticketMakerController.stockList[
                              ticketMakerController.currentIndex.value] ==
                          StockTypeEnum.smallSign ||
                      ticketMakerController.stockList[
                              ticketMakerController.currentIndex.value] ==
                          StockTypeEnum.largeSign
                  ? getSignUI()
                  : ticketMakerController.stockList[
                              ticketMakerController.currentIndex.value] ==
                          StockTypeEnum.shoes
                      ? getShoes()
                      : getTMFieldScreen()
              : const SizedBox.shrink()),
        ),
      ],
    );
  }

  Widget getTMFieldScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      child: SingleChildScrollView(
        child: Form(
          key: _validateTicketMaker,
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                scanOrEnter(),
                15.heightBox,
                ...ticketMakerController.controllerTextField.map((e) {
                  return getConditionalFields(e);
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SBOButtonCustom(
                        title: TranslationKey.enterLabel.tr,
                        onPressed: () {
                          if (_validateTicketMaker.currentState!.validate()) {
                            ticketMakerController.onClickEnter();
                          }
                        },
                        isEnabled: false,
                        width_: 85,
                        isAppbar: false,
                        isLoading: ticketMakerController.isLoading),
                    SBOButtonCustom(
                      title: TranslationKey.clearLabel.tr,
                      onPressed: () {
                        ticketMakerController.onClickClear();
                      },
                      isEnabled: false,
                      width_: 85,
                      isAppbar: false,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSignUI() {
    return Container(
      margin: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SBOButton(
              onPressed: () {
                checkStockBeforeMoving() == PrinterStockStatusEnum.stockMatched
                    ? navigateToSignScreen(SignTypeEnum.vertical)
                    : null;
              },
              title: SignTypeEnum.vertical.rawValue),
          SBOButton(
              onPressed: () {
                checkStockBeforeMoving() == PrinterStockStatusEnum.stockMatched
                    ? navigateToSignScreen(SignTypeEnum.smHorizontal)
                    : null;
              },
              title: SignTypeEnum.smHorizontal.rawValue),
          SBOButton(
              onPressed: () {
                checkStockBeforeMoving() == PrinterStockStatusEnum.stockMatched
                    ? navigateToSignScreen(SignTypeEnum.lgHorizontal)
                    : null;
              },
              title: SignTypeEnum.lgHorizontal.rawValue),
        ],
      ),
    );
  }

  Widget getShoes() {
    return Container(
      margin: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SBOButton(
              onPressed: () {
                checkStockBeforeMoving() == PrinterStockStatusEnum.stockMatched
                    ? navigateToShoesScreen(
                        TranslationKey.tmBoxLabelTitle.tr,
                        RouteNames.shoesFrontScreen,
                      )
                    : null;
              },
              title: TranslationKey.tmBoxLabelTitle.tr),
          SBOButton(
            onPressed: () {
              checkStockBeforeMoving() == PrinterStockStatusEnum.stockMatched
                  ? navigateToShoesScreen(TranslationKey.tmSignLabelTitle.tr,
                      RouteNames.shoesFrontScreen)
                  : null;
            },
            title: TranslationKey.tmSignLabelTitle.tr,
          )
        ],
      ),
    );
  }

  Widget getConditionalFields(SBOFieldModel e) {
    return storeConfigController.isMarshallsUSA() &&
                e.sboField == SBOField.style ||
            !storeConfigController.isMarshallsUSA() &&
                e.sboField == SBOField.uline
        ? const SizedBox.shrink()
        : ticketMakerController
                        .stockList[ticketMakerController.currentIndex.value] ==
                    StockTypeEnum.markdown &&
                !(e.sboField == SBOField.compareAt)
            ? SBOInputField(
                sboFieldModel: e,
              )
            : e.sboField == SBOField.category ||
                    e.sboField == SBOField.compareAt
                ? isWinnerOrHomesence() && isStickerOrHangTag()
                    ? SBOInputField(
                        sboFieldModel: e,
                      )
                    : isPALabel() && e.sboField == SBOField.category
                        ? SBOInputField(
                            sboFieldModel: e,
                          )
                        : const SizedBox.shrink()
                : SBOInputField(
                    sboFieldModel: e,
                  );
  }

  navigateToSignScreen(SignTypeEnum appBarName) {
    ticketMakerController.selectedSignButton.value = appBarName;
    return Get.toNamed(RouteNames.signScreen, arguments: [appBarName.rawValue]);
  }

  navigateToShoesScreen(String appBarName, String shoeRoute) {
    return Get.toNamed(RouteNames.shoesFrontScreen, arguments: [appBarName]);
  }

  bool isWinnerOrHomesence() {
    return storeConfigController.selectedDivision.getDivisionName ==
            DivisionEnum.homeSenseCanada ||
        storeConfigController.selectedDivision.getDivisionName ==
            DivisionEnum.winnersCanadaOrMarshallsCanada;
  }

  bool isStickerOrHangTag() {
    return ticketMakerController
                .stockList[ticketMakerController.currentIndex.value] ==
            StockTypeEnum.hangTag ||
        ticketMakerController
                .stockList[ticketMakerController.currentIndex.value] ==
            StockTypeEnum.stickers;
  }

  bool isPALabel() {
    return ticketMakerController
            .stockList[ticketMakerController.currentIndex.value] ==
        StockTypeEnum.priceAdjust;
  }
}
