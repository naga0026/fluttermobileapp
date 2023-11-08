import 'package:intl/intl.dart';

import 'constants/app/date_format.dart';

class Util {
  static String currentDateFormatted() {
    var today = DateTime.now().toUtc();
    final DateFormat formatter =
    DateFormat(DateFormatConstants.printerDateFormat);
    return formatter.format(today);
  }
}