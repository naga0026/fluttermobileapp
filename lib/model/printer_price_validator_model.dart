import 'dart:convert';

PriceValidationParameters priceValidationParametersFromJson(String str) => PriceValidationParameters.fromJson(json.decode(str));

String priceValidationParametersToJson(PriceValidationParameters data) => json.encode(data.toJson());

class PriceValidationParameters {
  List<ValidPrice> validPrices;

  PriceValidationParameters({
    required this.validPrices,
  });

  factory PriceValidationParameters.fromJson(Map<String, dynamic> json) => PriceValidationParameters(
    validPrices: List<ValidPrice>.from(json["ValidPrices"].map((x) => ValidPrice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ValidPrices": List<dynamic>.from(validPrices.map((x) => x.toJson())),
  };
}

class ValidPrice {
  String divisionCode;
  List<String> initial;
  List<String> sub;

  ValidPrice({
    required this.divisionCode,
    required this.initial,
    required this.sub,
  });

  factory ValidPrice.fromJson(Map<String, dynamic> json) => ValidPrice(
    divisionCode: json["DivisionCode"],
    initial: List<String>.from(json["Initial"].map((x) => x)),
    sub: List<String>.from(json["Sub"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "DivisionCode": divisionCode,
    "Initial": List<dynamic>.from(initial.map((x) => x)),
    "Sub": List<dynamic>.from(sub.map((x) => x)),
  };
}
