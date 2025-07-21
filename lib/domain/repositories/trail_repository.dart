import 'package:sacriversafety/domain/entities/trail_condition.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/trail_incident.dart';
import 'package:sacriversafety/domain/entities/park_status.dart';
import 'package:sacriversafety/domain/entities/drowning_incident.dart';
import 'package:sacriversafety/domain/entities/resource_directory.dart';
import 'package:sacriversafety/domain/entities/life_jacket_program.dart';
import 'package:sacriversafety/domain/entities/trail_data.dart';

/// Repository interface for trail-related data operations
abstract class TrailRepository {
  /// Get current trail conditions
  Future<TrailCondition> getTrailCondition();
  
  /// Get trail safety alerts
  Future<List<SafetyAlert>> getSafetyAlerts();
  
  /// Get trail amenities (water fountains, restrooms, etc.)
  Future<List<TrailAmenity>> getTrailAmenities();
  Future<List<TrailIncident>> getTrailIncidents();
  Future<List<ParkStatus>> getParkStatus();
  Future<List<DrowningIncident>> getDrowningIncidents();
  Future<List<ResourceDirectory>> getResourceDirectory();
  Future<List<LifeJacketProgram>> getLifeJacketPrograms();
  Future<List<TrailSegment>> getTrailSegments();
} 