import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/model/api_response/get_printer_response.dart';
import 'package:base_project/services/navigation/navigation_service.dart';
import 'package:base_project/utility/enums/status_code_enum.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../services/network/mock_api_repository.dart';

class MockPrinterListController extends GetxController with Mock implements PrinterListViewController {

  @override
  MockAPIRepository get repository => MockAPIRepository();

  @override
  Future<void> apiCallGetPreviousPrinters() async {
    GetPrinterResponse result = await repository.getAssignedPrinters();
    if(result.status == StatusCodeEnum.success.statusValue){
      var previousPrinters = result.assignedPrinters ?? [];
      connectedPrinters.addAll(previousPrinters);
    } else {
      NavigationService.showToast(result.error ?? 'Error');
    }
  }

}