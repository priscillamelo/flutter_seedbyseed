import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDate {
  static const String kLASTRECORDEDDATE = "lastRecordedDate";
  
  static saveCurrentDay(DateTime lastRecordedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(kLASTRECORDEDDATE, lastRecordedDate.toString());
  }

  static Future<String> getLastRecordedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSaveDate = prefs.getString(kLASTRECORDEDDATE);
    return lastSaveDate ?? "";
  }
}
