// To parse this JSON data, do
//
//     final performSgmPostDataModel = performSgmPostDataModelFromJson(jsonString);

import 'dart:convert';

PerformSgmPostDataModel performSgmPostDataModelFromJson(String str) => PerformSgmPostDataModel.fromJson(json.decode(str));

String performSgmPostDataModelToJson(PerformSgmPostDataModel data) => json.encode(data.toJson());

class PerformSgmPostDataModel {
  String? departmentCode;
  String? divisionCode;
  String? storeNumber;
  String? reasonCode;
  String? originCode;
  String? style;
  String? uline;
  String? userId;
  String? deviceType;
  String? deviceId;
  int? fromPrice;
  int? toPrice;
  String? category;
  int quantity;
  bool isKeyed;
  String itemSize;
  String type;
  String pieces;
  String method;
  String authorizingUserId;

  PerformSgmPostDataModel({
    required this.departmentCode,
    required this.divisionCode,
    required this.storeNumber,
    required this.reasonCode,
    required this.originCode,
    required this.style,
    required this.uline,
    required this.userId,
    required this.deviceType,
    required this.deviceId,
    required this.fromPrice,
    required this.toPrice,
    required this.category,
    required this.quantity,
    required this.isKeyed,
    required this.itemSize,
    required this.type,
    required this.pieces,
    required this.method,
    required this.authorizingUserId,
  });

  factory PerformSgmPostDataModel.fromJson(Map<String, dynamic> json) => PerformSgmPostDataModel(
    departmentCode: json["departmentCode"],
    divisionCode: json["divisionCode"],
    storeNumber: json["storeNumber"],
    reasonCode: json["reasonCode"],
    originCode: json["originCode"],
    style: json["style"],
    uline: json["uline"],
    userId: json["userId"],
    deviceType: json["deviceType"],
    deviceId: json["deviceId"],
    fromPrice: json["fromPrice"],
    toPrice: json["toPrice"],
    category: json["category"],
    quantity: json["quantity"],
    isKeyed: json["isKeyed"],
    itemSize: json["itemSize"],
    type: json["type"],
    pieces: json["pieces"],
    method: json["method"],
    authorizingUserId: json["authorizingUserId"],
  );

  Map<String, dynamic> toJson() => {
    "departmentCode": departmentCode,
    "divisionCode": divisionCode,
    "storeNumber": storeNumber,
    "reasonCode": reasonCode,
    "originCode": originCode,
    "style": style,
    "uline": uline,
    "userId": userId,
    "deviceType": deviceType,
    "deviceId": deviceId,
    "fromPrice": fromPrice,
    "toPrice": toPrice,
    "category": category,
    "quantity": quantity,
    "isKeyed": isKeyed,
    "itemSize": itemSize,
    "type": type,
    "pieces": pieces,
    "method": method,
    "authorizingUserId": authorizingUserId,
  };
}
