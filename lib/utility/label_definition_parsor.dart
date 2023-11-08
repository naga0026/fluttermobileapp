import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';

import '../model/label_definition/printer_label_definition.dart';
import 'enums/label_definition_condition_enum.dart';
import 'enums/tag_type_enum.dart';

class LabelDefinitionParser {
  static String replaceDoubleBraces(
      String labelDefinition, Map<String, dynamic> labelDataMap) {
    return labelDefinition.replaceAllMapped(RegExp(r'{{(.+?)}}'), (match) {
      String? g1 = match.group(1);
      return labelDataMap[g1] ?? g1;
    });
  }

  static String getLabelDefinitionFromGivenData(
      {required List<PrinterLabelDefinition> definitions,
      required List<LabelDefinitionConditionEnum> conditions,
      required TagTypeEnum tagType, required Map<String, dynamic> dataMap, int numberOfLabels = 1}) {
    PrinterLabelDefinition? definition;
    if (conditions.length >= 2) {
      for (var conditionObject in conditions) {
        definition = definitions.firstWhereOrNull((element) {
          return element.condition.contains(conditionObject.rawValue) &&
              element.tagType.contains(tagType.rawValue);
        });
        LoggerConfig.logger.d("$conditionObject $definitions");
        if (definition != null) {
          break;
        }
      }
    } else {
      definition = definitions.firstWhereOrNull((element) {
        return element.condition.contains(conditions.first.rawValue) &&
            element.tagType.contains(tagType.rawValue);
      });
    }

    if (definition != null) {
      LoggerConfig.logger.d(
          "Selected label definition for ${definition.tagType} & ${definition.condition}: ");
      var labelDefinitionString = '';
      for (var element in definition.labelDefinition) {
        if(element=="^PQ1" && numberOfLabels>1){
          element="^PQ$numberOfLabels";
        }
        labelDefinitionString = '$labelDefinitionString\n$element';
      }
      LoggerConfig.logger.d(labelDefinitionString);
      String parsedDefinition = LabelDefinitionParser.replaceDoubleBraces(
          labelDefinitionString, dataMap);
      LoggerConfig.logger.d("Parsed definition: $parsedDefinition");
      return "\'$parsedDefinition\'";
    } else {
      LoggerConfig.logger.i(
          "No label definitions found for Tag type ${definition?.tagType} and condition ${definition?.condition}");
      return '';
    }
  }
}
