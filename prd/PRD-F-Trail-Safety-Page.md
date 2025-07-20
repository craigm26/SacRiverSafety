# PRD-F · Trail Safety Page
**Parent project:** RiverSafeSac.com  
**Feature:** American River Parkway trail conditions, amenities, and safety information

## 1. Purpose
Create a comprehensive trail safety page that provides real-time conditions, amenities, safety alerts, and trail etiquette for the American River Parkway to help users plan safe outdoor activities.

## 2. Goals
- Display current weather and air quality conditions affecting trail safety
- Show trail amenities (water fountains, restrooms, emergency call boxes)
- Provide real-time safety alerts and trail status updates
- Display trail etiquette and rules for different user types
- Enable users to report trail issues and incidents
- Support multiple trail sections with detailed information

## 3. Non-Goals
- Real-time trail traffic monitoring
- User-generated trail reviews (community features handled separately)
- Complex trail mapping with GPS navigation
- Mobile-specific features (responsive design covers all platforms)

## 4. User Stories & Use Cases
| User Story | Acceptance Criteria |
|------------|-------------------|
| **Weather Check**: User wants to check if it's safe to bike/run | Can see temperature, AQI, and weather alerts |
| **Amenity Planning**: User wants to know where water/restrooms are | Can view interactive map with amenity locations |
| **Safety Alerts**: User wants to know about trail hazards | Receives clear alerts for closures, incidents, or dangerous conditions |
| **Trail Rules**: User wants to understand etiquette | Can view rules for cyclists, pedestrians, and equestrians |
| **Issue Reporting**: User encounters a trail problem | Can easily report issues with location and description |

## 5. Page Structure & Layout

### 5.1 Main Layout
```
┌─────────────────────────────────────┐
│ Header: Trail Safety                │
├─────────────────────────────────────┤
│ Current Conditions Banner           │
│ ┌─────────────────────────────────┐ │
│ │ 🌡️ 85°F | 🌤️ Sunny | AQI: 75  │ │
│ │ ⚠️ High Temperature Warning     │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Trail Map with Amenities            │
│ ┌─────────────────────────────────┐ │
│ │ [Interactive Map]               │ │
│ │ • Water Fountains (3)           │ │
│ │ • Restrooms (2)                 │ │
│ │ • Emergency Call Boxes (5)      │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Safety Alerts Section               │
│ ┌─────────────────────────────────┐ │
│ │ 🚧 Trail Closure: Mile 5-7      │ │
│ │ 🚨 Incident Report: Mile 12     │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Trail Rules & Etiquette             │
│ ┌─────────────────────────────────┐ │
│ │ Speed Limit: 15 mph             │ │
│ │ Keep Right, Pass Left           │ │
│ │ Helmets Required for Cyclists   │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Report Issues Button                │
│ ┌─────────────────────────────────┐ │
│ │ [Report Trail Issue]            │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## 6. Technical Implementation

### 6.1 Trail Safety Cubit
```dart
// lib/presentation/cubits/trail_safety_cubit.dart
class TrailSafetyCubit extends Cubit<TrailSafetyState> {
  final TrailRepository _trailRepository;
  
  TrailSafetyCubit({required TrailRepository trailRepository})
      : _trailRepository = trailRepository,
        super(TrailSafetyInitial());
  
  Future<void> loadTrailData() async {
    emit(TrailSafetyLoading());
    
    try {
      final trailCondition = await _trailRepository.getTrailConditions();
      final amenities = await _trailRepository.getAmenities();
      final safetyAlerts = await _trailRepository.getSafetyAlerts();
      final incidents = await _trailRepository.getRecentIncidents();
      
      emit(TrailSafetyLoaded(
        trailCondition: trailCondition,
        amenities: amenities,
        safetyAlerts: safetyAlerts,
        incidents: incidents,
      ));
    } catch (e) {
      emit(TrailSafetyError(e.toString()));
    }
  }
  
  Future<void> reportIssue(TrailIssue issue) async {
    try {
      await _trailRepository.reportIssue(issue);
      // Refresh data after reporting
      loadTrailData();
    } catch (e) {
      emit(TrailSafetyError('Failed to report issue: $e'));
    }
  }
}
```

### 6.2 Trail Safety Page
```dart
// lib/presentation/pages/trail_safety_page.dart
class TrailSafetyPage extends StatelessWidget {
  const TrailSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trail Safety'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TrailSafetyCubit>().loadTrailData(),
          ),
        ],
      ),
      body: BlocBuilder<TrailSafetyCubit, TrailSafetyState>(
        builder: (context, state) {
          if (state is TrailSafetyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is TrailSafetyError) {
            return Center(
              child: Column(
                children: [
                  const Icon(Icons.error, size: 64),
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<TrailSafetyCubit>().loadTrailData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is TrailSafetyLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildConditionsBanner(context, state.trailCondition),
                  const SizedBox(height: 16),
                  _buildTrailMap(context, state.amenities),
                  const SizedBox(height: 16),
                  _buildSafetyAlerts(context, state.safetyAlerts),
                  const SizedBox(height: 16),
                  _buildTrailRules(context),
                  const SizedBox(height: 16),
                  _buildReportIssueButton(context),
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### 6.3 Conditions Banner
```dart
Widget _buildConditionsBanner(BuildContext context, TrailCondition condition) {
  return Card(
    color: _getSafetyColor(condition.overallSafety),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConditionItem(
                context,
                Icons.thermostat,
                'Temperature',
                '${condition.temperature.toStringAsFixed(0)}°F',
              ),
              _buildConditionItem(
                context,
                Icons.air,
                'Air Quality',
                'AQI ${condition.airQualityIndex}',
              ),
              _buildConditionItem(
                context,
                Icons.wb_sunny,
                'Weather',
                condition.weatherCondition,
              ),
            ],
          ),
          if (condition.alerts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      condition.alerts.first,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
```

## 7. Interactive Trail Map

### 7.1 Map Implementation
```dart
// Using flutter_map for interactive mapping
Widget _buildTrailMap(BuildContext context, List<TrailAmenity> amenities) {
  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Trail Amenities',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 300,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(38.5901, -121.3442), // American River Parkway
              zoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.riversafe.sac',
              ),
              MarkerLayer(
                markers: amenities.map((amenity) {
                  return Marker(
                    point: LatLng(amenity.latitude, amenity.longitude),
                    width: 40,
                    height: 40,
                    builder: (context) => _buildAmenityMarker(amenity),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildAmenityLegend(amenities),
        ),
      ],
    ),
  );
}
```

### 7.2 Amenity Markers
```dart
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
    case 'ranger_station':
      icon = Icons.local_police;
      color = Colors.red;
      break;
    case 'emergency_callbox':
      icon = Icons.phone;
      color = Colors.orange;
      break;
    default:
      icon = Icons.place;
      color = Colors.grey;
  }
  
  return Container(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Icon(icon, color: Colors.white, size: 20),
  );
}
```

## 8. Trail Rules & Etiquette

### 8.1 Rules Display
```dart
Widget _buildTrailRules(BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trail Rules & Etiquette',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildRuleSection(
            context,
            'Speed Limits',
            [
              '• Cyclists: 15 mph maximum',
              '• Equestrians: Walk only',
              '• Pedestrians: Normal walking pace',
            ],
            Icons.speed,
          ),
          const SizedBox(height: 16),
          _buildRuleSection(
            context,
            'Trail Etiquette',
            [
              '• Keep right, pass left',
              '• Announce when passing',
              '• Yield to equestrians',
              '• Stay on designated trails',
            ],
            Icons.people,
          ),
          const SizedBox(height: 16),
          _buildRuleSection(
            context,
            'Safety Requirements',
            [
              '• Helmets required for cyclists',
              '• Leash dogs (6 ft maximum)',
              '• No motorized vehicles',
              '• Respect trail closures',
            ],
            Icons.security,
          ),
        ],
      ),
    ),
  );
}
```

## 9. Issue Reporting

### 9.1 Report Issue Dialog
```dart
Future<void> _showReportIssueDialog(BuildContext context) async {
  final issueType = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Report Trail Issue'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Hazard'),
            onTap: () => Navigator.pop(context, 'hazard'),
          ),
          ListTile(
            leading: const Icon(Icons.construction),
            title: const Text('Maintenance'),
            onTap: () => Navigator.pop(context, 'maintenance'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Incident'),
            onTap: () => Navigator.pop(context, 'incident'),
          ),
          ListTile(
            leading: const Icon(Icons.other_houses),
            title: const Text('Other'),
            onTap: () => Navigator.pop(context, 'other'),
          ),
        ],
      ),
    ),
  );
  
  if (issueType != null) {
    // Show detailed report form
    _showIssueReportForm(context, issueType);
  }
}
```

## 10. Implementation Phases

### Phase 1: Basic Page Structure (Week 1)
- [ ] Create TrailSafetyPage layout
- [ ] Implement conditions banner
- [ ] Add basic trail rules display
- [ ] Error handling and loading states

### Phase 2: Map Integration (Week 2)
- [ ] Implement interactive trail map
- [ ] Add amenity markers and legend
- [ ] Connect to real amenity data
- [ ] Test map interactions

### Phase 3: Data Integration (Week 3)
- [ ] Connect to weather and AQI APIs
- [ ] Implement TrailSafetyCubit
- [ ] Add safety alerts system
- [ ] Test with live data

### Phase 4: Issue Reporting (Week 4)
- [ ] Implement issue reporting system
- [ ] Add photo upload capability
- [ ] Create reporting analytics
- [ ] Performance optimization

## 11. Testing Strategy

### 11.1 Unit Tests
```dart
test('safety level calculation based on conditions', () {
  final safeCondition = TrailCondition(
    temperature: 75.0,
    airQualityIndex: 50,
    // ... other fields
  );
  
  final dangerousCondition = TrailCondition(
    temperature: 105.0,
    airQualityIndex: 150,
    // ... other fields
  );
  
  expect(_calculateSafetyLevel(safeCondition), 'safe');
  expect(_calculateSafetyLevel(dangerousCondition), 'danger');
});
```

### 11.2 Widget Tests
- Test page loading and error states
- Test map interactions and markers
- Test issue reporting flow
- Test safety alert display

### 11.3 Integration Tests
- Test weather API integration
- Test amenity data loading
- Test issue reporting submission
- Test real-time data updates

## 12. Success Metrics
- **Data Accuracy**: 95% accuracy for weather and AQI data
- **Page Load Time**: <3 seconds for initial load
- **User Engagement**: >70% of users check conditions before trail use
- **Issue Reports**: >50% of reported issues resolved within 24 hours
- **Safety Impact**: Reduced trail-related incidents

## 13. Dependencies
- **flutter_map**: Interactive mapping (already in pubspec.yaml)
- **geolocator**: Location services (already in pubspec.yaml)
- **image_picker**: Photo upload for issue reports (already in pubspec.yaml)

## 14. Future Enhancements
- **Real-time Trail Traffic**: Live user count and congestion alerts
- **Weather Forecast**: 7-day trail condition predictions
- **Community Features**: User-submitted trail reviews and tips
- **Emergency Integration**: Direct connection to emergency services
- **Offline Maps**: Cached trail data for poor connectivity 