import 'package:base_project/controller/home/ticket_maker/ticket_maker_controller.dart';
import 'package:base_project/model/label_definition/label_data.dart';
import 'package:base_project/model/label_definition/printer_label_definition.dart';
import 'package:base_project/utility/enums/division_enum.dart';
import 'package:base_project/utility/enums/sign_buttons.dart';
import 'package:base_project/utility/enums/stock_type.dart';
import 'package:base_project/utility/label_definition_parsor.dart';
import 'package:get/get.dart';

import '../../utility/constants/app/label_constants.dart';
import '../../utility/enums/label_definition_condition_enum.dart';
import '../../utility/enums/tag_type_enum.dart';


class TicketMakerLabelData extends LabelData {
  String digiUserId;
  String dept;
  String? classCode;
  String? style;
  String? uline;
  String price;
  String weekNumber;
  String formattedPrice;
  String? barcode;
  String weekNumberLabel;
  String? division;
  String? compareAt;
  String? category;
  String? line1;
  String? line2;
  String? YAline;
  int quantity;

  TicketMakerLabelData(
      {required this.digiUserId,
      required this.dept,
       this.classCode,
      this.style,
      this.uline,
      required this.quantity,
      required this.price,
      required this.formattedPrice,
      this.barcode,
      required this.weekNumber,
      required this.weekNumberLabel,
      this.division,
      this.compareAt,
      this.line1,
      this.line2,
      this.YAline,
       this.category});
  final currentDate = DateTime.now();
  @override
  Map<String, dynamic> toLabelDataMap() {
    return {
      "DigiUserId": digiUserId,
      "AltDeptLbl":"RAYON",
      "AltCompareAtLbl":"COMPARABLE",
      "AltPriceLbl":"NOTRE PRIX",
      "Div":division,
      "FormattedPrice": formattedPrice,
      "Dept": dept,
      "Uline": uline,
      "Price": price,
      "WeekNumberLabel": weekNumberLabel,
      "Barcode": barcode,
      "Category": category??"00",
      "ClassCode": classCode??classCode!.substring(0,2)??"00",
      "Style": style,
      "WeekNumber": weekNumber,
      "DeptLbl": "DEPT",
      "StyleLbl": "STYLE",
      "CategoryLbl": "CAT",
      "PriceLbl": "OUR PRICE",
      "CompareAtLbl": "COMPARE AT",
      "FormattedCompare": compareAt ?? "",
      "Vendor1": line1 ?? "",
      "Vendor2": line2 ?? "",
      "YAlign": YAline ?? "",
      "FormattedComparePrice":compareAt ?? "",
      "Mmyy":"${getCurrentMonth()}${currentDate.year.toString().substring(2)}"
    };
  }

  @override
  TagTypeEnum getTagType() {
    final tMakerController = Get.find<TicketMakerController>();
    StockTypeEnum currentSelectedTagInTMScreen =
        tMakerController.stockList[tMakerController.currentIndex.value];
    var parsedPrice = double.parse(price);
    var tgType = currentSelectedTagInTMScreen == StockTypeEnum.smallSign ||
            currentSelectedTagInTMScreen == StockTypeEnum.largeSign
        ? tMakerController
            .selectedSignButton.value.getTagTypeEnumFromSignTypeEnum
        : currentSelectedTagInTMScreen.rawValue.getTagTypeEnumFromString;
    var checkPriced = parsedPrice < LabelsConstants.oneThousand;
    switch (tgType) {
      case TagTypeEnum.sticker:
        return checkPriced
            ? TagTypeEnum.sticker
            : TagTypeEnum.stickerPriceAtLeast1000;
      case TagTypeEnum.priceAdjust:
        return checkPriced
            ? TagTypeEnum.priceAdjust
            : TagTypeEnum.priceAdjustPriceAtLeast1000;
      case TagTypeEnum.markdown:
        return checkPriced
            ? TagTypeEnum.markdown
            : TagTypeEnum.markdownPriceAtLEast1000;
      case TagTypeEnum.hangTag:
        return checkPriced
            ? TagTypeEnum.hangTag
            : TagTypeEnum.hangTagPriceAtLeast1000;
      case TagTypeEnum.shoes:
        return checkPriced
            ? TagTypeEnum.shoes
            : TagTypeEnum.shoesPriceAtLeast1000;
      default:
        return tgType;
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
  List<LabelDefinitionConditionEnum> getCondition() {
    String division = storeConfigController.selectedDivision;
    DivisionEnum divisionEnum = division.getDivisionName;
    switch (divisionEnum) {
      case DivisionEnum.tjMaxxUsa:
        return [
          LabelDefinitionConditionEnum.isDivision08Or28,
          LabelDefinitionConditionEnum.isDivision_08,
        ];
      case DivisionEnum.tkMaxxEuropeUk:
        return [LabelDefinitionConditionEnum.isDivision05];
      case DivisionEnum.tkMaxxEuropeOther:
        return [LabelDefinitionConditionEnum.isDivision55];
      case DivisionEnum.marshallsUsa:
        return [
          LabelDefinitionConditionEnum.isDivision10,
          LabelDefinitionConditionEnum.isDivision04Or10,
        ];
      case DivisionEnum.homeGoodsUsaOrHomeSenseUsa:
        return [
          LabelDefinitionConditionEnum.isDivision28,
          LabelDefinitionConditionEnum.isDivision08Or28
        ];
      case DivisionEnum.homeSenseCanada:
        return [
          LabelDefinitionConditionEnum.isDivision04Or24,
          LabelDefinitionConditionEnum.isDivision24,
        ];
      case DivisionEnum.winnersCanadaOrMarshallsCanada:
        return [
          LabelDefinitionConditionEnum.isDivision04Or24,
          LabelDefinitionConditionEnum.isDivision04,
        ];
    }
  }

  @override
  String getLabelDefinition() {
    var condition = getCondition();
    List<PrinterLabelDefinition> ticketMakerDefinition =
        readConfigController.labelDefinitions.ticketMaker ?? [];
    String? definitionWithDataUpdated;
    var tagType = getTagType();

    logger.d(
        "ticketMakerDefinition:${ticketMakerDefinition.length} | \ncondition:$condition |\ntagType:$tagType");
    definitionWithDataUpdated =
        LabelDefinitionParser.getLabelDefinitionFromGivenData(
            definitions: ticketMakerDefinition,
            conditions: condition,
            tagType: tagType,
            dataMap: toLabelDataMap(),
            numberOfLabels: quantity);

    if (definitionWithDataUpdated.isEmpty) {
      definitionWithDataUpdated =
          LabelDefinitionParser.getLabelDefinitionFromGivenData(
              definitions: ticketMakerDefinition,
              conditions: condition,
              tagType: getInvertTagType(tagType),
              dataMap: toLabelDataMap(),
              numberOfLabels: quantity);

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
