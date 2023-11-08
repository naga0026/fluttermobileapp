import 'package:flutter/services.dart';

class PlatformChannelConstants {
  static const MethodChannel sboPrintMethodChannel =
  MethodChannel('com.tjxsbostoreapp/sbo_print_method_channel');

  static const EventChannel sboEventChannel =
  EventChannel('com.tjxsbostoreapp/scan');

  static const MethodChannel sboLogChannel =
  MethodChannel('com.tjxsbostoreapp/sbo_log_channel');

  static const MethodChannel sboConfigurationsChannel =
  MethodChannel('com.tjxsbostoreapp/sbo_config_channel');

  static const MethodChannel sboRestartChannel =
  MethodChannel('com.tjxsbostoreapp/sbo_restart_channel');

  static const dataWedgeSoftScanTrigger = 'com.symbol.datawedge.api.SOFT_SCAN_TRIGGER';
}