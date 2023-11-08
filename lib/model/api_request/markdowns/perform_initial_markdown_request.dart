import 'package:base_project/model/api_response/markdowns/get_initial_markdown_response.dart';
import 'package:get/get.dart';

import '../../../controller/login/user_management.dart';
import '../../../controller/store_config/store_config_controller.dart';
import '../../../services/network/network_service.dart';

class PerformInitialMarkdownRequest {
  late String divisionCode;
  late String storeNumber;
  late String departmentCode;
  late String weekId;
  String? style;
  String? uline;
  late int inputPrice;
  late int outputPrice;
  bool? isKeyed;
  late String deviceId;
  late String userId;
  String? digiUserIdForPrinting;
  String? classOrCategoryForPrinting;

  PerformInitialMarkdownRequest(
      {required this.divisionCode,
        required this.storeNumber,
        required this.departmentCode,
        required this.weekId,
        this.style,
        this.uline,
        required this.inputPrice,
        required this.outputPrice,
        this.isKeyed = true,
        required this.deviceId,
        required this.userId, this.digiUserIdForPrinting, this.classOrCategoryForPrinting});

  factory PerformInitialMarkdownRequest.fromMarkdownData(MarkdownData markdownData){
    final storeConfigController = Get.find<StoreConfigController>();
    var userManagementController = Get.find<UserManagementController>();
    final networkService = Get.find<NetworkService>();
    return PerformInitialMarkdownRequest(
        divisionCode: storeConfigController.selectedDivision ?? '',
        storeNumber:  storeConfigController.selectedStoreNumber ?? '',
        departmentCode: markdownData.departmentCode ?? '',
        weekId: (markdownData.weekId ?? ''),
        inputPrice: int.parse(markdownData.fromPrice ?? '0'),
        outputPrice: int.parse(markdownData.toPrice ?? '0'),
        deviceId: networkService.deviceIP,
        userId: userManagementController.userData?.data?.userId ?? '',
        uline:
        storeConfigController.isMarshallsUSA() ? markdownData.uline : null,
        style:
        storeConfigController.isMarshallsUSA() ? null : markdownData.style,
        classOrCategoryForPrinting: markdownData.classCode
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['divisionCode'] = divisionCode;
    data['storeNumber'] = storeNumber;
    data['departmentCode'] = departmentCode;
    data['weekId'] = weekId;
    if ((style ?? '').isNotEmpty) {
      data['style'] = style;
    }
    if ((uline ?? '').isNotEmpty) {
      data['uline'] = uline;
    }
    data['inputPrice'] = inputPrice;
    data['outputPrice'] = outputPrice;
    if (isKeyed != null) {
      data['isKeyed'] = isKeyed;
    }
    data['deviceId'] = deviceId;
    data['userId'] = userId;
    return data;
  }

}
