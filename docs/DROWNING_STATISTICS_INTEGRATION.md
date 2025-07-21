# Drowning Statistics Integration Guide

This document outlines how to integrate with real drowning statistics APIs for the Sacramento region to replace the mock data currently used in the application.

## Overview

The drowning statistics service aggregates data from multiple authoritative sources to provide comprehensive safety statistics for the Sacramento region. The service is designed to be resilient, with fallback mechanisms when APIs are unavailable.

## Data Sources

### 1. California EPICenter (CDPH)
- **URL**: https://epicenter.cdph.ca.gov/
- **Contact**: epicenter@cdph.ca.gov
- **Data**: Official California Department of Public Health drowning statistics for Sacramento County (2005-2020)
- **API Access**: Requires formal request to CDPH
- **Data Format**: JSON/CSV
- **Update Frequency**: Annual

**Integration Steps:**
1. Contact CDPH at epicenter@cdph.ca.gov
2. Request API access for Sacramento County drowning statistics
3. Obtain API credentials and documentation
4. Update `_cdphEpicenterUrl` in `DrowningStatisticsService`
5. Implement `_parseCDPHResponse()` method

### 2. Sacramento County Regional Parks
- **URL**: https://regionalparks.saccounty.gov/
- **Contact**: (916) 875-6961
- **Data**: Park incident reports and safety statistics
- **API Access**: May require FOIA request or direct contact
- **Data Format**: JSON/XML
- **Update Frequency**: Real-time/Weekly

**Integration Steps:**
1. Contact Sacramento County Regional Parks
2. Request access to incident report data
3. Obtain API documentation
4. Update `_sacCountyParksUrl` in `DrowningStatisticsService`
5. Implement `_parseSacCountyResponse()` method

### 3. Sacramento Metropolitan Fire District
- **URL**: https://www.sacmetrofire.org/
- **Contact**: (916) 859-4300
- **Data**: River rescue statistics and incident reports
- **API Access**: May require formal request
- **Data Format**: JSON/CSV
- **Update Frequency**: Real-time

**Integration Steps:**
1. Contact Sacramento Metro Fire District
2. Request access to water rescue statistics
3. Obtain API credentials
4. Add new service method for fire district data
5. Implement response parsing

### 4. USACE Public Recreation Fatalities
- **URL**: https://www.usace.army.mil/
- **Data**: Federal recreation fatality statistics
- **API Access**: Public data, may require scraping
- **Data Format**: PDF/JSON
- **Update Frequency**: Annual

**Integration Steps:**
1. Check for public API availability
2. If no API, implement PDF scraping
3. Update `_usaceFatalityUrl` in `DrowningStatisticsService`
4. Implement `_parseUSACEResponse()` method

### 5. American Whitewater Accident Database
- **URL**: https://www.americanwhitewater.org/
- **Data**: Whitewater accidents and incidents
- **API Access**: May require membership or request
- **Data Format**: JSON/CSV
- **Update Frequency**: Real-time

**Integration Steps:**
1. Contact American Whitewater
2. Request API access for California data
3. Obtain API credentials
4. Update `_americanWhitewaterUrl` in `DrowningStatisticsService`
5. Implement `_parseAmericanWhitewaterResponse()` method

## Implementation Guide

### 1. API Configuration

Update `lib/core/constants/api_config.dart`:

```dart
// Drowning Statistics APIs
static const String cdphEpicenterUrl = 'https://epicenter.cdph.ca.gov/api/';
static const String sacCountyParksUrl = 'https://regionalparks.saccounty.gov/api/';
static const String sacMetroFireUrl = 'https://www.sacmetrofire.org/api/';
static const String usaceFatalityUrl = 'https://www.usace.army.mil/api/recreation/fatalities/';
static const String americanWhitewaterUrl = 'https://www.americanwhitewater.org/api/accidents/';

// API Keys (set via environment variables)
static const String cdphApiKey = String.fromEnvironment('CDPH_API_KEY', defaultValue: '');
static const String sacCountyApiKey = String.fromEnvironment('SAC_COUNTY_API_KEY', defaultValue: '');
static const String americanWhitewaterApiKey = String.fromEnvironment('AMERICAN_WHITEWATER_API_KEY', defaultValue: '');
```

### 2. Service Implementation

For each data source, implement the corresponding parsing method in `DrowningStatisticsService`:

```dart
DrowningStatistics _parseCDPHResponse(dynamic data) {
  try {
    final yearlyData = <YearlyStatistics>[];
    final sectionData = <String, SectionStatistics>{};
    
    // Parse CDPH specific JSON structure
    final incidents = data['incidents'] as List;
    
    for (final incident in incidents) {
      // Parse incident data and add to statistics
      // Implementation depends on actual API response format
    }
    
    return DrowningStatistics(
      yearlyData: yearlyData,
      sectionData: sectionData,
      lastUpdated: DateTime.now(),
      sources: ['CDPH EPICenter'],
    );
  } catch (e) {
    print('Error parsing CDPH response: $e');
    return _getMockStatistics();
  }
}
```

### 3. Error Handling

Implement robust error handling for each API:

```dart
Future<DrowningStatistics?> _getCDPHStatistics() async {
  try {
    final response = await _dio.get(
      '$_cdphEpicenterUrl/drowning-statistics',
      queryParameters: {
        'county': 'Sacramento',
        'startYear': DateTime.now().year - 10,
        'endYear': DateTime.now().year,
        'format': 'json',
        'api_key': ApiConfig.cdphApiKey,
      },
    );

    if (response.statusCode == 200) {
      return _parseCDPHResponse(response.data);
    }
  } catch (e) {
    print('CDPH EPICenter API error: $e');
    // Log error for monitoring
    ApiHealthMonitor.trackApiCall(
      endpoint: 'CDPH EPICenter',
      duration: Duration.zero,
      success: false,
      errorMessage: e.toString(),
    );
  }
  return null;
}
```

### 4. Data Validation

Implement data validation to ensure quality:

```dart
bool _validateYearlyStatistics(YearlyStatistics stats) {
  return stats.totalIncidents >= 0 &&
         stats.fatalIncidents >= 0 &&
         stats.fatalIncidents <= stats.totalIncidents &&
         stats.year >= 2010 &&
         stats.year <= DateTime.now().year &&
         stats.averageAge >= 0 &&
         stats.averageAge <= 100;
}
```

### 5. Caching Strategy

Implement caching to reduce API calls:

```dart
class DrowningStatisticsCache {
  static const Duration cacheDuration = Duration(hours: 6);
  static final Map<String, CachedData> _cache = {};
  
  static DrowningStatistics? getCachedData(String key) {
    final cached = _cache[key];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }
    return null;
  }
  
  static void cacheData(String key, DrowningStatistics data) {
    _cache[key] = CachedData(data, DateTime.now().add(cacheDuration));
  }
}
```

## Testing Strategy

### 1. Unit Tests

Create comprehensive unit tests for each parsing method:

```dart
test('CDPH response parsing', () {
  final service = DrowningStatisticsService();
  final mockResponse = loadMockCDPHResponse();
  
  final result = service._parseCDPHResponse(mockResponse);
  
  expect(result.yearlyData.length, greaterThan(0));
  expect(result.sectionData.length, greaterThan(0));
  expect(result.sources, contains('CDPH EPICenter'));
});
```

### 2. Integration Tests

Test API connectivity and response handling:

```dart
test('CDPH API integration', () async {
  final service = DrowningStatisticsService();
  
  final result = await service._getCDPHStatistics();
  
  expect(result, isNotNull);
  expect(result!.sources, contains('CDPH EPICenter'));
});
```

### 3. Error Handling Tests

Test fallback mechanisms:

```dart
test('API failure fallback', () async {
  final service = DrowningStatisticsService();
  
  // Mock API failure
  when(mockDio.get(any)).thenThrow(Exception('API Error'));
  
  final result = await service.getDrowningStatistics();
  
  expect(result.sources, contains('Mock Data'));
});
```

## Monitoring and Analytics

### 1. API Health Monitoring

Track API performance and reliability:

```dart
class DrowningStatisticsMonitor {
  static void trackApiCall(String source, Duration duration, bool success) {
    ApiHealthMonitor.trackApiCall(
      endpoint: 'Drowning Statistics - $source',
      duration: duration,
      success: success,
    );
  }
  
  static void trackDataQuality(DrowningStatistics stats) {
    // Track data completeness, freshness, and quality metrics
  }
}
```

### 2. Data Quality Metrics

Monitor data quality indicators:

- Data completeness (percentage of expected data received)
- Data freshness (time since last update)
- Data consistency (cross-validation between sources)
- Error rates and types

## Deployment Considerations

### 1. Environment Variables

Set up environment variables for API keys:

```bash
# Production
export CDPH_API_KEY="your_cdph_api_key"
export SAC_COUNTY_API_KEY="your_sac_county_api_key"
export AMERICAN_WHITEWATER_API_KEY="your_american_whitewater_api_key"

# Development
export CDPH_API_KEY="dev_key"
export SAC_COUNTY_API_KEY="dev_key"
export AMERICAN_WHITEWATER_API_KEY="dev_key"
```

### 2. Rate Limiting

Implement rate limiting to respect API limits:

```dart
class RateLimiter {
  static final Map<String, DateTime> _lastCall = {};
  static const Map<String, Duration> _limits = {
    'CDPH': Duration(minutes: 5),
    'SacCounty': Duration(minutes: 1),
    'USACE': Duration(hours: 1),
    'AmericanWhitewater': Duration(minutes: 10),
  };
  
  static bool canCall(String api) {
    final lastCall = _lastCall[api];
    final limit = _limits[api];
    
    if (lastCall == null || limit == null) return true;
    
    return DateTime.now().difference(lastCall) >= limit;
  }
}
```

### 3. Data Backup

Implement data backup strategies:

- Cache successful API responses
- Store historical data locally
- Implement offline mode with cached data
- Regular data exports for analysis

## Legal and Compliance

### 1. Data Usage Agreements

Ensure compliance with data usage agreements:

- Review terms of service for each API
- Implement appropriate attribution
- Respect rate limits and usage restrictions
- Maintain data privacy and security

### 2. FOIA Requests

For government data sources:

- Submit FOIA requests for data access
- Document all requests and responses
- Maintain records for compliance
- Consider public data portals as alternatives

## Success Metrics

Track the following metrics to measure integration success:

- **API Reliability**: 95%+ uptime for all data sources
- **Data Freshness**: <6 hours for critical data
- **Data Completeness**: 90%+ of expected data received
- **Error Rate**: <5% API failure rate
- **Performance**: <3 seconds for data aggregation
- **User Engagement**: Increased usage of statistics features

## Next Steps

1. **Phase 1**: Contact data providers and request API access
2. **Phase 2**: Implement parsing methods for available APIs
3. **Phase 3**: Add comprehensive error handling and monitoring
4. **Phase 4**: Implement caching and performance optimization
5. **Phase 5**: Add data validation and quality checks
6. **Phase 6**: Deploy and monitor in production

## Support and Resources

- **CDPH EPICenter**: epicenter@cdph.ca.gov
- **Sacramento County Regional Parks**: (916) 875-6961
- **Sacramento Metro Fire**: (916) 859-4300
- **American Whitewater**: info@americanwhitewater.org
- **USACE**: Public Affairs Office

## Related Documentation

- [API Integration Implementation](API_INTEGRATION_IMPLEMENTATION.md)
- [Error Handling Strategy](ERROR_HANDLING.md)
- [Monitoring and Analytics](MONITORING.md)
- [Data Privacy and Security](PRIVACY_SECURITY.md) 