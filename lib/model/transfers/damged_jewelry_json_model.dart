
import 'dart:convert';

List<DamagedJeweleryModel> damagedJeweleryModelFromJson(String str) => List<DamagedJeweleryModel>.from(json.decode(str).map((x) => DamagedJeweleryModel.fromJson(x)));

String damagedJeweleryModelToJson(List<DamagedJeweleryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DamagedJeweleryModel {
  String currentDivision;
  String returnDivisionId;
  String returnStoreNumberId;
  dynamic alternateReturnDivisionId;
  dynamic alternateReturnStoreNumberId;

  DamagedJeweleryModel({
    required this.currentDivision,
    required this.returnDivisionId,
    required this.returnStoreNumberId,
    required this.alternateReturnDivisionId,
    required this.alternateReturnStoreNumberId,
  });

  factory DamagedJeweleryModel.fromJson(Map<String, dynamic> json) => DamagedJeweleryModel(
    currentDivision: json["CurrentDivision"],
    returnDivisionId: json["ReturnDivisionId"],
    returnStoreNumberId: json["ReturnStoreNumberId"],
    alternateReturnDivisionId: json["AlternateReturnDivisionId"],
    alternateReturnStoreNumberId: json["AlternateReturnStoreNumberId"],
  );

  Map<String, dynamic> toJson() => {
    "CurrentDivision": currentDivision,
    "ReturnDivisionId": returnDivisionId,
    "ReturnStoreNumberId": returnStoreNumberId,
    "AlternateReturnDivisionId": alternateReturnDivisionId,
    "AlternateReturnStoreNumberId": alternateReturnStoreNumberId,
  };
}
