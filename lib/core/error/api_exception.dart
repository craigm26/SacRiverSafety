/// API exception for handling API-related errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final DateTime timestamp;
  final String? endpoint;
  final Map<String, dynamic>? context;

  ApiException(
    this.message, {
    this.statusCode,
    this.endpoint,
    this.context,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('ApiException: $message');
    
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    
    if (endpoint != null) {
      buffer.write(' [Endpoint: $endpoint]');
    }
    
    if (context != null && context!.isNotEmpty) {
      buffer.write(' [Context: $context]');
    }
    
    buffer.write(' at $timestamp');
    return buffer.toString();
  }

  /// Check if this exception should trigger a retry
  bool get shouldRetry {
    // Retry on network errors, 5xx server errors, and rate limiting
    if (statusCode == null) return true; // Network error
    if (statusCode! >= 500) return true; // Server error
    if (statusCode == 429) return true; // Rate limited
    if (statusCode == 503) return true; // Service unavailable
    return false;
  }

  /// Get retry delay based on error type
  Duration get retryDelay {
    if (statusCode == 429) {
      // Rate limiting - wait longer
      return const Duration(seconds: 30);
    }
    if (statusCode != null && statusCode! >= 500) {
      // Server error - exponential backoff
      return const Duration(seconds: 5);
    }
    // Network error - short delay
    return const Duration(seconds: 2);
  }
} 