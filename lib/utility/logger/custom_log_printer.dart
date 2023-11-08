import 'dart:convert';

import 'package:logger/logger.dart';

class CustomPrinter implements SimplePrinter {
  @override
  final bool printTime;
  @override
  final bool colors;
  CustomPrinter({this.printTime = false, this.colors = true});
  static final levelPrefixes = {
    Level.verbose: 'VERBOSE',
    Level.debug: 'DEBUG',
    Level.info: 'INFO',
    Level.warning: 'WARNING',
    Level.error: 'ERROR',
    Level.wtf: 'WTF',
  };
  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };
  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = printTime ? '${event.time.toLocal()}' : '';
    return ['$timeStr ${_labelFor(event.level)} $messageStr$errorStr'];
  }

  String _labelFor(Level level) {
    var prefix = levelPrefixes[level]!;
    var color = levelColors[level]!;

    return colors ? color(prefix) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
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