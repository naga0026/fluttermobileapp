// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:base_project/services/config/config_service.dart';
// import 'package:base_project/utility/extensions/string_extension.dart';
//
// class APIConstants {
//   static APIConstants? _apiConstants;
//   APIConstants._instance();
//
//   factory APIConstants() {
//     return _apiConstants ?? APIConstants._instance();
//   }
//
//   static String? apigeeURL;
//   static String? apigeeClientID;
//   static String? apigeeSecret;
//   static String? clientSecret;
//   static String? authString;
//   static String? baseURL;
//   static String? getReasonCode;
//   static String? getOriginCode;
//   static String? getInitMarkdown;
//   static String? getStoreConfig;
//   static String? userAuthLogin;
//   static String? performInitialMarkdown;
//
//   readFile(String fileName){
//     String? path =  ConfigService.universalFolderName;
//     String filePath = path!+fileName;
//     if(checkFileExist(filePath)){
//       var data = File(filePath).readAsStringSync();
//       return jsonDecode(data);
//     }
//   }
//
//   checkFileExist(String filePath){
//     if(File(filePath).existsSync()){
//       return true;
//     }
//     return false;
//   }
//
//   Future<void> readJsonData() async {
//     String? path =  ConfigService.universalFolderName;
//     if(path!=null){
//       var jsonData = readFile("subapicalls.json");
//       apigeeURL = jsonData["apigeeURL"];
//       apigeeClientID = jsonData["apigeeClientID"];
//       apigeeSecret = jsonData["apigeeSecret"];
//       clientSecret = "$apigeeClientID:$apigeeSecret";
//       authString = "Basic ${clientSecret?.toBase64}";
//       baseURL = jsonData["baseURL"];
//       getReasonCode = "$baseURL${jsonData["getReasonCode"]}";
//       getOriginCode = "$baseURL${jsonData["getOriginCode"]}";
//       getInitMarkdown = "$baseURL${jsonData["getInitMarkdown"]}";
//       getStoreConfig = "$baseURL${jsonData["getStoreConfig"]}";
//       userAuthLogin = "$baseURL${jsonData["userAuthLogin"]}";
//       performInitialMarkdown = "$baseURL${jsonData["performInitialMarkdown"]}";
//     }
//
//   }
// }