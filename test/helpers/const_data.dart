class HelperData{



  static const Map<String, dynamic> appBaseData = {
    "ApiBaseUrl": "https://dev.api.tjx.com/stores/storeweb/usmar0705/v2",
    "apigeeURL" : "https://qa.api.tjx.com/stores/storeweb/oAuth2/accesstoken?grant_type=client_credentials",
    "apigeeClientID" : "EG90mv1Jsxs0saY53xr4QRD7AAQvm8jN",
    "apigeeSecret" : "DGatVVOL3QbyqzFw",
    "ipAddress": "http://192.168.225.137"
  };

  static const Map<String, dynamic> apiBaseData = {
    "ApplicationConfigVersion": "110",
    "DebugScreenActive": true,
    "NetworkConfigScreenPassword": "tiw.30SM",
    "LoginTimeoutSeconds": 600,
    "InitialPrinterExpireTimeHours": 24,
    "ForegroundPassiveRecallTrackingTimeSpanMinutes": 1,
    "BackgroundPassiveRecallTrackingTimeSpanMinutes": 15,
    "CultureCheckPolicyIsActive": true,
    "HttpTimeoutSeconds": 200,
    "MarkdownsPageSize": 75000,
    "UseScannerActivation": true,
    "UseScannerDeactivation": true,
    "ScannerBehaviorLoggingEnabled": false,
    "ZplEnabled": false,
    "LiveOnlyModeForInitialMarkdownsEnabled": false,
    "DownloadInitialMarkdownsAsBinary": true,
    "Api": {
      "ApiKey": "sboproject12345",
      "ApiLoginUrl": "/api/Authentication/Login/",
      "ApiStoreConfigUrl": "/api/Store/GetStoreConfig/",
      "PrinterSetupUrl": "/api/PrinterSetup/",
      "PrinterSetupAssignUrl": "/api/PrinterSetup/AssignPrinter/",
      "PrinterSetupUnassignUrl": "/api/PrinterSetup/UnassignPrinter/",
      "GetAssignedPrintersForDevice": "/api/PrinterSetup/GetAllPrintersForDevice/",
      "GetRecallTrackingData": "/api/RecallTracking/",
      "PostRecallTrackingData": "/api/RecallTracking/Attempt",
      "PutUpdateLastTested": "/api/PrinterSetup/UpdateLastTested/",
      "GetDepartmentData": "/api/Store/GetDepartmentData/",
      "GetDepartmentWithNameData": "/api/Store/GetDepartmentWithNameData/",
      "GetClassData": "/api/Store/GetClassData/",
      "GetOriginCodes": "/api/Sgm/GetOriginCodes",
      "GetReasonCodes": "/api/Sgm/GetReasonCodes",
      "GetInitialMarkdowns": "/api/Markdowns/InitialMarkdowns",
      "GetInitialMarkdownCandidate": "/api/Markdowns/InitialMarkdownCandidate",
      "IsInitialCachingRequired": "/api/Markdowns/IsInitialCachingRequired",
      "GetMluMarkdownCandidate": "/api/Markdowns/MluMarkdownCandidate",
      "SubsequentMarkdownsUlineClass": "/api/Markdowns/SubsequentMarkdownsUlineClass",
      "SubsequentMarkdownsDepartmentCodes": "/api/Markdowns/SubsequentMarkdownsDepartmentCodes",
      "SubsequentMarkdownsExceptions": "/api/Markdowns/SubsequentMarkdownsExceptions",
      "SubsequentMarkdownsGuides": "/api/Markdowns/SubsequentMarkdownsGuides",
      "SubsequentMarkdownsPricePoints": "/api/Markdowns/SubsequentMarkdownsPricePoints",
      "SubsequentMarkdownsRanges": "/api/Markdowns/SubsequentMarkdownsRanges",
      "PostInitialMarkdowns": "/api/Markdowns/PerformInitialMarkdown",
      "PostSubsMarkdowns": "/api/Markdowns/PerformSubsequentMarkdown",
      "ReprintMarkdown": "/api/Markdowns/ReprintMarkdown",
      "VoidMarkdown": "/api/Markdowns/VoidMarkdown",
      "ReturnItemLookup": "/api/ReturnItemLookup/ReturnItemLookup",
      "ReturnItemLookupLogActivity": "/api/ReturnItemLookup/LogActivity",
      "OpenMarkdownWeek": "/api/Markdowns/OpenMarkdownWeek",
      "PerformSgm": "/api/Sgm/PerformSgm",
      "CreateTransferRequest": "/api/Transfers/",
      "GetDamagedJewelryCreatedDate": "/api/Transfers/DamagedJewelryCreatedDate",
      "ReprintSgm": "/api/Sgm/ReprintSgm/",
      "ControlNumberValidStatus": "/api/Transfers/ControlNumberValidStatus",
      "AddItemToBoxTransfers": "/api/Transfers/AddItemToBox",
      "InquireBox": "/api/Transfers/InquireBox",
      "DeleteItemInBox": "/api/Transfers/DeleteItemInBox",
      "EndBoxTransfers": "/api/Transfers/EndBox",
      "VoidBox": "/api/Transfers/VoidBox",
      "ChangeReceiverTransfers": "/api/Transfers/ChangeReceiver",
      "ReprintTransfers": "/api/Transfers/TransfersReprintLabel",
      "ValidateStoreNumberTransfers": "/api/Transfers/ValidateStoreNumber",
      "IsShoeStore": "/api/Store/IsShoeStore",
      "PrintTransferReport": "/api/Transfers/PrintTransferReport",
      "TicketMakerVendors": "/api/TicketMaker/TicketMakerVendors",
      "InquireSpecialProject": "/api/Transfers/InquireSpecialProject",
      "InquireBoxReceived": "/api/Transfers/InquireBoxReceived",
      "TicketMakerLog": "/api/TicketMaker/Log",
      "GetStyleRangeData": "/api/Store/GetStyleRangeData",
      "PriceTicketMessages": "/api/Store/PriceTicketMessages",
      "PriceMatchingSearch": "/api/PriceMatching/Search",
      "PriceMatchingBrands": "/api/PriceMatching/Brands",
      "GetStoreAddress": "/api/Transfers/StoreAddress",
      "TestResponse": "/api/Test/ResponseTest"
    },
    "PrintingConfiguration": {
      "MaxNumberOfPrinters": 3,
      "MarkdownStock": "Markdown (red label)",
      "StickerStock": "Sticker",
      "PriceAdjustStock": "Price Adjust (yellow label)",
      "HangTagStock": "Hang tag",
      "TransferStock": "Transfer",
      "ShoeTagStock": "Shoe tag",
      "ShoeStickerStock": "Shoe sticker",
      "LargeSignStock": "Large sign",
      "SmallSignStock": "Small sign"
    },
    "Transfers": {
      "MaxNumberOfItemsInBox": 999
    }
  };





}