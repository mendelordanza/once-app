import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider<SharedPrefs>((ref) => SharedPrefs());

class SharedPrefs {
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static const String KEY_IS_FINISHED = "key_is_finished";
  static const String KEY_USER_ID = "key_user_id";
  static const String KEY_EMAIL = "key_email";
  static const String KEY_FIRST_NAME = "key_first_name";
  static const String KEY_LAST_NAME = "key_last_name";
  static const String KEY_TASK_FOR_TODAY = "KEY_TASK_FOR_TODAY";

  Future setFinishedOnboarding(bool isFinished) async {
    await _preferences?.setBool(KEY_IS_FINISHED, isFinished);
  }

  bool? getFinishedOnboarding() => _preferences?.getBool(KEY_IS_FINISHED);

  Future setUserId(String userId) async {
    await _preferences?.setString(KEY_USER_ID, userId);
  }

  String? getUserId() => _preferences?.getString(KEY_USER_ID);

  Future setEmail(String email) async {
    await _preferences?.setString(KEY_EMAIL, email);
  }

  String? getEmail() => _preferences?.getString(KEY_EMAIL);

  Future setFirstName(String username) async {
    await _preferences?.setString(KEY_FIRST_NAME, username);
  }

  String? getFirstName() => _preferences?.getString(KEY_FIRST_NAME);

  Future setLastName(String lastName) async {
    await _preferences?.setString(KEY_LAST_NAME, lastName);
  }

  String? getLastName() => _preferences?.getString(KEY_LAST_NAME);

  Future setTaskForToday(String task) async {
    await _preferences?.setString(KEY_TASK_FOR_TODAY, task);
  }

  String? getTaskForToday() => _preferences?.getString(KEY_TASK_FOR_TODAY);

  Future clear() async {
    await _preferences?.remove(KEY_USER_ID);
    await _preferences?.remove(KEY_EMAIL);
    await _preferences?.remove(KEY_FIRST_NAME);
    await _preferences?.remove(KEY_LAST_NAME);
  }
}
