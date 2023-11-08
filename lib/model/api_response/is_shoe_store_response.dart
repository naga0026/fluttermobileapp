import 'dart:convert';

class IsShoeStoreResponse {
  int status;
  String? message;
  IsShoeStore? data;

  IsShoeStoreResponse({required this.status, this.data, this.message});
}

IsShoeStore isShoeStoreResponseFromJson(String str) => IsShoeStore.fromJson(json.decode(str));

String isShoeStoreResponseToJson(IsShoeStore data) => json.encode(data.toJson());

class IsShoeStore {
  final int responseCode;
  final dynamic data;

  IsShoeStore({
    required this.responseCode,
    this.data,
  });

  factory IsShoeStore.fromJson(Map<String, dynamic> json) => IsShoeStore(
    responseCode: json["responseCode"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data,
  };
}
