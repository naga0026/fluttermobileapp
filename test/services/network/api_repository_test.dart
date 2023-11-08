import 'package:base_project/model/api_response/get_printer_response.dart';
import 'package:base_project/services/network/models/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../constants/responses.dart';
import '../../controllers/read/mock_read_config_controller.dart';
import 'mock_api_provider.dart';
import 'mock_network_service.dart';

Future<void> main() async {

  await Get.putAsync(() => MockNetworkService().init());
  Get.put(MockReadConfigController(),permanent: true);

  final apiProvider = MockAPIProvider();

  test("printer list test | fetch previous printers with data", () async {
    // Fetch printers success
    // Arrange
    var printers = getPrintersResponseFromJson(MockResponse.printerListMockResponse);
    var getPrinterResponse = GetPrinterResponse(status: 200, assignedPrinters: printers);
    var baseResponse = BaseResponse(statusCode: 200, resultJson: MockResponse.printerListMockResponse);
    when(apiProvider.apiCallGetPreviousPrinters()).thenAnswer((_) async
    => Future.delayed(const Duration(milliseconds: 200)).then((value) => getPrinterResponse)
    );

    // Act
    var result = await apiProvider.apiCallGetPreviousPrinters();

    // Assert
    verify(apiProvider.apiCallGetPreviousPrinters());
    expect(result, getPrinterResponse);
  });


}