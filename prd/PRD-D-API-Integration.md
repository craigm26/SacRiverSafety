# PRD-D · Real API Integration
**Parent project:** RiverSafeSac.com  
**Feature:** Live data integration with USGS, Weather, and Air Quality APIs

## 1. Purpose
Replace mock data with real-time API integrations to provide accurate, up-to-date river conditions, weather data, and air quality information for informed safety decisions.

## 2. Goals
- Provide real-time river water levels and flow rates from USGS gauges
- Display current weather conditions and forecasts for trail safety
- Show air quality data to help users make informed outdoor activity decisions
- Ensure data reliability with proper error handling and fallbacks
- Optimize API usage to minimize costs and improve performance

## 3. Non-Goals
- Real-time data streaming (polling-based updates are sufficient)
- Historical data analysis (implemented separately)
- User-generated data collection (community features handled separately)

## 4. Data Sources & APIs

### 4.1 USGS Water Data
- **Base URL**: `https://waterservices.usgs.gov/nwis/`
- **Endpoints**:
  - Current conditions: `/iv/?format=json&sites={gaugeId}&parameterCd=00060,00065`
  - Historical data: `/dv/?format=json&sites={gaugeId}&parameterCd=00060,00065&period=P7D`
- **Gauge IDs**:
  - `11446500`: American River at Fair Oaks
  - `11447650`: Sacramento River at Downtown
- **Parameters**:
  - `00060`: Discharge (cubic feet per second)
  - `00065`: Gage height (feet)

### 4.2 National Weather Service (NWS)
- **Base URL**: `https://api.weather.gov/`
- **Endpoints**:
  - Current conditions: `/stations/{stationId}/observations/latest`
  - Forecast: `/gridpoints/{office}/{x},{y}/forecast`
  - Alerts: `/alerts/active?area={state}`
- **Stations**:
  - `KSAC`: Sacramento Executive Airport
  - `KSMF`: Sacramento International Airport

### 4.3 AirNow Air Quality
- **Base URL**: `https://www.airnowapi.org/aq/`
- **Endpoints**:
  - Current AQI: `/observation/zipCode/current/?format=application/json&zipCode={zip}&distance=25&API_KEY={key}`
- **Coverage**: Sacramento area (ZIP codes: 95814, 95816, 95818, etc.)

## 5. Data Models

### 5.1 USGS Response Models
```dart
class USGSResponse {
  final String name;
  final List<USGSValue> timeSeries;
}

class USGSValue {
  final String name;
  final String unit;
  final List<USGSDataPoint> values;
}

class USGSDataPoint {
  final DateTime dateTime;
  final double value;
  final String qualifiers;
}
```

### 5.2 Weather Response Models
```dart
class WeatherResponse {
  final WeatherProperties properties;
}

class WeatherProperties {
  final WeatherPeriod periods;
  final WeatherObservation observation;
}

class WeatherPeriod {
  final int number;
  final String name;
  final double temperature;
  final String shortForecast;
  final String detailedForecast;
}
```

### 5.3 Air Quality Response Models
```dart
class AirQualityResponse {
  final List<AirQualityObservation> observations;
}

class AirQualityObservation {
  final DateTime dateObserved;
  final int aqi;
  final String category;
  final String parameterName;
  final double latitude;
  final double longitude;
}
```

## 6. Technical Implementation

### 6.1 API Service Layer
```dart
// lib/data/services/usgs_service.dart
class USGSService {
  final Dio _dio;
  
  Future<RiverCondition> getRiverConditions(String gaugeId) async {
    try {
      final response = await _dio.get(
        'https://waterservices.usgs.gov/nwis/iv/',
        queryParameters: {
          'format': 'json',
          'sites': gaugeId,
          'parameterCd': '00060,00065',
        },
      );
      
      return _parseUSGSResponse(response.data, gaugeId);
    } catch (e) {
      throw ApiException('Failed to fetch USGS data: $e');
    }
  }
  
  RiverCondition _parseUSGSResponse(Map<String, dynamic> data, String gaugeId) {
    // Parse USGS JSON response
    // Extract water level and flow rate
    // Determine safety level based on thresholds
  }
}
```

### 6.2 Weather Service
```dart
// lib/data/services/weather_service.dart
class WeatherService {
  final Dio _dio;
  
  Future<TrailCondition> getTrailConditions() async {
    try {
      final weather = await _getCurrentWeather();
      final airQuality = await _getAirQuality();
      final alerts = await _getWeatherAlerts();
      
      return TrailCondition(
        temperature: weather.temperature,
        airQualityIndex: airQuality.aqi,
        weatherCondition: weather.shortForecast,
        alerts: alerts.map((a) => a.headline).toList(),
        overallSafety: _calculateSafetyLevel(weather, airQuality),
      );
    } catch (e) {
      throw ApiException('Failed to fetch weather data: $e');
    }
  }
}
```

### 6.3 Error Handling & Retry Logic
```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final DateTime timestamp;
  
  ApiException(this.message, {this.statusCode}) 
    : timestamp = DateTime.now();
}

class RetryInterceptor extends Interceptor {
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && _retryCount < maxRetries) {
      await Future.delayed(Duration(seconds: _retryCount * 2));
      _retryCount++;
      // Retry request
    } else {
      handler.next(err);
    }
  }
}
```

## 7. Data Caching Strategy

### 7.1 Cache Configuration
```dart
class CacheConfig {
  static const Duration riverDataCache = Duration(minutes: 15);
  static const Duration weatherCache = Duration(minutes: 30);
  static const Duration airQualityCache = Duration(hours: 1);
  static const Duration alertsCache = Duration(minutes: 5);
}
```

### 7.2 Hive Storage Implementation
```dart
@HiveType(typeId: 1)
class CachedRiverData extends HiveObject {
  @HiveField(0)
  final String gaugeId;
  
  @HiveField(1)
  final RiverCondition data;
  
  @HiveField(2)
  final DateTime timestamp;
  
  bool get isExpired => 
    DateTime.now().difference(timestamp) > CacheConfig.riverDataCache;
}
```

## 8. Safety Thresholds & Alerts

### 8.1 River Safety Levels
```dart
class RiverSafetyThresholds {
  static const double safeWaterLevel = 2.0;      // feet
  static const double cautionWaterLevel = 3.5;   // feet
  static const double dangerWaterLevel = 5.0;    // feet
  
  static const double safeFlowRate = 1000.0;     // cfs
  static const double cautionFlowRate = 2000.0;  // cfs
  static const double dangerFlowRate = 3500.0;   // cfs
}
```

### 8.2 Weather Safety Levels
```dart
class WeatherSafetyThresholds {
  static const double maxSafeTemperature = 95.0;  // °F
  static const double maxSafeHeatIndex = 105.0;   // °F
  static const int maxSafeAQI = 100;              // Air Quality Index
}
```

## 9. Implementation Phases

### Phase 1: USGS Integration (Week 1)
- [ ] Implement USGS API service
- [ ] Create data parsing logic
- [ ] Add error handling and retry logic
- [ ] Test with real gauge data
- [ ] Update RiverCubit to use real data

### Phase 2: Weather Integration (Week 2)
- [ ] Implement NWS API service
- [ ] Add weather data parsing
- [ ] Integrate with TrailCubit
- [ ] Test weather alerts
- [ ] Add temperature and heat index calculations

### Phase 3: Air Quality Integration (Week 3)
- [ ] Implement AirNow API service
- [ ] Add AQI data parsing
- [ ] Integrate with trail conditions
- [ ] Test air quality alerts
- [ ] Add AQI-based safety recommendations

### Phase 4: Caching & Optimization (Week 4)
- [ ] Implement Hive caching
- [ ] Add cache expiration logic
- [ ] Optimize API request frequency
- [ ] Add offline data support
- [ ] Performance testing

## 10. Testing Strategy

### 10.1 Unit Tests
```dart
test('USGS service parses river data correctly', () async {
  final service = USGSService();
  final mockResponse = loadMockUSGSResponse();
  
  final result = service.parseUSGSResponse(mockResponse, '11446500');
  
  expect(result.waterLevel, 2.5);
  expect(result.flowRate, 1500.0);
  expect(result.safetyLevel, 'caution');
});
```

### 10.2 Integration Tests
- Test API connectivity and response parsing
- Test error handling and retry logic
- Test cache functionality
- Test data consistency across APIs

### 10.3 Load Testing
- Test API rate limiting
- Test concurrent requests
- Test cache performance
- Test memory usage

## 11. Monitoring & Analytics

### 11.1 API Health Monitoring
```dart
class ApiHealthMonitor {
  static void trackApiCall(String endpoint, Duration duration, bool success) {
    // Log API call metrics
    // Track success/failure rates
    // Monitor response times
  }
}
```

### 11.2 Error Tracking
- Log API failures with context
- Track error patterns and frequencies
- Monitor cache hit/miss ratios
- Alert on service degradation

## 12. Success Metrics
- **API Reliability**: 99% uptime for all data sources
- **Data Freshness**: <15 minutes for river data, <30 minutes for weather
- **Performance**: <2 seconds for data loading
- **Cache Efficiency**: >80% cache hit rate
- **Error Rate**: <5% API failure rate

## 13. Dependencies
- **dio**: HTTP client (already in pubspec.yaml)
- **hive**: Local caching (already in pubspec.yaml)
- **json_annotation**: JSON parsing (already in pubspec.yaml)

## 14. API Keys & Configuration
```dart
// lib/core/constants/api_config.dart
class ApiConfig {
  static const String airNowApiKey = String.fromEnvironment('AIRNOW_API_KEY');
  static const String usgsBaseUrl = 'https://waterservices.usgs.gov/nwis/';
  static const String weatherBaseUrl = 'https://api.weather.gov/';
  static const String airNowBaseUrl = 'https://www.airnowapi.org/aq/';
}
```

## 15. Risks & Mitigation
| Risk | Impact | Mitigation |
|------|--------|------------|
| **API Rate Limits** | High | Implement caching, respect rate limits |
| **Service Outages** | High | Add fallback data, graceful degradation |
| **Data Accuracy** | Medium | Validate data ranges, add sanity checks |
| **Cost Overruns** | Medium | Monitor API usage, implement caching |
| **Performance Issues** | Low | Optimize requests, use background updates | 