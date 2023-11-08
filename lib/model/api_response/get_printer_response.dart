import 'dart:convert';

import '../../../../model/printer_setup.dart';

class GetPrinterResponse {
  int status;
  List<PrinterSetUp>? assignedPrinters;
  String? error;

  GetPrinterResponse({required this.status, this.assignedPrinters, this.error});
}

List<PrinterSetUp> getPrintersResponseFromJson(String str) =>
    List<PrinterSetUp>.from(
        json.decode(str).map((x) => PrinterSetUp.fromJson(x)));

String getPrintersResponseToJson(List<PrinterSetUp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
