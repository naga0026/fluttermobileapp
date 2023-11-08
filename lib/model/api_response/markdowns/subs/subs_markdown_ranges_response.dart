import 'dart:convert';
import '../../../../utility/generic/mapping_model.dart';

class SubsMarkdownsRangesResponse {
  int status;
  String? error;
  SubsMarkdownRangeModel? data;

  SubsMarkdownsRangesResponse({required this.status,this.error, this.data });
}

SubsMarkdownRangeModel subsMarkdownRangeResponseFromJson(String str) => SubsMarkdownRangeModel.fromJson(json.decode(str));

String subsMarkdownRangeResponseToJson(SubsMarkdownRangeModel data) => json.encode(data.toJson());

class SubsMarkdownRangeModel {
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;
  final String? nextPage;
  final int? previousPage;
  final List<RangeData>? data;

  SubsMarkdownRangeModel({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
  });

  factory SubsMarkdownRangeModel.fromJson(Map<String, dynamic> json) => SubsMarkdownRangeModel(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: json["data"] == null ? [] : List<RangeData>.from(json["data"]!.map((x) => RangeData.fromJson(x))),
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

class RangeData extends ClassMappingModel<RangeData>{
  final String? weekId;
  final String? fromClass;
  final String? toClass;
  final String? departmentCode;
  final String? divisionCode;
  final int? lowPrice;
  final int? highPrice;
  final String? type;
  final String? storeNumber;

  RangeData({
    this.weekId,
    this.fromClass,
    this.toClass,
    this.departmentCode,
    this.divisionCode,
    this.lowPrice,
    this.highPrice,
    this.type,
    this.storeNumber,
  });

  factory RangeData.fromJson(Map<String, dynamic> json) => RangeData(
    weekId: json["weekId"] ?? '',
    fromClass: json["fromClass"],
    toClass: json["toClass"],
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    lowPrice: json["lowPrice"],
    highPrice: json["highPrice"],
    type: json["type"],
    storeNumber: json["storeNumber"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "fromClass": fromClass,
    "toClass": toClass,
    "departmentCode": departmentCode,
    "divisionCode": divisionCode,
    "lowPrice": lowPrice,
    "highPrice": highPrice,
    "type": type,
    "storeNumber": storeNumber,
  };

  @override
  RangeData fromJson(Map<String, dynamic> json) => RangeData(
    weekId: json["weekId"] ?? '',
    fromClass: json["fromClass"],
    toClass: json["toClass"],
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    lowPrice: json["lowPrice"],
    highPrice: json["highPrice"],
    type: json["type"],
    storeNumber: json["storeNumber"],
  );

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "weekId": "'$weekId'",
      "fromClass": "'$fromClass'",
      "toClass": "'$toClass'",
      "departmentCode": "'$departmentCode'",
      "divisionCode": "'$divisionCode'",
      "lowPrice": lowPrice,
      "highPrice": highPrice,
      "type": "'$type'",
      "storeNumber": "'$storeNumber'",
    };
  }

  static String tableVariables() {
    var value = '''
    weekId TEXT,
    fromClass TEXT,
    toClass TEXT,
    departmentCode TEXT,
    divisionCode TEXT,
    lowPrice INTEGER,
    highPrice INTEGER,
    type TEXT,
    storeNumber TEXT
    ''';
    return value;
  }
}
