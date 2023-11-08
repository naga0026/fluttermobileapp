import 'dart:convert';

ZplSettings zplSettingsFromJson(String str) => ZplSettings.fromJson(json.decode(str));

String zplSettingsToJson(ZplSettings data) => json.encode(data.toJson());

class ZplSettings {
  final String commandStartSymbol;
  final SeparatorTypeZpl separatorTypeZpl;
  final LabelLength labelLength;

  ZplSettings({
    required this.commandStartSymbol,
    required this.separatorTypeZpl,
    required this.labelLength,
  });

  factory ZplSettings.fromJson(Map<String, dynamic> json) => ZplSettings(
    commandStartSymbol: json["CommandStartSymbol"],
    separatorTypeZpl: SeparatorTypeZpl.fromJson(json["SeparatorTypeZpl"]),
    labelLength: LabelLength.fromJson(json["LabelLength"]),
  );

  Map<String, dynamic> toJson() => {
    "CommandStartSymbol": commandStartSymbol,
    "SeparatorTypeZpl": separatorTypeZpl.toJson(),
    "LabelLength": labelLength.toJson(),
  };
}

class LabelLength {
  final Europe northAmerica;
  final Europe europe;
  final Common common;

  LabelLength({
    required this.northAmerica,
    required this.europe,
    required this.common,
  });

  factory LabelLength.fromJson(Map<String, dynamic> json) => LabelLength(
    northAmerica: Europe.fromJson(json["NorthAmerica"]),
    europe: Europe.fromJson(json["Europe"]),
    common: Common.fromJson(json["Common"]),
  );

  Map<String, dynamic> toJson() => {
    "NorthAmerica": northAmerica.toJson(),
    "Europe": europe.toJson(),
    "Common": common.toJson(),
  };
}

class Common {
  final String recallTracking;
  final Sign sign;
  final String hangTag;
  final String shoes;

  Common({
    required this.recallTracking,
    required this.sign,
    required this.hangTag,
    required this.shoes,
  });

  factory Common.fromJson(Map<String, dynamic> json) => Common(
    recallTracking: json["RecallTracking"],
    sign: Sign.fromJson(json["Sign"]),
    hangTag: json["HangTag"],
    shoes: json["Shoes"],
  );

  Map<String, dynamic> toJson() => {
    "RecallTracking": recallTracking,
    "Sign": sign.toJson(),
    "HangTag": hangTag,
    "Shoes": shoes,
  };
}

class Sign {
  final String small;
  final String large;

  Sign({
    required this.small,
    required this.large,
  });

  factory Sign.fromJson(Map<String, dynamic> json) => Sign(
    small: json["Small"],
    large: json["Large"],
  );

  Map<String, dynamic> toJson() => {
    "Small": small,
    "Large": large,
  };
}

class Europe {
  final String markdown;
  final String sticker;
  final String transfers;

  Europe({
    required this.markdown,
    required this.sticker,
    required this.transfers,
  });

  factory Europe.fromJson(Map<String, dynamic> json) => Europe(
    markdown: json["Markdown"],
    sticker: json["Sticker"],
    transfers: json["Transfers"],
  );

  Map<String, dynamic> toJson() => {
    "Markdown": markdown,
    "Sticker": sticker,
    "Transfers": transfers,
  };
}

class SeparatorTypeZpl {
  final String barSense;
  final String gapSense;

  SeparatorTypeZpl({
    required this.barSense,
    required this.gapSense,
  });

  factory SeparatorTypeZpl.fromJson(Map<String, dynamic> json) => SeparatorTypeZpl(
    barSense: json["BarSense"],
    gapSense: json["GapSense"],
  );

  Map<String, dynamic> toJson() => {
    "BarSense": barSense,
    "GapSense": gapSense,
  };
}
