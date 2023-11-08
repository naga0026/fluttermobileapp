import 'package:base_project/utility/logger/logger_config.dart';
import 'package:logger/logger.dart';

class MockLoggerConfig  implements LoggerConfig {

  static Logger logger = MockLoggerConfig.initLog();

  static initLog() {
    final logger =  Logger();
    return logger;
  }

}