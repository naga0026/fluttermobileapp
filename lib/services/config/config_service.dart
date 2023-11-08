import 'dart:convert';
import 'dart:io';
import 'package:base_project/utility/constants/app/platform_channel_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import '../../utility/logger/logger_config.dart';

class ConfigService extends GetxService {
  Logger logger = LoggerConfig.initLog();
  static const _channel = PlatformChannelConstants.sboConfigurationsChannel;
  static String folderName = "SBO_Configuration";
  static String? universalFolderName;

  Future<ConfigService> init() async {
    await checkPermissionAndCreateDir();
    return this;
  }

  Future<String?> getConfigFolderPath() async {
    final getDir = await getExternalStorageDirectory();
    String? sortDir;
    if (getDir != null) {
      sortDir = "${getDir.toString().split("Android")[0]}Documents/$folderName/"
          .substring(12);
    }
    universalFolderName = sortDir;
    return sortDir;
  }

  Future<void> rewriteExistingFileAppBaseUrl(String ipAddress,
      {bool isRemote = false}) async {
    try {
      Map<String, dynamic> arg = {};
      arg["FolderName"] = folderName;
      const fileName = "apiBaseUrlParameter.json";
      final data =
          await rootBundle.loadString("assets/configurations/$fileName");
      final readableData = jsonDecode(data);
      if (isRemote) {
        readableData["ApiBaseUrl"] =
            "https://dev.api.tjx.com/stores/storeweb/$ipAddress/v2";
      } else {
        readableData["ipAddress"] = ipAddress;
      }
      arg[fileName] = jsonEncode(readableData);
      await _channel.invokeMethod("rewrite_file", arg);
    } catch (e) {
      logger
          .e("Error while rewriting apiBaseUrlParameter.json file | Error:$e");
    }
  }

  Future<(bool, List<String>)> checkIfAllFilesAreInFolder() async {
    List<String> filesWhichAreNotInFolder = [];
    List<String> filesWhichAreInFolder = [];
    var (arguments, filesList) = await getArgumentByReferringCountConfigFile();
    var (isDirExists, dirPath) = await checkIfConfigDirectoryExist();
    if (!isDirExists) {
      logger.e("Config folder Directory is not exists");
      return (false, filesWhichAreNotInFolder);
    }
    for (String itr in filesList) {
      if (dirPath != null) {
        if (File(dirPath + itr).existsSync()) {
          filesWhichAreInFolder.add(itr);
        } else {
          filesWhichAreNotInFolder.add(itr);
        }
      }
    }
    return filesWhichAreNotInFolder.isEmpty
        ? (true, filesWhichAreInFolder)
        : (false, filesWhichAreNotInFolder);
  }

  Future<(bool, String?)> checkIfConfigDirectoryExist() async {
    final sortDir = await getConfigFolderPath();
    if (sortDir != null) {
      if (Directory(sortDir).existsSync()) {
        return (true, sortDir);
      }
    }
    return (false, null);
  }

  getManualFilesDataArg(fileList) async {
    Map<String, dynamic> arg = {};
    arg["FolderName"] = folderName;
    for (String fileName in fileList) {
      final data =
          await rootBundle.loadString("assets/configurations/$fileName");
      arg[fileName] = data;
    }
    return arg;
  }

  Future<(Map<String, dynamic>, List<String>)>
      getArgumentByReferringCountConfigFile() async {
    Map<String, dynamic> arguments = {};
    List<String> filesList = [];
    final readFinalCountFile = await rootBundle
        .loadString("assets/configurations/configFileCount.json");
    final decodeFinalCountFile = jsonDecode(readFinalCountFile);
    final int fileCount = decodeFinalCountFile["count"];
    final files = decodeFinalCountFile["fileNames"];
    arguments["FolderName"] = folderName;
    if (fileCount == files.length) {
      for (int itr in Iterable.generate(fileCount)) {
        filesList.add(files[itr]);
        final data =
            await rootBundle.loadString("assets/configurations/${files[itr]}");
        arguments[files[itr]] = data;
      }
    }
    return (arguments, filesList);
  }

  Future<void> checkPermissionAndCreateDir() async {
    try {
      var (isDirectoryExist, path) = await checkIfConfigDirectoryExist();
      var (areAllFilesExists, fileList) = await checkIfAllFilesAreInFolder();
      if (isDirectoryExist) {
        if (!areAllFilesExists) {
          //here will check which files are not there is DIR and Write them.
          final arg = await getManualFilesDataArg(fileList);
          await _channel.invokeMethod("load_single_config", arg);
        }
      } else {
        //If DIR not exist means need to create it and write all the files.

        var (arguments, filesList) =
            await getArgumentByReferringCountConfigFile();
        await _channel.invokeMethod("load_config", arguments);
      }
    } catch (e) {
      logger.e(
          "facing issue while loading configuration files due to | issue: $e");
    }
  }
}
