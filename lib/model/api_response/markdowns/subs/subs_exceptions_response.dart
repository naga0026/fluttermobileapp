import 'dart:convert';
import '../../../../utility/generic/mapping_model.dart';

class SubsMarkdownsExceptionResponse {
  int status;
  String? error;
  SubsMarkdownExceptionModel? data;

  SubsMarkdownsExceptionResponse({required this.status,this.error, this.data });
}

SubsMarkdownExceptionModel subsMarkdownExceptionResponseFromJson(String str) => SubsMarkdownExceptionModel.fromJson(json.decode(str));

String subsMarkdownExceptionResponseToJson(SubsMarkdownExceptionModel data) => json.encode(data.toJson());

class SubsMarkdownExceptionModel {
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;
  final String? nextPage;
  final int? previousPage;
  final List<ExceptionData>? data;

  SubsMarkdownExceptionModel({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
  });

  factory SubsMarkdownExceptionModel.fromJson(Map<String, dynamic> json) => SubsMarkdownExceptionModel(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: json["data"] == null ? [] : List<ExceptionData>.from(json["data"]!.map((x) => ExceptionData.fromJson(x))),
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

class ExceptionData extends ClassMappingModel<ExceptionData> {
  final String? weekId;
  final double? toPercent;
  final int? toPrice;
  final String? departmentCode;
  final String? divisionCode;
  final String? classCode;
  final int? lowFromPrice;
  final int? highFromPrice;
  final String? storeNumber;

  ExceptionData({
    this.weekId,
    this.toPercent,
    this.toPrice,
    this.departmentCode,
    this.divisionCode,
    this.lowFromPrice,
    this.highFromPrice,
    this.storeNumber,
    this.classCode
  });

  factory ExceptionData.fromJson(Map<String, dynamic> json) => ExceptionData(
    weekId: json["weekId"] ?? '',
    toPercent: json["toPercent"],
    toPrice: json["toPrice"],
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    classCode: json["classCode"],
    lowFromPrice: json["lowFromPrice"],
    highFromPrice: json["highFromPrice"],
    storeNumber: json["storeNumber"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "toPercent": toPercent,
    "toPrice": toPrice,
    "departmentCode": departmentCode,
    "divisionCode": divisionCode,
    "lowFromPrice": lowFromPrice,
    "highFromPrice": highFromPrice,
    "classCode": classCode,
    "storeNumber": storeNumber,
  };

  @override
  ExceptionData fromJson(Map<String, dynamic> json) => ExceptionData(
    weekId: json["weekId"] ?? '',
    toPercent: json["toPercent"],
    toPrice: json["toPrice"],
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    classCode: json["classCode"],
    lowFromPrice: json["lowFromPrice"],
    highFromPrice: json["highFromPrice"],
    storeNumber: json["storeNumber"],
  );

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "weekId": "'$weekId'",
      "toPercent": toPercent,
      "toPrice": toPrice,
      "departmentCode": "'$departmentCode'",
      "divisionCode": "'$divisionCode'",
      "lowFromPrice": lowFromPrice,
      "highFromPrice": highFromPrice,
      "classCode": "'$classCode'",
      "storeNumber": "'$storeNumber'",
    };
  }

  static String tableVariables() {
    var value = '''
    weekId TEXT,
    toPercent REAL,
    toPrice INTEGER,
    departmentCode TEXT,
    divisionCode TEXT,
    lowFromPrice INTEGER,
    highFromPrice INTEGER,
    classCode TEXT,
    storeNumber TEXT
    ''';
    return value;
  }
}
