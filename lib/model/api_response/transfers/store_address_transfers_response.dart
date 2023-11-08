
import 'dart:convert';

StoreAddressResponse storeAddressResponseFromJson(String str) => StoreAddressResponse.fromJson(json.decode(str));

String storeAddressResponseToJson(StoreAddressResponse data) => json.encode(data.toJson());

class StoreAddressResponse {
  int responseCode;
  Data? data;

  StoreAddressResponse({
    required this.responseCode,
    required this.data,
  });

  factory StoreAddressResponse.fromJson(Map<String, dynamic> json) => StoreAddressResponse(
    responseCode: json["responseCode"],
    data: Data.fromJson(json["data"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data!.toJson(),
  };
}

class Data {
  String? locationId;
  String? divisionName;
  String? storeAddress1;
  String? storeAddress2;
  String? storeAddress3;
  String? postalCode1;
  String? postalCode2;

  Data({
    required this.locationId,
    required this.divisionName,
    required this.storeAddress1,
    required this.storeAddress2,
    required this.storeAddress3,
    required this.postalCode1,
    required this.postalCode2,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    locationId: json["locationId"]??"",
    divisionName: json["divisionName"]??"",
    storeAddress1: json["storeAddress1"]??"",
    storeAddress2: json["storeAddress2"]??"",
    storeAddress3: json["storeAddress3"]??"",
    postalCode1: json["postalCode1"]??"",
    postalCode2: json["postalCode2"]??"",
  );

  Map<String, dynamic> toJson() => {
    "locationId": locationId,
    "divisionName": divisionName,
    "storeAddress1": storeAddress1,
    "storeAddress2": storeAddress2,
    "storeAddress3": storeAddress3,
    "postalCode1": postalCode1,
    "postalCode2": postalCode2,
  };
}
