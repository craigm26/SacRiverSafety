# PRD-H · Local Storage with Hive
**Parent project:** RiverSafeSac.com  
**Feature:** Offline-capable data persistence and caching system

## 1. Purpose
Implement a robust local storage system using Hive to enable offline functionality, improve app performance, and provide seamless user experience even with poor connectivity.

## 2. Goals
- Enable offline access to river conditions and trail safety data
- Improve app performance through intelligent caching
- Reduce API calls and data usage
- Provide seamless user experience during connectivity issues
- Support data synchronization when connectivity is restored
- Maintain data consistency across app sessions

## 3. Non-Goals
- Full offline app functionality (some features require internet)
- User-generated content storage (handled separately)
- Complex data synchronization conflicts (simple last-write-wins)
- Cross-device data synchronization (device-specific storage)

## 4. User Stories & Use Cases
| User Story | Acceptance Criteria |
|------------|-------------------|
| **Offline Access**: User has no internet connection | Can view cached river conditions and trail data |
| **Performance**: User wants faster app loading | Data loads from cache first, then updates from API |
| **Data Usage**: User wants to minimize mobile data | App uses cached data when available, reduces API calls |
| **Connectivity Issues**: User has poor signal | App gracefully degrades to cached data |
| **Data Freshness**: User wants current information | App shows cache age and updates when possible |

## 5. Data Storage Strategy

### 5.1 Cache Categories
| Data Type | Cache Duration | Priority | Description |
|-----------|----------------|----------|-------------|
| **River Conditions** | 15 minutes | High | USGS gauge data, critical for safety |
| **Trail Conditions** | 30 minutes | High | Weather, AQI, trail status |
| **Safety Alerts** | 5 minutes | Critical | Real-time alerts and warnings |
| **Amenities** | 24 hours | Medium | Trail facilities, rarely changes |
| **Map Tiles** | 7 days | Low | Static map data |
| **User Preferences** | Persistent | High | App settings and preferences |

### 5.2 Storage Structure
```
Hive Boxes:
├── river_conditions_cache
│   ├── gauge_11446500 → CachedRiverData
│   └── gauge_11447650 → CachedRiverData
├── trail_conditions_cache
│   ├── current → CachedTrailData
│   └── historical → List<CachedTrailData>
├── safety_alerts_cache
│   ├── active → List<CachedAlert>
│   └── recent → List<CachedAlert>
├── amenities_cache
│   ├── water_fountains → List<CachedAmenity>
│   ├── restrooms → List<CachedAmenity>
│   └── emergency_callboxes → List<CachedAmenity>
├── map_tiles_cache
│   ├── tile_10_123_456 → Uint8List
│   └── tile_10_123_457 → Uint8List
└── user_preferences
    ├── theme_mode → String
    ├── notifications_enabled → bool
    └── favorite_gauges → List<String>
```

## 6. Technical Implementation

### 6.1 Hive Configuration
```dart
// lib/core/storage/hive_config.dart
class HiveConfig {
  static const String riverConditionsBox = 'river_conditions_cache';
  static const String trailConditionsBox = 'trail_conditions_cache';
  static const String safetyAlertsBox = 'safety_alerts_cache';
  static const String amenitiesBox = 'amenities_cache';
  static const String mapTilesBox = 'map_tiles_cache';
  static const String userPreferencesBox = 'user_preferences';
  
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(CachedRiverDataAdapter());
    Hive.registerAdapter(CachedTrailDataAdapter());
    Hive.registerAdapter(CachedAlertAdapter());
    Hive.registerAdapter(CachedAmenityAdapter());
    
    // Open boxes
    await Hive.openBox<CachedRiverData>(riverConditionsBox);
    await Hive.openBox<CachedTrailData>(trailConditionsBox);
    await Hive.openBox<CachedAlert>(safetyAlertsBox);
    await Hive.openBox<CachedAmenity>(amenitiesBox);
    await Hive.openBox<Uint8List>(mapTilesBox);
    await Hive.openBox(userPreferencesBox);
  }
}
```

### 6.2 Cache Models
```dart
// lib/data/models/cached_river_data.dart
@HiveType(typeId: 1)
class CachedRiverData extends HiveObject {
  @HiveField(0)
  final String gaugeId;
  
  @HiveField(1)
  final RiverCondition data;
  
  @HiveField(2)
  final DateTime timestamp;
  
  @HiveField(3)
  final Duration cacheDuration;
  
  CachedRiverData({
    required this.gaugeId,
    required this.data,
    required this.timestamp,
    this.cacheDuration = const Duration(minutes: 15),
  });
  
  bool get isExpired => 
    DateTime.now().difference(timestamp) > cacheDuration;
    
  bool get isStale => 
    DateTime.now().difference(timestamp) > cacheDuration * 0.5;
}

class CachedRiverDataAdapter extends TypeAdapter<CachedRiverData> {
  @override
  final int typeId = 1;
  
  @override
  CachedRiverData read(BinaryReader reader) {
    return CachedRiverData(
      gaugeId: reader.readString(),
      data: reader.read() as RiverCondition,
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      cacheDuration: Duration(milliseconds: reader.readInt()),
    );
  }
  
  @override
  void write(BinaryWriter writer, CachedRiverData obj) {
    writer.writeString(obj.gaugeId);
    writer.write(obj.data);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeInt(obj.cacheDuration.inMilliseconds);
  }
}
```

### 6.3 Cache Service
```dart
// lib/data/services/cache_service.dart
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();
  
  late Box<CachedRiverData> _riverConditionsBox;
  late Box<CachedTrailData> _trailConditionsBox;
  late Box<CachedAlert> _safetyAlertsBox;
  late Box<CachedAmenity> _amenitiesBox;
  late Box<Uint8List> _mapTilesBox;
  late Box _userPreferencesBox;
  
  Future<void> initialize() async {
    _riverConditionsBox = Hive.box<CachedRiverData>(HiveConfig.riverConditionsBox);
    _trailConditionsBox = Hive.box<CachedTrailData>(HiveConfig.trailConditionsBox);
    _safetyAlertsBox = Hive.box<CachedAlert>(HiveConfig.safetyAlertsBox);
    _amenitiesBox = Hive.box<CachedAmenity>(HiveConfig.amenitiesBox);
    _mapTilesBox = Hive.box<Uint8List>(HiveConfig.mapTilesBox);
    _userPreferencesBox = Hive.box(HiveConfig.userPreferencesBox);
  }
  
  // River conditions caching
  Future<void> cacheRiverCondition(String gaugeId, RiverCondition data) async {
    final cachedData = CachedRiverData(
      gaugeId: gaugeId,
      data: data,
      timestamp: DateTime.now(),
    );
    
    await _riverConditionsBox.put(gaugeId, cachedData);
  }
  
  CachedRiverData? getCachedRiverCondition(String gaugeId) {
    final cachedData = _riverConditionsBox.get(gaugeId);
    if (cachedData != null && !cachedData.isExpired) {
      return cachedData;
    }
    return null;
  }
  
  // Trail conditions caching
  Future<void> cacheTrailCondition(TrailCondition data) async {
    final cachedData = CachedTrailData(
      data: data,
      timestamp: DateTime.now(),
    );
    
    await _trailConditionsBox.put('current', cachedData);
  }
  
  CachedTrailData? getCachedTrailCondition() {
    final cachedData = _trailConditionsBox.get('current');
    if (cachedData != null && !cachedData.isExpired) {
      return cachedData;
    }
    return null;
  }
  
  // Safety alerts caching
  Future<void> cacheSafetyAlerts(List<SafetyAlert> alerts) async {
    final cachedAlerts = alerts.map((alert) => CachedAlert(
      alert: alert,
      timestamp: DateTime.now(),
    )).toList();
    
    await _safetyAlertsBox.put('active', cachedAlerts);
  }
  
  List<SafetyAlert> getCachedSafetyAlerts() {
    final cachedAlerts = _safetyAlertsBox.get('active') as List<CachedAlert>?;
    if (cachedAlerts != null) {
      final validAlerts = cachedAlerts.where((ca) => !ca.isExpired).toList();
      return validAlerts.map((ca) => ca.alert).toList();
    }
    return [];
  }
  
  // User preferences
  Future<void> setUserPreference(String key, dynamic value) async {
    await _userPreferencesBox.put(key, value);
  }
  
  T? getUserPreference<T>(String key, {T? defaultValue}) {
    return _userPreferencesBox.get(key, defaultValue: defaultValue) as T?;
  }
  
  // Cache management
  Future<void> clearExpiredCache() async {
    await _clearExpiredRiverConditions();
    await _clearExpiredTrailConditions();
    await _clearExpiredSafetyAlerts();
    await _clearExpiredMapTiles();
  }
  
  Future<void> clearAllCache() async {
    await _riverConditionsBox.clear();
    await _trailConditionsBox.clear();
    await _safetyAlertsBox.clear();
    await _amenitiesBox.clear();
    await _mapTilesBox.clear();
  }
  
  Future<int> getCacheSize() async {
    int totalSize = 0;
    totalSize += await _getBoxSize(_riverConditionsBox);
    totalSize += await _getBoxSize(_trailConditionsBox);
    totalSize += await _getBoxSize(_safetyAlertsBox);
    totalSize += await _getBoxSize(_amenitiesBox);
    totalSize += await _getBoxSize(_mapTilesBox);
    return totalSize;
  }
}
```

### 6.4 Repository Integration
```dart
// lib/data/repositories/river_repository_impl.dart
class RiverRepositoryImpl implements RiverRepository {
  final RiverService _riverService;
  final CacheService _cacheService;
  
  RiverRepositoryImpl({
    required RiverService riverService,
    required CacheService cacheService,
  }) : _riverService = riverService,
       _cacheService = cacheService;
  
  @override
  Future<RiverCondition> getRiverConditions(String gaugeId) async {
    // Check cache first
    final cachedData = _cacheService.getCachedRiverCondition(gaugeId);
    if (cachedData != null) {
      // Return cached data immediately
      return cachedData.data;
    }
    
    try {
      // Fetch fresh data from API
      final freshData = await _riverService.getRiverConditions(gaugeId);
      
      // Cache the fresh data
      await _cacheService.cacheRiverCondition(gaugeId, freshData);
      
      return freshData;
    } catch (e) {
      // If API fails and we have stale cache, return it
      if (cachedData != null && cachedData.isStale) {
        return cachedData.data;
      }
      throw e;
    }
  }
  
  @override
  Future<List<RiverCondition>> getHistoricalData(
    String gaugeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // For historical data, always try API first
    try {
      final historicalData = await _riverService.getHistoricalData(
        gaugeId,
        startDate,
        endDate,
      );
      
      // Cache historical data with longer duration
      for (final data in historicalData) {
        await _cacheService.cacheRiverCondition(
          '$gaugeId_${data.timestamp.millisecondsSinceEpoch}',
          data,
        );
      }
      
      return historicalData;
    } catch (e) {
      // Try to get from cache if API fails
      final cachedData = _getCachedHistoricalData(gaugeId, startDate, endDate);
      if (cachedData.isNotEmpty) {
        return cachedData;
      }
      throw e;
    }
  }
}
```

## 7. Offline Mode Management

### 7.1 Connectivity Service
```dart
// lib/data/services/connectivity_service.dart
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  
  Stream<bool> get connectivityStream => _connectivityController.stream;
  bool _isConnected = true;
  
  bool get isConnected => _isConnected;
  
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    _connectivityController.add(_isConnected);
    
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      final wasConnected = _isConnected;
      _isConnected = result != ConnectivityResult.none;
      
      if (wasConnected != _isConnected) {
        _connectivityController.add(_isConnected);
      }
    });
  }
  
  Future<void> dispose() async {
    await _connectivityController.close();
  }
}
```

### 7.2 Offline Mode Widget
```dart
// lib/presentation/widgets/offline_indicator.dart
class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityOffline) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.orange,
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Offline Mode - Using cached data',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Last updated: ${_formatLastUpdate(state.lastUpdate)}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

## 8. Data Synchronization

### 8.1 Sync Service
```dart
// lib/data/services/sync_service.dart
class SyncService {
  final CacheService _cacheService;
  final ConnectivityService _connectivityService;
  
  SyncService({
    required CacheService cacheService,
    required ConnectivityService connectivityService,
  }) : _cacheService = cacheService,
       _connectivityService = connectivityService;
  
  Future<void> syncWhenOnline() async {
    if (!_connectivityService.isConnected) return;
    
    // Sync river conditions
    await _syncRiverConditions();
    
    // Sync trail conditions
    await _syncTrailConditions();
    
    // Sync safety alerts
    await _syncSafetyAlerts();
  }
  
  Future<void> _syncRiverConditions() async {
    final cachedGauges = _cacheService.getCachedGaugeIds();
    
    for (final gaugeId in cachedGauges) {
      final cachedData = _cacheService.getCachedRiverCondition(gaugeId);
      if (cachedData != null && cachedData.isStale) {
        try {
          final freshData = await _riverService.getRiverConditions(gaugeId);
          await _cacheService.cacheRiverCondition(gaugeId, freshData);
        } catch (e) {
          // Log error but continue with other gauges
          print('Failed to sync gauge $gaugeId: $e');
        }
      }
    }
  }
}
```

## 9. Implementation Phases

### Phase 1: Basic Caching (Week 1)
- [ ] Set up Hive configuration and adapters
- [ ] Implement CacheService with basic operations
- [ ] Add caching to RiverRepository
- [ ] Test basic cache functionality

### Phase 2: Offline Mode (Week 2)
- [ ] Implement ConnectivityService
- [ ] Add offline mode indicators
- [ ] Create offline data access patterns
- [ ] Test offline functionality

### Phase 3: Data Synchronization (Week 3)
- [ ] Implement SyncService
- [ ] Add background sync capabilities
- [ ] Create cache expiration management
- [ ] Test sync scenarios

### Phase 4: Performance & Optimization (Week 4)
- [ ] Add cache size management
- [ ] Implement cache compression
- [ ] Add cache analytics
- [ ] Performance testing and optimization

## 10. Testing Strategy

### 10.1 Unit Tests
```dart
test('cache service stores and retrieves river data', () async {
  final cacheService = CacheService();
  await cacheService.initialize();
  
  final testData = RiverCondition(
    gaugeId: '11446500',
    waterLevel: 2.5,
    flowRate: 1500.0,
    // ... other fields
  );
  
  await cacheService.cacheRiverCondition('11446500', testData);
  
  final cachedData = cacheService.getCachedRiverCondition('11446500');
  expect(cachedData, isNotNull);
  expect(cachedData!.data.waterLevel, 2.5);
});
```

### 10.2 Integration Tests
- Test cache persistence across app restarts
- Test offline mode functionality
- Test data synchronization
- Test cache expiration and cleanup

### 10.3 Performance Tests
- Test cache read/write performance
- Test memory usage with large datasets
- Test cache size management
- Test concurrent access patterns

## 11. Success Metrics
- **Offline Availability**: 90% of core features available offline
- **Cache Hit Rate**: >80% for frequently accessed data
- **App Launch Time**: <2 seconds with cached data
- **Data Freshness**: <15 minutes for critical safety data
- **Storage Efficiency**: <50MB total cache size

## 12. Dependencies
- **hive**: Local storage (already in pubspec.yaml)
- **hive_flutter**: Flutter integration (already in pubspec.yaml)
- **connectivity_plus**: Network connectivity (already in pubspec.yaml)

## 13. Future Enhancements
- **Cross-Device Sync**: Cloud-based data synchronization
- **Advanced Caching**: Predictive caching based on user patterns
- **Data Compression**: Reduce storage footprint
- **Cache Analytics**: Track cache performance and usage patterns
- **Selective Sync**: User-controlled data synchronization 