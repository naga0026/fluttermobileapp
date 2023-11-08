import 'dart:convert';

import '../../../../utility/generic/mapping_model.dart';

class SubsMarkdownsPricePointResponse {
  int status;
  String? error;
  SubsMarkdownPricePointModel? data;

  SubsMarkdownsPricePointResponse({required this.status,this.error, this.data });
}

SubsMarkdownPricePointModel subsMarkdownPricePointResponseFromJson(String str) => SubsMarkdownPricePointModel.fromJson(json.decode(str));

String subsMarkdownPricePointResponseToJson(SubsMarkdownPricePointModel data) => json.encode(data.toJson());

class SubsMarkdownPricePointModel {
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;
  final String? nextPage;
  final dynamic previousPage;
  final List<PricePointData>? data;

  SubsMarkdownPricePointModel({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
  });

  factory SubsMarkdownPricePointModel.fromJson(Map<String, dynamic> json) => SubsMarkdownPricePointModel(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: json["data"] == null ? [] : List<PricePointData>.from(json["data"]!.map((x) => PricePointData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
    "nextPage": nextPage,
    "previousPage": previousPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PricePointData extends ClassMappingModel<PricePointData> {
  final String? weekId;
  final String? departmentCode;
  final String? divisionCode;
  final String? classCode;
  final int? fromPrice;
  final int? toPrice;
  final String? storeNumber;

  PricePointData({
    this.weekId,
    this.departmentCode,
    this.divisionCode,
    this.classCode,
    this.fromPrice,
    this.toPrice,
    this.storeNumber,
  });

  factory PricePointData.fromJson(Map<String, dynamic> json) => PricePointData(
    weekId: json["weekId"] ?? '',
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    classCode: json["classCode"],
    fromPrice: json["fromPrice"],
    toPrice: json["toPrice"],
    storeNumber: json["storeNumber"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "departmentCode": departmentCode,
    "divisionCode": divisionCode,
    "classCode": classCode,
    "fromPrice": fromPrice,
    "toPrice": toPrice,
    "storeNumber": storeNumber,
  };

  @override
  PricePointData fromJson(Map<String, dynamic> json) => PricePointData(
    weekId: json["weekId"] ?? '',
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    classCode: json["classCode"],
    fromPrice: json["fromPrice"],
    toPrice: json["toPrice"],
    storeNumber: json["storeNumber"],
  );

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "weekId": "'$weekId'",
      "departmentCode": "'$departmentCode'",
      "divisionCode": "'$divisionCode'",
      "storeNumber": "'$storeNumber'",
      "classCode": "'$classCode'",
      "fromPrice": fromPrice,
      "toPrice": toPrice,
    };
  }

  static String tableVariables() {
    var value = '''
    weekId TEXT,
    departmentCode TEXT,
    divisionCode TEXT,
    storeNumber TEXT,
    classCode TEXT,
    fromPrice INTEGER,
    toPrice INTEGER
    ''';
    return value;
  }
}

