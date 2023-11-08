import 'dart:convert';

InquireBoxModelT inquireBoxModelTFromJson(String str) => InquireBoxModelT.fromJson(json.decode(str));

String inquireBoxModelTToJson(InquireBoxModelT data) => json.encode(data.toJson());

class InquireBoxModelT {
  String quantityOfItems;
  String controlNumber;
  String storeNumber;
  int transferType;
  DateTime? transmittedDate;
  String fromStore;
  String toStore;
  int boxState;

  InquireBoxModelT({
    required this.quantityOfItems,
    required this.controlNumber,
    required this.storeNumber,
    required this.transferType,
    required this.transmittedDate,
    required this.fromStore,
    required this.toStore,
    required this.boxState,
  });

  factory InquireBoxModelT.fromJson(Map<String, dynamic> json) => InquireBoxModelT(
    quantityOfItems: json["quantityOfItems"],
    controlNumber: json["controlNumber"],
    storeNumber: json["storeNumber"],
    transferType: json["transferType"],
    transmittedDate: json["transmittedDate"]==null?null:DateTime.parse(json["transmittedDate"]),
    fromStore: json["fromStore"],
    toStore: json["toStore"],
    boxState: json["boxState"],
  );

  Map<String, dynamic> toJson() => {
    "quantityOfItems": quantityOfItems,
    "controlNumber": controlNumber,
    "storeNumber": storeNumber,
    "transferType": transferType,
    "transmittedDate": transmittedDate!.toIso8601String(),
    "fromStore": fromStore,
    "toStore": toStore,
    "boxState": boxState,
  };
}
