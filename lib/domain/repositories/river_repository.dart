import 'package:riversafe_sac/domain/entities/river_condition.dart';

/// Repository interface for river-related data operations
abstract class RiverRepository {
  /// Get current river conditions for specified gauge
  Future<RiverCondition> getRiverConditions(String gaugeId);
  
  /// Get historical river data
  Future<List<RiverCondition>> getHistoricalData(String gaugeId, DateTime start, DateTime end);
  
  /// Get safety alerts for rivers
  Future<List<String>> getSafetyAlerts();
} 