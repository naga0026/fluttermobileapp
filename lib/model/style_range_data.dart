import 'dart:convert';

import 'package:base_project/utility/generic/mapping_model.dart';

List<GetStyleRangeData> getStyleRangeDataFromJson(String str) => List<GetStyleRangeData>.from(json.decode(str).map((x) => GetStyleRangeData.fromJson(x)));

String getStyleRangeDataToJson(List<GetStyleRangeData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetStyleRangeData extends ClassMappingModel<GetStyleRangeData> {
  final String department;
  final String chain;
  final int startRange;
  final int endRange;

  GetStyleRangeData({
    required this.department,
    required this.chain,
    required this.startRange,
    required this.endRange,
  });

  factory GetStyleRangeData.fromJson(Map<String, dynamic> json) => GetStyleRangeData(
    department: json["department"],
    chain: json["chain"],
    startRange: json["startRange"],
    endRange: json["endRange"],
  );

  @override
  GetStyleRangeData fromJson(Map<String, dynamic> json)=> GetStyleRangeData(
    department: json["department"],
    chain: json["chain"],
    startRange: json["startRange"],
    endRange: json["endRange"],
  );


  @override
  Map<String, dynamic> toJson() => {
    "department": department,
    "chain": chain,
    "startRange": startRange,
    "endRange": endRange,
  };

  @override
  Map<String, dynamic> toJsonForDB() {
    return {
      "department": "'$department'",
      "chain": "'$chain'",
      "startRange": startRange,
      "endRange": endRange,
    };
  }

  static String tableVariables() {
    var value = '''
    department TEXT,
    chain TEXT,
    startRange INTEGER,
    endRange INTEGER
    ''';
    return value;
  }

}
