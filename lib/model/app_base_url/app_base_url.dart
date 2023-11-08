import 'dart:convert';

AppBaseURL appBaseURLFromJson(String str) => AppBaseURL.fromJson(json.decode(str));

String appBaseURLToJson(AppBaseURL data) => json.encode(data.toJson());

class AppBaseURL {
  String apiBaseUrl;
  String apigeeUrl;
  String apigeeClientId;
  String apigeeSecret;
  String? ipAddress;

  AppBaseURL({
    required this.apiBaseUrl,
    required this.apigeeUrl,
    required this.apigeeClientId,
    required this.apigeeSecret,
    required this.ipAddress,
  });

  factory AppBaseURL.fromJson(Map<String, dynamic> json) => AppBaseURL(
    apiBaseUrl: json["ApiBaseUrl"],
    apigeeUrl: json["apigeeURL"],
    apigeeClientId: json["apigeeClientID"],
    apigeeSecret: json["apigeeSecret"], ipAddress: json["ipAddress"],
  );

  Map<String, dynamic> toJson() => {
    "ApiBaseUrl": apiBaseUrl,
    "apigeeURL": apigeeUrl,
    "apigeeClientID": apigeeClientId,
    "apigeeSecret": apigeeSecret,
    "ipAddress":ipAddress
  };
}