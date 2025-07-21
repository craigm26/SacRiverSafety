import 'package:dio/dio.dart';
import 'package:sacriversafety/core/constants/api_config.dart';
import 'package:sacriversafety/core/error/api_exception.dart';
import 'package:sacriversafety/core/interceptors/retry_interceptor.dart';
import 'package:sacriversafety/data/models/weather_response.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';

/// Service for fetching weather data from National Weather Service
class WeatherService {
  final Dio _dio;

  WeatherService() : _dio = Dio() {
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.interceptors.add(RetryInterceptor());
  }

  /// Get current weather conditions for Sacramento area
  Future<WeatherObservation> getCurrentWeather() async {
    try {
      // Use Sacramento Executive Airport as primary station
      final response = await _dio.get(
        '${ApiConfig.weatherStationsUrl}KSAC/observations/latest',
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Weather API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
          endpoint: '${ApiConfig.weatherStationsUrl}KSAC/observations/latest',
        );
      }

      final data = response.data;
      if (data == null) {
        throw ApiException('Invalid response from weather API');
      }

      return WeatherObservation.fromJson(data);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch weather data: $e');
    }
  }

  /// Get weather forecast for Sacramento area
  Future<List<WeatherPeriod>> getWeatherForecast() async {
    try {
      // Sacramento forecast grid coordinates (approximate)
      const office = 'STO'; // Sacramento Weather Forecast Office
      const x = 120; // Grid X coordinate
      const y = 80;  // Grid Y coordinate

      final response = await _dio.get(
        '${ApiConfig.weatherBaseUrl}gridpoints/$office/$x,$y/forecast',
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Weather forecast API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
          endpoint: '${ApiConfig.weatherBaseUrl}gridpoints/$office/$x,$y/forecast',
        );
      }

      final data = response.data;
      if (data == null || data['properties'] == null) {
        throw ApiException('Invalid response from weather forecast API');
      }

      final weatherResponse = WeatherResponse.fromJson(data);
      return weatherResponse.properties.periods;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch weather forecast: $e');
    }
  }

  /// Get weather alerts for California
  Future<List<Map<String, dynamic>>> getWeatherAlerts() async {
    try {
      final response = await _dio.get(
        ApiConfig.weatherAlertsUrl,
        queryParameters: {
          'area': 'CA',
          'status': 'actual',
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Weather alerts API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
          endpoint: ApiConfig.weatherAlertsUrl,
        );
      }

      final data = response.data;
      if (data == null || data['features'] == null) {
        throw ApiException('Invalid response from weather alerts API');
      }

      final features = data['features'] as List;
      return features.map((feature) {
        final properties = feature['properties'] ?? {};
        return {
          'headline': properties['headline'] ?? 'Weather Alert',
          'description': properties['description'] ?? '',
          'severity': properties['severity'] ?? 'unknown',
          'effective': properties['effective'] ?? '',
          'expires': properties['expires'] ?? '',
        };
      }).toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch weather alerts: $e');
    }
  }

  /// Get comprehensive trail conditions including weather
  Future<TrailCondition> getTrailConditions() async {
    try {
      final weather = await getCurrentWeather();
      final forecast = await getWeatherForecast();
      final alerts = await getWeatherAlerts();

      // Calculate overall safety level
      final overallSafety = _calculateSafetyLevel(weather, forecast, alerts);

      return TrailCondition(
        temperature: weather.temperature,
        airQualityIndex: 50, // Default value, will be updated by air quality service
        weatherCondition: weather.description,
        sunrise: null, // Will be calculated separately
        sunset: null, // Will be calculated separately
        alerts: alerts.map((a) => a['headline'] as String).toList(),
        overallSafety: overallSafety,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch trail conditions: $e');
    }
  }

  /// Calculate safety level based on weather conditions
  String _calculateSafetyLevel(
    WeatherObservation weather,
    List<WeatherPeriod> forecast,
    List<Map<String, dynamic>> alerts,
  ) {
    // Check for extreme weather conditions
    if (weather.temperature > 95.0) {
      return 'danger'; // Extreme heat
    }
    if (weather.temperature < 32.0) {
      return 'caution'; // Freezing conditions
    }

    // Check for severe weather alerts
    final severeAlerts = alerts.where((alert) {
      final severity = alert['severity'] as String?;
      return severity == 'Severe' || severity == 'Extreme';
    }).toList();

    if (severeAlerts.isNotEmpty) {
      return 'danger';
    }

    // Check forecast for adverse conditions
    final adverseConditions = forecast.where((period) {
      final forecastText = period.shortForecast.toLowerCase();
      return forecastText.contains('thunderstorm') ||
             forecastText.contains('tornado') ||
             forecastText.contains('flood') ||
             forecastText.contains('extreme');
    }).toList();

    if (adverseConditions.isNotEmpty) {
      return 'caution';
    }

    return 'safe';
  }
} 