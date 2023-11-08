import 'dart:convert';

/// status holds a http response code, message hold an error if any, data holds the success response
/// converted into given data type
class LoginResponse {
  int status;
  String? message;
  LoginData? data;

  LoginResponse({required this.status, this.data, this.message});
}


LoginData loginResponseFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginResponseToJson(LoginData data) => json.encode(data.toJson());


/// LoginData holds the data received from login api call success
class LoginData {
  final int responseCode;
  final Data? data;

  LoginData({
    required this.responseCode,
    this.data,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    responseCode: json["responseCode"],
    data: json["data"]!= null ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data != null ? data!.toJson() : null,
  };
}

class Data {
  final String userId;
  final List<Division> divisions;

  Data({
    required this.userId,
    required this.divisions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["userId"],
    divisions: List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "divisions": List<dynamic>.from(divisions.map((x) => x.toJson())),
  };
}

class Division {
  final String code;
  final List<UserApp> userApps;

  Division({
    required this.code,
    required this.userApps,
  });

  factory Division.fromJson(Map<String, dynamic> json) => Division(
    code: json["code"],
    userApps: List<UserApp>.from(json["userApps"].map((x) => UserApp.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "userApps": List<dynamic>.from(userApps.map((x) => x.toJson())),
  };
}

class UserApp {
  final int appName;
  final int appAccessRight;

  UserApp({
    required this.appName,
    required this.appAccessRight,
  });

  factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
    appName: json["appName"],
    appAccessRight: json["appAccessRight"],
  );

  Map<String, dynamic> toJson() => {
    "appName": appName,
    "appAccessRight": appAccessRight,
  };
}

