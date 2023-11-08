import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';

import '../services/network/mock_api_repository.dart';

abstract class MockBaseViewController extends GetxController {
  final repository = MockAPIRepository();
  final logger = LoggerConfig.initLog();
}