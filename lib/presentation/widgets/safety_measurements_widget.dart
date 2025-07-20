import 'package:flutter/material.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';

class SafetyMeasurementsWidget extends StatelessWidget {
  final List<RiverGauge> riverGauges;
  final TrailCondition? trailCondition;

  const SafetyMeasurementsWidget({
    super.key,
    required this.riverGauges,
    this.trailCondition,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Critical Safety Measurements',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // River conditions
          if (riverGauges.isNotEmpty) ...[
            Text(
              'River Conditions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            ...riverGauges.map((gauge) => _buildRiverGaugeCard(context, gauge)),
            const SizedBox(height: 16),
          ],
          
          // Trail conditions
          if (trailCondition != null) ...[
            Text(
              'Trail Conditions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            _buildTrailConditionCard(context, trailCondition!),
          ],
        ],
      ),
    );
  }

  Widget _buildRiverGaugeCard(BuildContext context, RiverGauge gauge) {
    final safetyColor = _getSafetyColor(gauge.safetyLevel);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8, // Smaller indicator
                  height: 8,
                  decoration: BoxDecoration(
                    color: safetyColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    gauge.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: safetyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    gauge.safetyLevel.toUpperCase(),
                    style: TextStyle(
                      color: safetyColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMeasurementItem(
                    context,
                    'Water',
                    '${gauge.waterLevel.toStringAsFixed(1)} ft',
                    Icons.water_drop,
                    safetyColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMeasurementItem(
                    context,
                    'Flow',
                    '${gauge.flowRate.toStringAsFixed(0)} cfs',
                    Icons.waves,
                    safetyColor,
                  ),
                ),
              ],
            ),
            if (gauge.alert != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        gauge.alert!,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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

  Widget _buildTrailConditionCard(BuildContext context, TrailCondition condition) {
    final safetyColor = _getSafetyColor(condition.overallSafety);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8, // Smaller indicator
                  height: 8,
                  decoration: BoxDecoration(
                    color: safetyColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'American River Trail',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: safetyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    condition.overallSafety.toUpperCase(),
                    style: TextStyle(
                      color: safetyColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMeasurementItem(
                    context,
                    'Temp',
                    '${condition.temperature.toStringAsFixed(0)}°F',
                    Icons.thermostat,
                    _getTemperatureColor(condition.temperature),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMeasurementItem(
                    context,
                    'AQI',
                    '${condition.airQualityIndex}',
                    Icons.air,
                    _getAQIColor(condition.airQualityIndex),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildMeasurementItem(
                    context,
                    'Weather',
                    condition.weatherCondition,
                    Icons.wb_sunny,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMeasurementItem(
                    context,
                    'Sunset',
                    condition.sunset != null 
                        ? '${condition.sunset!.hour}:${condition.sunset!.minute.toString().padLeft(2, '0')}'
                        : 'N/A',
                    Icons.nightlight_round,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            if (condition.alerts.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        condition.alerts.first,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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

  Widget _buildMeasurementItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 11,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
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

  Color _getTemperatureColor(double temperature) {
    if (temperature < 50) return Colors.blue;
    if (temperature < 80) return Colors.green;
    if (temperature < 95) return Colors.orange;
    return Colors.red;
  }

  Color _getAQIColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    return Colors.purple;
  }
} 