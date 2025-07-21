import 'package:flutter/material.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class MapOverlayControls extends StatelessWidget {
  final bool showRiverGauges;
  final bool showAmenities;
  final bool showSafetyAlerts;
  final bool showTrailSegments;
  final ValueChanged<bool> onRiverGaugesChanged;
  final ValueChanged<bool> onAmenitiesChanged;
  final ValueChanged<bool> onSafetyAlertsChanged;
  final ValueChanged<bool> onTrailSegmentsChanged;

  const MapOverlayControls({
    super.key,
    required this.showRiverGauges,
    required this.showAmenities,
    required this.showSafetyAlerts,
    required this.showTrailSegments,
    required this.onRiverGaugesChanged,
    required this.onAmenitiesChanged,
    required this.onSafetyAlertsChanged,
    required this.onTrailSegmentsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      width: 280, // Fixed width to prevent layout issues
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Map Layers',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildLayerToggle(
            context,
            icon: Icons.water_drop,
            title: 'River Gauges',
            subtitle: 'Water level & flow data',
            value: showRiverGauges,
            onChanged: onRiverGaugesChanged,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildLayerToggle(
            context,
            icon: Icons.place,
            title: 'Trail Amenities',
            subtitle: 'Water, restrooms, emergency',
            value: showAmenities,
            onChanged: onAmenitiesChanged,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _buildLayerToggle(
            context,
            icon: Icons.warning,
            title: 'Safety Alerts',
            subtitle: 'Active warnings & closures',
            value: showSafetyAlerts,
            onChanged: onSafetyAlertsChanged,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildLayerToggle(
            context,
            icon: Icons.directions_bike,
            title: 'Trail Segments',
            subtitle: 'FOLFAN trail network',
            value: showTrailSegments,
            onChanged: onTrailSegmentsChanged,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildLayerToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }
} 