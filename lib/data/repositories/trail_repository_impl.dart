import 'package:sacriversafety/data/services/trail_service.dart';
import 'package:sacriversafety/data/services/weather_service.dart';
import 'package:sacriversafety/data/services/air_quality_service.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/trail_incident.dart';
import 'package:sacriversafety/domain/entities/park_status.dart';
import 'package:sacriversafety/domain/entities/drowning_incident.dart';
import 'package:sacriversafety/domain/entities/resource_directory.dart';
import 'package:sacriversafety/domain/entities/life_jacket_program.dart';
import 'package:sacriversafety/domain/entities/trail_data.dart';
import 'package:sacriversafety/domain/repositories/trail_repository.dart';

/// Implementation of TrailRepository
class TrailRepositoryImpl implements TrailRepository {
  final TrailService _trailService;
  final WeatherService _weatherService;
  final AirQualityService _airQualityService;

  const TrailRepositoryImpl({
    required TrailService trailService,
    required WeatherService weatherService,
    required AirQualityService airQualityService,
  })  : _trailService = trailService,
        _weatherService = weatherService,
        _airQualityService = airQualityService;

  @override
  Future<TrailCondition> getTrailCondition() async {
    try {
      // Get weather conditions
      final weatherCondition = await _weatherService.getTrailConditions();
      
      // Get air quality
      final airQualityIndex = await _airQualityService.getAverageAQI();
      
      // Combine weather and air quality data
      return TrailCondition(
        temperature: weatherCondition.temperature,
        airQualityIndex: airQualityIndex,
        weatherCondition: weatherCondition.weatherCondition,
        sunrise: weatherCondition.sunrise,
        sunset: weatherCondition.sunset,
        alerts: weatherCondition.alerts,
        overallSafety: _calculateOverallSafety(weatherCondition, airQualityIndex),
      );
    } catch (e) {
      // Fallback to trail service data
      return await _trailService.getTrailCondition();
    }
  }

  /// Calculate overall safety level based on weather and air quality
  String _calculateOverallSafety(TrailCondition weather, int airQualityIndex) {
    // Check air quality first
    final airQualitySafety = _airQualityService.getAirQualitySafetyLevel(airQualityIndex);
    
    // If air quality is dangerous, overall is dangerous
    if (airQualitySafety == 'danger') return 'danger';
    
    // If air quality is caution, overall is caution unless weather is also dangerous
    if (airQualitySafety == 'caution' && weather.overallSafety == 'danger') {
      return 'danger';
    }
    
    // Return the worse of the two conditions
    if (weather.overallSafety == 'danger' || airQualitySafety == 'caution') {
      return 'caution';
    }
    
    return 'safe';
  }

  @override
  Future<List<TrailAmenity>> getTrailAmenities() async {
    return await _trailService.getTrailAmenities();
  }

  @override
  Future<List<SafetyAlert>> getSafetyAlerts() async {
    return await _trailService.getSafetyAlerts();
  }

  @override
  Future<List<TrailIncident>> getTrailIncidents() async {
    return await _trailService.getTrailIncidents();
  }

  @override
  Future<List<ParkStatus>> getParkStatus() async {
    return await _trailService.getParkStatus();
  }

  @override
  Future<List<DrowningIncident>> getDrowningIncidents() async {
    return await _trailService.getDrowningIncidents();
  }

  @override
  Future<List<ResourceDirectory>> getResourceDirectory() async {
    return await _trailService.getResourceDirectory();
  }

  @override
  Future<List<LifeJacketProgram>> getLifeJacketPrograms() async {
    return await _trailService.getLifeJacketPrograms();
  }

  @override
  Future<List<TrailSegment>> getTrailSegments() async {
    return await _trailService.getTrailSegments();
  }
} 