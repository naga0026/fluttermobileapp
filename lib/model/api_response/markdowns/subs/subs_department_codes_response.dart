import 'dart:convert';

import '../../../../utility/enums/week_status.dart';
import '../../../../utility/generic/mapping_model.dart';

class SubsMarkdownsDepartmentCodesResponse {
  int status;
  String? error;
  SubsDepartmentCodeModel? data;

  SubsMarkdownsDepartmentCodesResponse({required this.status,this.error, this.data });
}

SubsDepartmentCodeModel subsMarkdownDepartmentCodesResponseFromJson(String str) => SubsDepartmentCodeModel.fromJson(json.decode(str));

String subsMarkdownDepartmentCodesResponseToJson(SubsDepartmentCodeModel data) => json.encode(data.toJson());

class SubsDepartmentCodeModel {
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;
  final String? nextPage;
  final dynamic previousPage;
  final List<SubsDepartmentData>? data;

  SubsDepartmentCodeModel({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
  });

  factory SubsDepartmentCodeModel.fromJson(Map<String, dynamic> json) => SubsDepartmentCodeModel(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: json["data"] == null ? [] : List<SubsDepartmentData>.from(json["data"]!.map((x) => SubsDepartmentData.fromJson(x))),
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

class SubsDepartmentData extends ClassMappingModel<SubsDepartmentData>{
  final String? weekId;
  final String? department;
  final WeekStatus? weekStatus;

  SubsDepartmentData({
    this.weekId,
    this.department,
    this.weekStatus,
  });

  factory SubsDepartmentData.fromJson(Map<String, dynamic> json) => SubsDepartmentData(
    weekId: json["weekId"],
    department: json["department"],
    weekStatus: weekStatusValues.map[json["weekStatus"]]!,
  );

  @override
  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "department": department,
    "weekStatus": weekStatusValues.reverse[weekStatus],
  };

  @override
  SubsDepartmentData fromJson(Map<String, dynamic> json) => SubsDepartmentData(
    weekId: json["weekId"],
    department: json["department"],
    weekStatus: weekStatusValues.map[json["weekStatus"]]!,
  );

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "weekId": "'$weekId'",
      "department": "'$department'",
      "weekStatus": "'${weekStatusValues.reverse[weekStatus]}'",
    };
  }

  static String tableVariables() {
    var value = '''
    weekId TEXT,
    department TEXT,
    weekStatus TEXT
    ''';
    return value;
  }
}
