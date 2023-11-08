import 'package:base_project/controller/home/transfers/transfers_controller.dart';
import 'package:base_project/model/label_definition/label_data.dart';
import 'package:base_project/model/label_definition/printer_label_definition.dart';
import 'package:base_project/utility/enums/division_enum.dart';
import 'package:base_project/utility/label_definition_parsor.dart';
import 'package:get/get.dart';
import '../../utility/enums/label_definition_condition_enum.dart';
import '../../utility/enums/tag_type_enum.dart';

enum LabelCondition{
controlNumber,
  addressForRegion,
  boxItem
}

class TransfersLabelData extends LabelData {
  String controlNumber;
  String? divisionName;
  String? storeAddress1;
  String? storeAddress2;
  String? storeAddress3;
  String? postalCode;
  String? storeNumber;
  String? boxItemCount;
  String? receivingStore;
  String? storeBarCode;
  TransfersLabelData({
    required this.controlNumber,
    this.divisionName,
    this.storeAddress1,
    this.storeAddress2,
    this.storeAddress3,
    this.postalCode,
    this.storeNumber,
    this.boxItemCount,
    this.receivingStore,
    this.storeBarCode,
  });

  @override
  Map<String, dynamic> toLabelDataMap() {
    return {
      "ControlNumber": controlNumber,
      "DivisionName": divisionName??"",
      "StoreAddress1": storeAddress1??"",
      "StoreAddress2": storeAddress2??"",
      "StoreAddress3": storeAddress3??"",
      "PostalCode": postalCode??"",
      "StoreNumber": storeNumber??"",
      "BoxItemCount": boxItemCount??"",
      "ReceivingStore": receivingStore??"",
      "StoreBarCode": storeBarCode??""
    };
  }



  @override
  List<LabelDefinitionConditionEnum> getCondition({LabelCondition? condition}) {
    String division = storeConfigController.selectedDivision;
    DivisionEnum divisionEnum = division.getDivisionName;
    switch (divisionEnum) {
      case DivisionEnum.tkMaxxEuropeUk:
      case DivisionEnum.tkMaxxEuropeOther:
        return switch(condition){
          LabelCondition.controlNumber=>getControlNumberForRegion(),
          LabelCondition.addressForRegion=>getAddressForRegion(),
          LabelCondition.boxItem=>getBoxItemForRegion(),
        _=>getControlNumberForRegion()
        };
      case DivisionEnum.tjMaxxUsa:
      case DivisionEnum.marshallsUsa:
      case DivisionEnum.homeGoodsUsaOrHomeSenseUsa:
      case DivisionEnum.homeSenseCanada:
      case DivisionEnum.winnersCanadaOrMarshallsCanada:
      return switch(condition){
        LabelCondition.controlNumber=>getControlNumberForRegion(isNa:true),
        LabelCondition.addressForRegion=>getAddressForRegion(isNa:true),
        LabelCondition.boxItem=>getBoxItemForRegion(isNa:true),
        _=>getControlNumberForRegion(isNa:true)
      };

      ///TODO: for polland we ll use store config varibale
      ///end box  ----  controlll n --> l
    }
  }

  @override
  String getLabelDefinition({LabelCondition? cnd}) {
    var condition = getCondition(condition: cnd);
    List<PrinterLabelDefinition> transfersDefinition =
        readConfigController.labelDefinitions.transfers ?? [];
    String? definitionWithDataUpdated;
    var tagType = getTagType();

    logger.d(
        "TransfersDefinition:${transfersDefinition.length} | \ncondition:$condition |\ntagType:$tagType");
    definitionWithDataUpdated =
        LabelDefinitionParser.getLabelDefinitionFromGivenData(
            definitions: transfersDefinition,
            conditions: condition,
            tagType: tagType,
            dataMap: toLabelDataMap());
    return definitionWithDataUpdated;
  }

  @override
  TagTypeEnum getTagType() {
    return TagTypeEnum.transfers;
  }

  List<LabelDefinitionConditionEnum> getControlNumberForRegion(
      {bool isNa = false}) {
    return isNa
        ? [LabelDefinitionConditionEnum.isControlLabelNA]
        : [LabelDefinitionConditionEnum.isControlLabelEU];
  }

  List<LabelDefinitionConditionEnum> getBoxItemForRegion({bool isNa = false}) {
    return isNa
        ? [LabelDefinitionConditionEnum.isBoxBarcodeLabelNA]
        : storeConfigController.isCountryPoland.value
            ? [LabelDefinitionConditionEnum.isBoxBarcodeLabelPL]
            : [LabelDefinitionConditionEnum.isBoxBarcodeLabelEU];
  }

  List<LabelDefinitionConditionEnum> getAddressForRegion({bool isNa = false}) {
    return isNa
        ? [LabelDefinitionConditionEnum.isAddressLabelNA]
        : storeConfigController.isCountryPoland.value
            ? [LabelDefinitionConditionEnum.isAddressLabelPL]
            : [LabelDefinitionConditionEnum.isAddressLabelEU];
  }
}
