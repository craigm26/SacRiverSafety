import 'package:sacriversafety/data/services/drowning_statistics_service.dart';
import 'package:sacriversafety/domain/repositories/drowning_statistics_repository.dart';

/// Implementation of DrowningStatisticsRepository
class DrowningStatisticsRepositoryImpl implements DrowningStatisticsRepository {
  final DrowningStatisticsService _drowningStatisticsService;

  const DrowningStatisticsRepositoryImpl({
    required DrowningStatisticsService drowningStatisticsService,
  }) : _drowningStatisticsService = drowningStatisticsService;

  @override
  Future<DrowningStatistics> getDrowningStatistics() async {
    return await _drowningStatisticsService.getDrowningStatistics();
  }

  @override
  Future<YearlyStatistics> getCurrentYearStatistics() async {
    return await _drowningStatisticsService.getCurrentYearStatistics();
  }

  @override
  Future<List<YearlyStatistics>> getTenYearTrend() async {
    return await _drowningStatisticsService.getTenYearTrend();
  }

  @override
  Future<Map<String, SectionStatistics>> getStatisticsBySection() async {
    return await _drowningStatisticsService.getStatisticsBySection();
  }
} 