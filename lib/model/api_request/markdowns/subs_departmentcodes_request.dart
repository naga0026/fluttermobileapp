import 'package:get/get.dart';
// Uline class & department codes only page number and size
import '../../../controller/store_config/store_config_controller.dart';

class SubsMarkdownsCachingRequest {
  int pageNumber;
  int pageSize;
  String? divisionCode;
  String? storeNumber;
  String? secondDivisionCode;
  String? secondStoreNumber;

  SubsMarkdownsCachingRequest({
    this.divisionCode,
    this.storeNumber,
    this.secondDivisionCode,
    this.secondStoreNumber,
    required this.pageNumber,
    required this.pageSize});

  Map<String, dynamic> toJson() {
    Map<String,dynamic> data = {};
    data["pageSize"] = pageSize;
    data["pageNumber"] = pageNumber;
    if(divisionCode != null){
      data["divisionCode"] = divisionCode;
    }
    if(storeNumber != null){
      data["storeNumber"] = storeNumber;
    }
    if(secondDivisionCode != null){
      data["secondDivisionCode"] = secondDivisionCode;
    }
    if(secondStoreNumber != null){
      data["secondStoreNumber"] = secondStoreNumber;
    }
    return data;
  }

  updateRequestWhenNotUlineDepartment() {
    final storeConfigService = Get.find<StoreConfigController>();
    if (storeConfigService.isMega) {
      divisionCode = storeConfigService.firstMegaStoreDetails?.storeDivision ?? '';
      storeNumber = storeConfigService.firstMegaStoreDetails?.storeNumber ?? '';
      secondDivisionCode = storeConfigService.secondMegaStoreDetails?.storeDivision ?? '';
      secondStoreNumber = storeConfigService.secondMegaStoreDetails?.storeNumber ?? '';
    } else {
      divisionCode = storeConfigService.firstMegaStoreDetails?.storeDivision ?? '';
      storeNumber = storeConfigService.firstMegaStoreDetails?.storeNumber ?? '';
    }
  }
}