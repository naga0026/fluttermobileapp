import 'dart:convert';

class GetPostSGMResponse {
  int status;
  PerformSgmResponseModel? data;
  String? error;

  GetPostSGMResponse({required this.status, required this.data, this.error});
}

PerformSgmResponseModel performSgmResponseModelFromJson(String str) => PerformSgmResponseModel.fromJson(json.decode(str));

String performSgmResponseModelToJson(PerformSgmResponseModel data) => json.encode(data.toJson());

class PerformSgmResponseModel {
  int id;
  String activeWeekNumber;

  PerformSgmResponseModel({
    required this.id,
    required this.activeWeekNumber,
  });

  factory PerformSgmResponseModel.fromJson(Map<String, dynamic> json) => PerformSgmResponseModel(
    id: json["id"],
    activeWeekNumber: json["activeWeekNumber"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activeWeekNumber": activeWeekNumber,
  };
}