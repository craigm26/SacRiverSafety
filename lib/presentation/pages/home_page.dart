import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/presentation/cubits/home_cubit.dart';
import 'package:sacriversafety/presentation/widgets/river_map_widget.dart';
import 'package:sacriversafety/presentation/widgets/map_overlay_controls.dart';
import 'package:sacriversafety/presentation/widgets/safety_measurements_widget.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showRiverGauges = true;
  bool _showAmenities = true;
  bool _showSafetyAlerts = true;
  bool _isSafetyMeasurementsExpanded = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is HomeError) {
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
                  safetyAlerts: state.mapAlerts,
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
                    onRiverGaugesChanged: (value) => setState(() => _showRiverGauges = value),
                    onAmenitiesChanged: (value) => setState(() => _showAmenities = value),
                    onSafetyAlertsChanged: (value) => setState(() => _showSafetyAlerts = value),
                  ),
                ),
                
                // Collapsible Safety Measurements (Top Right)
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildCollapsibleSafetyMeasurements(context, state),
                ),
              ],
            );
          }
          
          return const Center(child: CircularProgressIndicator());
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
        maxWidth: MediaQuery.of(context).size.width * 0.8, // Responsive width
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
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: const BorderRadius.only(
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