import 'package:shared_preferences/shared_preferences.dart';

/// Keys used to persist splash/intro visibility state.
/// Stored under SharedPreferences — works on Android, iOS, and web.
class SplashPreferenceKeys {
  SplashPreferenceKeys._();

  /// When true, the user has opted out of seeing the intro permanently.
  static const String hideSplash = 'phrasePopHideSplash';
}

/// Thin wrapper around [SharedPreferences] that encapsulates the
/// hide-splash preference.
///
/// Call [load] once at startup before reading any values.
class SplashPreferences {
  SplashPreferences._();

  static SharedPreferences? _prefs;

  /// Loads SharedPreferences. Must be called before any other method.
  static Future<void> load() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ─── Hide splash preference ───────────────────────────────────────────────

  /// Whether the user has permanently opted out of seeing the intro.
  static bool get hideSplash =>
      _prefs?.getBool(SplashPreferenceKeys.hideSplash) ?? false;

  /// Persists the user's "Don't show again" choice.
  static Future<void> setHideSplash(bool value) async {
    await _prefs?.setBool(SplashPreferenceKeys.hideSplash, value);
  }

  // ─── Decision helper ──────────────────────────────────────────────────────

  /// Returns true when the intro page should be shown on this launch.
  ///
  /// Rule: show on every launch unless the user has ticked "Don't show again".
  static bool get shouldShowIntro => !hideSplash;
}
