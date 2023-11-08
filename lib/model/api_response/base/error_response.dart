import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) => ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());


/// Class that holds all 400 Bad request from the api response
class ErrorResponse {
  final String? type;
  final String? title;
  final int? status;
  final String? detail;
  final String? instance;
  final String? additionalProp1;
  final String? additionalProp2;
  final String? additionalProp3;

  ErrorResponse({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    type: json["type"],
    title: json["title"],
    status: json["status"],
    detail: json["detail"],
    instance: json["instance"],
    additionalProp1: json["additionalProp1"],
    additionalProp2: json["additionalProp2"],
    additionalProp3: json["additionalProp3"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "status": status,
    "detail": detail,
    "instance": instance,
    "additionalProp1": additionalProp1,
    "additionalProp2": additionalProp2,
    "additionalProp3": additionalProp3,
  };
}
