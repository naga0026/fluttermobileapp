import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../controllers/initial_controller/mock_initial_controller.dart';
import '../../controllers/printer/mock_printer_list_controller.dart';
import '../../controllers/read/mock_read_config_controller.dart';
import '../../services/network/mock_network_service.dart';

void main() async {
  late MockPrinterListController controller;
  Get.testMode = true;
  Get.put(MockInitialController());
  Get.put(MockReadConfigController(), permanent: true);
  await Get.putAsync(() => MockNetworkService().init());
  //Get.put(StockTypeService());

  setUp(() {
    controller = Get.put(MockPrinterListController());
  });

  test("printer list test | fetch previous printers with data", () async {
    // Fetch printers success


  });
}
