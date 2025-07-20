# PRD-E · River Conditions Page
**Parent project:** sacriversafety.com  
**Feature:** Interactive river conditions display with live data and safety alerts

## 1. Purpose
Create a comprehensive river conditions page that displays real-time water levels, flow rates, safety information, and historical data for Sacramento area rivers to help users make informed safety decisions.

## 2. Goals
- Display real-time river conditions from USGS gauges
- Show safety levels and alerts based on current conditions
- Provide historical data visualization for trend analysis
- Enable users to quickly assess river safety before activities
- Support multiple river gauges with easy switching
- Provide actionable safety recommendations

## 3. Non-Goals
- Real-time video feeds of rivers
- User-generated river reports (community features handled separately)
- Complex hydrological analysis tools
- Mobile-specific features (responsive design covers all platforms)

## 4. User Stories & Use Cases
| User Story | Acceptance Criteria |
|------------|-------------------|
| **Quick Safety Check**: User wants to check if it's safe to go tubing | Can see current water level, flow rate, and safety status at a glance |
| **Historical Comparison**: User wants to see how conditions compare to yesterday | Can view 7-day historical chart with current vs. previous conditions |
| **Multiple Rivers**: User wants to compare different river sections | Can switch between American River and Sacramento River gauges |
| **Safety Alerts**: User wants to know about dangerous conditions | Receives clear alerts for high water, strong currents, or other hazards |
| **Planning**: User wants to plan activities for the weekend | Can see forecasted conditions and historical patterns |

## 5. Page Structure & Layout

### 5.1 Main Layout
```
┌─────────────────────────────────────┐
│ Header: River Conditions            │
├─────────────────────────────────────┤
│ Gauge Selector: [American] [Sac]    │
├─────────────────────────────────────┤
│ Current Conditions Card             │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│ │ Water   │ │ Flow    │ │ Safety  │ │
│ │ Level   │ │ Rate    │ │ Status  │ │
│ └─────────┘ └─────────┘ └─────────┘ │
├─────────────────────────────────────┤
│ Safety Alerts Section               │
│ ┌─────────────────────────────────┐ │
│ │ ⚠️ High Water Flow Warning      │ │
│ │ Current conditions dangerous    │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Historical Data Chart               │
│ ┌─────────────────────────────────┐ │
│ │ 7-Day Water Level Trend         │ │
│ │ [Interactive Chart]             │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Safety Information & Tips           │
│ ┌─────────────────────────────────┐ │
│ │ • Current safety level: CAUTION │ │
│ │ • Water temperature: 65°F       │ │
│ │ • Recommended activities: None  │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### 5.2 Gauge Information
| Gauge ID | Location | Description | Typical Use |
|----------|----------|-------------|-------------|
| `11446500` | American River at Fair Oaks | Popular tubing and swimming area | Recreational activities |
| `11447650` | Sacramento River at Downtown | Urban river access | Kayaking, fishing |

## 6. Technical Implementation

### 6.1 River Conditions Cubit
```dart
// lib/presentation/cubits/river_conditions_cubit.dart
class RiverConditionsCubit extends Cubit<RiverConditionsState> {
  final RiverRepository _riverRepository;
  
  RiverConditionsCubit({required RiverRepository riverRepository})
      : _riverRepository = riverRepository,
        super(RiverConditionsInitial());
  
  Future<void> loadRiverConditions(String gaugeId) async {
    emit(RiverConditionsLoading());
    
    try {
      final riverCondition = await _riverRepository.getRiverConditions(gaugeId);
      final historicalData = await _riverRepository.getHistoricalData(
        gaugeId, 
        DateTime.now().subtract(const Duration(days: 7)),
        DateTime.now(),
      );
      final safetyAlerts = await _riverRepository.getSafetyAlerts();
      
      emit(RiverConditionsLoaded(
        riverCondition: riverCondition,
        historicalData: historicalData,
        safetyAlerts: safetyAlerts,
      ));
    } catch (e) {
      emit(RiverConditionsError(e.toString()));
    }
  }
}
```

### 6.2 River Conditions Page
```dart
// lib/presentation/pages/river_conditions_page.dart
class RiverConditionsPage extends StatelessWidget {
  const RiverConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('River Conditions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<RiverConditionsCubit>().refresh(),
          ),
        ],
      ),
      body: BlocBuilder<RiverConditionsCubit, RiverConditionsState>(
        builder: (context, state) {
          if (state is RiverConditionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RiverConditionsError) {
            return Center(
              child: Column(
                children: [
                  const Icon(Icons.error, size: 64),
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<RiverConditionsCubit>().retry(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is RiverConditionsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildGaugeSelector(context),
                  const SizedBox(height: 16),
                  _buildCurrentConditionsCard(context, state.riverCondition),
                  const SizedBox(height: 16),
                  _buildSafetyAlertsSection(context, state.safetyAlerts),
                  const SizedBox(height: 16),
                  _buildHistoricalChart(context, state.historicalData),
                  const SizedBox(height: 16),
                  _buildSafetyInformation(context, state.riverCondition),
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

### 6.3 Current Conditions Card
```dart
Widget _buildCurrentConditionsCard(BuildContext context, RiverCondition condition) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            condition.gaugeName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Water Level',
                  '${condition.waterLevel.toStringAsFixed(1)} ft',
                  _getWaterLevelColor(condition.waterLevel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Flow Rate',
                  '${condition.flowRate.toStringAsFixed(0)} cfs',
                  _getFlowRateColor(condition.flowRate),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSafetyStatusCard(
                  context,
                  condition.safetyLevel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Last updated: ${_formatDateTime(condition.timestamp)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}
```

## 7. Data Visualization

### 7.1 Historical Chart
```dart
// Using fl_chart for data visualization
Widget _buildHistoricalChart(BuildContext context, List<RiverCondition> data) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7-Day Water Level Trend',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()} ft');
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                        return Text('${date.month}/${date.day}');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.waterLevel);
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.primaryBlue,
                    barWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```

## 8. Safety Alerts & Recommendations

### 8.1 Safety Level Calculation
```dart
String _calculateSafetyLevel(RiverCondition condition) {
  if (condition.waterLevel >= RiverSafetyThresholds.dangerWaterLevel ||
      condition.flowRate >= RiverSafetyThresholds.dangerFlowRate) {
    return 'danger';
  } else if (condition.waterLevel >= RiverSafetyThresholds.cautionWaterLevel ||
             condition.flowRate >= RiverSafetyThresholds.cautionFlowRate) {
    return 'caution';
  } else {
    return 'safe';
  }
}
```

### 8.2 Safety Recommendations
```dart
List<String> _getSafetyRecommendations(RiverCondition condition) {
  final recommendations = <String>[];
  
  switch (condition.safetyLevel) {
    case 'danger':
      recommendations.addAll([
        '⚠️ Avoid all water activities',
        'Strong currents present',
        'High water levels dangerous',
        'Wait for conditions to improve',
      ]);
      break;
    case 'caution':
      recommendations.addAll([
        '⚠️ Use extreme caution',
        'Life jacket required',
        'Stay close to shore',
        'Avoid swimming in deep areas',
      ]);
      break;
    case 'safe':
      recommendations.addAll([
        '✅ Conditions suitable for activities',
        'Always wear life jacket',
        'Stay within designated areas',
        'Supervise children closely',
      ]);
      break;
  }
  
  return recommendations;
}
```

## 9. Implementation Phases

### Phase 1: Basic Page Structure (Week 1)
- [ ] Create RiverConditionsPage layout
- [ ] Implement gauge selector
- [ ] Add current conditions display
- [ ] Basic error handling and loading states

### Phase 2: Data Integration (Week 2)
- [ ] Connect to real USGS API data
- [ ] Implement RiverConditionsCubit
- [ ] Add data refresh functionality
- [ ] Test with live river data

### Phase 3: Visualization (Week 3)
- [ ] Implement historical chart with fl_chart
- [ ] Add safety level indicators
- [ ] Create safety recommendations
- [ ] Add data export functionality

### Phase 4: Safety Features (Week 4)
- [ ] Implement safety alerts system
- [ ] Add push notifications for dangerous conditions
- [ ] Create safety tips and educational content
- [ ] Performance optimization

## 10. Testing Strategy

### 10.1 Unit Tests
```dart
test('safety level calculation works correctly', () {
  final safeCondition = RiverCondition(
    waterLevel: 1.5,
    flowRate: 800.0,
    // ... other fields
  );
  
  final cautionCondition = RiverCondition(
    waterLevel: 4.0,
    flowRate: 2500.0,
    // ... other fields
  );
  
  expect(_calculateSafetyLevel(safeCondition), 'safe');
  expect(_calculateSafetyLevel(cautionCondition), 'caution');
});
```

### 10.2 Widget Tests
- Test page loading and error states
- Test gauge selector functionality
- Test data refresh behavior
- Test chart interactions

### 10.3 Integration Tests
- Test API data integration
- Test real-time data updates
- Test safety alert generation
- Test historical data loading

## 11. Success Metrics
- **Data Accuracy**: 99% accuracy compared to USGS official data
- **Page Load Time**: <3 seconds for initial load
- **Data Freshness**: <15 minutes from USGS update
- **User Engagement**: >60% of users check conditions before activities
- **Safety Impact**: Reduced river-related incidents in target areas

## 12. Dependencies
- **fl_chart**: Data visualization (already in pubspec.yaml)
- **intl**: Date/time formatting (already in pubspec.yaml)
- **flutter_bloc**: State management (already in pubspec.yaml)

## 13. Future Enhancements
- **Forecast Integration**: Weather-based river condition predictions
- **Camera Feeds**: Live river webcam integration
- **Community Reports**: User-submitted condition updates
- **Mobile Notifications**: Push alerts for dangerous conditions
- **Offline Support**: Cached data for poor connectivity areas 