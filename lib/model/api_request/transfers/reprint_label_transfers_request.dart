import 'dart:convert';

ReprintLabelTransfersRequest reprintLabelTransfersRequestFromJson(String str) => ReprintLabelTransfersRequest.fromJson(json.decode(str));

String reprintLabelTransfersRequestToJson(ReprintLabelTransfersRequest data) => json.encode(data.toJson());

class ReprintLabelTransfersRequest {
  String currentDivision;
  String currentStore;
  String controlNumber;
  String? alternativeDivision;
  String? alternativeLocation;

  ReprintLabelTransfersRequest({
    required this.currentDivision,
    required this.currentStore,
    required this.controlNumber,
   this.alternativeDivision,
   this.alternativeLocation,
  });

  factory ReprintLabelTransfersRequest.fromJson(Map<String, dynamic> json) => ReprintLabelTransfersRequest(
    currentDivision: json["CurrentDivision"],
    currentStore: json["CurrentStore"],
    controlNumber: json["ControlNumber"],
    alternativeDivision: json["AlternativeDivision"],
    alternativeLocation: json["AlternativeLocation"],
  );

  Map<String, dynamic> toJson() => {
    "CurrentDivision": currentDivision,
    "CurrentStore": currentStore,
    "ControlNumber": controlNumber,
    "AlternativeDivision": alternativeLocation,
    "AlternativeLocation": alternativeDivision,
  };
}
