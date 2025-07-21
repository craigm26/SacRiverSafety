import 'package:shared_preferences/shared_preferences.dart';
import 'package:sacriversafety/core/constants/language_constants.dart';

/// Service for managing language preferences and translations
class LanguageService {
  static const String _languageKey = 'selected_language';
  
  /// Get the current language preference
  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? LanguageConstants.defaultLanguage;
  }
  
  /// Set the language preference
  static Future<void> setLanguage(String languageCode) async {
    if (!LanguageConstants.isSupported(languageCode)) {
      throw ArgumentError('Unsupported language: $languageCode');
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  /// Get the current language info
  static Future<Map<String, String>?> getCurrentLanguageInfo() async {
    final languageCode = await getCurrentLanguage();
    return LanguageConstants.getLanguageInfo(languageCode);
  }
  
  /// Check if a language is currently selected
  static Future<bool> isLanguageSelected(String languageCode) async {
    final currentLanguage = await getCurrentLanguage();
    return currentLanguage == languageCode;
  }
  
  /// Get all supported languages with selection status
  static Future<Map<String, Map<String, dynamic>>> getSupportedLanguagesWithStatus() async {
    final currentLanguage = await getCurrentLanguage();
    final languages = <String, Map<String, dynamic>>{};
    
    for (final entry in LanguageConstants.supportedLanguages.entries) {
      languages[entry.key] = {
        ...entry.value,
        'isSelected': entry.key == currentLanguage,
      };
    }
    
    return languages;
  }
  
  /// Reset language to default
  static Future<void> resetToDefault() async {
    await setLanguage(LanguageConstants.defaultLanguage);
  }
  
  /// Get language display name
  static String getLanguageDisplayName(String languageCode) {
    final info = LanguageConstants.getLanguageInfo(languageCode);
    return info?['native'] ?? info?['name'] ?? languageCode;
  }
  
  /// Get language flag emoji
  static String getLanguageFlag(String languageCode) {
    final info = LanguageConstants.getLanguageInfo(languageCode);
    return info?['flag'] ?? '🌐';
  }
} 