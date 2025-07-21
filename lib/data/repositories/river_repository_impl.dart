import 'package:sacriversafety/data/services/river_service.dart';
import 'package:sacriversafety/domain/entities/river_condition.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/repositories/river_repository.dart';

/// Implementation of RiverRepository
class RiverRepositoryImpl implements RiverRepository {
  final RiverService _riverService;

  const RiverRepositoryImpl({required RiverService riverService})
      : _riverService = riverService;

  @override
  Future<RiverCondition> getRiverConditions(String gaugeId) async {
    return await _riverService.getRiverConditions(gaugeId);
  }

  @override
  Future<List<RiverGauge>> getRiverGauges() async {
    // Get all available Sacramento County gauge IDs
    final gaugeIds = _riverService.getAvailableGaugeIds();
    final gauges = <RiverGauge>[];
    
    // Limit to most important gauges for performance, but include all major river systems
    final priorityGauges = [
      '11446500', // American River at Fair Oaks (popular recreation area)
      '11447650', // Sacramento River at Freeport
      '11335000', // Cosumnes River at Michigan Bar
      '11329500', // Dry Creek near Galt
      '11447360', // Arcade Creek near Del Paso Heights
      '11336585', // Laguna Creek near Elk Grove
    ];
    
    for (final gaugeId in priorityGauges) {
      try {
        final condition = await _riverService.getRiverConditions(gaugeId);
        
        // Convert RiverCondition to RiverGauge for map display
        gauges.add(RiverGauge(
          id: condition.gaugeId,
          name: condition.gaugeName,
          latitude: _getGaugeLatitude(gaugeId),
          longitude: _getGaugeLongitude(gaugeId),
          waterLevel: condition.waterLevel,
          flowRate: condition.flowRate,
          safetyLevel: condition.safetyLevel,
          lastUpdated: condition.timestamp,
          alert: condition.alert,
        ));
      } catch (e) {
        // Fallback to mock data if API fails
        gauges.add(_getMockGauge(gaugeId));
      }
    }
    
    return gauges;
  }

  @override
  Future<List<RiverCondition>> getHistoricalData(
    String gaugeId,
    DateTime start,
    DateTime end,
  ) async {
    return await _riverService.getHistoricalData(gaugeId, start, end);
  }

  @override
  Future<List<SafetyAlert>> getSafetyAlerts() async {
    // Get current river conditions to generate alerts for priority gauges
    final priorityGauges = [
      '11446500', // American River at Fair Oaks
      '11447650', // Sacramento River at Freeport
      '11335000', // Cosumnes River
    ];
    
    final alerts = <SafetyAlert>[];
    
    for (final gaugeId in priorityGauges) {
      try {
        final condition = await _riverService.getRiverConditions(gaugeId);
        
        if (condition.alert != null) {
          alerts.add(SafetyAlert(
            id: 'alert_${gaugeId}_${DateTime.now().millisecondsSinceEpoch}',
            title: 'River Safety Alert - ${condition.gaugeName}',
            description: condition.alert!,
            severity: condition.safetyLevel == 'danger' ? 'high' : 
                     condition.safetyLevel == 'caution' ? 'medium' : 'low',
            latitude: _getGaugeLatitude(gaugeId),
            longitude: _getGaugeLongitude(gaugeId),
            radius: 5000.0, // 5km radius
            startTime: condition.timestamp,
            endTime: null, // Active until conditions improve
            alertType: 'water_condition',
          ));
        }
      } catch (e) {
        // Add mock alerts if API fails
        alerts.addAll(_getMockAlerts(gaugeId));
      }
    }
    
    return alerts;
  }

  /// Get gauge latitude based on USGS site data
  double _getGaugeLatitude(String gaugeId) {
    switch (gaugeId) {
      case '11446500': // American River at Fair Oaks
        return 38.6354394;
      case '11446700': // American River at William B Pond Park
        return 38.6283;
      case '11446220': // American River below Folsom Dam
        return 38.6833;
      case '11446980': // American River below Watt Ave Bridge
        return 38.6333;
      case '11447360': // Arcade Creek near Del Paso Heights
        return 38.6333;
      case '11335000': // Cosumnes River at Michigan Bar
        return 38.5167;
      case '11329500': // Dry Creek near Galt
        return 38.2500;
      case '11336585': // Laguna Creek near Elk Grove
        return 38.4167;
      case '11447650': // Sacramento River at Freeport
        return 38.4600;
      case '11447890': // Sacramento River above Delta Cross Channel
        return 38.2333;
      case '11447905': // Sacramento River below Georgiana Slough
        return 38.2167;
      case '11447903': // Georgiana Slough near Sacramento River
        return 38.2167;
      case '11336600': // Delta Cross Channel near Walnut Grove
        return 38.2333;
      case '11336930': // Mokelumne River at Andrus Island
        return 38.1167;
      case '11336685': // North Mokelumne near Walnut Grove
        return 38.2333;
      case '381427121305401': // Sacramento River below Walnut Grove Bridge
        return 38.2381;
      case '380138121441401': // San Joaquin River at Channel Marker 18
        return 38.0233;
      case '11336955': // San Joaquin River at Channel Marker 42
        return 38.2667;
      case '11447850': // Steamboat Slough near Walnut Grove
        return 38.2333;
      case '11447830': // Sutter Slough at Courtland
        return 38.3167;
      case '11337080': // Threemile Slough near Rio Vista
        return 38.1500;
      default:
        return 38.5816; // Default to Sacramento
    }
  }

  /// Get gauge longitude based on USGS site data
  double _getGaugeLongitude(String gaugeId) {
    switch (gaugeId) {
      case '11446500': // American River at Fair Oaks
        return -121.227692;
      case '11446700': // American River at William B Pond Park
        return -121.3283;
      case '11446220': // American River below Folsom Dam
        return -121.1833;
      case '11446980': // American River below Watt Ave Bridge
        return -121.2833;
      case '11447360': // Arcade Creek near Del Paso Heights
        return -121.3833;
      case '11335000': // Cosumnes River at Michigan Bar
        return -120.5167;
      case '11329500': // Dry Creek near Galt
        return -121.3000;
      case '11336585': // Laguna Creek near Elk Grove
        return -121.3667;
      case '11447650': // Sacramento River at Freeport
        return -121.4944;
      case '11447890': // Sacramento River above Delta Cross Channel
        return -121.5667;
      case '11447905': // Sacramento River below Georgiana Slough
        return -121.5667;
      case '11447903': // Georgiana Slough near Sacramento River
        return -121.5667;
      case '11336600': // Delta Cross Channel near Walnut Grove
        return -121.5667;
      case '11336930': // Mokelumne River at Andrus Island
        return -121.5167;
      case '11336685': // North Mokelumne near Walnut Grove
        return -121.5667;
      case '381427121305401': // Sacramento River below Walnut Grove Bridge
        return -121.5114;
      case '380138121441401': // San Joaquin River at Channel Marker 18
        return -121.7367;
      case '11336955': // San Joaquin River at Channel Marker 42
        return -121.5667;
      case '11447850': // Steamboat Slough near Walnut Grove
        return -121.5667;
      case '11447830': // Sutter Slough at Courtland
        return -121.5667;
      case '11337080': // Threemile Slough near Rio Vista
        return -121.5667;
      default:
        return -121.4944; // Default to Sacramento
    }
  }

  /// Mock gauge data for fallback
  RiverGauge _getMockGauge(String gaugeId) {
    final gaugeName = _riverService.getGaugeName(gaugeId);
    
    // Different mock data for different river systems
    double waterLevel;
    double flowRate;
    String safetyLevel;
    String? alert;
    
    if (gaugeId.startsWith('11446')) { // American River gauges
      waterLevel = 3.2;
      flowRate = 1200.0;
      safetyLevel = 'caution';
      alert = 'High water flow - use caution';
    } else if (gaugeId.startsWith('11447')) { // Sacramento River gauges
      waterLevel = 2.8;
      flowRate = 800.0;
      safetyLevel = 'safe';
      alert = null;
    } else if (gaugeId.startsWith('11335')) { // Cosumnes River
      waterLevel = 1.5;
      flowRate = 400.0;
      safetyLevel = 'safe';
      alert = null;
    } else { // Other creeks and sloughs
      waterLevel = 1.0;
      flowRate = 200.0;
      safetyLevel = 'safe';
      alert = null;
    }

    return RiverGauge(
      id: gaugeId,
      name: gaugeName,
      latitude: _getGaugeLatitude(gaugeId),
      longitude: _getGaugeLongitude(gaugeId),
      waterLevel: waterLevel,
      flowRate: flowRate,
      safetyLevel: safetyLevel,
      lastUpdated: DateTime.now(),
      alert: alert,
    );
  }

  /// Mock alerts for fallback
  List<SafetyAlert> _getMockAlerts(String gaugeId) {
    final gaugeName = _riverService.getGaugeName(gaugeId);
    
    switch (gaugeId) {
      case '11446500':
      case '11446700':
      case '11446220':
        return [
          SafetyAlert(
            id: 'alert_${gaugeId}_${DateTime.now().millisecondsSinceEpoch}',
            title: 'American River Safety Alert',
            description: 'Current water flow is above safe levels for recreational activities. Avoid swimming and tubing.',
            severity: 'high',
            latitude: _getGaugeLatitude(gaugeId),
            longitude: _getGaugeLongitude(gaugeId),
            radius: 5000.0,
            startTime: DateTime.now(),
            endTime: null,
            alertType: 'water_condition',
          ),
        ];
      case '11447650':
        return [
          SafetyAlert(
            id: 'alert_${gaugeId}_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Sacramento River Safety Alert',
            description: 'Cold water shock risk. Water temperatures are below 60°F. Cold water shock can occur within minutes.',
            severity: 'medium',
            latitude: _getGaugeLatitude(gaugeId),
            longitude: _getGaugeLongitude(gaugeId),
            radius: 3000.0,
            startTime: DateTime.now(),
            endTime: null,
            alertType: 'weather',
          ),
        ];
      case '11335000':
        return [
          SafetyAlert(
            id: 'alert_${gaugeId}_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Cosumnes River Safety Alert',
            description: 'Variable flow conditions. Check current conditions before activities.',
            severity: 'low',
            latitude: _getGaugeLatitude(gaugeId),
            longitude: _getGaugeLongitude(gaugeId),
            radius: 2000.0,
            startTime: DateTime.now(),
            endTime: null,
            alertType: 'water_condition',
          ),
        ];
      default:
        return [];
    }
  }
} 