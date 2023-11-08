// To parse this JSON data, do
//
//     final priceThresholdParameters = priceThresholdParametersFromJson(jsonString);

import 'dart:convert';

List<PriceThresholdParameters> priceThresholdParametersFromJson(String str) => List<PriceThresholdParameters>.from(json.decode(str).map((x) => PriceThresholdParameters.fromJson(x)));

String priceThresholdParametersToJson(List<PriceThresholdParameters> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PriceThresholdParameters {
  String divisionCode;
  String threshold;

  PriceThresholdParameters({
    required this.divisionCode,
    required this.threshold,
  });

  factory PriceThresholdParameters.fromJson(Map<String, dynamic> json) => PriceThresholdParameters(
    divisionCode: json["DivisionCode"],
    threshold: json["Threshold"],
  );

  Map<String, dynamic> toJson() => {
    "DivisionCode": divisionCode,
    "Threshold": threshold,
  };
}
