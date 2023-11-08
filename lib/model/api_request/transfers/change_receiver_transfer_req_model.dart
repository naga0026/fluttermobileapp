import 'dart:convert';

ChangeReceiverTransfersModel changeReceiverTransfersModelFromJson(String str) => ChangeReceiverTransfersModel.fromJson(json.decode(str));

String changeReceiverTransfersModelToJson(ChangeReceiverTransfersModel data) => json.encode(data.toJson());

class ChangeReceiverTransfersModel {
  String currentDivision;
  String currentStore;
  String userId;
  String controlNumber;
  String oldReceiverDivision;
  String oldReceiverId;
  String newReceiverDivision;
  String newReceiverId;
  int transferType;

  ChangeReceiverTransfersModel({
    required this.currentDivision,
    required this.currentStore,
    required this.userId,
    required this.controlNumber,
    required this.oldReceiverDivision,
    required this.oldReceiverId,
    required this.newReceiverDivision,
    required this.newReceiverId,
    required this.transferType,
  });

  factory ChangeReceiverTransfersModel.fromJson(Map<String, dynamic> json) => ChangeReceiverTransfersModel(
    currentDivision: json["currentDivision"],
    currentStore: json["currentStore"],
    userId: json["userId"],
    controlNumber: json["controlNumber"],
    oldReceiverDivision: json["oldReceiverDivision"],
    oldReceiverId: json["oldReceiverId"],
    newReceiverDivision: json["newReceiverDivision"],
    newReceiverId: json["newReceiverId"],
    transferType: json["transferType"],
  );

  Map<String, dynamic> toJson() => {
    "currentDivision": currentDivision,
    "currentStore": currentStore,
    "userId": userId,
    "controlNumber": controlNumber,
    "oldReceiverDivision": oldReceiverDivision,
    "oldReceiverId": oldReceiverId,
    "newReceiverDivision": newReceiverDivision,
    "newReceiverId": newReceiverId,
    "transferType": transferType,
  };
}
