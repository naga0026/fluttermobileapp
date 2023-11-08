import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/services/printing/zebra_print_service.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockZebraPrintService extends GetxService
    with Mock
    implements ZebraPrintService {

  @override
  Future<(bool, String)> connectToPrinter(PrinterSetUp printer) async {
    bool isPrinterConnected = false;
    String connectionMessage = "";
    if (connectedPrinters.length < 3) {
      try {
        var isConnected = await Future.delayed(const Duration(seconds: 2)).then((value) => true);
        if (isConnected) {
          connectedPrinters.add(printer);
          isPrinterConnected = true;
          LoggerConfig.logger.d("Printer with ip ${printer.printerId} is connected.");
        }
      }
      catch (e) {
        connectionMessage = e.toString();
        LoggerConfig.logger.e("Error connecting to the printer ${e.toString()}");
      }
    }
    return (isPrinterConnected, connectionMessage);
  }

  @override
  Future<bool?> disconnect(PrinterSetUp printer) async {
    try {
      var isDisconnected = await Future.delayed(const Duration(seconds: 2)).then((value) => true);
      connectedPrinters.remove(printer);
      return isDisconnected;
    } catch (e) {
      LoggerConfig.logger.e("Error disconnecting the printer ${e.toString()}");
    }
    return null;
  }

}

