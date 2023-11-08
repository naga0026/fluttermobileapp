import 'dart:convert';
import 'package:base_project/controller/login/user_management.dart';
import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:get/get.dart';
import '../../../controller/barcode/scanned_item_model.dart';
import '../../utility/enums/transfers_enum.dart';

TransfersModel transfersModelFromJson(String str) => TransfersModel.fromJson(json.decode(str));

String transfersModelToJson(TransfersModel data) => json.encode(data.toJson());

class TransfersModel {
  String senderDivision;
  String senderId;
  String currentStoreNumber;
  String currentDivision;
  int transferType;
  int transferDirection;
  String userId;
  String receiverDivision;
  String? receiverId;
  String? directiveNumber;
  String control;
  int expectedItemCount;
  int actualItemCount;
  bool? confirmDateRange;
  bool isMagicBox;

  TransfersModel({
    required this.senderDivision,
    required this.senderId,
    required this.currentStoreNumber,
    required this.currentDivision,
    required this.transferType,
    required this.transferDirection,
    required this.userId,
    required this.receiverDivision,
    required this.receiverId,
    this.directiveNumber,
    required this.control,
    required this.expectedItemCount,
    required this.actualItemCount,
    required this.confirmDateRange,
    required this.isMagicBox,
  });

  factory TransfersModel.fromJson(Map<String, dynamic> json) => TransfersModel(
    senderDivision: json["senderDivision"]??"",
    senderId: json["senderId"]??"",
    currentStoreNumber: json["currentStoreNumber"]??"",
    currentDivision: json["currentDivision"]??"",
    transferType: json["transferType"]??"",
    transferDirection: json["transferDirection"]??"",
    userId: json["userId"]??"",
    receiverDivision: json["receiverDivision"]??"",
    receiverId: json["receiverId"]??"",
    directiveNumber: json["directiveNumber"]??"",
    control: json["control"]??"",
    expectedItemCount: json["expectedItemCount"]??"",
    actualItemCount: json["actualItemCount"]??"",
    confirmDateRange: json["confirmDateRange"]??"",
    isMagicBox: json["isMagicBox"]??"",
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["senderDivision"] = senderDivision;
    data["senderId"] = senderId;
    data["currentStoreNumber"] = currentStoreNumber;
    data["currentDivision"] = currentDivision;
    data["transferType"] = transferType;
    data["transferDirection"] = transferDirection;
    data["userId"] = userId;
    data["receiverDivision"] = receiverDivision;
    data["receiverId"] = receiverId;
    data["directiveNumber"] = directiveNumber;
    data["control"] = control;
    data["expectedItemCount"] = expectedItemCount;
    data["actualItemCount"] = actualItemCount;
    if(confirmDateRange != null) data["confirmDateRange"] = confirmDateRange;
    data["isMagicBox"] = isMagicBox;
    return data;
  }

  static TransfersModel fromScanOrEnteredTransferReceivingItem(
  {required ScanOrEnteredTransferReceivingItem receivedItem,
    required TransfersDirection direction,
    required TransferTypeEnum transferType
  }) {
    final storeConfig = Get.find<StoreConfigController>();
    final userData = Get.find<UserManagementController>();
    var request = TransfersModel(
        senderDivision: '${receivedItem.interpretedControlNumber?.receivingDivision}',
        senderId: receivedItem.interpretedControlNumber!.shippingStoreNumber.toStringWithPadLeft(4),
        currentStoreNumber: storeConfig.selectedStoreNumber,
        currentDivision: storeConfig.selectedDivision,
        transferType: transferType.rawValue,
        transferDirection: direction.rawValue,
        userId: userData.currentUserId,
        receiverDivision: '${receivedItem.interpretedControlNumber?.receivingDivision}',
        receiverId: receivedItem.receivingStoreNumber,
        directiveNumber: null,
        control: receivedItem.controlNumber,
        expectedItemCount: int.parse(receivedItem.itemCount),
        actualItemCount: receivedItem.receivedItemCount ?? 0,
        confirmDateRange: null,
        isMagicBox: false);
    return request;
  }
}

//-----------response from TransfersAPI-Model
TResponseData tResponseDataFromJson(String str) => TResponseData.fromJson(json.decode(str));

String tResponseDataToJson(TResponseData data) => json.encode(data.toJson());

/// Common response model contains a int: responseCode and String: data
class TResponseData {
  int responseCode;
  String data;

  TResponseData({
    required this.responseCode,
    required this.data,
  });

  factory TResponseData.fromJson(Map<String, dynamic> json) => TResponseData(
    responseCode: json["responseCode"],
    data: json["data"]??"",
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data,
  };
}
//---------end........
