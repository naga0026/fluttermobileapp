import 'package:base_project/model/label_definition/label_data.dart';
import 'package:base_project/model/label_definition/printer_label_definition.dart';
import 'package:base_project/utility/enums/division_enum.dart';
import 'package:base_project/utility/label_definition_parsor.dart';

import '../../utility/constants/app/label_constants.dart';
import '../../utility/enums/label_definition_condition_enum.dart';
import '../../utility/enums/tag_type_enum.dart';

/// Markdown label data contains the data which can later be used for printing the labels
/// price will be string without decimals and formatted price will be with decimal points
class MarkdownLabelData extends LabelData {
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

  MarkdownLabelData(
      {required this.digiUserId,
      required this.dept,
      this.classCode,
      this.style,
      this.uline,
      required this.price,
      required this.formattedPrice,
        this.barcode,
      required this.weekNumber,
      required this.weekNumberLabel,
        this.division,
      });

  @override
  Map<String, dynamic> toLabelDataMap() {
    return {
      "DigiUserId": digiUserId,
      "FormattedPrice": storeConfigController.getCurrencySymbol() + formattedPrice,
      "Dept": dept,
      "Uline": uline,
      "Price":  price,
      "WeekNumberLabel": weekNumberLabel,
      "Barcode": barcode,
      "ClassCode": classCode,
      "Style": style,
      "WeekNumber": weekNumber
    };
  }

  @override
  TagTypeEnum getTagType() {
    var parsedPrice = int.parse(price);
    var tagType = parsedPrice < LabelsConstants.oneThousand
        ? TagTypeEnum.markdown
        : TagTypeEnum.markdownPriceAtLEast1000;
    return tagType;
  }

  @override
  List<LabelDefinitionConditionEnum> getCondition() {
    String division = storeConfigController.selectedDivision;
    DivisionEnum divisionEnum = division.getDivisionName;
    switch (divisionEnum) {
      case DivisionEnum.tjMaxxUsa:
        return [LabelDefinitionConditionEnum.isDivision08Or28];
      case DivisionEnum.tkMaxxEuropeUk:
        return [LabelDefinitionConditionEnum.isDivision05];
      case DivisionEnum.tkMaxxEuropeOther:
        return [LabelDefinitionConditionEnum.isDivision55];
      case DivisionEnum.marshallsUsa:
        return [LabelDefinitionConditionEnum.isDivision10];
      case DivisionEnum.homeGoodsUsaOrHomeSenseUsa:
        return [LabelDefinitionConditionEnum.isDivision08Or28];
      case DivisionEnum.homeSenseCanada:
        return [LabelDefinitionConditionEnum.isDivision04Or24];
      case DivisionEnum.winnersCanadaOrMarshallsCanada:
        return [LabelDefinitionConditionEnum.isDivision04Or24];
    }
  }

  @override
  String getLabelDefinition() {
    List<LabelDefinitionConditionEnum> condition = getCondition();
    TagTypeEnum tagType = getTagType();
    List<PrinterLabelDefinition> markdownDefinitions =
        readConfigController.labelDefinitions.markdown ?? [];
    return LabelDefinitionParser.getLabelDefinitionFromGivenData(
        definitions: markdownDefinitions,
        conditions: condition,
        tagType: tagType,
        dataMap: toLabelDataMap());
  }
}
