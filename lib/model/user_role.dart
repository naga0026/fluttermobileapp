import 'dart:convert';

import 'package:base_project/utility/enums/app_name_enum.dart';

UserRole userRoleFromJson(String str) => UserRole.fromJson(json.decode(str));

String userRoleToJson(UserRole data) => json.encode(data.toJson());

class UserRole {
  final List<Role> roles;

  UserRole({
    required this.roles,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
  };
}

class Role {
  final String divisionId;
  final AppNameEnum application;
  final String role;

  Role({
    required this.divisionId,
    required this.application,
    required this.role,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    divisionId: json["DivisionId"],
    application: (json["Application"] as String).appName,
    role: json["Role"],
  );

  Map<String, dynamic> toJson() => {
    "DivisionId": divisionId,
    "Application": application,
    "Role": role,
  };
}
