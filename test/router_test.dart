import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sacriversafety/core/router/route_constants.dart';
import 'package:sacriversafety/core/router/navigation_utils.dart';

void main() {
  group('Route Constants Tests', () {
    test('should generate correct river conditions URL', () {
      final url = RouteConstants.riverConditionsWithGauge('11446500');
      expect(url, '/river/conditions/11446500');
    });

    test('should generate correct alert detail URL', () {
      final url = RouteConstants.alertDetailWithId('high-water-2024-07-15');
      expect(url, '/alerts/alert/high-water-2024-07-15');
    });

    test('should generate correct trail incident URL', () {
      final url = RouteConstants.trailIncidentWithId('2024-07-15-001');
      expect(url, '/trail/incident/2024-07-15-001');
    });

    test('should identify river routes correctly', () {
      expect(RouteConstants.isRiverRoute('/river'), true);
      expect(RouteConstants.isRiverRoute('/river/conditions/11446500'), true);
      expect(RouteConstants.isRiverRoute('/trail'), false);
    });

    test('should identify trail routes correctly', () {
      expect(RouteConstants.isTrailRoute('/trail'), true);
      expect(RouteConstants.isTrailRoute('/trail/amenities'), true);
      expect(RouteConstants.isTrailRoute('/river'), false);
    });

    test('should identify alert routes correctly', () {
      expect(RouteConstants.isAlertRoute('/alerts'), true);
      expect(RouteConstants.isAlertRoute('/alerts/river'), true);
      expect(RouteConstants.isAlertRoute('/river'), false);
    });

    test('should identify detail routes correctly', () {
      expect(RouteConstants.isDetailRoute('/river/conditions/11446500'), true);
      expect(RouteConstants.isDetailRoute('/alerts/alert/high-water-2024-07-15'), true);
      expect(RouteConstants.isDetailRoute('/river'), false);
    });

    test('should extract gauge ID correctly', () {
      final gaugeId = RouteConstants.extractGaugeId('/river/conditions/11446500');
      expect(gaugeId, '11446500');
    });

    test('should extract alert ID correctly', () {
      final alertId = RouteConstants.extractAlertId('/alerts/alert/high-water-2024-07-15');
      expect(alertId, 'high-water-2024-07-15');
    });

    test('should extract incident ID correctly', () {
      final incidentId = RouteConstants.extractIncidentId('/trail/incident/2024-07-15-001');
      expect(incidentId, '2024-07-15-001');
    });

    test('should generate URL with query parameters', () {
      final url = RouteConstants.withQueryParams('/river/conditions/11446500', {
        'time': '7d',
        'units': 'metric'
      });
      expect(url, '/river/conditions/11446500?time=7d&units=metric');
    });

    test('should handle empty query parameters', () {
      final url = RouteConstants.withQueryParams('/river/conditions/11446500', {});
      expect(url, '/river/conditions/11446500');
    });
  });

  group('Navigation Utils Tests', () {
    test('should generate correct deep link for river gauge', () {
      final link = NavigationUtils.generateRiverGaugeLink('11446500', timeRange: '7d');
      expect(link, '/river/conditions/11446500?time=7d');
    });

    test('should generate correct deep link for trail incident', () {
      final link = NavigationUtils.generateTrailIncidentLink('2024-07-15-001');
      expect(link, '/trail/incident/2024-07-15-001');
    });

    test('should generate correct deep link for alert', () {
      final link = NavigationUtils.generateAlertLink('high-water-2024-07-15');
      expect(link, '/alerts/alert/high-water-2024-07-15');
    });

    test('should generate deep link with query parameters', () {
      final link = NavigationUtils.generateDeepLink(
        route: '/river/conditions/:gaugeId',
        pathParameters: {'gaugeId': '11446500'},
        queryParameters: {'time': '7d', 'units': 'metric'},
      );
      expect(link, '/river/conditions/11446500?time=7d&units=metric');
    });

    test('should generate deep link without query parameters', () {
      final link = NavigationUtils.generateDeepLink(
        route: '/river/conditions/:gaugeId',
        pathParameters: {'gaugeId': '11446500'},
      );
      expect(link, '/river/conditions/11446500');
    });

    test('should generate deep link without path parameters', () {
      final link = NavigationUtils.generateDeepLink(
        route: '/river',
        queryParameters: {'time': '7d'},
      );
      expect(link, '/river?time=7d');
    });
  });

  group('Route Structure Tests', () {
    test('should have correct main routes', () {
      expect(RouteConstants.home, '/');
      expect(RouteConstants.river, '/river');
      expect(RouteConstants.trail, '/trail');
      expect(RouteConstants.map, '/map');
      expect(RouteConstants.alerts, '/alerts');
      expect(RouteConstants.about, '/about');
      expect(RouteConstants.settings, '/settings');
    });

    test('should have correct river sub-routes', () {
      expect(RouteConstants.riverConditions, '/river/conditions');
      expect(RouteConstants.riverAlert, '/river/alert');
    });

    test('should have correct trail sub-routes', () {
      expect(RouteConstants.trailSafety, '/trail/safety');
      expect(RouteConstants.trailAmenities, '/trail/amenities');
      expect(RouteConstants.trailIncident, '/trail/incident');
    });

    test('should have correct alert sub-routes', () {
      expect(RouteConstants.alertsRiver, '/alerts/river');
      expect(RouteConstants.alertsTrail, '/alerts/trail');
      expect(RouteConstants.alertDetail, '/alerts/alert');
    });

    test('should have correct legacy routes', () {
      expect(RouteConstants.riverConditionsLegacy, '/river-conditions');
      expect(RouteConstants.trailSafetyLegacy, '/trail-safety');
    });

    test('should have correct route names', () {
      expect(RouteConstants.homeName, 'home');
      expect(RouteConstants.riverName, 'river');
      expect(RouteConstants.trailName, 'trail');
      expect(RouteConstants.mapName, 'map');
      expect(RouteConstants.alertsName, 'alerts');
      expect(RouteConstants.aboutName, 'about');
      expect(RouteConstants.settingsName, 'settings');
    });
  });

  group('URL Examples Tests', () {
    test('should support river conditions URLs', () {
      expect(RouteConstants.river, '/river');
      expect(RouteConstants.riverConditionsWithGauge('11446500'), '/river/conditions/11446500');
      expect(RouteConstants.riverConditionsWithGauge('11447650'), '/river/conditions/11447650');
    });

    test('should support trail safety URLs', () {
      expect(RouteConstants.trail, '/trail');
      expect(RouteConstants.trailSafety, '/trail/safety');
      expect(RouteConstants.trailAmenities, '/trail/amenities');
      expect(RouteConstants.trailIncidentWithId('2024-07-15-001'), '/trail/incident/2024-07-15-001');
    });

    test('should support safety alerts URLs', () {
      expect(RouteConstants.alerts, '/alerts');
      expect(RouteConstants.alertsRiver, '/alerts/river');
      expect(RouteConstants.alertsTrail, '/alerts/trail');
      expect(RouteConstants.alertDetailWithId('high-water-2024-07-15'), '/alerts/alert/high-water-2024-07-15');
    });

    test('should support query parameters', () {
      expect(RouteConstants.withQueryParams('/river/conditions/11446500', {'time': '7d'}), 
             '/river/conditions/11446500?time=7d');
      expect(RouteConstants.withQueryParams('/river/conditions/11446500', {'units': 'metric'}), 
             '/river/conditions/11446500?units=metric');
      expect(RouteConstants.withQueryParams('/trail/amenities', {'type': 'water'}), 
             '/trail/amenities?type=water');
    });
  });
} 