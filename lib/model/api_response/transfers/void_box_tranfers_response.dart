import 'dart:convert';

VoidBoxResponseT voidBoxResponseTFromJson(String str) => VoidBoxResponseT.fromJson(json.decode(str));

String voidBoxResponseTToJson(VoidBoxResponseT data) => json.encode(data.toJson());

class VoidBoxResponseT {
  int voidBoxStatus;
  String? controlNumber;

  VoidBoxResponseT({
    required this.voidBoxStatus,
    required this.controlNumber,
  });

  factory VoidBoxResponseT.fromJson(Map<String, dynamic> json) => VoidBoxResponseT(
    voidBoxStatus: json["voidBoxStatus"],
    controlNumber: json["controlNumber"]??"",
  );

  Map<String, dynamic> toJson() => {
    "voidBoxStatus": voidBoxStatus,
    "controlNumber": controlNumber,
  };
}
