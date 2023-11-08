import 'dart:convert';

AppSettings appSettingsFromJson(String str) => AppSettings.fromJson(json.decode(str));

String appSettingsToJson(AppSettings data) => json.encode(data.toJson());

class AppSettings {
  String applicationConfigVersion;
  bool debugScreenActive;
  String networkConfigScreenPassword;
  int loginTimeoutSeconds;
  int initialPrinterExpireTimeHours;
  int foregroundPassiveRecallTrackingTimeSpanMinutes;
  int backgroundPassiveRecallTrackingTimeSpanMinutes;
  bool cultureCheckPolicyIsActive;
  int httpTimeoutSeconds;
  int markdownsPageSize;
  bool useScannerActivation;
  bool useScannerDeactivation;
  bool scannerBehaviorLoggingEnabled;
  bool zplEnabled;
  bool liveOnlyModeForInitialMarkdownsEnabled;
  bool downloadInitialMarkdownsAsBinary;
  Map<String, String> api;
  PrintingConfiguration printingConfiguration;
  Transfers transfers;

  AppSettings({
    required this.applicationConfigVersion,
    required this.debugScreenActive,
    required this.networkConfigScreenPassword,
    required this.loginTimeoutSeconds,
    required this.initialPrinterExpireTimeHours,
    required this.foregroundPassiveRecallTrackingTimeSpanMinutes,
    required this.backgroundPassiveRecallTrackingTimeSpanMinutes,
    required this.cultureCheckPolicyIsActive,
    required this.httpTimeoutSeconds,
    required this.markdownsPageSize,
    required this.useScannerActivation,
    required this.useScannerDeactivation,
    required this.scannerBehaviorLoggingEnabled,
    required this.zplEnabled,
    required this.liveOnlyModeForInitialMarkdownsEnabled,
    required this.downloadInitialMarkdownsAsBinary,
    required this.api,
    required this.printingConfiguration,
    required this.transfers,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    applicationConfigVersion: json["ApplicationConfigVersion"],
    debugScreenActive: json["DebugScreenActive"],
    networkConfigScreenPassword: json["NetworkConfigScreenPassword"],
    loginTimeoutSeconds: json["LoginTimeoutSeconds"],
    initialPrinterExpireTimeHours: json["InitialPrinterExpireTimeHours"],
    foregroundPassiveRecallTrackingTimeSpanMinutes: json["ForegroundPassiveRecallTrackingTimeSpanMinutes"],
    backgroundPassiveRecallTrackingTimeSpanMinutes: json["BackgroundPassiveRecallTrackingTimeSpanMinutes"],
    cultureCheckPolicyIsActive: json["CultureCheckPolicyIsActive"],
    httpTimeoutSeconds: json["HttpTimeoutSeconds"],
    markdownsPageSize: json["MarkdownsPageSize"],
    useScannerActivation: json["UseScannerActivation"],
    useScannerDeactivation: json["UseScannerDeactivation"],
    scannerBehaviorLoggingEnabled: json["ScannerBehaviorLoggingEnabled"],
    zplEnabled: json["ZplEnabled"],
    liveOnlyModeForInitialMarkdownsEnabled: json["LiveOnlyModeForInitialMarkdownsEnabled"],
    downloadInitialMarkdownsAsBinary: json["DownloadInitialMarkdownsAsBinary"],
    api: Map.from(json["Api"]).map((k, v) => MapEntry<String, String>(k, v)),
    printingConfiguration: PrintingConfiguration.fromJson(json["PrintingConfiguration"]),
    transfers: Transfers.fromJson(json["Transfers"]),
  );

  Map<String, dynamic> toJson() => {
    "ApplicationConfigVersion": applicationConfigVersion,
    "DebugScreenActive": debugScreenActive,
    "NetworkConfigScreenPassword": networkConfigScreenPassword,
    "LoginTimeoutSeconds": loginTimeoutSeconds,
    "InitialPrinterExpireTimeHours": initialPrinterExpireTimeHours,
    "ForegroundPassiveRecallTrackingTimeSpanMinutes": foregroundPassiveRecallTrackingTimeSpanMinutes,
    "BackgroundPassiveRecallTrackingTimeSpanMinutes": backgroundPassiveRecallTrackingTimeSpanMinutes,
    "CultureCheckPolicyIsActive": cultureCheckPolicyIsActive,
    "HttpTimeoutSeconds": httpTimeoutSeconds,
    "MarkdownsPageSize": markdownsPageSize,
    "UseScannerActivation": useScannerActivation,
    "UseScannerDeactivation": useScannerDeactivation,
    "ScannerBehaviorLoggingEnabled": scannerBehaviorLoggingEnabled,
    "ZplEnabled": zplEnabled,
    "LiveOnlyModeForInitialMarkdownsEnabled": liveOnlyModeForInitialMarkdownsEnabled,
    "DownloadInitialMarkdownsAsBinary": downloadInitialMarkdownsAsBinary,
    "Api": Map.from(api).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "PrintingConfiguration": printingConfiguration.toJson(),
    "Transfers": transfers.toJson(),
  };
}

class PrintingConfiguration {
  int maxNumberOfPrinters;
  String markdownStock;
  String stickerStock;
  String priceAdjustStock;
  String hangTagStock;
  String transferStock;
  String shoeTagStock;
  String shoeStickerStock;
  String largeSignStock;
  String smallSignStock;

  PrintingConfiguration({
    required this.maxNumberOfPrinters,
    required this.markdownStock,
    required this.stickerStock,
    required this.priceAdjustStock,
    required this.hangTagStock,
    required this.transferStock,
    required this.shoeTagStock,
    required this.shoeStickerStock,
    required this.largeSignStock,
    required this.smallSignStock,
  });

  factory PrintingConfiguration.fromJson(Map<String, dynamic> json) => PrintingConfiguration(
    maxNumberOfPrinters: json["MaxNumberOfPrinters"],
    markdownStock: json["MarkdownStock"],
    stickerStock: json["StickerStock"],
    priceAdjustStock: json["PriceAdjustStock"],
    hangTagStock: json["HangTagStock"],
    transferStock: json["TransferStock"],
    shoeTagStock: json["ShoeTagStock"],
    shoeStickerStock: json["ShoeStickerStock"],
    largeSignStock: json["LargeSignStock"],
    smallSignStock: json["SmallSignStock"],
  );

  Map<String, dynamic> toJson() => {
    "MaxNumberOfPrinters": maxNumberOfPrinters,
    "MarkdownStock": markdownStock,
    "StickerStock": stickerStock,
    "PriceAdjustStock": priceAdjustStock,
    "HangTagStock": hangTagStock,
    "TransferStock": transferStock,
    "ShoeTagStock": shoeTagStock,
    "ShoeStickerStock": shoeStickerStock,
    "LargeSignStock": largeSignStock,
    "SmallSignStock": smallSignStock,
  };
}

class Transfers {
  int maxNumberOfItemsInBox;

  Transfers({
    required this.maxNumberOfItemsInBox,
  });

  factory Transfers.fromJson(Map<String, dynamic> json) => Transfers(
    maxNumberOfItemsInBox: json["MaxNumberOfItemsInBox"],
  );

  Map<String, dynamic> toJson() => {
    "MaxNumberOfItemsInBox": maxNumberOfItemsInBox,
  };
}
