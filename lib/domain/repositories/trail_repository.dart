import 'package:sacriversafety/domain/entities/trail_condition.dart';

/// Repository interface for trail-related data operations
abstract class TrailRepository {
  /// Get current trail conditions
  Future<TrailCondition> getTrailConditions();
  
  /// Get trail safety alerts
  Future<List<String>> getSafetyAlerts();
  
  /// Get trail amenities (water fountains, restrooms, etc.)
  Future<List<TrailAmenity>> getAmenities();
}

/// Entity representing trail amenities
class TrailAmenity {
  final String name;
  final String type; // 'water', 'restroom', 'ranger_station'
  final double latitude;
  final double longitude;
  final String? description;

  const TrailAmenity({
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.description,
  });
} 