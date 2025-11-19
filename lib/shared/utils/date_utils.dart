import 'package:intl/intl.dart';

class DateUtilsShared {
  static String formatDate(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(date);
  }

  static DateTime? parseDate(String input, {String pattern = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(pattern).parseStrict(input);
    } catch (_) {
      return null;
    }
  }
}
