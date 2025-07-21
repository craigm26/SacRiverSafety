import 'package:dio/dio.dart';
import 'package:sacriversafety/core/error/api_exception.dart';
import 'package:sacriversafety/core/constants/api_config.dart';

/// Dio interceptor for handling retries and error handling
class RetryInterceptor extends Interceptor {
  final Map<String, int> _retryCounts = {};

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestKey = _getRequestKey(err.requestOptions);
    final retryCount = _retryCounts[requestKey] ?? 0;

    // Create API exception
    final apiException = ApiException(
      err.message ?? 'Network error',
      statusCode: err.response?.statusCode,
      endpoint: err.requestOptions.uri.toString(),
      context: {
        'method': err.requestOptions.method,
        'retryCount': retryCount,
      },
    );

    // Check if we should retry
    if (apiException.shouldRetry && retryCount < ApiConfig.maxRetries) {
      _retryCounts[requestKey] = retryCount + 1;
      
      // Wait before retrying
      await Future.delayed(apiException.retryDelay);
      
      // Retry the request
      try {
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (retryError) {
        // If retry fails, continue with original error
        _retryCounts.remove(requestKey);
      }
    }

    // Clean up retry count
    _retryCounts.remove(requestKey);
    
    // Pass the error through
    handler.next(err);
  }

  /// Retry the request
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio();
    dio.options.connectTimeout = ApiConfig.connectTimeout;
    dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    
    return await dio.fetch(requestOptions);
  }

  /// Generate a unique key for the request
  String _getRequestKey(RequestOptions options) {
    return '${options.method}_${options.uri}_${options.data.hashCode}';
  }

  /// Clear retry counts (useful for testing)
  void clearRetryCounts() {
    _retryCounts.clear();
  }
} 