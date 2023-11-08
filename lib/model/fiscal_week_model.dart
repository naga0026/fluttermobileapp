import 'dart:convert';

List<FiscalWeekDefinition> fiscalWeekDefinitionFromJson(String str) =>
    List<FiscalWeekDefinition>.from(
        json.decode(str).map((x) => FiscalWeekDefinition.fromJson(x)));

String fiscalWeekDefinitionToJson(List<FiscalWeekDefinition> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FiscalWeekDefinition {
  String fiscalYear;
  String fiscalWeek;

  FiscalWeekDefinition({
    required this.fiscalYear,
    required this.fiscalWeek,
  });

  factory FiscalWeekDefinition.fromJson(Map<String, dynamic> json) =>
      FiscalWeekDefinition(
        fiscalYear: json["FiscalYear"],
        fiscalWeek: json["FiscalWeek"],
      );

  Map<String, dynamic> toJson() => {
        "FiscalYear": fiscalYear,
        "FiscalWeek": fiscalWeek,
      };
}
