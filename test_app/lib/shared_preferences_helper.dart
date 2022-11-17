import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;
  static List<String> _conferenceAliases = [];

  static Future<void> load() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  String get accessToken => _preferences?.getString(keyAccessToken) ?? '';
  set accessToken(String value) {
    _preferences?.setString(keyAccessToken, value);
  }

  String get username => _preferences?.getString(keyUsername) ?? '';
  set username(String value) {
    _preferences?.setString(keyUsername, value);
  }

  String get latestAlias => _preferences?.getString(keyLatestAlias) ?? '';
  set latestAlias(String value) {
    manageList(value);
    _preferences?.setString(keyLatestAlias, value);
  }

  List<String>? get conferenceAliases => _preferences?.getStringList(keyConferenceAliases);
  set conferenceAliases(List<String>? value) => _preferences?.setStringList(keyConferenceAliases, value ?? []);

  void manageList(String value) {
    _conferenceAliases = conferenceAliases ?? [];

    if (!_conferenceAliases.contains(value)) {
      if (_conferenceAliases.length == 5) {
        _conferenceAliases.removeAt(0);
      }
      _conferenceAliases.add(value);
      conferenceAliases = _conferenceAliases;
    }
  }
}

const String keyAccessToken = 'key_access_token';
const String keyUsername = 'key_username';
const String keyLatestAlias = 'key_latest_alias';
const String keyConferenceAliases = 'key_conference_aliases';
