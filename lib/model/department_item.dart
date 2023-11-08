import 'dart:convert';

import 'package:base_project/utility/generic/mapping_model.dart';

List<GetDepartmentData> getDepartmentDataFromJson(String str) => List<GetDepartmentData>.from(json.decode(str).map((x) => GetDepartmentData.fromJson(x)));

String getDepartmentDataToJson(List<GetDepartmentData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetDepartmentData extends ClassMappingModel<GetDepartmentData>{
  final String code;
  final String division;
  final String requestingDivision;

  GetDepartmentData({
    required this.code,
    required this.division,
    required this.requestingDivision,
  });

  factory GetDepartmentData.fromJson(Map<String, dynamic> json) => GetDepartmentData(
    code: json["code"],
    division: json["division"],
    requestingDivision: json["requestingDivision"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "code": code,
    "division": division,
    "requestingDivision": requestingDivision,
  };


  @override
  GetDepartmentData fromJson(Map<String, dynamic> json) {
    return GetDepartmentData(
      code: json["code"],
      division: json["division"],
      requestingDivision: json["requestingDivision"],
    );
  }

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "code": "'$code'",
      "division": "'$division'",
      "requestingDivision": "'$requestingDivision'",
    };
  }

  static String tableVariables() {
    var value = '''
    code TEXT,
    division TEXT,
    requestingDivision TEXT
    ''';
    return value;
  }
}
