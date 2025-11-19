import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight SharedPreferences wrapper reused from delivery project.
/// Adapted to be project-neutral (no dependency on external SettingsState).
class SharedPreferencesService {
  static late SharedPreferences prefs;

  static const keys = {
    'pushNotification': 'pushNotification',
    'locationEnabled': 'locationEnabled',
    'languageIndex': 'languageIndex',
    'isDarkMode': 'isDarkMode',
    'lastRoute': 'lastRoute',
    'onboardingCompleted': 'onboardingCompleted',
  };

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Generic setters
  static Future<void> setBool(String key, bool value) =>
      prefs.setBool(keys[key] ?? key, value);

  static Future<void> setInt(String key, int value) =>
      prefs.setInt(keys[key] ?? key, value);

  static Future<void> setString(String key, String value) =>
      prefs.setString(keys[key] ?? key, value);

  // Generic getters
  static bool getBool(String key, {bool defaultValue = false}) =>
      prefs.getBool(keys[key] ?? key) ?? defaultValue;

  static int getInt(String key, {int defaultValue = 0}) =>
      prefs.getInt(keys[key] ?? key) ?? defaultValue;

  static String getString(String key, {String defaultValue = ''}) =>
      prefs.getString(keys[key] ?? key) ?? defaultValue;

  static Future<void> saveLastRoute(String path) async {
    await prefs.setString(keys['lastRoute']!, path);
  }

  static String getLastRoute() {
    return prefs.getString(keys['lastRoute']!) ?? '';
  }

  static Future<void> markOnboardingCompleted() async {
    await prefs.setBool(keys['onboardingCompleted']!, true);
  }

  static bool isOnboardingCompleted() {
    return prefs.getBool(keys['onboardingCompleted']!) ?? false;
  }
}
