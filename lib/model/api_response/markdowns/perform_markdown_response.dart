import 'dart:convert';

class PerformInitialMarkdownResponse {
  MarkdownResponse? response;
  int statusCode;
  String? error;

  PerformInitialMarkdownResponse({required this.statusCode, this.response, this.error});

}

MarkdownResponse performMarkdownResponseFromJson(String str) => MarkdownResponse.fromJson(json.decode(str));

String performMarkdownResponseToJson(MarkdownResponse data) => json.encode(data.toJson());

class MarkdownResponse {
  final int? responseCode;
  final Data? data;

  MarkdownResponse({
    this.responseCode,
    this.data,
  });

  factory MarkdownResponse.fromJson(Map<String, dynamic> json) => MarkdownResponse(
    responseCode: json["responseCode"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data?.toJson(),
  };
}

class Data {
  final int? logId;

  Data({
    this.logId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    logId: json["logId"],
  );

  Map<String, dynamic> toJson() => {
    "logId": logId,
  };
}
