import 'dart:convert';

import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/utility/enums/week_status.dart';
import 'package:get/get.dart';

import '../../../../../utility/generic/mapping_model.dart';

class GetInitialMarkdownResponse {
  int status;
  InitialsSubsResponseModel? markdownsData;
  String? error;

  GetInitialMarkdownResponse(
      {required this.status, this.markdownsData, this.error});
}

InitialsSubsResponseModel initialsSubsModelFromJson(String str) =>
    InitialsSubsResponseModel().fromJson(json.decode(str));

String initialsSubsModelToJson(InitialsSubsResponseModel data) =>
    json.encode(data.toJson());

class InitialsSubsResponseModel
    extends ClassMappingModel<InitialsSubsResponseModel> {
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;
  final String? nextPage;
  final dynamic previousPage;
  final List<MarkdownData>? data;

  InitialsSubsResponseModel({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
  });

  @override
  fromJson(Map<String, dynamic> json) => InitialsSubsResponseModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
        nextPage: json["nextPage"],
        previousPage: json["previousPage"],
        data: List<MarkdownData>.from(
            json["data"].map((x) => MarkdownData().fromJson(x))),
      );

  @override
  toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalPages": totalPages,
        "totalRecords": totalRecords,
        "nextPage": nextPage,
        "previousPage": previousPage,
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
      };
}

List<MarkdownData> markdownDataFromJson(String str) => List<MarkdownData>.from(
    json.decode(str).map((x) => MarkdownData.fromJson(x)));

class MarkdownData extends ClassMappingModel<MarkdownData> {
  final String? weekId;
  final DateTime? startDate;
  final WeekStatus? weekStatus;
  String? style;
  String? uline;
  String? departmentCode;
  String? fromPrice;
  String? toPrice;
  final int? mluPercent;
  final int? initialPercent;
  final bool? isPriceAdjustment;
  final String? classCode;
  String? divisionCode;

  MarkdownData({
    this.weekId,
    this.startDate,
    this.weekStatus,
    this.style,
    this.uline,
    this.departmentCode,
    this.fromPrice,
    this.toPrice,
    this.mluPercent,
    this.initialPercent,
    this.isPriceAdjustment,
    this.classCode,
    this.divisionCode,
  });

  factory MarkdownData.fromJson(Map<String, dynamic> json) => MarkdownData(
        weekId: json["weekId"],
        startDate: DateTime.parse(json["startDate"]),
        weekStatus: weekStatusValues.map[json["weekStatus"]]!,
        style: json["style"],
        uline: json["uline"],
        departmentCode: json["departmentCode"],
        fromPrice: json["fromPrice"].toString(),
        toPrice: json["toPrice"].toString(),
        mluPercent: json["mluPercent"],
        initialPercent: json["initialPercent"],
        isPriceAdjustment: (json["isPriceAdjustment"]).runtimeType == bool
            ? json["isPriceAdjustment"]
            : json["isPriceAdjustment"] == "false"
                ? false
                : true,
        classCode: json["classCode"],
        divisionCode: json["divisionCode"],
      );

  @override
  fromJson(Map<String, dynamic> json) => MarkdownData(
        weekId: json["weekId"],
        startDate: DateTime.parse(json["startDate"]),
        weekStatus: weekStatusValues.map[json["weekStatus"]]!,
        style: json["style"],
        uline: json["uline"],
        departmentCode: json["departmentCode"],
        fromPrice: json["fromPrice"].toString(),
        toPrice: json["toPrice"].toString(),
        mluPercent: json["mluPercent"],
        initialPercent: json["initialPercent"],
        isPriceAdjustment: (json["isPriceAdjustment"]).runtimeType == bool
            ? json["isPriceAdjustment"]
            : json["isPriceAdjustment"] == "false"
                ? false
                : true,
        classCode: json["classCode"],
        divisionCode: json["divisionCode"],
      );

  @override
  toJson() => {
        "weekId": weekId,
        "startDate": startDate?.toIso8601String() ?? "",
        "weekStatus": weekStatusValues.reverse[weekStatus],
        "style": style,
        "uline": uline,
        "departmentCode": departmentCode,
        "fromPrice": fromPrice,
        "toPrice": toPrice,
        "mluPercent": mluPercent,
        "initialPercent": initialPercent,
        "isPriceAdjustment": isPriceAdjustment,
        "classCode": classCode,
        "divisionCode": divisionCode,
      };

  @override
  toJsonForDB() => {
        "weekId": "'$weekId'",
        "startDate": "'${startDate?.toIso8601String() ?? ""}'",
        "weekStatus": "'${weekStatusValues.reverse[weekStatus]}'",
        "style": "'$style'",
        "uline": "'$uline'",
        "departmentCode": "'$departmentCode'",
        "fromPrice": "'$fromPrice'",
        "toPrice": "'$toPrice'",
        "mluPercent": mluPercent,
        "initialPercent": initialPercent,
        "isPriceAdjustment": "'$isPriceAdjustment'",
        "classCode": "'$classCode'",
        "divisionCode": "'$divisionCode'",
      };

  static String tableVariables() {
    var value = '''
    weekId TEXT,
    startDate TEXT,
    weekStatus TEXT,
    style TEXT,
    uline TEXT,
    departmentCode TEXT,
    fromPrice INTEGER,
    toPrice INTEGER,
    mluPercent INTEGER,
    initialPercent INTEGER,
    isPriceAdjustment TEXT,
    classCode TEXT,
    divisionCode TEXT
    ''';
    return value;
  }

  String get weekNumber {
    return weekId != null ? weekId!.substring(0, 2) : '';
  }

  Map<String, dynamic> findMarkdownDataInDBQuery({String? openWeekId}) {
    final storeConfigController = Get.find<StoreConfigController>();
    Map<String, dynamic> data = {};
    if (storeConfigController.isMarshallsUSA()) {
      if (uline != null) {
        data["uline"] = "\'$uline\'";
      }
    } else {
      if (style != null) {
        data["style"] = "\'$style\'";
      }
    }
    data["departmentCode"] = "\'$departmentCode\'";
    if (openWeekId != null) {
      data["weekId"] = "\'$openWeekId\'";
    }
    if (divisionCode != null) {
      data["divisionCode"] = "\'$divisionCode\'";
    }
    if (fromPrice != null) {
      data["fromPrice"] = "\'$fromPrice\'";
    }
    if (toPrice != null) {
      data["toPrice"] = "\'$toPrice\'";
    }
    return data;
  }
}
