import 'package:dio/dio.dart';
import 'package:sacriversafety/core/constants/api_config.dart';
import 'package:sacriversafety/core/error/api_exception.dart';
import 'package:sacriversafety/core/interceptors/retry_interceptor.dart';
import 'package:sacriversafety/data/models/air_quality_response.dart';

/// Service for fetching air quality data from AirNow API
class AirQualityService {
  final Dio _dio;

  AirQualityService() : _dio = Dio() {
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.interceptors.add(RetryInterceptor());
  }

  /// Get current air quality for Sacramento area
  Future<AirQualityObservation> getCurrentAirQuality({String? zipCode}) async {
    try {
      final targetZipCode = zipCode ?? ApiConfig.sacramentoZipCodes.first;
      
      final response = await _dio.get(
        ApiConfig.airNowObservationUrl,
        queryParameters: {
          'format': 'application/json',
          'zipCode': targetZipCode,
          'distance': '25',
          'API_KEY': ApiConfig.airNowApiKey,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'AirNow API returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
          endpoint: ApiConfig.airNowObservationUrl,
        );
      }

      final data = response.data;
      if (data == null) {
        throw ApiException('Invalid response from AirNow API');
      }

      // AirNow returns a list of observations
      final observations = data as List;
      if (observations.isEmpty) {
        throw ApiException('No air quality data available');
      }

      // Return the first observation (most recent)
      return AirQualityObservation.fromJson(observations.first);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch air quality data: $e');
    }
  }

  /// Get air quality for multiple Sacramento ZIP codes
  Future<List<AirQualityObservation>> getSacramentoAirQuality() async {
    final observations = <AirQualityObservation>[];
    
    for (final zipCode in ApiConfig.sacramentoZipCodes.take(5)) { // Limit to 5 for performance
      try {
        final observation = await getCurrentAirQuality(zipCode: zipCode);
        observations.add(observation);
      } catch (e) {
        // Continue with other ZIP codes if one fails
        print('Failed to get air quality for ZIP $zipCode: $e');
      }
    }
    
    return observations;
  }

  /// Get average air quality index for Sacramento area
  Future<int> getAverageAQI() async {
    try {
      final observations = await getSacramentoAirQuality();
      
      if (observations.isEmpty) {
        return 50; // Default moderate AQI
      }
      
      final totalAQI = observations.fold<int>(0, (sum, obs) => sum + obs.aqi);
      return (totalAQI / observations.length).round();
    } catch (e) {
      return 50; // Default moderate AQI on error
    }
  }

  /// Get air quality safety level
  String getAirQualitySafetyLevel(int aqi) {
    if (aqi <= 50) return 'safe';
    if (aqi <= 100) return 'caution';
    if (aqi <= 150) return 'caution';
    if (aqi <= 200) return 'danger';
    if (aqi <= 300) return 'danger';
    return 'danger'; // Very unhealthy or hazardous
  }

  /// Get air quality category description
  String getAirQualityCategory(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  /// Get air quality recommendations
  String getAirQualityRecommendations(int aqi) {
    if (aqi <= 50) {
      return 'Air quality is good. Outdoor activities are safe for everyone.';
    } else if (aqi <= 100) {
      return 'Air quality is moderate. Sensitive individuals should consider reducing outdoor activities.';
    } else if (aqi <= 150) {
      return 'Air quality is unhealthy for sensitive groups. Children, elderly, and those with respiratory conditions should limit outdoor activities.';
    } else if (aqi <= 200) {
      return 'Air quality is unhealthy. Everyone should reduce outdoor activities, especially children and those with respiratory conditions.';
    } else if (aqi <= 300) {
      return 'Air quality is very unhealthy. Everyone should avoid outdoor activities.';
    } else {
      return 'Air quality is hazardous. Everyone should stay indoors and avoid outdoor activities.';
    }
  }
} 