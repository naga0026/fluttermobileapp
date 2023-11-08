import 'dart:convert';

EndBoxTransfersResponse endBoxTransfersResponseFromJson(String str) => EndBoxTransfersResponse.fromJson(json.decode(str));

String endBoxTransfersResponseToJson(EndBoxTransfersResponse data) => json.encode(data.toJson());

class EndBoxTransfersResponse {
  int boxResultStatus;
  String controlNumber;
  String? divisionName;
  String? divisionId;
  String? locationId;
  int? boxItemCount;
  String? storeAddress1;
  String? storeAddress2;
  String? storeAddress3;
  String? postalCode1;
  String? postalCode2;

  EndBoxTransfersResponse({
    required this.boxResultStatus,
    required this.controlNumber,
    required this.divisionName,
    required this.divisionId,
    required this.locationId,
    required this.boxItemCount,
    required this.storeAddress1,
    required this.storeAddress2,
    required this.storeAddress3,
    required this.postalCode1,
    required this.postalCode2,
  });

  factory EndBoxTransfersResponse.fromJson(Map<String, dynamic> json) => EndBoxTransfersResponse(
    boxResultStatus: json["boxResultStatus"]??0,
    controlNumber: json["controlNumber"]??"",
    divisionName: json["divisionName"]??"",
    divisionId: json["divisionId"]??"",
    locationId: json["locationId"]??"",
    boxItemCount: json["boxItemCount"]??0,
    storeAddress1: json["storeAddress1"]??"",
    storeAddress2: json["storeAddress2"]??"",
    storeAddress3: json["storeAddress3"]??"",
    postalCode1: json["postalCode1"]??"",
    postalCode2: json["postalCode2"]??"",
  );

  Map<String, dynamic> toJson() => {
    "boxResultStatus": boxResultStatus,
    "controlNumber": controlNumber,
    "divisionName": divisionName,
    "divisionId": divisionId,
    "locationId": locationId,
    "boxItemCount": boxItemCount,
    "storeAddress1": storeAddress1,
    "storeAddress2": storeAddress2,
    "storeAddress3": storeAddress3,
    "postalCode1": postalCode1,
    "postalCode2": postalCode2,
  };
}
