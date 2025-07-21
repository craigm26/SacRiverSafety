import 'package:sacriversafety/data/services/drowning_statistics_service.dart';

/// Repository interface for drowning statistics operations
abstract class DrowningStatisticsRepository {
  /// Get comprehensive drowning statistics for Sacramento region
  Future<DrowningStatistics> getDrowningStatistics();
  
  /// Get current year statistics
  Future<YearlyStatistics> getCurrentYearStatistics();
  
  /// Get 10-year trend data
  Future<List<YearlyStatistics>> getTenYearTrend();
  
  /// Get statistics by river section
  Future<Map<String, SectionStatistics>> getStatisticsBySection();
} 