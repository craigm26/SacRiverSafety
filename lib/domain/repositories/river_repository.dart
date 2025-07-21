import 'package:sacriversafety/domain/entities/river_condition.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';

/// Repository interface for river-related data operations
abstract class RiverRepository {
  /// Get current river conditions for specified gauge
  Future<RiverCondition> getRiverConditions(String gaugeId);
  
  /// Get all available river gauges
  Future<List<RiverGauge>> getRiverGauges();
  
  /// Get historical river data
  Future<List<RiverCondition>> getHistoricalData(String gaugeId, DateTime start, DateTime end);
  
  /// Get safety alerts for rivers
  Future<List<SafetyAlert>> getSafetyAlerts();
} 