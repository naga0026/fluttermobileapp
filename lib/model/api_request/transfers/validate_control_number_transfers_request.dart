
import 'dart:convert';

ValidateControlNumberModel validateControlNumberModelFromJson(String str) => ValidateControlNumberModel.fromJson(json.decode(str));

String validateControlNumberModelToJson(ValidateControlNumberModel data) => json.encode(data.toJson());

class ValidateControlNumberModel {
  String divisionNumber;
  String storeNumber;
  String controlNumber;
  int transferType;
  int transferRequestType;

  ValidateControlNumberModel({
    required this.divisionNumber,
    required this.storeNumber,
    required this.controlNumber,
    required this.transferType,
    required this.transferRequestType,
  });

  factory ValidateControlNumberModel.fromJson(Map<String, dynamic> json) => ValidateControlNumberModel(
    divisionNumber: json["DivisionNumber"],
    storeNumber: json["StoreNumber"],
    controlNumber: json["ControlNumber"],
    transferType: json["TransferType"],
    transferRequestType: json["TransferRequestType"],
  );

  Map<String, dynamic> toJson() => {
    "DivisionNumber": divisionNumber,
    "StoreNumber": storeNumber,
    "ControlNumber": controlNumber,
    "TransferType": transferType,
    "TransferRequestType": transferRequestType,
  };
}
