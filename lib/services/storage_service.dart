import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service for bookmarks and user preferences
class StorageService {
  static const String _bookmarksKey = 'bookmarked_shlokas';
  static const String _lastReadKey = 'last_read';
  static const String _themeKey = 'theme_mode'; // 'dark', 'light', 'system'
  static const String _scriptKey = 'script_mode'; // 'dual', 'kannada', 'devanagari'
  static const String _fontSizeKey = 'font_size'; // multiplier: 1.0, 1.2, 1.5, etc.
  static const String _readModeKey = 'read_mode'; // 'swipe' or 'scroll'

  // ── Bookmarks ──
  static Future<Set<String>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_bookmarksKey) ?? [];
    return list.toSet();
  }

  static Future<void> toggleBookmark(String shlokaId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_bookmarksKey) ?? [];
    final set = list.toSet();
    if (set.contains(shlokaId)) {
      set.remove(shlokaId);
    } else {
      set.add(shlokaId);
    }
    await prefs.setStringList(_bookmarksKey, set.toList());
  }

  static Future<bool> isBookmarked(String shlokaId) async {
    final bookmarks = await getBookmarks();
    return bookmarks.contains(shlokaId);
  }

  // ── Last Read Position ──
  static Future<void> setLastRead(String granthaId, String adhyayaId, int shlokaIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReadKey, '$granthaId|$adhyayaId|$shlokaIndex');
  }

  static Future<Map<String, dynamic>?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_lastReadKey);
    if (val == null) return null;
    final parts = val.split('|');
    if (parts.length != 3) return null;
    return {
      'granthaId': parts[0],
      'adhyayaId': parts[1],
      'shlokaIndex': int.tryParse(parts[2]) ?? 0,
    };
  }

  // ── Theme Mode ──
  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'dark';
  }

  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }

  // ── Script Mode ──
  static Future<String> getScriptMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_scriptKey) ?? 'dual';
  }

  static Future<void> setScriptMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scriptKey, mode);
  }

  // ── Font Size ──
  static Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeKey) ?? 1.0;
  }

  static Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  // ── Read Mode ──
  static Future<String> getReadMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_readModeKey) ?? 'swipe';
  }

  static Future<void> setReadMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_readModeKey, mode);
  }
}
