import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation utility class for programmatic navigation and deep linking
class NavigationUtils {
  /// Navigate to river conditions overview
  static void goToRiverConditions(BuildContext context) {
    context.go('/river');
  }

  /// Navigate to specific river gauge details
  static void goToRiverGauge(BuildContext context, String gaugeId) {
    context.go('/river/conditions/$gaugeId');
  }

  /// Navigate to river gauge with query parameters
  static void goToRiverGaugeWithParams(
    BuildContext context, 
    String gaugeId, {
    String? timeRange,
    String? units,
  }) {
    final queryParams = <String, String>{};
    if (timeRange != null) queryParams['time'] = timeRange;
    if (units != null) queryParams['units'] = units;
    
    final queryString = queryParams.isNotEmpty 
        ? '?${Uri(queryParameters: queryParams).query}'
        : '';
    
    context.go('/river/conditions/$gaugeId$queryString');
  }

  /// Navigate to river alert details
  static void goToRiverAlert(BuildContext context, String alertId) {
    context.go('/river/alert/$alertId');
  }

  /// Navigate to trail safety overview
  static void goToTrailSafety(BuildContext context) {
    context.go('/trail');
  }

  /// Navigate to trail amenities
  static void goToTrailAmenities(BuildContext context, {String? type}) {
    final queryString = type != null ? '?type=$type' : '';
    context.go('/trail/amenities$queryString');
  }

  /// Navigate to trail incident details
  static void goToTrailIncident(BuildContext context, String incidentId) {
    context.go('/trail/incident/$incidentId');
  }

  /// Navigate to interactive map
  static void goToMap(BuildContext context) {
    context.go('/map');
  }

  /// Navigate to all safety alerts
  static void goToAlerts(BuildContext context) {
    context.go('/alerts');
  }

  /// Navigate to river alerts only
  static void goToRiverAlerts(BuildContext context) {
    context.go('/alerts/river');
  }

  /// Navigate to trail alerts only
  static void goToTrailAlerts(BuildContext context) {
    context.go('/alerts/trail');
  }

  /// Navigate to specific alert details
  static void goToAlertDetails(BuildContext context, String alertId) {
    context.go('/alerts/alert/$alertId');
  }

  /// Navigate to safety education page
  static void goToSafetyEducation(BuildContext context) {
    context.go('/safety-education');
  }

  /// Navigate to statistics page
  static void goToStatistics(BuildContext context) {
    context.go('/statistics');
  }

  /// Navigate to about page
  static void goToAbout(BuildContext context) {
    context.go('/about');
  }

  /// Navigate to settings page
  static void goToSettings(BuildContext context) {
    context.go('/settings');
  }

  /// Navigate to home page
  static void goToHome(BuildContext context) {
    context.go('/');
  }

  /// Navigate back
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  /// Generate deep link URL for sharing
  static String generateDeepLink({
    required String route,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
  }) {
    String url = route;
    
    // Replace path parameters
    if (pathParameters != null) {
      for (final entry in pathParameters.entries) {
        url = url.replaceAll(':${entry.key}', entry.value);
      }
    }
    
    // Add query parameters
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParameters).query;
      url = '$url?$queryString';
    }
    
    return url;
  }

  /// Generate shareable URL for river gauge
  static String generateRiverGaugeLink(String gaugeId, {String? timeRange}) {
    final params = <String, String>{};
    if (timeRange != null) params['time'] = timeRange;
    
    return generateDeepLink(
      route: '/river/conditions/:gaugeId',
      pathParameters: {'gaugeId': gaugeId},
      queryParameters: params.isNotEmpty ? params : null,
    );
  }

  /// Generate shareable URL for trail incident
  static String generateTrailIncidentLink(String incidentId) {
    return generateDeepLink(
      route: '/trail/incident/:incidentId',
      pathParameters: {'incidentId': incidentId},
    );
  }

  /// Generate shareable URL for safety alert
  static String generateAlertLink(String alertId) {
    return generateDeepLink(
      route: '/alerts/alert/:alertId',
      pathParameters: {'alertId': alertId},
    );
  }

  /// Check if current route matches pattern
  static bool isCurrentRoute(BuildContext context, String routePattern) {
    final location = GoRouterState.of(context).uri.path;
    return location == routePattern || location.startsWith('$routePattern/');
  }

  /// Get current route path
  static String getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Get path parameters from current route
  static Map<String, String> getPathParameters(BuildContext context) {
    return GoRouterState.of(context).pathParameters;
  }

  /// Get query parameters from current route
  static Map<String, String> getQueryParameters(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }
} 