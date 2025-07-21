import 'package:flutter_test/flutter_test.dart';
import 'package:sacriversafety/core/constants/api_config.dart';
import 'package:sacriversafety/core/error/api_exception.dart';
import 'package:sacriversafety/core/monitoring/api_health_monitor.dart';
import 'package:sacriversafety/data/models/weather_response.dart';
import 'package:sacriversafety/data/models/air_quality_response.dart';
import 'package:sacriversafety/data/services/weather_service.dart';
import 'package:sacriversafety/data/services/air_quality_service.dart';

void main() {
  group('API Configuration Tests', () {
    test('should have valid USGS API URLs', () {
      expect(ApiConfig.usgsBaseUrl, 'https://waterservices.usgs.gov/nwis/');
      expect(ApiConfig.usgsInstantaneousUrl, 'https://waterservices.usgs.gov/nwis/iv/');
      expect(ApiConfig.usgsDailyUrl, 'https://waterservices.usgs.gov/nwis/dv/');
    });

    test('should have valid weather API URLs', () {
      expect(ApiConfig.weatherBaseUrl, 'https://api.weather.gov/');
      expect(ApiConfig.weatherStationsUrl, 'https://api.weather.gov/stations/');
      expect(ApiConfig.weatherAlertsUrl, 'https://api.weather.gov/alerts/active');
    });

    test('should have valid air quality API URLs', () {
      expect(ApiConfig.airNowBaseUrl, 'https://www.airnowapi.org/aq/');
      expect(ApiConfig.airNowObservationUrl, 'https://www.airnowapi.org/aq/observation/zipCode/current/');
    });

    test('should have Sacramento weather stations', () {
      expect(ApiConfig.sacramentoWeatherStations, contains('KSAC'));
      expect(ApiConfig.sacramentoWeatherStations, contains('KSMF'));
    });

    test('should have Sacramento ZIP codes', () {
      expect(ApiConfig.sacramentoZipCodes, contains('95814'));
      expect(ApiConfig.sacramentoZipCodes, contains('95816'));
      expect(ApiConfig.sacramentoZipCodes.length, greaterThan(10));
    });

    test('should have reasonable cache durations', () {
      expect(ApiConfig.riverDataCache.inMinutes, 15);
      expect(ApiConfig.weatherCache.inMinutes, 30);
      expect(ApiConfig.airQualityCache.inHours, 1);
      expect(ApiConfig.alertsCache.inMinutes, 5);
    });

    test('should have reasonable timeouts', () {
      expect(ApiConfig.connectTimeout.inSeconds, 10);
      expect(ApiConfig.receiveTimeout.inSeconds, 10);
    });

    test('should have retry configuration', () {
      expect(ApiConfig.maxRetries, 3);
      expect(ApiConfig.retryDelay.inSeconds, 2);
    });
  });

  group('API Exception Tests', () {
    test('should create API exception with all parameters', () {
      final exception = ApiException(
        'Test error message',
        statusCode: 500,
        endpoint: '/test/endpoint',
        context: {'key': 'value'},
      );

      expect(exception.message, 'Test error message');
      expect(exception.statusCode, 500);
      expect(exception.endpoint, '/test/endpoint');
      expect(exception.context, {'key': 'value'});
      expect(exception.timestamp, isA<DateTime>());
    });

    test('should determine retry correctly', () {
      // Network error (no status code) should retry
      final networkError = ApiException('Network error');
      expect(networkError.shouldRetry, true);

      // 5xx errors should retry
      final serverError = ApiException('Server error', statusCode: 500);
      expect(serverError.shouldRetry, true);

      // 4xx errors (except 429) should not retry
      final clientError = ApiException('Client error', statusCode: 400);
      expect(clientError.shouldRetry, false);

      // 429 (rate limit) should retry
      final rateLimitError = ApiException('Rate limited', statusCode: 429);
      expect(rateLimitError.shouldRetry, true);
    });

    test('should provide appropriate retry delays', () {
      final rateLimitError = ApiException('Rate limited', statusCode: 429);
      expect(rateLimitError.retryDelay.inSeconds, 30);

      final serverError = ApiException('Server error', statusCode: 500);
      expect(serverError.retryDelay.inSeconds, 5);

      final networkError = ApiException('Network error');
      expect(networkError.retryDelay.inSeconds, 2);
    });
  });

  group('Weather Response Model Tests', () {
    test('should parse weather response from JSON', () {
      final json = {
        'properties': {
          'periods': [
            {
              'number': 1,
              'name': 'Tonight',
              'temperature': 65,
              'shortForecast': 'Clear',
              'detailedForecast': 'Clear skies tonight',
            }
          ],
          'observation': {
            'temperature': 70.0,
            'textDescription': 'Partly Cloudy',
            'timestamp': '2024-01-01T12:00:00Z',
          }
        }
      };

      final response = WeatherResponse.fromJson(json);
      expect(response.properties.periods.length, 1);
      expect(response.properties.periods.first.temperature, 65);
      expect(response.properties.observation?.temperature, 70.0);
    });

    test('should handle missing observation data', () {
      final json = {
        'properties': {
          'periods': []
        }
      };

      final response = WeatherResponse.fromJson(json);
      expect(response.properties.periods, isEmpty);
      expect(response.properties.observation, isNull);
    });
  });

  group('Air Quality Response Model Tests', () {
    test('should parse air quality response from JSON', () {
      final json = [
        {
          'DateObserved': '2024-01-01',
          'AQI': 45,
          'Category': {'Name': 'Good'},
          'ParameterName': 'Ozone',
          'Latitude': 38.5816,
          'Longitude': -121.4944,
        }
      ];

      final response = AirQualityResponse.fromJson(json);
      expect(response.observations.length, 1);
      expect(response.observations.first.aqi, 45);
      expect(response.observations.first.category, 'Good');
    });

    test('should handle empty observations', () {
      final json = <Map<String, dynamic>>[];
      final response = AirQualityResponse.fromJson(json);
      expect(response.observations, isEmpty);
    });
  });

  group('Air Quality Service Tests', () {
    late AirQualityService airQualityService;

    setUp(() {
      airQualityService = AirQualityService();
    });

    test('should determine air quality safety levels correctly', () {
      expect(airQualityService.getAirQualitySafetyLevel(25), 'safe');
      expect(airQualityService.getAirQualitySafetyLevel(75), 'caution');
      expect(airQualityService.getAirQualitySafetyLevel(125), 'caution');
      expect(airQualityService.getAirQualitySafetyLevel(175), 'danger');
      expect(airQualityService.getAirQualitySafetyLevel(350), 'danger');
    });

    test('should provide correct air quality categories', () {
      expect(airQualityService.getAirQualityCategory(25), 'Good');
      expect(airQualityService.getAirQualityCategory(75), 'Moderate');
      expect(airQualityService.getAirQualityCategory(125), 'Unhealthy for Sensitive Groups');
      expect(airQualityService.getAirQualityCategory(175), 'Unhealthy');
      expect(airQualityService.getAirQualityCategory(350), 'Hazardous');
    });

    test('should provide appropriate recommendations', () {
      final goodRecommendation = airQualityService.getAirQualityRecommendations(25);
      expect(goodRecommendation, contains('good'));
      expect(goodRecommendation, contains('safe'));

      final unhealthyRecommendation = airQualityService.getAirQualityRecommendations(175);
      expect(unhealthyRecommendation, contains('unhealthy'));
      expect(unhealthyRecommendation, contains('reduce'));
    });
  });

  group('API Health Monitor Tests', () {
    setUp(() {
      ApiHealthMonitor.clearMetrics();
    });

    test('should track successful API calls', () {
      ApiHealthMonitor.trackApiCall(
        endpoint: '/test/endpoint',
        duration: const Duration(milliseconds: 500),
        success: true,
        statusCode: 200,
      );

      final summary = ApiHealthMonitor.getHealthSummary();
      expect(summary.endpoints['/test/endpoint'], isNotNull);
      expect(summary.endpoints['/test/endpoint']!.totalCalls, 1);
      expect(summary.endpoints['/test/endpoint']!.successfulCalls, 1);
      expect(summary.endpoints['/test/endpoint']!.errorRate, 0.0);
    });

    test('should track failed API calls', () {
      ApiHealthMonitor.trackApiCall(
        endpoint: '/test/endpoint',
        duration: const Duration(milliseconds: 1000),
        success: false,
        statusCode: 500,
        errorMessage: 'Server error',
      );

      final summary = ApiHealthMonitor.getHealthSummary();
      expect(summary.endpoints['/test/endpoint']!.totalCalls, 1);
      expect(summary.endpoints['/test/endpoint']!.successfulCalls, 0);
      expect(summary.endpoints['/test/endpoint']!.errorRate, 1.0);
    });

    test('should calculate error rates correctly', () {
      // Add 10 calls: 8 successful, 2 failed
      for (int i = 0; i < 8; i++) {
        ApiHealthMonitor.trackApiCall(
          endpoint: '/test/endpoint',
          duration: const Duration(milliseconds: 500),
          success: true,
        );
      }
      for (int i = 0; i < 2; i++) {
        ApiHealthMonitor.trackApiCall(
          endpoint: '/test/endpoint',
          duration: const Duration(milliseconds: 1000),
          success: false,
        );
      }

      final errorRate = ApiHealthMonitor.getErrorRate('/test/endpoint');
      expect(errorRate, 0.2); // 20% error rate
    });

    test('should determine endpoint health correctly', () {
      // Add calls with 3% error rate (should be healthy)
      for (int i = 0; i < 97; i++) {
        ApiHealthMonitor.trackApiCall(
          endpoint: '/test/endpoint',
          duration: const Duration(milliseconds: 500),
          success: true,
        );
      }
      for (int i = 0; i < 3; i++) {
        ApiHealthMonitor.trackApiCall(
          endpoint: '/test/endpoint',
          duration: const Duration(milliseconds: 1000),
          success: false,
        );
      }

      expect(ApiHealthMonitor.isEndpointHealthy('/test/endpoint'), true);
    });

    test('should calculate average response times', () {
      ApiHealthMonitor.trackApiCall(
        endpoint: '/test/endpoint',
        duration: const Duration(milliseconds: 500),
        success: true,
      );
      ApiHealthMonitor.trackApiCall(
        endpoint: '/test/endpoint',
        duration: const Duration(milliseconds: 1000),
        success: true,
      );

      final avgTime = ApiHealthMonitor.getAverageResponseTime('/test/endpoint');
      expect(avgTime, greaterThan(0));
    });

    test('should limit metrics storage', () {
      // Add 150 calls (should keep only last 100)
      for (int i = 0; i < 150; i++) {
        ApiHealthMonitor.trackApiCall(
          endpoint: '/test/endpoint',
          duration: const Duration(milliseconds: 500),
          success: true,
        );
      }

      final summary = ApiHealthMonitor.getHealthSummary();
      expect(summary.endpoints['/test/endpoint']!.totalCalls, 100);
    });
  });
} 