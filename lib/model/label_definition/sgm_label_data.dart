import 'dart:core';

import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/model/label_definition/label_data.dart';
import 'package:base_project/model/label_definition/printer_label_definition.dart';
import 'package:base_project/utility/enums/division_enum.dart';
import 'package:base_project/utility/enums/label_definition_condition_enum.dart';
import 'package:base_project/utility/enums/tag_type_enum.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:get/get.dart';

import '../../utility/label_definition_parsor.dart';

class SGMLabelData extends LabelData {
  String departmentCode;
  String classCode;
  String? division;
  String? style;
  String? uline;
  String? userId;
  String? toPrice;
  String category;
  String? barcode;
  String? weekNumber;
  String? weekNumberLabel;
  String? formatedPrice;
  int quantity;

  SGMLabelData(
      {required this.departmentCode,
      required this.category,
      this.division,
      this.userId,
      this.uline,
      this.style,
      required this.classCode,
      required this.quantity,
      this.weekNumberLabel,
      this.toPrice, this.weekNumber,this.formatedPrice});

  @override
  List<LabelDefinitionConditionEnum> getCondition() {
    String division = storeConfigController.selectedDivision;
    DivisionEnum divisionEnum = division.getDivisionName;
    switch (divisionEnum) {
      case DivisionEnum.tjMaxxUsa:
        return [
          LabelDefinitionConditionEnum.isDivision08Or28,
          LabelDefinitionConditionEnum.isDivision_08,
          LabelDefinitionConditionEnum.isAnyNorthAmericaDivision
        ];
      case DivisionEnum.tkMaxxEuropeUk:
        return [
          LabelDefinitionConditionEnum.isDivision05,
          LabelDefinitionConditionEnum.isAnyEuropeDivision,
        ];
      case DivisionEnum.tkMaxxEuropeOther:
        return [LabelDefinitionConditionEnum.isDivision55,
         LabelDefinitionConditionEnum.isAnyEuropeDivision
        ];
      case DivisionEnum.marshallsUsa:
        return [
          LabelDefinitionConditionEnum.isDivision10,
          LabelDefinitionConditionEnum.isAnyNorthAmericaDivision
        ];
      case DivisionEnum.homeGoodsUsaOrHomeSenseUsa:
        return [
          LabelDefinitionConditionEnum.isDivision28,
          LabelDefinitionConditionEnum.isDivision08Or28,
          LabelDefinitionConditionEnum.isAnyNorthAmericaDivision
        ];
      case DivisionEnum.homeSenseCanada:
        return [
          LabelDefinitionConditionEnum.isDivision04Or24,
          LabelDefinitionConditionEnum.isDivision24,
          LabelDefinitionConditionEnum.isAnyNorthAmericaDivision
        ];
      case DivisionEnum.winnersCanadaOrMarshallsCanada:
        return [
          LabelDefinitionConditionEnum.isDivision04Or24,
          LabelDefinitionConditionEnum.isDivision04,
          LabelDefinitionConditionEnum.isAnyNorthAmericaDivision
        ];
      default:
        return storeConfigController.isEurope.value
            ? [LabelDefinitionConditionEnum.isAnyEuropeDivision]
            : [LabelDefinitionConditionEnum.isAnyNorthAmericaDivision];
    }
  }
  TagTypeEnum getInvertTagType(TagTypeEnum tgType) {
    switch (tgType) {
      case TagTypeEnum.stickerPriceAtLeast1000:
        return TagTypeEnum.sticker;
      case TagTypeEnum.priceAdjustPriceAtLeast1000:
        return TagTypeEnum.priceAdjust;
      case TagTypeEnum.markdownPriceAtLEast1000:
        return TagTypeEnum.markdown;
      case TagTypeEnum.hangTagPriceAtLeast1000:
        return TagTypeEnum.hangTag;
      case TagTypeEnum.shoesPriceAtLeast1000:
        return TagTypeEnum.shoes;
      default:
        return tgType;
    }
  }
  @override
  String getLabelDefinition({TagTypeEnum tagType = TagTypeEnum.markdown}) {
    var condition = getCondition();
    PrinterLabelDefinition? definition;
    List<PrinterLabelDefinition> sgmDefinition =
        readConfigController.labelDefinitions.sgm ?? [];
    // var tagType = getTagType();
    String? definitionWithDataUpdated;
    definitionWithDataUpdated =  LabelDefinitionParser.getLabelDefinitionFromGivenData(
        definitions: sgmDefinition,
        conditions: condition,
        tagType: tagType,
        dataMap: toLabelDataMap(), numberOfLabels: quantity);
    if (definitionWithDataUpdated.isEmpty) {
      definitionWithDataUpdated =
          LabelDefinitionParser.getLabelDefinitionFromGivenData(
              definitions: sgmDefinition,
              conditions: condition,
              tagType: getInvertTagType(tagType),
              dataMap: toLabelDataMap(), numberOfLabels: quantity);

      // NavigationService.showDialog(
      //     title: "No Definition Found",
      //     subtitle: "Please re-try with different price.",
      //     buttonCallBack: () {
      //       Get.back();
      //     },
      //     icon: IconConstants.warningIcon);
    }
    return definitionWithDataUpdated;
  }
  final currentDate = DateTime.now();

  @override
  Map<String, dynamic> toLabelDataMap() {
    return {
      "DigiUserId": userId,
      "FormattedPrice": getFormattedPrice(),
      "Dept": departmentCode,
      "Uline": uline,
      "Price": toPrice,
      "Barcode": barcode,
      "Style": style,
      "WeekNumber": weekNumber,
      "WeekNumberLabel": weekNumberLabel,
      "Category": category,
      "ClassCode": classCode,
      "DeptLbl": "DEPT",
      "StyleLbl": "STYLE",
      "CategoryLbl": "CAT",
      "PriceLbl": "OUR PRICE",
      "CompareAtLbl": "COMPARE AT",
      "Date":getCurrentDate(),
      "AltDeptLbl":"RAYON",
      "AltCompareAtLbl":"COMPARABLE",
      "AltPriceLbl":"NOTRE PRIX",
      "Div":division,
      "FormattedComparePrice":getFormattedPrice() ?? "",
      "Mmyy":"${getCurrentMonth()}${currentDate.year.toString().substring(2)}"
    };
  }



  @override
  TagTypeEnum getTagType() {
    // TODO: implement getTagType
    throw UnimplementedError();
  }

  String formattedPriceMarshalls() {
    return getCurrency()+toPrice
        .toString()
        .addLeadingZeroLengthFive
        .formattedPrice
        .toStringAsFixed(2);
  }

  String formattedPrice() {
    return getCurrency()+toPrice
        .toString()
        .addLeadingZero
        .formattedPrice
        .toStringAsFixed(2);
  }

  String getFormattedPrice(){
    if(toPrice.toString()=="00000" || toPrice.toString()=="000000"){
      return "${getCurrency()}0.00";
    }
    final storeConfigController = Get.find<StoreConfigController>();
    return storeConfigController.isMarshallsUSA()?formattedPriceMarshalls():formattedPrice();
  }
  String getCurrency() {
    final storeConfigController = Get.find<StoreConfigController>();
    return storeConfigController.getCurrencySymbol();
  }

  String getCurrentMonth(){
    return currentDate.month.toString().length==1?"0${currentDate.month.toString()}"
        :currentDate.month.toString();
  }
  String getCurrentDay(){
    return currentDate.day.toString().length==1?"0${currentDate.day.toString()}"
        :currentDate.day.toString();
  }
 String getCurrentDate() {
    return "${getCurrentMonth()}/${getCurrentDay()}/${currentDate.year.toString().substring(2,4)}";
  }
}
