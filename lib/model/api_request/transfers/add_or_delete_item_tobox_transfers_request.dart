import 'dart:convert';

AddORDeleteItemToBoxTransferModel addORDeleteItemToBoxTransferModelFromJson(String str) => AddORDeleteItemToBoxTransferModel.fromJson(json.decode(str));

String addORDeleteItemToBoxTransferModelToJson(AddORDeleteItemToBoxTransferModel data) => json.encode(data.toJson());

class AddORDeleteItemToBoxTransferModel {
  String? controlNumber;
  String? division;
  String? storeNumber;
  String? department;
  String? style;
  int? price;
  int? transferDirection;

  AddORDeleteItemToBoxTransferModel({
     this.controlNumber,
     this.division,
     this.storeNumber,
     this.department,
     this.style,
     this.price,
     this.transferDirection,
  });

  factory AddORDeleteItemToBoxTransferModel.fromJson(Map<String, dynamic> json) => AddORDeleteItemToBoxTransferModel(
    controlNumber: json["controlNumber"]??"",
    division: json["division"]??"",
    storeNumber: json["storeNumber"]??"",
    department: json["department"]??"",
    style: json["style"]??"",
    price: json["price"]??"",
    transferDirection: json["transferDirection"]??"",
  );

  Map<String, dynamic> toJson() => {
    "controlNumber": controlNumber,
    "division": division,
    "storeNumber": storeNumber,
    "department": department,
    "style": style,
    "price": price,
    "transferDirection": transferDirection,
  };
}
