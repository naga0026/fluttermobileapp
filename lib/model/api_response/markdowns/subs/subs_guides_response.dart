import 'dart:convert';

import '../../../../utility/generic/mapping_model.dart';


class SubsMarkdownsGuidesResponse {
  int status;
  String? error;
  SubsMarkdownGuidesModel? data;

  SubsMarkdownsGuidesResponse({required this.status,this.error, this.data });
}

SubsMarkdownGuidesModel subsMarkdownGuidesResponseFromJson(String str) => SubsMarkdownGuidesModel.fromJson(json.decode(str));

String subsMarkdownGuidesResponseToJson(SubsMarkdownGuidesModel data) => json.encode(data.toJson());

class SubsMarkdownGuidesModel {
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;
  final String? nextPage;
  final dynamic previousPage;
  final List<GuideData>? data;

  SubsMarkdownGuidesModel({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
  });

  factory SubsMarkdownGuidesModel.fromJson(Map<String, dynamic> json) => SubsMarkdownGuidesModel(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: json["data"] == null ? [] : List<GuideData>.from(json["data"]!.map((x) => GuideData.fromJson(x))),
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

class GuideData extends ClassMappingModel<GuideData>{
  final String? weekId;
  final String? departmentCode;
  final String? divisionCode;
  final int? fromPrice;
  final int? toPrice;
  final String? storeNumber;

  GuideData({
    this.weekId,
    this.departmentCode,
    this.divisionCode,
    this.fromPrice,
    this.toPrice,
    this.storeNumber,
  });

  factory GuideData.fromJson(Map<String, dynamic> json) => GuideData(
    weekId: json["weekId"] ?? '',
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    fromPrice: json["fromPrice"],
    toPrice: json["toPrice"],
    storeNumber: json["storeNumber"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "departmentCode": departmentCode,
    "divisionCode": divisionCode,
    "fromPrice": fromPrice,
    "toPrice": toPrice,
    "storeNumber": storeNumber,
  };

  @override
  GuideData fromJson(Map<String, dynamic> json) => GuideData(
    weekId: json["weekId"] ?? '',
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
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
      "fromPrice": fromPrice,
      "toPrice": toPrice,
      "storeNumber": "'$storeNumber'",
    };
  }

  static String tableVariables() {
    var value = '''
    weekId TEXT,
    departmentCode TEXT,
    divisionCode TEXT,
    fromPrice INTEGER,
    toPrice INTEGER,
    storeNumber TEXT
    ''';
    return value;
  }
}

