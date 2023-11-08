import 'dart:convert';

List<OriginReasonModel> originAndReasonModelFromJson(String str) =>
    List<OriginReasonModel>.from(
        json.decode(str).map((x) => OriginReasonModel().fromJson(x)));

String originAndReasonModelToJson(List<OriginReasonModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OriginReasonModel {
  final String? code;
  final bool? isZeroPrice;
  final String? shortDescription;

  OriginReasonModel({
    this.code,
    this.isZeroPrice,
    this.shortDescription,
  });

  OriginReasonModel fromJson(Map<String, dynamic> json) {
    return OriginReasonModel(
      code: json["code"],
      isZeroPrice: json["isZeroPrice"] ?? false,
      shortDescription: json["shortDescription"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "isZeroPrice": isZeroPrice,
      "shortDescription": shortDescription,
    };
  }
}
