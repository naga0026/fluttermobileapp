//region Parse Fault response for token expire
import 'dart:convert';

FaultResponse faultResponseFromJson(String str) => FaultResponse.fromJson(json.decode(str));

String faultResponseToJson(FaultResponse data) => json.encode(data.toJson());

class FaultResponse {
  final Fault? fault;

  FaultResponse({
     this.fault,
  });

  factory FaultResponse.fromJson(Map<String, dynamic> json) => FaultResponse(
    fault: json["fault"] != null ? Fault.fromJson(json["fault"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "fault": fault?.toJson(),
  };
}

class Fault {
  final String? faultString;

  Fault({
     this.faultString,
  });

  factory Fault.fromJson(Map<String, dynamic> json) => Fault(
    faultString: json["faultString"],
  );

  Map<String, dynamic> toJson() => {
    "faultString": faultString,
  };

  bool get isTokenExpired {
    return (faultString ?? '').contains('expired');
  }
}
//endregion