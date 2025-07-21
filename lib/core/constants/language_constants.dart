/// Language constants for the Sac River Safety app
class LanguageConstants {
  // Supported languages for the Sacramento region
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {
      'name': 'English',
      'native': 'English',
      'flag': '🇺🇸',
    },
    'es': {
      'name': 'Spanish',
      'native': 'Español',
      'flag': '🇪🇸',
    },
    'zh': {
      'name': 'Chinese',
      'native': '中文',
      'flag': '🇨🇳',
    },
    'vi': {
      'name': 'Vietnamese',
      'native': 'Tiếng Việt',
      'flag': '🇻🇳',
    },
    'ru': {
      'name': 'Russian',
      'native': 'Русский',
      'flag': '🇷🇺',
    },
    'hmn': {
      'name': 'Hmong',
      'native': 'Hmong',
      'flag': '🇱🇦',
    },
    'ko': {
      'name': 'Korean',
      'native': '한국어',
      'flag': '🇰🇷',
    },
    'hi': {
      'name': 'Hindi',
      'native': 'हिन्दी',
      'flag': '🇮🇳',
    },
  };

  /// Get language info by code
  static Map<String, String>? getLanguageInfo(String languageCode) {
    return supportedLanguages[languageCode];
  }

  /// Get all supported language codes
  static List<String> get supportedLanguageCodes {
    return supportedLanguages.keys.toList();
  }

  /// Check if language is supported
  static bool isSupported(String languageCode) {
    return supportedLanguages.containsKey(languageCode);
  }

  /// Get default language
  static String get defaultLanguage => 'en';
} 