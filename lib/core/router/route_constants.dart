/// Route constants for the Sac River Safety app
class RouteConstants {
  // Main routes
  static const String home = '/';
  static const String river = '/river';
  static const String trail = '/trail';
  static const String map = '/map';
  static const String alerts = '/alerts';
  static const String about = '/about';
  static const String settings = '/settings';
  static const String safetyEducation = '/safety-education';
  static const String statistics = '/statistics';
  static const String resourceDirectory = '/resources';
  static const String pdfFlyers = '/flyers';
  static const String volunteerResources = '/volunteer-resources';

  // River routes
  static const String riverConditions = '/river/conditions';
  static const String riverAlert = '/river/alert';

  // Trail routes
  static const String trailSafety = '/trail/safety';
  static const String trailAmenities = '/trail/amenities';
  static const String trailIncident = '/trail/incident';

  // Alert routes
  static const String alertsRiver = '/alerts/river';
  static const String alertsTrail = '/alerts/trail';
  static const String alertDetail = '/alerts/alert';

  // Legacy routes (for backward compatibility)
  static const String riverConditionsLegacy = '/river-conditions';
  static const String trailSafetyLegacy = '/trail-safety';

  // Route names for named navigation
  static const String homeName = 'home';
  static const String riverName = 'river';
  static const String riverDetailName = 'river-detail';
  static const String riverAlertName = 'river-alert';
  static const String trailName = 'trail';
  static const String trailSafetyName = 'trail-safety';
  static const String trailAmenitiesName = 'trail-amenities';
  static const String trailIncidentName = 'trail-incident';
  static const String mapName = 'map';
  static const String alertsName = 'alerts';
  static const String alertsRiverName = 'alerts-river';
  static const String alertsTrailName = 'alerts-trail';
  static const String alertDetailName = 'alert-detail';
  static const String aboutName = 'about';
  static const String settingsName = 'settings';
  static const String safetyEducationName = 'safety-education';
  static const String statisticsName = 'statistics';
  static const String resourceDirectoryName = 'resources';
  static const String pdfFlyersName = 'flyers';
  static const String volunteerResourcesName = 'volunteer-resources';

  /// Generate river conditions URL with gauge ID
  static String riverConditionsWithGauge(String gaugeId) => '$riverConditions/$gaugeId';

  /// Generate river alert URL with alert ID
  static String riverAlertWithId(String alertId) => '$riverAlert/$alertId';

  /// Generate trail incident URL with incident ID
  static String trailIncidentWithId(String incidentId) => '$trailIncident/$incidentId';

  /// Generate alert detail URL with alert ID
  static String alertDetailWithId(String alertId) => '$alertDetail/$alertId';

  /// Generate URL with query parameters
  static String withQueryParams(String baseUrl, Map<String, String> params) {
    if (params.isEmpty) return baseUrl;
    
    final queryString = Uri(queryParameters: params).query;
    return '$baseUrl?$queryString';
  }

  /// Check if route is a river-related route
  static bool isRiverRoute(String route) {
    return route.startsWith('/river');
  }

  /// Check if route is a trail-related route
  static bool isTrailRoute(String route) {
    return route.startsWith('/trail');
  }

  /// Check if route is an alert-related route
  static bool isAlertRoute(String route) {
    return route.startsWith('/alerts');
  }

  /// Check if route is a detail page (has path parameters)
  static bool isDetailRoute(String route) {
    return route.contains('/:') || 
           route.contains('/conditions/') ||
           route.contains('/alert/') ||
           route.contains('/incident/');
  }

  /// Extract gauge ID from river conditions URL
  static String? extractGaugeId(String route) {
    final pattern = RegExp(r'/river/conditions/([^/?]+)');
    final match = pattern.firstMatch(route);
    return match?.group(1);
  }

  /// Extract alert ID from alert URL
  static String? extractAlertId(String route) {
    final pattern = RegExp(r'/alerts/alert/([^/?]+)');
    final match = pattern.firstMatch(route);
    return match?.group(1);
  }

  /// Extract incident ID from trail incident URL
  static String? extractIncidentId(String route) {
    final pattern = RegExp(r'/trail/incident/([^/?]+)');
    final match = pattern.firstMatch(route);
    return match?.group(1);
  }
} 