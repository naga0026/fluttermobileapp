import 'dart:convert';

import '../utility/generic/mapping_model.dart';

InitialMarkdownCandidate initialMarkdownCandidateFromJson(String str) => InitialMarkdownCandidate.fromJson(json.decode(str));

String initialMarkdownCandidateToJson(InitialMarkdownCandidate data) => json.encode(data.toJson());

class InitialMarkdownCandidate extends ClassMappingModel<InitialMarkdownCandidate>{
  final String weekId;
  final DateTime startDate;
  final String weekStatus;
  final String style;
  final String uline;
  final String departmentCode;
  final int fromPrice;
  final int toPrice;
  final int mluPercent;
  final int initialPercent;
  final bool isPriceAdjustment;
  final String classCode;
  final String divisionCode;

  InitialMarkdownCandidate({
    required this.weekId,
    required this.startDate,
    required this.weekStatus,
    required this.style,
    required this.uline,
    required this.departmentCode,
    required this.fromPrice,
    required this.toPrice,
    required this.mluPercent,
    required this.initialPercent,
    required this.isPriceAdjustment,
    required this.classCode,
    required this.divisionCode,
  });

  factory InitialMarkdownCandidate.fromJson(Map<String, dynamic> json) => InitialMarkdownCandidate(
    weekId: json["weekId"],
    startDate: DateTime.parse(json["startDate"]),
    weekStatus: json["weekStatus"],
    style: json["style"],
    uline: json["uline"],
    departmentCode: json["departmentCode"],
    fromPrice: json["fromPrice"],
    toPrice: json["toPrice"],
    mluPercent: json["mluPercent"],
    initialPercent: json["initialPercent"],
    isPriceAdjustment: json["isPriceAdjustment"],
    classCode: json["classCode"],
    divisionCode: json["divisionCode"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "startDate": startDate.toIso8601String(),
    "weekStatus": weekStatus,
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
  InitialMarkdownCandidate fromJson(Map<String, dynamic> json) {
    return InitialMarkdownCandidate(
      weekId: json["weekId"],
      startDate: DateTime.parse(json["startDate"]),
      weekStatus: json["weekStatus"],
      style: json["style"],
      uline: json["uline"],
      departmentCode: json["departmentCode"],
      fromPrice: json["fromPrice"],
      toPrice: json["toPrice"],
      mluPercent: json["mluPercent"],
      initialPercent: json["initialPercent"],
      isPriceAdjustment: json["isPriceAdjustment"],
      classCode: json["classCode"],
      divisionCode: json["divisionCode"],
    );
  }

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "weekId": "'$weekId'",
      "startDate": "'${startDate.toIso8601String()}'",
      "weekStatus": "'$weekStatus'",
      "style": "'$style'",
      "uline": "'$uline'",
      "departmentCode": "'$departmentCode'",
      "fromPrice": fromPrice,
      "toPrice": toPrice,
      "mluPercent": mluPercent,
      "initialPercent": initialPercent,
      "isPriceAdjustment": "'$isPriceAdjustment'",
      "classCode": "'$classCode'",
      "divisionCode": "'$divisionCode'",
    };
  }

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
}