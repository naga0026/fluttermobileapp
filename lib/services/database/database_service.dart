import 'dart:io';
import 'dart:isolate';
import 'package:base_project/model/api_response/markdowns/subs/subs_department_codes_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_exceptions_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_guides_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_markdown_ranges_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_price_point_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_uline_class_response.dart';
import 'package:base_project/services/base/base_service.dart';
import 'package:base_project/services/caching/caching_service.dart';
import 'package:base_project/utility/constants/app/table_names.dart';
import 'package:base_project/utility/generic/mapping_model.dart';
import 'package:base_project/utility/generic/mapping_model_implementation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../model/api_response/markdowns/get_initial_markdown_response.dart';
import '../../model/class_item.dart';
import '../../model/department_item.dart';
import '../../model/printer_setup.dart';
import '../../model/request_page_params.dart';
import '../../model/style_range_data.dart';
import 'package:get/get.dart';

typedef ListCallBack = Function(List<dynamic>);

class DatabaseService extends BaseService {
  static const String dbName = 'sbo_store_app';

  //region Variables
  late Database _database;

  //endregion

  //region Database getter and initialization

  Future<DatabaseService> init() async {
    await initDatabase();
    return this;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}$dbName";

    var storeDB = await openDatabase(path,
        version: 1,
        onCreate: _createDB,
        password: "sbo_flutter",
        onUpgrade: _createDBV2);
    _database = storeDB;

    return storeDB;
  }

  // Create database function when creating a database for the first time
  Future _createDB(Database db, int newVersion) async {
    logger.i('create db v1');
    await initializeTables(db);
  }

  Future _createDBV2(Database db, int oldVersion, int newVersion) async {
    logger.i('create db v2');
    _createV2Table(db);
    // TODO: manage database version changes
  }

  Future<void> _createV2Table(Database db) async {
   // TODO: manage versioning
  }

  Future<void> initializeTables(Database db) async {
    await createTable(
        db: db,
        tableName: TableNames.initialMarkdownTable,
        tableVariables: MarkdownData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.classItemTable,
        tableVariables: GetClassData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.departmentItemTable,
        tableVariables: GetDepartmentData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.printerTable,
        tableVariables: PrinterSetUp.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.styleRangeItemTable,
        tableVariables: GetStyleRangeData.tableVariables());
    // Subs caching tables
    await createTable(
        db: db,
        tableName: TableNames.subsDepartmentCodeTable,
        tableVariables: SubsDepartmentData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.subsExceptionsTable,
        tableVariables: ExceptionData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.subsGuidesTable,
        tableVariables: GuideData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.subsRangesTable,
        tableVariables: RangeData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.subsPricePointsTable,
        tableVariables: PricePointData.tableVariables());
    await createTable(
        db: db,
        tableName: TableNames.subsUlineClassTable,
        tableVariables: UlineClassData.tableVariables());
  }

  Future<void> createTable(
      {required Database db,
      required String tableName,
      required String tableVariables}) async {
    var query = '''
    CREATE TABLE $tableName(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    $tableVariables
    )
    ''';
    try {
      await db.execute(query).then((_) {
        logger.d("Table created: $tableName");
      });
    } catch (error) {
      logger.e('Error while creating table $tableName : ${error.toString()}');
    }
  }

  Future clearTable(String tableName) async {
    try {
      await _database.rawDelete('''
      DELETE FROM $tableName
      ''');
    } catch (error) {
      logger
          .e("Error while clearing $tableName. Error is: ${error.toString()}");
    }
  }

//endregion

  //region Generic functions to perform database operations
  // Generic Add One Item
  Future<int?> genericAddSingleRow<T>(
      ClassMappingModel item, String table) async {
    try {
      var result = await _database.insert(table, item.toJson());
      logger.i('Generic item added: $result');
      return result;
    } catch (error) {
      logger.e("Error while adding to $table. Error is: ${error.toString()}");
    }
    return null;
  }

  // Generic Add List
  Future<void> addItems<T extends ClassMappingModel>(
      List<T> items, String table, {RequestPageParam? subsCachingParam}) async {
    RootIsolateToken? token = RootIsolateToken.instance;
    final receivePort = ReceivePort();
    await Isolate.spawn((SendPort sendPort) async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token!);
      final query = ClassMappingModelFactory.convertQuery(items);
      if (query != null) {
        final queryStr =
            'INSERT INTO $table ${query.keys} VALUES ${query.values}';
        await _database.rawQuery(queryStr);
        sendPort.send('''
        Adding items to $table completed. 
        Items added to $table = ${items.length},
        Current items in table $table = ${subsCachingParam?.currentRecords}
        ''');
      }
    }, receivePort.sendPort);
    receivePort.listen((message) {
      if(subsCachingParam != null){
        subsCachingParam.currentRecords += items.length;
        final cachingService = Get.find<CachingService>();
        cachingService.updateCachingProgress();
      }
      logger.i("Completion Status: $message");
    });
  }

  Future<List<Map<String, dynamic>>> getItems<T>({required String table}) async {
    try {
      var items = await _database.query(table);
      return items;
      // ClassMappingModel model =
      // ClassMappingModelFactory.get(typeOf<T>().toString());
      // var result = items.map<T>((e) => model.fromJson(e) as T).toList();
      // logger.i('Generic get all ${result.length}');
      // arrData = result;
    } catch (error) {
      logger
          .e("Error getting items from $table. Error is: ${error.toString()}");
    }
    return [];
  }

//endregion

  Future<Map<String, dynamic>?> selectQuery(
      {required String tableName,
      required Map<String, dynamic> queryParams}) async {
    var result =
        await selectAllQuery(tableName: tableName, queryParams: queryParams);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>?>> selectAllQuery(
      {required String tableName,
      required Map<String, dynamic> queryParams}) async {
    var whereClause = "";
    int index = 0;
    queryParams.forEach((key, value) {
      if (index == 0) {
        whereClause = "$whereClause$key = $value";
      } else {
        whereClause = "$whereClause AND $key = $value";
      }
      index++;
    });

    String query = "SELECT * FROM $tableName WHERE $whereClause";
    logger.i('query: $query');
    List<Map<String, dynamic>> result = await _database.rawQuery(query);
    logger.i('Select query result: $result');
    return result;
  }

  Future<List<Map<String, dynamic>?>> selectAllQueryWhere(
      {required String tableName,
        required String where}) async {

    String query = "SELECT * FROM $tableName WHERE $where";
    logger.i('query: $query');
    List<Map<String, dynamic>> result = await _database.rawQuery(query);
    logger.i('Select query result: $result');
    return result;
  }

// Map<String, dynamic> data = {};
// data["code"] = "01";
// data["division"] = "10";
// databaseService.selectQuery(TableNames.departmentItemTable, data);
}
