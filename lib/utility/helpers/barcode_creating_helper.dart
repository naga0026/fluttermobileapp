import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:get/get.dart';

import '../../controller/home/ticket_maker/ticket_maker_controller.dart';
import '../../model/label_definition/label_data.dart';
import '../enums/division_enum.dart';
import '../enums/stock_type.dart';

abstract class BarcodeCreatingHelper {
  final storeConfigController = Get.find<StoreConfigController>();

  String generateBarcode(LabelData labelData);

  String get currentDivision => storeConfigController.selectedDivision;

  String getClassCode(String classCode){
    return classCode.length>2?classCode.substring(0,2):classCode;
  }

  bool isWinnerOrHomesence() {
    return storeConfigController.selectedDivision.getDivisionName ==
        DivisionEnum.homeSenseCanada ||
        storeConfigController.selectedDivision.getDivisionName ==
            DivisionEnum.winnersCanadaOrMarshallsCanada;
  }

  bool getClassCodeForCanada(){
    List<StockTypeEnum> stocks = [
      StockTypeEnum.hangTag,
      StockTypeEnum.stickers,
      StockTypeEnum.shoes,
      StockTypeEnum.largeSign,
      StockTypeEnum.smallSign,
    ];
    final ticketMController = Get.find<TicketMakerController>();
    final status = stocks.contains(ticketMController.stockList[ticketMController.currentIndex.value]);
    return status&&isWinnerOrHomesence();
  }
  getDepartmentForMarshallsUsa(String dept) {
    return dept.length==2?"12$dept":dept;
  }

}