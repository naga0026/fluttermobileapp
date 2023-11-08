import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

abstract class BaseService extends GetxService {

  Logger logger = LoggerConfig.initLog();

}