import 'package:riversafe_sac/data/services/trail_service.dart';
import 'package:riversafe_sac/domain/entities/trail_condition.dart';
import 'package:riversafe_sac/domain/repositories/trail_repository.dart';

/// Implementation of TrailRepository
class TrailRepositoryImpl implements TrailRepository {
  final TrailService _trailService;

  const TrailRepositoryImpl({required TrailService trailService})
      : _trailService = trailService;

  @override
  Future<TrailCondition> getTrailConditions() async {
    return await _trailService.getTrailConditions();
  }

  @override
  Future<List<String>> getSafetyAlerts() async {
    // TODO: Implement safety alerts logic
    return ['High temperature warning', 'Air quality alert'];
  }

  @override
  Future<List<TrailAmenity>> getAmenities() async {
    return await _trailService.getAmenities();
  }
} 