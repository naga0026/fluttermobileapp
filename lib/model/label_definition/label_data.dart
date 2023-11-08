import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';

import '../../controller/read_configuration/read_config_files__controller.dart';
import '../../controller/store_config/store_config_controller.dart';
import '../../utility/enums/label_definition_condition_enum.dart';
import '../../utility/enums/tag_type_enum.dart';

/// Abstract class that holds data to print label as well as the tag type and condition
/// Create class for each feature (like markdown, sgm, transfer) and extend it with this class
abstract class LabelData {
  final storeConfigController = Get.find<StoreConfigController>();
  final readConfigController = Get.find<ReadConfigFileController>();
  final logger = LoggerConfig.initLog();

  TagTypeEnum getTagType();

  List<LabelDefinitionConditionEnum> getCondition();

  /// Checks the tag type and condition and returns label definition
  String getLabelDefinition();

  /// Converts the data into key value pair which can later be used to
  /// generate label definition with real time values
  Map<String, dynamic> toLabelDataMap();
}
