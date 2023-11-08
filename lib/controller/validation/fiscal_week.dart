import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:get/get.dart';

import '../../model/fiscal_week_model.dart';

class FiscalWeekCalculationService extends BaseViewController {
  final readFile = Get.find<ReadConfigFileController>();
  final List<DateTime> _dateTimes = [];

  List<FiscalWeekDefinition>? get fiscalWeeksAndYears =>
      readFile.fiscalWeekDefinition;

  @override
  void onInit() {
    super.onInit();
    loadFiscalDates();
  }

  void loadFiscalDates() {
    try {
      final selectedFiscalWeeksAndYears = fiscalWeeksAndYears!
          .map((sfi) => sfi.fiscalWeek)
          .map(createDateTimeFiscalWeekFromString);

      for (final newDt in selectedFiscalWeeksAndYears) {
        _dateTimes.add(newDt);
      }
    } catch (ex) {
      logger.e("Fiscal weeks could not be loaded from property file $ex");
    }

    _dateTimes.sort();
  }

  DateTime createDateTimeFiscalWeekFromString(String value) {
    const startMonthIndex = 0;
    const monthLength = 2;

    const startDayIndex = startMonthIndex + monthLength;
    const dayLength = 2;

    const startYearIndex = startDayIndex + dayLength;
    const yearLength = 4;

    try {
      final parsedYear = int.parse(
          value.substring(startYearIndex, startYearIndex + yearLength));
      final parsedMonth = int.parse(
          value.substring(startMonthIndex, startMonthIndex + monthLength));
      final parsedDay =
          int.parse(value.substring(startDayIndex, startDayIndex + dayLength));

      final dateTime = DateTime(parsedYear, parsedMonth, parsedDay, 0, 0, 0);
      return dateTime;
    } catch (ex) {
      final exceptionMessage =
          "Parsing fiscal weeks from file failed. Exception: $ex";
      logger.e(exceptionMessage);
      throw ArgumentError(exceptionMessage);
    }
  }

  DateTime getStartDate(DateTime date) {
    for (var i = _dateTimes.length - 1; i >= 0; i--) {
      final startDate = _dateTimes[i];
      if (date.isBefore(startDate)) {
        continue;
      }

      logger.i("Returning start date: $startDate");
      return startDate;
    }

    throw ArgumentError(
        "Cannot determine start date to get fiscal week's starting date.");
  }

  int getCurrentFiscalWeek() {
    return getFiscalWeek(DateTime.now());
  }

  String getCurrentFiscalWeekBarcodeFormatted() {
    return getCurrentFiscalWeek().toString().padLeft(2, '0');
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  int getFiscalWeek(DateTime date) {
    final startDate = getStartDate(date);
    int fiscalWeek;
    int diff;
    final startJulian =
        startDate.difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final todayJulian = date.difference(DateTime(date.year, 1, 1)).inDays;

    if (date.year == startDate.year) {
      diff = todayJulian - startJulian;
      if (diff < 7) {
        fiscalWeek = 1;
      } else {
        fiscalWeek = (diff + 7) ~/ 7;
      }
    } else {
      final maxDaysOfStartDate = isLeapYear(startDate.year) ? 366 : 365;
      logger.i("Starting year is different than current year");
      logger.i("days in year: $maxDaysOfStartDate");
      diff = (maxDaysOfStartDate - startJulian) + todayJulian;

      fiscalWeek = (diff + 7) ~/ 7;
    }

    logger.d("Returning fiscal week: $fiscalWeek");
    return fiscalWeek;
  }
}
