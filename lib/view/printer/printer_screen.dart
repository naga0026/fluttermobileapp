import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/ui_controls/sbo_list_tile.dart';
import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/navigation/routes/route_names.dart';
import '../../translations/translation_keys.dart';
import '../../ui_controls/stock_selection.dart';

class PrinterListScreen extends StatefulWidget {
  const PrinterListScreen({Key? key}) : super(key: key);

  @override
  State<PrinterListScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterListScreen> {
  final _printerListController = Get.find<PrinterListViewController>();


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Stack(
        children: [
          Obx(() {
              var printers = _printerListController.connectedPrinters;
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var printer = printers[index];
                  return SBOListTile(
                      swipeToLeftTitle: TranslationKey.unassign.tr,
                    swipeToRightTitle: TranslationKey.selectStockTitle.tr,
                    onDismiss: (direction) => _onSwipe(direction, printer),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          color: ColorConstants.grey777777,
                          child: Center(
                            child: Text(
                              printer.printerId.stationID,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          color: ColorConstants.greyC9C9C9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _printerListController.getStockType(
                                    printer.printerStock),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: printers.length,
              );
            },
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Get.toNamed(RouteNames.printerAddPage);
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  //region Handlers
  Future<bool?> _onSwipe(DismissDirection direction,
      PrinterSetUp printer) async {
    if (direction == DismissDirection.endToStart) {
      return _showDisconnectPrinterDialog(printer);
    } else {
      return _showSelectStockDialog(printer);
    }
  }

  Future<bool?> _showDisconnectPrinterDialog(PrinterSetUp printer) async {
    bool isRemove = false;
    return await showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text(TranslationKey.disconnectPrinterTitle.tr),
              content: Text(TranslationKey.confirmDisconnectMsg.tr),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      TranslationKey.no.tr,
                      style: TextStyle(color: ColorConstants.primaryRedColor),
                    )),
                TextButton(
                    onPressed: () {
                      _printerListController.removePrinter(printer);
                      isRemove = true;
                      Get.back();
                    },
                    child: Text(TranslationKey.yes.tr,
                        style:
                        TextStyle(color: ColorConstants.primaryRedColor))),
              ],
            )).then((value) => isRemove);
  }

  Future<bool?> _showSelectStockDialog(PrinterSetUp printer) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text(
                TranslationKey.selectStockTitle.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(TranslationKey.cancel.tr,
                        style:
                        TextStyle(color: ColorConstants.primaryRedColor)))
              ],
              content: StockSelection(
                stockTypes: _printerListController.stocks,
                onStockTypeUpdate: (selectedStock) {
                  _printerListController.updateSelectedStock(
                      printer: printer, stock: selectedStock).then((value) =>
                      Get.back());
                },
                selectedStock: _printerListController.selectedStock.value,
              ),
            ));
  }
//endregion
}
