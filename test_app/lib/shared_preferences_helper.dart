import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  String get accessToken => _preferences?.getString(keyAccessToken) ?? '';
  set accessToken(String value) {
    _preferences?.setString(keyAccessToken, value);
  }
}
final sharedPreferences = SharedPreferencesHelper();

const String keyAccessToken = "key_access_token";
