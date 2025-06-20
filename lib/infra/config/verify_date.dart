import 'package:flutter_seedbyseed/infra/config/shared_preferences_date.dart';
import 'package:intl/intl.dart';

class VerifyDate {
  static String normalizeDayMonth(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static Future<bool> loadAndCompareDate(DateTime dateTimeNow) async {
    String lastRecordedDateString = await SharedPreferencesDate.getLastRecordedDate();

    if (lastRecordedDateString.isEmpty) {
      await SharedPreferencesDate.saveCurrentDay(dateTimeNow);
      return true;
    }

    DateTime lastRecordedDate = DateTime.parse(lastRecordedDateString);

    final String diaMesNow = normalizeDayMonth(dateTimeNow);
    final String lastDayMonth = normalizeDayMonth(lastRecordedDate);

    bool isNewDay = diaMesNow != lastDayMonth;

    if (isNewDay) {
      await SharedPreferencesDate.saveCurrentDay(dateTimeNow);
    }

    return isNewDay;
  }
}
