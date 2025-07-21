import 'package:sacriversafety/core/services/language_service.dart';

/// Helper class for managing translations
class TranslationHelper {
  static final Map<String, Map<String, String>> _translations = {
    'en': {
      'app_title': 'Sac River Safety',
      'home': 'Home',
      'river_conditions': 'River Conditions',
      'trail_safety': 'Trail Safety',
      'interactive_map': 'Interactive Map',
      'safety_education': 'Safety Education',
      'statistics': 'Statistics',
      'safety_alerts': 'Safety Alerts',
      'emergency_info': 'Emergency Information',
      'about': 'About',
      'language': 'Language',
      'settings': 'Settings',
      'help_support': 'Help & Support',
      'version': 'Version',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'close': 'Close',
      'save': 'Save',
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'refresh': 'Refresh',
      'share': 'Share',
      'report': 'Report',
      'contact': 'Contact',
      'emergency': 'Emergency',
      'safety': 'Safety',
      'water_level': 'Water Level',
      'flow_rate': 'Flow Rate',
      'temperature': 'Temperature',
      'weather': 'Weather',
      'alerts': 'Alerts',
      'warnings': 'Warnings',
      'closures': 'Closures',
      'incidents': 'Incidents',
      'statistics': 'Statistics',
      'education': 'Education',
      'resources': 'Resources',
      'volunteer': 'Volunteer',
      'donate': 'Donate',
      'about_us': 'About Us',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'accessibility': 'Accessibility',
      'feedback': 'Feedback',
      'support': 'Support',
    },
    'es': {
      'app_title': 'Seguridad del Río Sacramento',
      'home': 'Inicio',
      'river_conditions': 'Condiciones del Río',
      'trail_safety': 'Seguridad de Senderos',
      'interactive_map': 'Mapa Interactivo',
      'safety_education': 'Educación de Seguridad',
      'statistics': 'Estadísticas',
      'safety_alerts': 'Alertas de Seguridad',
      'emergency_info': 'Información de Emergencia',
      'about': 'Acerca de',
      'language': 'Idioma',
      'settings': 'Configuración',
      'help_support': 'Ayuda y Soporte',
      'version': 'Versión',
      'loading': 'Cargando...',
      'error': 'Error',
      'retry': 'Reintentar',
      'close': 'Cerrar',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'ok': 'OK',
      'yes': 'Sí',
      'no': 'No',
      'back': 'Atrás',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'search': 'Buscar',
      'filter': 'Filtrar',
      'sort': 'Ordenar',
      'refresh': 'Actualizar',
      'share': 'Compartir',
      'report': 'Reportar',
      'contact': 'Contacto',
      'emergency': 'Emergencia',
      'safety': 'Seguridad',
      'water_level': 'Nivel de Agua',
      'flow_rate': 'Tasa de Flujo',
      'temperature': 'Temperatura',
      'weather': 'Clima',
      'alerts': 'Alertas',
      'warnings': 'Advertencias',
      'closures': 'Cierres',
      'incidents': 'Incidentes',
      'statistics': 'Estadísticas',
      'education': 'Educación',
      'resources': 'Recursos',
      'volunteer': 'Voluntario',
      'donate': 'Donar',
      'about_us': 'Sobre Nosotros',
      'privacy_policy': 'Política de Privacidad',
      'terms_of_service': 'Términos de Servicio',
      'accessibility': 'Accesibilidad',
      'feedback': 'Comentarios',
      'support': 'Soporte',
    },
    'zh': {
      'app_title': '萨克拉门托河安全',
      'home': '首页',
      'river_conditions': '河流状况',
      'trail_safety': '步道安全',
      'interactive_map': '交互式地图',
      'safety_education': '安全教育',
      'statistics': '统计',
      'safety_alerts': '安全警报',
      'emergency_info': '紧急信息',
      'about': '关于',
      'language': '语言',
      'settings': '设置',
      'help_support': '帮助和支持',
      'version': '版本',
      'loading': '加载中...',
      'error': '错误',
      'retry': '重试',
      'close': '关闭',
      'save': '保存',
      'cancel': '取消',
      'ok': '确定',
      'yes': '是',
      'no': '否',
      'back': '返回',
      'next': '下一步',
      'previous': '上一步',
      'search': '搜索',
      'filter': '筛选',
      'sort': '排序',
      'refresh': '刷新',
      'share': '分享',
      'report': '报告',
      'contact': '联系',
      'emergency': '紧急',
      'safety': '安全',
      'water_level': '水位',
      'flow_rate': '流量',
      'temperature': '温度',
      'weather': '天气',
      'alerts': '警报',
      'warnings': '警告',
      'closures': '关闭',
      'incidents': '事件',
      'statistics': '统计',
      'education': '教育',
      'resources': '资源',
      'volunteer': '志愿者',
      'donate': '捐赠',
      'about_us': '关于我们',
      'privacy_policy': '隐私政策',
      'terms_of_service': '服务条款',
      'accessibility': '无障碍',
      'feedback': '反馈',
      'support': '支持',
    },
  };

  /// Get translation for a key in the current language
  static Future<String> t(String key) async {
    final currentLanguage = await LanguageService.getCurrentLanguage();
    return _translations[currentLanguage]?[key] ?? 
           _translations['en']?[key] ?? 
           key;
  }

  /// Get translation for a key in a specific language
  static String tForLanguage(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? 
           _translations['en']?[key] ?? 
           key;
  }

  /// Check if a translation exists for a key
  static bool hasTranslation(String key, [String? languageCode]) {
    if (languageCode != null) {
      return _translations[languageCode]?.containsKey(key) ?? false;
    }
    return _translations.values.any((lang) => lang.containsKey(key));
  }

  /// Get all available translation keys
  static Set<String> get availableKeys {
    final keys = <String>{};
    for (final lang in _translations.values) {
      keys.addAll(lang.keys);
    }
    return keys;
  }

  /// Get supported languages for translations
  static Set<String> get supportedTranslationLanguages {
    return _translations.keys.toSet();
  }

  /// Add a new translation
  static void addTranslation(String languageCode, String key, String value) {
    _translations[languageCode] ??= {};
    _translations[languageCode]![key] = value;
  }

  /// Remove a translation
  static void removeTranslation(String languageCode, String key) {
    _translations[languageCode]?.remove(key);
  }

  /// Get all translations for a specific language
  static Map<String, String>? getTranslationsForLanguage(String languageCode) {
    return _translations[languageCode];
  }
} 