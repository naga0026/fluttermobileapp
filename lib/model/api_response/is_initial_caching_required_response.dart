import 'dart:convert';

import 'package:base_project/utility/extensions/int_extension.dart';

class IsInitialCachingRequiredResponse {
  int status;
  IsInitialCachingRequired? cachingRequired;
  String? error;

  IsInitialCachingRequiredResponse({required this.status, this.cachingRequired, this.error});
}

IsInitialCachingRequired isInitialCachingRequiredResponseFromJson(String str) => IsInitialCachingRequired.fromJson(json.decode(str));

String isInitialCachingRequiredResponseToJson(IsInitialCachingRequired data) => json.encode(data.toJson());

class IsInitialCachingRequired {
  final int responseCode;
  final String? data;

  IsInitialCachingRequired({
    required this.responseCode,
    this.data,
  });

  factory IsInitialCachingRequired.fromJson(Map<String, dynamic> json) => IsInitialCachingRequired(
    responseCode: json["responseCode"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data,
  };

  bool get isRequired {
    return responseCode.boolValue;
  }
}
