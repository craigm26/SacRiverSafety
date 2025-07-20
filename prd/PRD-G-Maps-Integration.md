# PRD-G · Maps Integration with Flutter Map
**Parent project:** sacriversafety.com  
**Feature:** Interactive mapping system for river conditions, trail amenities, and safety information

## 1. Purpose
Implement a comprehensive mapping system using flutter_map that displays river gauges, trail amenities, safety alerts, and real-time conditions in an interactive, user-friendly interface.

## 2. Goals
- Display river gauge locations with real-time condition data
- Show trail amenities (water fountains, restrooms, emergency call boxes)
- Provide interactive safety alerts and incident reporting
- Enable users to explore the Sacramento area river system
- Support offline map functionality for poor connectivity areas
- Integrate with existing river and trail data systems

## 3. Non-Goals
- Turn-by-turn navigation (use existing navigation apps)
- Real-time user tracking or location sharing
- Complex GIS analysis tools
- Custom map tile creation

## 4. User Stories & Use Cases
| User Story | Acceptance Criteria |
|------------|-------------------|
| **River Exploration**: User wants to see all river gauges | Can view map with all USGS gauge locations and current data |
| **Amenity Planning**: User wants to find nearby facilities | Can see water fountains, restrooms, and emergency call boxes on map |
| **Safety Awareness**: User wants to avoid dangerous areas | Can see safety alerts and incident reports overlaid on map |
| **Offline Access**: User has poor connectivity | Can access cached map data and basic information offline |
| **Data Exploration**: User wants to understand river system | Can zoom and pan to explore different river sections |

## 5. Map Layers & Data

### 5.1 Base Map Layers
```dart
// OpenStreetMap tiles for base mapping
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.riversafe.sac',
  maxZoom: 18,
  minZoom: 10,
)

// Satellite imagery for detailed river views
TileLayer(
  urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  maxZoom: 18,
  minZoom: 10,
)
```

### 5.2 Data Layers
| Layer Type | Data Source | Update Frequency | Description |
|------------|-------------|------------------|-------------|
| **River Gauges** | USGS API | 15 minutes | Water level and flow rate data |
| **Trail Amenities** | Local database | Daily | Water fountains, restrooms, call boxes |
| **Safety Alerts** | Multiple APIs | Real-time | Weather alerts, trail closures, incidents |
| **Trail Routes** | GeoJSON | Static | American River Parkway trail system |
| **Park Boundaries** | GeoJSON | Static | Regional park and recreation areas |

## 6. Technical Implementation

### 6.1 Map Controller
```dart
// lib/presentation/controllers/map_controller.dart
class RiverMapController {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  final List<Circle> _circles = [];
  
  // River gauge markers
  void addRiverGaugeMarkers(List<RiverGauge> gauges) {
    for (final gauge in gauges) {
      _markers.add(
        Marker(
          point: LatLng(gauge.latitude, gauge.longitude),
          width: 40,
          height: 40,
          builder: (context) => _buildRiverGaugeMarker(gauge),
        ),
      );
    }
  }
  
  // Trail amenity markers
  void addAmenityMarkers(List<TrailAmenity> amenities) {
    for (final amenity in amenities) {
      _markers.add(
        Marker(
          point: LatLng(amenity.latitude, amenity.longitude),
          width: 30,
          height: 30,
          builder: (context) => _buildAmenityMarker(amenity),
        ),
      );
    }
  }
  
  // Safety alert circles
  void addSafetyAlerts(List<SafetyAlert> alerts) {
    for (final alert in alerts) {
      _circles.add(
        Circle(
          center: LatLng(alert.latitude, alert.longitude),
          radius: alert.radius,
          color: _getAlertColor(alert.severity).withOpacity(0.3),
          borderColor: _getAlertColor(alert.severity),
          borderStrokeWidth: 2,
        ),
      );
    }
  }
}
```

### 6.2 Interactive Map Widget
```dart
// lib/presentation/widgets/river_map_widget.dart
class RiverMapWidget extends StatefulWidget {
  final List<RiverGauge> riverGauges;
  final List<TrailAmenity> amenities;
  final List<SafetyAlert> safetyAlerts;
  final Function(RiverGauge)? onGaugeTap;
  final Function(TrailAmenity)? onAmenityTap;
  
  const RiverMapWidget({
    super.key,
    required this.riverGauges,
    required this.amenities,
    required this.safetyAlerts,
    this.onGaugeTap,
    this.onAmenityTap,
  });
  
  @override
  State<RiverMapWidget> createState() => _RiverMapWidgetState();
}

class _RiverMapWidgetState extends State<RiverMapWidget> {
  final MapController _mapController = MapController();
  late List<Marker> _markers;
  late List<Circle> _circles;
  
  @override
  void initState() {
    super.initState();
    _buildMapElements();
  }
  
  void _buildMapElements() {
    _markers = [];
    _circles = [];
    
    // Add river gauge markers
    for (final gauge in widget.riverGauges) {
      _markers.add(
        Marker(
          point: LatLng(gauge.latitude, gauge.longitude),
          width: 40,
          height: 40,
          builder: (context) => _buildRiverGaugeMarker(gauge),
        ),
      );
    }
    
    // Add amenity markers
    for (final amenity in widget.amenities) {
      _markers.add(
        Marker(
          point: LatLng(amenity.latitude, amenity.longitude),
          width: 30,
          height: 30,
          builder: (context) => _buildAmenityMarker(amenity),
        ),
      );
    }
    
    // Add safety alert circles
    for (final alert in widget.safetyAlerts) {
      _circles.add(
        Circle(
          center: LatLng(alert.latitude, alert.longitude),
          radius: alert.radius,
          color: _getAlertColor(alert.severity).withOpacity(0.3),
          borderColor: _getAlertColor(alert.severity),
          borderStrokeWidth: 2,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: const LatLng(38.5901, -121.3442), // Sacramento area
        zoom: 11.0,
        minZoom: 9.0,
        maxZoom: 18.0,
        onTap: (point, latLng) => _handleMapTap(latLng),
      ),
      children: [
        // Base map layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.riversafe.sac',
        ),
        // Trail route layer
        PolylineLayer(
          polylines: _buildTrailRoutes(),
        ),
        // Safety alert circles
        CircleLayer(
          circles: _circles,
        ),
        // Markers layer
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }
}
```

### 6.3 Custom Markers
```dart
Widget _buildRiverGaugeMarker(RiverGauge gauge) {
  final safetyColor = _getSafetyColor(gauge.safetyLevel);
  
  return GestureDetector(
    onTap: () => widget.onGaugeTap?.call(gauge),
    child: Container(
      decoration: BoxDecoration(
        color: safetyColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.water_drop,
        color: Colors.white,
        size: 20,
      ),
    ),
  );
}

Widget _buildAmenityMarker(TrailAmenity amenity) {
  IconData icon;
  Color color;
  
  switch (amenity.type) {
    case 'water':
      icon = Icons.water_drop;
      color = Colors.blue;
      break;
    case 'restroom':
      icon = Icons.wc;
      color = Colors.green;
      break;
    case 'emergency_callbox':
      icon = Icons.phone;
      color = Colors.red;
      break;
    case 'ranger_station':
      icon = Icons.local_police;
      color = Colors.orange;
      break;
    default:
      icon = Icons.place;
      color = Colors.grey;
  }
  
  return GestureDetector(
    onTap: () => widget.onAmenityTap?.call(amenity),
    child: Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    ),
  );
}
```

## 7. Map Interactions

### 7.1 Marker Tapping
```dart
void _handleGaugeTap(RiverGauge gauge) {
  showModalBottomSheet(
    context: context,
    builder: (context) => RiverGaugeInfoSheet(gauge: gauge),
  );
}

void _handleAmenityTap(TrailAmenity amenity) {
  showModalBottomSheet(
    context: context,
    builder: (context) => AmenityInfoSheet(amenity: amenity),
  );
}
```

### 7.2 Info Sheets
```dart
// lib/presentation/widgets/river_gauge_info_sheet.dart
class RiverGaugeInfoSheet extends StatelessWidget {
  final RiverGauge gauge;
  
  const RiverGaugeInfoSheet({super.key, required this.gauge});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gauge.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  'Water Level',
                  '${gauge.waterLevel.toStringAsFixed(1)} ft',
                  _getSafetyColor(gauge.safetyLevel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  context,
                  'Flow Rate',
                  '${gauge.flowRate.toStringAsFixed(0)} cfs',
                  _getSafetyColor(gauge.safetyLevel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/river/conditions/${gauge.id}');
            },
            child: const Text('View Detailed Conditions'),
          ),
        ],
      ),
    );
  }
}
```

## 8. Offline Map Support

### 8.1 Tile Caching
```dart
// lib/data/services/tile_cache_service.dart
class TileCacheService {
  static const String cacheDir = 'map_tiles';
  
  Future<void> cacheTilesForArea(LatLngBounds bounds, int zoomLevel) async {
    final tiles = _calculateTilesForBounds(bounds, zoomLevel);
    
    for (final tile in tiles) {
      await _cacheTile(tile);
    }
  }
  
  Future<Uint8List?> getCachedTile(TileCoordinates tile) async {
    final file = await _getTileFile(tile);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  }
}
```

### 8.2 Offline Data Storage
```dart
@HiveType(typeId: 2)
class CachedMapData extends HiveObject {
  @HiveField(0)
  final List<RiverGauge> riverGauges;
  
  @HiveField(1)
  final List<TrailAmenity> amenities;
  
  @HiveField(2)
  final DateTime timestamp;
  
  bool get isExpired => 
    DateTime.now().difference(timestamp) > const Duration(hours: 24);
}
```

## 9. Performance Optimization

### 9.1 Marker Clustering
```dart
// For areas with many markers, implement clustering
class MarkerCluster {
  final LatLng center;
  final List<Marker> markers;
  final int count;
  
  Widget buildClusterMarker() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

### 9.2 Lazy Loading
```dart
// Load markers only for visible area
void _loadMarkersForVisibleArea(LatLngBounds bounds) {
  final visibleGauges = widget.riverGauges.where((gauge) {
    return bounds.contains(LatLng(gauge.latitude, gauge.longitude));
  }).toList();
  
  _updateMarkers(visibleGauges);
}
```

## 10. Implementation Phases

### Phase 1: Basic Map Setup (Week 1)
- [ ] Set up flutter_map with OpenStreetMap tiles
- [ ] Implement basic map controller
- [ ] Add river gauge markers
- [ ] Test map interactions

### Phase 2: Data Integration (Week 2)
- [ ] Connect to real river gauge data
- [ ] Add amenity markers
- [ ] Implement safety alert circles
- [ ] Add trail route polylines

### Phase 3: Interactivity (Week 3)
- [ ] Implement marker tapping
- [ ] Add info sheets for markers
- [ ] Create map legend
- [ ] Add search functionality

### Phase 4: Offline Support (Week 4)
- [ ] Implement tile caching
- [ ] Add offline data storage
- [ ] Create offline mode indicator
- [ ] Performance optimization

## 11. Testing Strategy

### 11.1 Unit Tests
```dart
test('marker creation with correct coordinates', () {
  final gauge = RiverGauge(
    id: '11446500',
    name: 'American River at Fair Oaks',
    latitude: 38.5901,
    longitude: -121.3442,
    // ... other fields
  );
  
  final marker = _createGaugeMarker(gauge);
  
  expect(marker.point.latitude, 38.5901);
  expect(marker.point.longitude, -121.3442);
});
```

### 11.2 Widget Tests
- Test map rendering and interactions
- Test marker tapping and info sheets
- Test offline mode functionality
- Test performance with many markers

### 11.3 Integration Tests
- Test real data integration
- Test tile caching and offline access
- Test map performance under load
- Test cross-platform compatibility

## 12. Success Metrics
- **Map Load Time**: <2 seconds for initial map load
- **Marker Performance**: Smooth interaction with 100+ markers
- **Offline Functionality**: 90% of features available offline
- **User Engagement**: >80% of users interact with map features
- **Data Accuracy**: 95% accuracy for marker locations and data

## 13. Dependencies
- **flutter_map**: Interactive mapping (already in pubspec.yaml)
- **latlong2**: Geographic coordinates (already in pubspec.yaml)
- **geolocator**: Location services (already in pubspec.yaml)

## 14. Future Enhancements
- **3D Terrain**: Elevation data and 3D river visualization
- **Weather Overlays**: Real-time weather radar and forecasts
- **User Location**: GPS tracking and "near me" features
- **Augmented Reality**: AR river condition overlay
- **Social Features**: User-submitted photos and reports on map 