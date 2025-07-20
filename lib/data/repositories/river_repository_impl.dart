import 'package:riversafe_sac/data/services/river_service.dart';
import 'package:riversafe_sac/domain/entities/river_condition.dart';
import 'package:riversafe_sac/domain/repositories/river_repository.dart';

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
  Future<List<RiverCondition>> getHistoricalData(
    String gaugeId,
    DateTime start,
    DateTime end,
  ) async {
    return await _riverService.getHistoricalData(gaugeId, start, end);
  }

  @override
  Future<List<String>> getSafetyAlerts() async {
    // TODO: Implement safety alerts logic
    return ['High water flow warning', 'Cold water shock risk'];
  }
} 