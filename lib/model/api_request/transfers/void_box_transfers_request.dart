import 'dart:convert';

VoidBoxTransferModel voidBoxTransferModelFromJson(String str) => VoidBoxTransferModel.fromJson(json.decode(str));

String voidBoxTransferModelToJson(VoidBoxTransferModel data) => json.encode(data.toJson());

class VoidBoxTransferModel {
  String currentDivision;
  String currentStore;
  String userId;
  String controlNumber;
  int transferDirection;
  int transferType;

  VoidBoxTransferModel({
    required this.currentDivision,
    required this.currentStore,
    required this.userId,
    required this.controlNumber,
    required this.transferDirection,
    required this.transferType,
  });

  factory VoidBoxTransferModel.fromJson(Map<String, dynamic> json) => VoidBoxTransferModel(
    currentDivision: json["currentDivision"],
    currentStore: json["currentStore"],
    userId: json["userId"],
    controlNumber: json["controlNumber"],
    transferDirection: json["transferDirection"],
    transferType: json["transferType"],
  );

  Map<String, dynamic> toJson() => {
    "currentDivision": currentDivision,
    "currentStore": currentStore,
    "userId": userId,
    "controlNumber": controlNumber,
    "transferDirection": transferDirection,
    "transferType": transferType,
  };
}
