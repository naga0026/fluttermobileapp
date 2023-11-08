import 'package:base_project/utility/constants/app/shared_preferences_constants.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/constants/app/table_names.dart';
import '../database/database_service.dart';

class SharedPreferenceService extends GetxService {
  late final SharedPreferences _sharedPreferences;

  Future<SharedPreferenceService> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  dynamic get({required String key, required Type type}) {
    switch (type) {
      case int:
        return _sharedPreferences.getInt(key);
      case bool:
        return _sharedPreferences.getBool(key);
      case double:
        return _sharedPreferences.getDouble(key);
      case String:
        return _sharedPreferences.getString(key) ?? '';
      default:
        LoggerConfig.logger.i("$type is not a default type");
        return null;
    }
  }

  void set({required String key, required dynamic value}) {
    var type = value.runtimeType;
    switch (type) {
      case int:
        _sharedPreferences.setInt(key, value);
        break;
      case bool:
        _sharedPreferences.setBool(key, value);
        break;
      case double:
        _sharedPreferences.setDouble(key, value);
        break;
      case String:
        _sharedPreferences.setString(key, value);
        break;
      default:
        LoggerConfig.logger.i("$type is not a default type");
    }
  }

  Future<void> clearCache({bool isClearDataOnLabChange = false}) async {
    final databaseService = Get.find<DatabaseService>();
    await databaseService.clearTable(TableNames.departmentItemTable);
    await databaseService.clearTable(TableNames.styleRangeItemTable);
    await databaseService.clearTable(TableNames.classItemTable);
    _sharedPreferences.remove(SharedPreferenceConstants.isDeptDataAvailable);
    _sharedPreferences.remove(SharedPreferenceConstants.isStyleRangeDataAvailable);
    _sharedPreferences.remove(SharedPreferenceConstants.isClassDataAvailable);
    _sharedPreferences.remove(SharedPreferenceConstants.recentInitialMarkdown);
    if(isClearDataOnLabChange){
      await databaseService.clearTable(TableNames.initialMarkdownTable);
      _sharedPreferences.remove(SharedPreferenceConstants.lastMarkdownDate);
    }
  }

  void setRecentMarkdown({int? logId}) {
    if(logId!=null){
      set(key: SharedPreferenceConstants.recentInitialMarkdown, value: logId);
    } else {
      _sharedPreferences.remove(SharedPreferenceConstants.recentInitialMarkdown);
    }
  }

  int? getRecentMarkdown() {
   return get(key: SharedPreferenceConstants.recentInitialMarkdown, type: int);
  }
}
