import 'dart:convert';

EndItemToBoxTransferModel endItemToBoxTransferModelFromJson(String str) => EndItemToBoxTransferModel.fromJson(json.decode(str));

String endItemToBoxTransferModelToJson(EndItemToBoxTransferModel data) => json.encode(data.toJson());

class EndItemToBoxTransferModel {
  String currentDivision;
  String currentStore;
  String userId;
  String controlNumber;
  int transferDirection;
  int transferType;
  String? alternativeShippingDivision;
  String? alternativeShippingLocation;

  EndItemToBoxTransferModel({
    required this.currentDivision,
    required this.currentStore,
    required this.userId,
    required this.controlNumber,
    required this.transferDirection,
    required this.transferType,
    required this.alternativeShippingDivision,
    required this.alternativeShippingLocation,
  });

  factory EndItemToBoxTransferModel.fromJson(Map<String, dynamic> json) => EndItemToBoxTransferModel(
    currentDivision: json["currentDivision"],
    currentStore: json["currentStore"],
    userId: json["userId"],
    controlNumber: json["controlNumber"],
    transferDirection: json["transferDirection"],
    transferType: json["transferType"],
    alternativeShippingDivision: json["alternativeShippingDivision"],
    alternativeShippingLocation: json["alternativeShippingLocation"],
  );

  Map<String, dynamic> toJson() => {
    "currentDivision": currentDivision,
    "currentStore": currentStore,
    "userId": userId,
    "controlNumber": controlNumber,
    "transferDirection": transferDirection,
    "transferType": transferType,
    "alternativeShippingDivision": alternativeShippingDivision,
    "alternativeShippingLocation": alternativeShippingLocation,
  };
}
