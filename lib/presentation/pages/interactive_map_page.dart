import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/presentation/cubits/home_cubit.dart';
import 'package:sacriversafety/presentation/widgets/river_map_widget.dart';
import 'package:sacriversafety/presentation/widgets/map_overlay_controls.dart';
import 'package:sacriversafety/presentation/widgets/safety_measurements_widget.dart';
import 'package:sacriversafety/presentation/widgets/trail_segments_widget.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/trail_data.dart';

class InteractiveMapPage extends StatefulWidget {
  const InteractiveMapPage({super.key});

  @override
  State<InteractiveMapPage> createState() => _InteractiveMapPageState();
}

class _InteractiveMapPageState extends State<InteractiveMapPage> {
  final Logger _logger = Logger();
  bool _showRiverGauges = true;
  bool _showAmenities = true;
  bool _showSafetyAlerts = true;
  bool _showTrailSegments = true;
  bool _isSafetyMeasurementsExpanded = true;

  @override
  void initState() {
    super.initState();
    _logger.i('InteractiveMapPage: initState called');
  }

  @override
  Widget build(BuildContext context) {
    // Remove debug logging to reduce console spam
    // _logger.d('InteractiveMapPage: build method called');
    
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Remove debug logging to reduce console spam
        // _logger.d('InteractiveMapPage: BlocBuilder called with state: ${state.runtimeType}');
        
        if (state is HomeInitial) {
          _logger.i('InteractiveMapPage: Showing initial state');
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing map...'),
              ],
            ),
          );
        }
        
        if (state is HomeLoading) {
          _logger.i('InteractiveMapPage: Showing loading state');
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading map data...'),
              ],
            ),
          );
        }
        
        if (state is HomeError) {
          _logger.e('InteractiveMapPage: Showing error state: ${state.message}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<HomeCubit>().loadHomeData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is HomeLoaded) {
          return Stack(
            children: [
              // Map
              RiverMapWidget(
                riverGauges: state.riverGauges,
                amenities: state.amenities,
                safetyAlerts: state.safetyAlerts,
                showRiverGauges: _showRiverGauges,
                showAmenities: _showAmenities,
                showSafetyAlerts: _showSafetyAlerts,
                onGaugeTap: (gauge) => _showGaugeInfo(context, gauge),
                onAmenityTap: (amenity) => _showAmenityInfo(context, amenity),
              ),
              
              // Map Overlay Controls (Top Left)
              Positioned(
                top: 16,
                left: 16,
                child: MapOverlayControls(
                  showRiverGauges: _showRiverGauges,
                  showAmenities: _showAmenities,
                  showSafetyAlerts: _showSafetyAlerts,
                  showTrailSegments: _showTrailSegments,
                  onRiverGaugesChanged: (value) => setState(() => _showRiverGauges = value),
                  onAmenitiesChanged: (value) => setState(() => _showAmenities = value),
                  onSafetyAlertsChanged: (value) => setState(() => _showSafetyAlerts = value),
                  onTrailSegmentsChanged: (value) => setState(() => _showTrailSegments = value),
                ),
              ),
              
              // Collapsible Safety Measurements (Top Right)
              Positioned(
                top: 16,
                right: 16,
                child: _buildCollapsibleSafetyMeasurements(context, state),
              ),

              // Map Legend (Bottom Left)
              Positioned(
                bottom: 16,
                left: 16,
                child: _buildMapLegend(context),
              ),

              // Quick Actions (Bottom Right)
              Positioned(
                bottom: 16,
                right: 16,
                child: _buildQuickActions(context),
              ),
            ],
          );
        }
        
        _logger.w('InteractiveMapPage: Unknown state type: ${state.runtimeType}');
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Unknown state...'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollapsibleSafetyMeasurements(BuildContext context, HomeLoaded state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isSafetyMeasurementsExpanded ? 280 : 50,
      constraints: BoxConstraints(
        maxHeight: _isSafetyMeasurementsExpanded ? 400 : 50,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with toggle button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isSafetyMeasurementsExpanded) ...[
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Safety Info',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                IconButton(
                  onPressed: () => setState(() => _isSafetyMeasurementsExpanded = !_isSafetyMeasurementsExpanded),
                  icon: Icon(
                    _isSafetyMeasurementsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),
          
          // Collapsible content
          if (_isSafetyMeasurementsExpanded)
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: SafetyMeasurementsWidget(
                  riverGauges: state.riverGauges,
                  trailCondition: state.trailCondition,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapLegend(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Map Legend',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem('River Gauges', Icons.water_drop, Colors.blue),
          _buildLegendItem('Water Fountains', Icons.water_drop, Colors.blue),
          _buildLegendItem('Restrooms', Icons.wc, Colors.green),
          _buildLegendItem('Emergency Call Boxes', Icons.emergency, Colors.red),
          _buildLegendItem('Ranger Stations', Icons.local_police, Colors.orange),
          _buildLegendItem('Safety Alerts', Icons.warning, Colors.red),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'search_button',
          onPressed: () => _showSearchDialog(context),
          backgroundColor: AppTheme.primaryBlue,
          child: const Icon(Icons.search, color: Colors.white),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'location_button',
          onPressed: () => _showLocationDialog(context),
          backgroundColor: Colors.green,
          child: const Icon(Icons.my_location, color: Colors.white),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'layers_button',
          onPressed: () => _showLayersDialog(context),
          backgroundColor: Colors.orange,
          child: const Icon(Icons.layers, color: Colors.white),
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Location'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter location or address...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement search functionality
              Navigator.of(context).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My Location'),
        content: const Text('This feature will show your current location on the map.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement location functionality
              Navigator.of(context).pop();
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showLayersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map Layers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('River Gauges'),
              value: _showRiverGauges,
              onChanged: (value) {
                setState(() => _showRiverGauges = value ?? true);
                Navigator.of(context).pop();
              },
            ),
            CheckboxListTile(
              title: const Text('Amenities'),
              value: _showAmenities,
              onChanged: (value) {
                setState(() => _showAmenities = value ?? true);
                Navigator.of(context).pop();
              },
            ),
            CheckboxListTile(
              title: const Text('Safety Alerts'),
              value: _showSafetyAlerts,
              onChanged: (value) {
                setState(() => _showSafetyAlerts = value ?? true);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGaugeInfo(BuildContext context, RiverGauge gauge) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
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
            if (gauge.alert != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        gauge.alert!,
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to detailed river conditions page
                },
                child: const Text('View Detailed Conditions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAmenityInfo(BuildContext context, TrailAmenity amenity) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amenity.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _getAmenityTypeName(amenity.type),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            if (amenity.description != null) ...[
              const SizedBox(height: 16),
              Text(amenity.description!),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  amenity.isOperational ? Icons.check_circle : Icons.cancel,
                  color: amenity.isOperational ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  amenity.isOperational ? 'Operational' : 'Out of Service',
                  style: TextStyle(
                    color: amenity.isOperational ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSafetyColor(String safetyLevel) {
    switch (safetyLevel.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'caution':
        return Colors.orange;
      case 'danger':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getAmenityTypeName(String type) {
    switch (type) {
      case 'water':
        return 'Water Fountain';
      case 'restroom':
        return 'Restroom';
      case 'emergency_callbox':
        return 'Emergency Call Box';
      case 'ranger_station':
        return 'Ranger Station';
      default:
        return 'Amenity';
    }
  }
}