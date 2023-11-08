import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/services/database/database_service.dart';
import 'package:base_project/utility/constants/app/table_names.dart';
import 'package:get/get.dart';

import '../../model/style_range_data.dart';
import '../../services/caching/caching_service.dart';
import '../../utility/enums/division_enum.dart';
import '../../utility/enums/style_range_division_type.dart';
import '../store_config/store_config_controller.dart';

class StyleRangeValidationController extends BaseViewController {
  final storeConfigController = Get.find<StoreConfigController>();
  final databaseService = Get.find<DatabaseService>();

  bool isStyleRangeSupported() {
    final cachingService = Get.find<CachingService>();
    return cachingService.isStyleRangeSupported;
  }

  StyleRangeDivisionType parseCurrentDivision() {
    String division = storeConfigController.selectedDivision;
    DivisionEnum divisionEnum = division.getDivisionName;
    switch (divisionEnum) {
      case DivisionEnum.tjMaxxUsa:
        return StyleRangeDivisionType.t;
      case DivisionEnum.homeGoodsUsaOrHomeSenseUsa:
        return StyleRangeDivisionType.h;
      default:
        throw Exception("Division type in mega store cannot be parsed.");
    }
  }

  Future<bool> validateStyleRangeStyle(
      {required String style, required String department}) async {
    var styleInInt = int.tryParse(style) ?? 0;
    var divisionType = parseCurrentDivision();
    var divisionTypeQuery = divisionType.rawValue;
    Map<String, dynamic> query = {
      "department": "\'$department\'"
    };
    List<Map<String,
        dynamic>?> styleRangeItemsForCurrentDept = await databaseService
        .selectAllQuery(
        tableName: TableNames.styleRangeItemTable,
        queryParams: query);

    // If department is not present in cached style range data,
    // then it means it's no overlapping so it's valid
    if (styleRangeItemsForCurrentDept.isEmpty) {
      return true;
    }

    var styleRangeItems = styleRangeItemsForCurrentDept.where((
        element) => element?["chain"].toString().toLowerCase() == divisionTypeQuery).toList();

    if (styleRangeItems.isEmpty) {
      logger.d("Style range item not found in cache");
      return false;
    }

    logger.d("Style range items found in cache");

    for (var styleRangeItem in styleRangeItems) {
      if(styleRangeItem!=null){
        final styleRangeData = GetStyleRangeData.fromJson(styleRangeItem);
        if(styleInInt >= styleRangeData.startRange && styleInInt <= styleRangeData.endRange){
          logger.d("Style $style was in range defined by style range item $styleRangeItem");
          return true;
        }
      }
    }
    logger.d("Style $style was not in range defined by style range item");
    return false;
  }
}
