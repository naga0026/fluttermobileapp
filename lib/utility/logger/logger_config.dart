import 'dart:io';

import 'package:base_project/utility/constants/app/platform_channel_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'custom_log_printer.dart';

class LoggerConfig {

  static Logger logger = LoggerConfig.initLog();
  static int days = 15; //All logs that are older than 15 days will be deleted automatically,
  // with today being considered the current day..\

  static initLog() {
    final logger =  Logger(
      printer: CustomPrinter(printTime: true, colors: false),
      output: FileOutput(),
    );
    return logger;
  }

}

class FileOutput implements LogOutput {
  static const _platform = PlatformChannelConstants.sboLogChannel;

  openLogFile(fileName) async {
    await _platform.invokeMethod("open_log_file", {"filepath": fileName.path});
  }

  Future<String> findDirectory() async {
    return await getApplicationDocumentsDirectory().then((value) => value.path);
  }

  deleteFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final listFile = dir.listSync();
    for (var file in listFile) {
      if (await file.exists()) {
        if (file.path.toString().endsWith(".txt")) {
          final lastModified = File(file.path).lastModifiedSync();
          if (lastModified.isBefore(
              DateTime.now().subtract(Duration(days: LoggerConfig.days)))) {
            file.deleteSync();
          }
        }
      }
    }
  }

  Future<(bool, File?)> downloadCustomFile(String filepath) async {
    final File fileName = File(filepath);
    if (await permissionHandler()) {
      File saveLogFile = File(
          "/storage/emulated/0/Download/StoreAppLog${filepath.substring(44)}");
      saveLogFile.open(mode: FileMode.append);
      saveLogFile.writeAsStringSync(fileName.readAsStringSync(), flush: true);
      return (saveLogFile.existsSync(), saveLogFile);
    }
    return (false, null);
  }

  Future<bool> permissionHandler() async {
    final storagePermission = await Permission.storage.request();
    final manageStoragePermission =
    await Permission.manageExternalStorage.request();
    if (storagePermission.isGranted && manageStoragePermission.isGranted) {
      return true;
    } else {
      await Permission.storage.request();
      return await Permission.manageExternalStorage
          .request()
          .then((value) => true);
    }
  }

  getFile() async {
    String filepath = await findDirectory();
    final File file =
    File("$filepath/log${DateTime.now().toString().substring(0, 10)}.txt");
    return file;
  }

  @override
  void output(OutputEvent event) async {
    File file = await getFile();
    for (var line in event.lines) {
      try {
        file.writeAsStringSync("$line\n", mode: FileMode.append);
      } catch (e) {
        if (kDebugMode) {
          print("facing issue while writing log $e");
        }
      }
      if (kDebugMode) {
        print(event.lines.toString());
      }
    }
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void init() {
    // TODO: implement init
  }
}