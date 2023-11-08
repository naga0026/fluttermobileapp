import 'dart:convert';

import '../../../../utility/generic/mapping_model.dart';

class SubsMarkdownsClassUlineResponse {
  int status;
  String? error;
  SubsMarkdownUlineClassModel? data;

  SubsMarkdownsClassUlineResponse(
      {required this.status, this.error, this.data});
}

SubsMarkdownUlineClassModel subsMarkdownUlineClassResponseFromJson(
        String str) =>
    SubsMarkdownUlineClassModel.fromJson(json.decode(str));

String subsMarkdownUlineClassResponseToJson(SubsMarkdownUlineClassModel data) =>
    json.encode(data.toJson());

class SubsMarkdownUlineClassModel {
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;
  final String? nextPage;
  final dynamic previousPage;
  final List<UlineClassData>? data;

  SubsMarkdownUlineClassModel({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
  });

  factory SubsMarkdownUlineClassModel.fromJson(Map<String, dynamic> json) =>
      SubsMarkdownUlineClassModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
        nextPage: json["nextPage"],
        previousPage: json["previousPage"],
        data: json["data"] == null
            ? []
            : List<UlineClassData>.from(
                json["data"]!.map((x) => UlineClassData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalPages": totalPages,
        "totalRecords": totalRecords,
        "nextPage": nextPage,
        "previousPage": previousPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class UlineClassData extends ClassMappingModel<UlineClassData> {
  final String? uline;
  final String? classCode;

  UlineClassData({
    this.uline,
    this.classCode,
  });

  factory UlineClassData.fromJson(Map<String, dynamic> json) => UlineClassData(
        uline: json["uline"],
        classCode: json["classCode"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "uline": uline,
        "classCode": classCode,
      };

  @override
  UlineClassData fromJson(Map<String, dynamic> json) => UlineClassData(
        uline: json["uline"],
        classCode: json["classCode"],
      );

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "uline": "'$uline'",
      "classCode": "'$classCode'",
    };
  }

  static String tableVariables() {
    var value = '''
    uline TEXT,
    classCode TEXT
    ''';
    return value;
  }
}
