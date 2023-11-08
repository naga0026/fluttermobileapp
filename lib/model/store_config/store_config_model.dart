import 'dart:convert';

StoreConfigData storeConfigFromJson(String str) => StoreConfigData.fromJson(json.decode(str));

String storeConfigToJson(StoreConfigData data) => json.encode(data.toJson());

class StoreConfigData {
  int compatibilityVersion;
  String apiVersion;
  String language;
  String country;
  String logo;
  dynamic comboSlaveHostname;
  dynamic comboMasterHostname;
  Siteid siteid;
  Divisions divisions;
  int storeType;

  StoreConfigData({
    required this.compatibilityVersion,
    required this.apiVersion,
    required this.language,
    required this.country,
    required this.logo,
    this.comboSlaveHostname,
    this.comboMasterHostname,
    required this.siteid,
    required this.divisions,
    required this.storeType,
  });

  factory StoreConfigData.fromJson(Map<String, dynamic> json) => StoreConfigData(
    compatibilityVersion: json["compatibilityVersion"],
    apiVersion: json["apiVersion"],
    language: json["language"],
    country: json["country"],
    logo: json["logo"],
    comboSlaveHostname: json["comboSlaveHostname"],
    comboMasterHostname: json["comboMasterHostname"],
    siteid: Siteid.fromJson(json["siteid"]),
    divisions: Divisions.fromJson(json["divisions"]),
    storeType: json["storeType"],
  );

  Map<String, dynamic> toJson() => {
    "compatibilityVersion": compatibilityVersion,
    "apiVersion": apiVersion,
    "language": language,
    "country": country,
    "logo": logo,
    "comboSlaveHostname": comboSlaveHostname,
    "comboMasterHostname": comboMasterHostname,
    "siteid": siteid.toJson(),
    "divisions": divisions.toJson(),
    "storeType": storeType,
  };
}

class Divisions {
  List<Divid> divid;

  Divisions({
    required this.divid,
  });

  factory Divisions.fromJson(Map<String, dynamic> json) => Divisions(
    divid: List<Divid>.from(json["divid"].map((x) => Divid.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "divid": List<dynamic>.from(divid.map((x) => x.toJson())),
  };
}

class Divid {
  String division;
  String name;
  String region;
  String district;
  String number;
  String logo;
  String abbrev;
  bool isTransfersShippingEnabled;
  bool isTransfersReceivingEnabled;

  Divid({
    required this.division,
    required this.name,
    required this.region,
    required this.district,
    required this.number,
    required this.logo,
    required this.abbrev,
    required this.isTransfersShippingEnabled,
    required this.isTransfersReceivingEnabled,
  });

  factory Divid.fromJson(Map<String, dynamic> json) => Divid(
    division: json["division"],
    name: json["name"],
    region: json["region"],
    district: json["district"],
    number: json["number"],
    logo: json["logo"],
    abbrev: json["abbrev"],
    isTransfersShippingEnabled: json["isTransfersShippingEnabled"],
    isTransfersReceivingEnabled: json["isTransfersReceivingEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "division": division,
    "name": name,
    "region": region,
    "district": district,
    "number": number,
    "logo": logo,
    "abbrev": abbrev,
    "isTransfersShippingEnabled": isTransfersShippingEnabled,
    "isTransfersReceivingEnabled": isTransfersReceivingEnabled,
  };
}

class Siteid {
  String street;
  String city;
  String state;
  String zip;
  String? phone;

  Siteid({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.phone,
  });

  factory Siteid.fromJson(Map<String, dynamic> json) => Siteid(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    zip: json["zip"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "zip": zip,
    "phone": phone,
  };
}
