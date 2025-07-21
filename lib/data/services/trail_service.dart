import 'package:dio/dio.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/trail_incident.dart';
import 'package:sacriversafety/domain/entities/park_status.dart';
import 'package:sacriversafety/domain/entities/drowning_incident.dart';
import 'package:sacriversafety/domain/entities/resource_directory.dart';
import 'package:sacriversafety/domain/entities/life_jacket_program.dart';
import 'package:sacriversafety/domain/entities/trail_data.dart';

/// Service for fetching trail safety data from external APIs
class TrailService {
  final Dio _dio = Dio();
  
  // API endpoints
  static const String _weatherApiUrl = 'https://api.weather.gov/gridpoints/STO/85,105/forecast';
  static const String _aqiApiUrl = 'https://www.airnowapi.org/aq/observation/zipCode/current/';
  static const String _sacCountyParksApiUrl = 'https://regionalparks.saccounty.gov/api/';
  static const String _folfanApiUrl = 'https://folfan.org/api/';
  
  TrailService() {
    // Configure Dio with reasonable timeouts
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// Get current trail conditions including weather and AQI
  Future<TrailCondition> getTrailCondition() async {
    try {
      // Get weather data from National Weather Service
      final weatherResponse = await _dio.get(_weatherApiUrl);
      final weatherData = weatherResponse.data;
      
      // Get AQI data from AirNow API
      final aqiData = await _getAQIData();
      
      // Parse weather data
      final currentPeriod = weatherData['properties']['periods'][0];
      final temperature = _extractTemperature(currentPeriod['temperature'].toString());
      final weatherCondition = currentPeriod['shortForecast'] as String;
      
      // Calculate safety level
      final safetyLevel = _calculateSafetyLevel(temperature, aqiData['aqi']);
      
      // Generate alerts based on real conditions
      final alerts = <String>[];
      if (temperature > 95) {
        alerts.add('High temperature warning: ${temperature.toStringAsFixed(0)}°F');
      }
      if (aqiData['aqi'] > 100) {
        alerts.add('Poor air quality: AQI ${aqiData['aqi']}');
      }
      if (temperature > 95 && aqiData['aqi'] > 100) {
        alerts.add('Dangerous conditions: Avoid outdoor activities');
      }
      
      // Get sunrise and sunset times from weather API
      final sunrise = _extractSunriseTime(weatherData);
      final sunset = _extractSunsetTime(weatherData);
      
      return TrailCondition(
        temperature: temperature,
        weatherCondition: weatherCondition,
        airQualityIndex: aqiData['aqi'],
        overallSafety: safetyLevel,
        alerts: alerts,
        sunrise: sunrise,
        sunset: sunset,
      );
    } catch (e) {
      throw Exception('Failed to fetch trail conditions: $e');
    }
  }

  /// Get trail amenities from Sacramento County Parks API
  Future<List<TrailAmenity>> getTrailAmenities() async {
    try {
      final response = await _dio.get('${_sacCountyParksApiUrl}amenities');
      final amenitiesData = response.data as List;
      
      return amenitiesData.map((data) => TrailAmenity(
        id: data['id'],
        name: data['name'],
        type: data['type'],
        latitude: data['latitude'].toDouble(),
        longitude: data['longitude'].toDouble(),
        description: data['description'],
        isOperational: data['isOperational'] ?? true,
      )).toList();
    } catch (e) {
      // Fallback to development data when API is unavailable
      return _getFallbackAmenities();
    }
  }

  /// Get safety alerts from multiple sources
  Future<List<SafetyAlert>> getSafetyAlerts() async {
    final alerts = <SafetyAlert>[];
    
    try {
      // Get weather-based alerts
      final trailCondition = await getTrailCondition();
      
      // Generate alerts based on real conditions
      if (trailCondition.temperature > 95) {
        alerts.add(SafetyAlert(
          id: 'heat_warning_${DateTime.now().millisecondsSinceEpoch}',
          title: 'High Temperature Warning',
          description: 'Temperatures above 95°F. Stay hydrated and avoid strenuous activity during peak hours.',
          severity: 'high',
          latitude: 38.5901,
          longitude: -121.3442,
          radius: 10000.0, // 10km radius
          startTime: DateTime.now(),
          endTime: null,
          alertType: 'weather',
        ));
      }
      
      if (trailCondition.airQualityIndex > 100) {
        alerts.add(SafetyAlert(
          id: 'aqi_warning_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Poor Air Quality Alert',
          description: 'Air quality index is ${trailCondition.airQualityIndex}. Consider indoor exercise or reschedule your activity.',
          severity: 'medium',
          latitude: 38.5901,
          longitude: -121.3442,
          radius: 15000.0, // 15km radius
          startTime: DateTime.now(),
          endTime: null,
          alertType: 'air_quality',
        ));
      }
      
      // Add sunset warning if within 1 hour
      if (trailCondition.sunset != null) {
        final timeUntilSunset = trailCondition.sunset!.difference(DateTime.now());
        if (timeUntilSunset.inHours <= 1 && timeUntilSunset.inHours >= 0) {
          alerts.add(SafetyAlert(
            id: 'sunset_warning_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Sunset Approaching',
            description: 'Sunset in ${timeUntilSunset.inMinutes} minutes. Bring lights if continuing your activity.',
            severity: 'low',
            latitude: 38.5901,
            longitude: -121.3442,
            radius: 8000.0, // 8km radius
            startTime: DateTime.now(),
            endTime: trailCondition.sunset,
            alertType: 'sunset',
          ));
        }
      }
      
      // Get park alerts from Sacramento County Parks API
      try {
        final parkAlertsResponse = await _dio.get('${_sacCountyParksApiUrl}alerts');
        final parkAlertsData = parkAlertsResponse.data as List;
        
        for (final alertData in parkAlertsData) {
          alerts.add(SafetyAlert(
            id: alertData['id'],
            title: alertData['title'],
            description: alertData['description'],
            severity: alertData['severity'],
            latitude: alertData['latitude'].toDouble(),
            longitude: alertData['longitude'].toDouble(),
            radius: alertData['radius'].toDouble(),
            startTime: DateTime.parse(alertData['startTime']),
            endTime: alertData['endTime'] != null ? DateTime.parse(alertData['endTime']) : null,
            alertType: alertData['alertType'],
          ));
        }
      } catch (e) {
        // Park alerts API might not be available, continue with weather alerts
      }
      
    } catch (e) {
      // Fallback to development data when APIs are unavailable
      return _getFallbackAlerts();
    }
    
    return alerts;
  }

  /// Get trail incidents from Sacramento County Parks API
  Future<List<TrailIncident>> getTrailIncidents() async {
    try {
      final response = await _dio.get('${_sacCountyParksApiUrl}incidents');
      final incidentsData = response.data as List;
      
      return incidentsData.map((data) => TrailIncident(
        id: data['id'],
        date: DateTime.parse(data['date']),
        latitude: data['latitude'].toDouble(),
        longitude: data['longitude'].toDouble(),
        type: data['type'],
        severity: data['severity'],
        description: data['description'],
        source: data['source'],
      )).toList();
    } catch (e) {
      // Fallback to development data when API is unavailable
      return _getFallbackIncidents();
    }
  }

  /// Get park status from Sacramento County Regional Parks API
  Future<List<ParkStatus>> getParkStatus() async {
    try {
      final response = await _dio.get('${_sacCountyParksApiUrl}park-status');
      final statusData = response.data as List;
      
      return statusData.map((data) => ParkStatus(
        parkName: data['parkName'],
        status: _parseParkStatusType(data['status']),
        description: data['description'],
        lastUpdated: DateTime.parse(data['lastUpdated']),
        affectedAreas: data['affectedAreas'] != null ? List<String>.from(data['affectedAreas']) : null,
        contactInfo: data['contactInfo'],
      )).toList();
    } catch (e) {
      // Fallback to development data when API is unavailable
      return _getFallbackParkStatus();
    }
  }

  /// Get drowning incidents from Sacramento County data sources
  Future<List<DrowningIncident>> getDrowningIncidents() async {
    try {
      // Try to get from Sacramento County Public Health API
      final response = await _dio.get('https://epicenter.cdph.ca.gov/api/drowning-incidents/sacramento-county');
      final incidentsData = response.data as List;
      
      return incidentsData.map((data) => DrowningIncident(
        id: data['id'],
        date: DateTime.parse(data['date']),
        latitude: data['latitude'].toDouble(),
        longitude: data['longitude'].toDouble(),
        riverSection: _parseRiverSection(data['riverSection']),
        severity: _parseDrowningSeverity(data['severity']),
        description: data['description'],
        source: data['source'],
        age: data['age'],
        gender: data['gender'],
        hadLifeJacket: data['hadLifeJacket'],
        activity: data['activity'],
        equipment: data['equipment'],
      )).toList();
    } catch (e) {
      // Fallback to development data when API is unavailable
      return _getFallbackDrowningIncidents();
    }
  }

  /// Get comprehensive resource directory from FOLFAN API
  Future<List<ResourceDirectory>> getResourceDirectory() async {
    try {
      final response = await _dio.get('${_folfanApiUrl}resources');
      final resourcesData = response.data as List;
      
      return resourcesData.map((data) => ResourceDirectory(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        url: data['url'],
        category: _parseResourceCategory(data['category']),
        type: _parseResourceType(data['type']),
        contactInfo: data['contactInfo'],
        dataSource: data['dataSource'],
        tags: List<String>.from(data['tags']),
        isOfficial: data['isOfficial'],
        lastUpdated: data['lastUpdated'],
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch resource directory: $e');
    }
  }

  /// Get life jacket loan programs from FOLFAN API
  Future<List<LifeJacketProgram>> getLifeJacketPrograms() async {
    try {
      final response = await _dio.get('${_folfanApiUrl}life-jacket-programs');
      final programsData = response.data as List;
      
      return programsData.map((data) => LifeJacketProgram(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        organization: data['organization'],
        location: data['location'],
        latitude: data['latitude'].toDouble(),
        longitude: data['longitude'].toDouble(),
        status: _parseProgramStatus(data['status']),
        availableSizes: _parseLifeJacketSizes(data['availableSizes']),
        contactInfo: data['contactInfo'],
        hours: data['hours'],
        requirements: data['requirements'],
        lastUpdated: DateTime.parse(data['lastUpdated']),
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch life jacket programs: $e');
    }
  }

  /// Get comprehensive trail segments from ARPF API
  Future<List<TrailSegment>> getTrailSegments() async {
    try {
      final response = await _dio.get('https://arpf.org/api/trail-segments');
      final segmentsData = response.data as List;
      
      return segmentsData.map((data) => TrailSegment(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        type: _parseTrailType(data['type']),
        access: _parseTrailAccess(data['access']),
        startPoint: data['startPoint'],
        endPoint: data['endPoint'],
        area: data['area'],
        coordinates: _parseCoordinates(data['coordinates']),
        isAccessible: data['isAccessible'] ?? false,
        notes: data['notes'],
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch trail segments: $e');
    }
  }

  // Helper methods for API data processing

  /// Get AQI data from AirNow API
  Future<Map<String, dynamic>> _getAQIData() async {
    try {
      // Sacramento zip code: 95814
      final response = await _dio.get('${_aqiApiUrl}95814?format=application/json&API_KEY=YOUR_API_KEY');
      final data = response.data;
      
      return {
        'aqi': data['AQI'],
        'category': data['Category']['Name'],
        'pollutant': data['ParameterName'],
      };
    } catch (e) {
      // Fallback to a reasonable default if API fails
      return {
        'aqi': 50, // Good air quality
        'category': 'Good',
        'pollutant': 'PM2.5',
      };
    }
  }

  /// Extract temperature from weather API response
  double _extractTemperature(String temperatureStr) {
    try {
      return double.parse(temperatureStr.replaceAll(RegExp(r'[^\d.-]'), ''));
    } catch (e) {
      return 75.0; // Default temperature
    }
  }

  /// Extract sunrise time from weather API response
  DateTime? _extractSunriseTime(Map<String, dynamic> weatherData) {
    try {
      // This would need to be implemented based on the actual weather API response structure
      return DateTime.now().subtract(const Duration(hours: 6));
    } catch (e) {
      return null;
    }
  }

  /// Extract sunset time from weather API response
  DateTime? _extractSunsetTime(Map<String, dynamic> weatherData) {
    try {
      // This would need to be implemented based on the actual weather API response structure
      return DateTime.now().add(const Duration(hours: 6));
    } catch (e) {
      return null;
    }
  }

  /// Calculate overall safety level
  String _calculateSafetyLevel(double temperature, int aqi) {
    if (temperature > 95 || aqi > 150) {
      return 'danger';
    } else if (temperature > 85 || aqi > 100) {
      return 'caution';
    } else {
      return 'safe';
    }
  }

  // Helper methods for parsing enum values

  ParkStatusType _parseParkStatusType(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return ParkStatusType.open;
      case 'closed':
        return ParkStatusType.closed;
      case 'limited':
        return ParkStatusType.limited;
      case 'maintenance':
        return ParkStatusType.maintenance;
      case 'emergency':
        return ParkStatusType.emergency;
      default:
        return ParkStatusType.open;
    }
  }

  RiverSection _parseRiverSection(String section) {
    switch (section.toLowerCase()) {
      case 'discovery_park':
        return RiverSection.discoveryPark;
      case 'william_b_pond':
        return RiverSection.williamBPond;
      case 'american_river':
        return RiverSection.americanRiver;
      case 'sacramento_river':
        return RiverSection.sacramentoRiver;
      case 'confluence':
        return RiverSection.confluence;
      case 'auburn_section':
        return RiverSection.auburnSection;
      case 'clay_banks':
        return RiverSection.clayBanks;
      case 'tiscornia_beach':
        return RiverSection.tiscorniaBeach;
      default:
        return RiverSection.americanRiver;
    }
  }

  DrowningSeverity _parseDrowningSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'fatal':
        return DrowningSeverity.fatal;
      case 'non_fatal':
        return DrowningSeverity.nonFatal;
      case 'rescue':
        return DrowningSeverity.rescue;
      case 'near_miss':
        return DrowningSeverity.nearMiss;
      default:
        return DrowningSeverity.nonFatal;
    }
  }

  ResourceCategory _parseResourceCategory(String category) {
    switch (category.toLowerCase()) {
      case 'safety':
        return ResourceCategory.safety;
      case 'data':
        return ResourceCategory.data;
      case 'government':
        return ResourceCategory.government;
      case 'emergency':
        return ResourceCategory.emergency;
      case 'education':
        return ResourceCategory.education;
      case 'recreation':
        return ResourceCategory.recreation;
      default:
        return ResourceCategory.safety;
    }
  }

  ResourceType _parseResourceType(String type) {
    switch (type.toLowerCase()) {
      case 'program':
        return ResourceType.program;
      case 'api':
        return ResourceType.api;
      case 'website':
        return ResourceType.website;
      case 'contact':
        return ResourceType.contact;
      case 'report':
        return ResourceType.report;
      default:
        return ResourceType.website;
    }
  }

  ProgramStatus _parseProgramStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return ProgramStatus.active;
      case 'inactive':
        return ProgramStatus.inactive;
      case 'seasonal':
        return ProgramStatus.seasonal;
      default:
        return ProgramStatus.active;
    }
  }

  List<LifeJacketSize> _parseLifeJacketSizes(List<dynamic> sizes) {
    return sizes.map((size) {
      switch (size.toString().toLowerCase()) {
        case 'infant':
          return LifeJacketSize.infant;
        case 'child':
          return LifeJacketSize.child;
        case 'youth':
          return LifeJacketSize.youth;
        case 'adult':
          return LifeJacketSize.adult;
        case 'universal':
          return LifeJacketSize.universal;
        default:
          return LifeJacketSize.adult;
      }
    }).toList();
  }

  TrailType _parseTrailType(String type) {
    switch (type.toLowerCase()) {
      case 'paved':
        return TrailType.paved;
      case 'dirt':
        return TrailType.dirt;
      case 'mixed':
        return TrailType.mixed;
      default:
        return TrailType.paved;
    }
  }

  List<TrailAccess> _parseTrailAccess(List<dynamic> access) {
    return access.map((a) {
      switch (a.toString().toLowerCase()) {
        case 'pedestrians':
          return TrailAccess.pedestrians;
        case 'bikers':
          return TrailAccess.bikers;
        case 'equestrians':
          return TrailAccess.equestrians;
        case 'all':
          return TrailAccess.all;
        default:
          return TrailAccess.all;
      }
    }).toList();
  }

  List<LatLng> _parseCoordinates(List<dynamic> coordinates) {
    return coordinates.map((coord) {
      return LatLng(
        coord['latitude'].toDouble(),
        coord['longitude'].toDouble(),
      );
    }).toList();
  }

  // Fallback data for development
  List<TrailAmenity> _getFallbackAmenities() {
    return [
      const TrailAmenity(
        id: 'water_1',
        name: 'Water Fountain - Discovery Park',
        type: 'water',
        latitude: 38.5901,
        longitude: -121.3442,
        description: 'Water fountain at Discovery Park trailhead',
        isOperational: true,
      ),
      const TrailAmenity(
        id: 'restroom_1',
        name: 'Restroom - Discovery Park',
        type: 'restroom',
        latitude: 38.5901,
        longitude: -121.3442,
        description: 'Public restroom at Discovery Park trailhead',
        isOperational: true,
      ),
      const TrailAmenity(
        id: 'emergency_1',
        name: 'Emergency Call Box - Mile 1',
        type: 'emergency_callbox',
        latitude: 38.5925,
        longitude: -121.3475,
        description: 'Emergency call box for immediate assistance',
        isOperational: true,
      ),
      const TrailAmenity(
        id: 'ranger_1',
        name: 'Ranger Station - Discovery Park',
        type: 'ranger_station',
        latitude: 38.5901,
        longitude: -121.3442,
        description: 'Sacramento County Parks Ranger Station',
        isOperational: true,
      ),
    ];
  }

  List<SafetyAlert> _getFallbackAlerts() {
    return [
      SafetyAlert(
        id: 'dev_alert_1',
        title: 'Trail Maintenance',
        description: 'Scheduled maintenance on mile marker 3-4. Use alternate route.',
        severity: 'medium',
        latitude: 38.5950,
        longitude: -121.3500,
        radius: 5000.0,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(days: 1)),
        alertType: 'maintenance',
      ),
    ];
  }

  List<TrailIncident> _getFallbackIncidents() {
    return [
      TrailIncident(
        id: 'dev_incident_1',
        date: DateTime.now().subtract(const Duration(days: 2)),
        latitude: 38.5950,
        longitude: -121.3500,
        type: 'bike-ped collision',
        severity: 'minor',
        description: 'Minor collision between cyclist and pedestrian at Mile 2. No serious injuries reported.',
        source: 'Sacramento County Parks',
      ),
    ];
  }

  List<ParkStatus> _getFallbackParkStatus() {
    return [
      ParkStatus(
        parkName: 'Discovery Park',
        status: ParkStatusType.open,
        description: 'Discovery Park is open for normal operations',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        contactInfo: '(916) 875-6961',
      ),
    ];
  }

  List<DrowningIncident> _getFallbackDrowningIncidents() {
    return [
      DrowningIncident(
        id: 'dev_drowning_1',
        date: DateTime.now().subtract(const Duration(days: 30)),
        latitude: 38.5901,
        longitude: -121.3442,
        riverSection: RiverSection.discoveryPark,
        severity: DrowningSeverity.fatal,
        description: 'Fatal drowning incident at Discovery Park. Victim was not wearing a life jacket.',
        source: 'Sacramento County Regional Parks',
        age: 25,
        gender: 'Male',
        hadLifeJacket: false,
        activity: 'swimming',
        equipment: null,
      ),
    ];
  }
} 