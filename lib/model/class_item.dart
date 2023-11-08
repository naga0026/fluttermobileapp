import 'dart:convert';

import 'package:base_project/utility/generic/mapping_model.dart';

List<GetClassData> getClassDataFromJson(String str) => List<GetClassData>.from(
    json.decode(str).map((x) => GetClassData.fromJson(x)));

String getClassDataToJson(List<GetClassData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetClassData extends ClassMappingModel<GetClassData> {
  final String classCode;
  final String departmentCode;
  final String divisionCode;

  GetClassData({
    required this.classCode,
    required this.departmentCode,
    required this.divisionCode,
  });

  factory GetClassData.fromJson(Map<String, dynamic> json) => GetClassData(
        classCode: json["classCode"],
        departmentCode: json["departmentCode"],
        divisionCode: json["divisionCode"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "classCode": classCode,
        "departmentCode": departmentCode,
        "divisionCode": divisionCode,
      };

  @override
  GetClassData fromJson(Map<String, dynamic> json) {
    return GetClassData(
      classCode: json["classCode"],
      departmentCode: json["departmentCode"],
      divisionCode: json["divisionCode"],
    );
  }

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "classCode": "'$classCode'",
      "departmentCode": "'$departmentCode'",
      "divisionCode": "'$divisionCode'",
    };
  }

  static String tableVariables() {
    var value = '''
    classCode TEXT,
    departmentCode TEXT,
    divisionCode TEXT
    ''';
    return value;
  }
}
