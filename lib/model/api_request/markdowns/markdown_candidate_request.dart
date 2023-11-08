import 'package:get/get.dart';

import '../../../controller/store_config/store_config_controller.dart';

class MLUCandidateRequest {
  String divisionCode;
  String departmentCode;
  String storeNumber;
  String weekId;


  MLUCandidateRequest({
    required this.departmentCode,
    required this.divisionCode,
    required this.storeNumber,
    required this.weekId});

  Map<String, dynamic> toJson() => {
    "DivisionCode" : divisionCode,
    "DepartmentCode" : departmentCode,
    "StoreNumber" : storeNumber,
    "WeekId" : weekId,
  };

}

class MarkdownCandidateRequest {
  String divisionCode;
  String departmentCode;
  String storeNumber;
  String styleOrLine;
  bool isMLU;


  MarkdownCandidateRequest({
    required this.departmentCode,
    required this.divisionCode,
    required this.storeNumber,
    required this.styleOrLine,
    required this.isMLU
  });

  Map<String, dynamic> toJson() {
    final storeConfigController = Get.find<StoreConfigController>();
    Map<String, dynamic> data = {};
    data["DivisionCode"] = divisionCode;
    data["DepartmentCode"] = departmentCode;
    data["StoreNumber"] = storeNumber;
    data["IsMlu"] = isMLU;
    if(storeConfigController.isMarshallsUSA()){
      data["Uline"] = styleOrLine;
    } else {
      data["StyleCode"] = styleOrLine;
    }
    return data;
  }

}