import 'dart:convert';

import 'package:base_project/services/network/network_service.dart';
import 'package:base_project/utility/constants/app/date_format.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:base_project/utility/generic/mapping_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

PrinterSetUp printerSetUpFromJson(String str) =>
    PrinterSetUp.fromJson(json.decode(str));

String printerSetUpToJson(PrinterSetUp data) => json.encode(data.toJson());

class PrinterSetUp extends ClassMappingModel<PrinterSetUp> {
  final String appId;
  final String printerId;
  String printerStock;
  String? printerDescription;
  final DateTime? printerExpiryDate;
  final DateTime? lastTested;
  int labelLength;
  int separatorType;

  PrinterSetUp(
      {required this.appId,
      required this.printerId,
      required this.printerStock,
      required this.printerDescription,
      this.printerExpiryDate,
      this.lastTested,
      required this.labelLength,
      required this.separatorType});

  factory PrinterSetUp.fromJson(Map<String, dynamic> json) => PrinterSetUp(
      appId: json["appId"],
      printerId: json["printerId"],
      printerStock: json["printerStock"] ?? '',
      printerDescription: json["printerDescription"],
      printerExpiryDate: json["printerExpiryDate"] != null
          ? DateFormat(DateFormatConstants.printerResponseDateFormat)
          .parse(json['printerExpiryDate'])
          : null,
      lastTested: json["lastTested"] != null
          ? DateFormat(DateFormatConstants.printerResponseDateFormat)
          .parse(json['lastTested'])
          : null,
      labelLength: json["labelLength"] ?? 0,
      separatorType: json["separatorType"] ?? 0);

  @override
  Map<String, dynamic> toJson() {
    final networkService = Get.find<NetworkService>();
    var lastTested = DateTime.now().toUtc();
    var expiryDate = lastTested.add(const Duration(days: 1)).toUtc();
    final DateFormat formatter =
        DateFormat(DateFormatConstants.printerDateFormat);
    var formattedExpiry = formatter.format(expiryDate);
    var lastTestedFormatted = formatter.format(lastTested);
    return {
      "appId": networkService.deviceIP.stationID,
      "printerId": printerId.printerIPWithoutLeadingZero,
      "printerStock": printerStock,
      "printerDescription": printerDescription,
      "printerExpiryDate": formattedExpiry,
      "lastTested": lastTestedFormatted,
      "labelLength": labelLength,
      "separatorType": separatorType,
    };
  }

  @override
  PrinterSetUp fromJson(Map<String, dynamic> json) {
    return PrinterSetUp(
        appId: json["appId"],
        printerId: json["printerId"],
        printerStock: json["printerStock"] ?? '',
        printerDescription: json["printerDescription"],
        printerExpiryDate: json["printerExpiryDate"] != null
            ? DateFormat(DateFormatConstants.printerResponseDateFormat)
                .parse(json['printerExpiryDate'])
            : null,
        lastTested: json["lastTested"] != null
            ? DateFormat(DateFormatConstants.printerResponseDateFormat)
                .parse(json['lastTested'])
            : null,
        labelLength: json["labelLength"],
        separatorType: json["separatorType"]);
  }

  @override
  Map<String, dynamic> toJsonForDB() {
    final networkService = Get.find<NetworkService>();
    var lastTested = DateTime.now().toUtc();
    var expiryDate = lastTested.add(const Duration(days: 1)).toUtc();
    final DateFormat formatter =
        DateFormat(DateFormatConstants.printerDateFormat);
    var formattedExpiry = formatter.format(expiryDate);
    var lastTestedFormatted = formatter.format(lastTested);
    return {
      "appId": "'${networkService.deviceIP.stationID}'",
      "printerId": "'${printerId.printerIPWithoutLeadingZero}'",
      "printerStock": "'$printerStock'",
      "printerDescription": "'$printerDescription'",
      "printerExpiryDate": "'$formattedExpiry'",
      "lastTested": "'$lastTestedFormatted'",
      "labelLength": labelLength,
      "separatorType": separatorType,
    };
  }

  static String tableVariables() {
    var value = '''
    appId TEXT,
    printerId TEXT,
    printerStock TEXT,
    printerDescription TEXT,
    printerExpiryDate TEXT,
    lastTested TEXT,
    labelLength INTEGER,
    separatorType INTEGER
    ''';
    return value;
  }

  Map<String, String> toJsonDeletePrinter() => {
    "printerId": printerId.printerIPWithoutLeadingZero
  };
}
