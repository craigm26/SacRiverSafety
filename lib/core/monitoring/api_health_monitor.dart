import 'package:logger/logger.dart';

/// API health monitoring and metrics tracking
class ApiHealthMonitor {
  static final Logger _logger = Logger();
  
  // Metrics storage
  static final Map<String, List<ApiCallMetric>> _metrics = {};
  static final Map<String, int> _errorCounts = {};
  static final Map<String, double> _averageResponseTimes = {};
  
  /// Track an API call
  static void trackApiCall({
    required String endpoint,
    required Duration duration,
    required bool success,
    int? statusCode,
    String? errorMessage,
  }) {
    final metric = ApiCallMetric(
      endpoint: endpoint,
      duration: duration,
      success: success,
      statusCode: statusCode,
      errorMessage: errorMessage,
      timestamp: DateTime.now(),
    );
    
    // Store metric
    if (!_metrics.containsKey(endpoint)) {
      _metrics[endpoint] = [];
    }
    _metrics[endpoint]!.add(metric);
    
    // Keep only last 100 metrics per endpoint
    if (_metrics[endpoint]!.length > 100) {
      _metrics[endpoint]!.removeAt(0);
    }
    
    // Update error counts
    if (!success) {
      _errorCounts[endpoint] = (_errorCounts[endpoint] ?? 0) + 1;
    }
    
    // Update average response times
    _updateAverageResponseTime(endpoint, duration);
    
    // Log the call
    _logApiCall(metric);
  }
  
  /// Get API health summary
  static ApiHealthSummary getHealthSummary() {
    final summaries = <String, EndpointHealthSummary>{};
    
    for (final endpoint in _metrics.keys) {
      final metrics = _metrics[endpoint]!;
      final totalCalls = metrics.length;
      final successfulCalls = metrics.where((m) => m.success).length;
      final errorRate = totalCalls > 0 ? (totalCalls - successfulCalls) / totalCalls : 0.0;
      final avgResponseTime = _averageResponseTimes[endpoint] ?? 0.0;
      
      summaries[endpoint] = EndpointHealthSummary(
        endpoint: endpoint,
        totalCalls: totalCalls,
        successfulCalls: successfulCalls,
        errorRate: errorRate,
        averageResponseTime: avgResponseTime,
        lastCall: metrics.isNotEmpty ? metrics.last.timestamp : null,
      );
    }
    
    return ApiHealthSummary(
      endpoints: summaries,
      overallHealth: _calculateOverallHealth(summaries),
    );
  }
  
  /// Get error rate for an endpoint
  static double getErrorRate(String endpoint) {
    final metrics = _metrics[endpoint];
    if (metrics == null || metrics.isEmpty) return 0.0;
    
    final totalCalls = metrics.length;
    final successfulCalls = metrics.where((m) => m.success).length;
    return (totalCalls - successfulCalls) / totalCalls;
  }
  
  /// Get average response time for an endpoint
  static double getAverageResponseTime(String endpoint) {
    return _averageResponseTimes[endpoint] ?? 0.0;
  }
  
  /// Check if an endpoint is healthy (error rate < 5%)
  static bool isEndpointHealthy(String endpoint) {
    return getErrorRate(endpoint) < 0.05;
  }
  
  /// Update average response time
  static void _updateAverageResponseTime(String endpoint, Duration duration) {
    final currentAvg = _averageResponseTimes[endpoint] ?? 0.0;
    final metrics = _metrics[endpoint] ?? [];
    final totalCalls = metrics.length;
    
    if (totalCalls == 1) {
      _averageResponseTimes[endpoint] = duration.inMilliseconds.toDouble();
    } else {
      // Exponential moving average
      const alpha = 0.1; // Smoothing factor
      _averageResponseTimes[endpoint] = 
          (alpha * duration.inMilliseconds) + ((1 - alpha) * currentAvg);
    }
  }
  
  /// Calculate overall health
  static String _calculateOverallHealth(Map<String, EndpointHealthSummary> summaries) {
    if (summaries.isEmpty) return 'unknown';
    
    final unhealthyEndpoints = summaries.values
        .where((summary) => summary.errorRate > 0.05)
        .length;
    
    final totalEndpoints = summaries.length;
    final healthyPercentage = (totalEndpoints - unhealthyEndpoints) / totalEndpoints;
    
    if (healthyPercentage >= 0.95) return 'excellent';
    if (healthyPercentage >= 0.90) return 'good';
    if (healthyPercentage >= 0.80) return 'fair';
    return 'poor';
  }
  
  /// Log API call
  static void _logApiCall(ApiCallMetric metric) {
    final level = metric.success ? Level.info : Level.error;
    final message = 'API Call: ${metric.endpoint} - '
        '${metric.success ? 'SUCCESS' : 'FAILED'} '
        '(${metric.duration.inMilliseconds}ms)';
    
    _logger.log(level, message);
    
    if (!metric.success && metric.errorMessage != null) {
      _logger.e('API Error: ${metric.errorMessage}');
    }
  }
  
  /// Clear all metrics (useful for testing)
  static void clearMetrics() {
    _metrics.clear();
    _errorCounts.clear();
    _averageResponseTimes.clear();
  }
}

/// Individual API call metric
class ApiCallMetric {
  final String endpoint;
  final Duration duration;
  final bool success;
  final int? statusCode;
  final String? errorMessage;
  final DateTime timestamp;

  const ApiCallMetric({
    required this.endpoint,
    required this.duration,
    required this.success,
    this.statusCode,
    this.errorMessage,
    required this.timestamp,
  });
}

/// Health summary for a single endpoint
class EndpointHealthSummary {
  final String endpoint;
  final int totalCalls;
  final int successfulCalls;
  final double errorRate;
  final double averageResponseTime;
  final DateTime? lastCall;

  const EndpointHealthSummary({
    required this.endpoint,
    required this.totalCalls,
    required this.successfulCalls,
    required this.errorRate,
    required this.averageResponseTime,
    this.lastCall,
  });
}

/// Overall API health summary
class ApiHealthSummary {
  final Map<String, EndpointHealthSummary> endpoints;
  final String overallHealth;

  const ApiHealthSummary({
    required this.endpoints,
    required this.overallHealth,
  });
} 