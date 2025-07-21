import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/presentation/cubits/trail_safety_cubit.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/presentation/widgets/trail_map_widget.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/trail_incident.dart';
import 'package:sacriversafety/domain/entities/park_status.dart';
import 'package:sacriversafety/domain/entities/drowning_incident.dart';
import 'package:sacriversafety/presentation/widgets/water_safety_stats_widget.dart';

class TrailSafetyPage extends StatefulWidget {
  const TrailSafetyPage({super.key});

  @override
  State<TrailSafetyPage> createState() => _TrailSafetyPageState();
}

class _TrailSafetyPageState extends State<TrailSafetyPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrailSafetyCubit>().loadTrailSafetyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrailSafetyCubit, TrailSafetyState>(
        builder: (context, state) {
          if (state is TrailSafetyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is TrailSafetyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading trail safety data',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<TrailSafetyCubit>().retry(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is TrailSafetyLoaded) {
            return _buildLoadedContent(context, state);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, TrailSafetyLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Trail Safety'),
          floating: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<TrailSafetyCubit>().refresh(),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSafetyAlertBanner(context, state),
              const SizedBox(height: 16),
              _buildTrailRulesCard(context),
              const SizedBox(height: 16),
              _buildCurrentConditionsCard(context, state.trailCondition),
              const SizedBox(height: 16),
              _buildEtiquetteCard(context),
              const SizedBox(height: 16),
              _buildAmenitiesCard(context, state.amenities),
              const SizedBox(height: 16),
              _buildIncidentsCard(context, state.incidents),
              const SizedBox(height: 16),
              _buildParkStatusCard(context, state.parkStatus),
              const SizedBox(height: 16),
              WaterSafetyStatsWidget(drowningIncidents: state.drowningIncidents),
              const SizedBox(height: 16),
              _buildTrailMapCard(context, state),
              const SizedBox(height: 16),
              _buildEssentialsChecklist(context),
              const SizedBox(height: 16),
              _buildEmergencyContactsCard(context),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyAlertBanner(BuildContext context, TrailSafetyLoaded state) {
    if (!state.hasActiveAlerts) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Trail conditions are safe for activities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Trail Safety Alerts Active',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...state.safetyAlerts.take(2).map((alert) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• ${alert.description}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.orange.shade700,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTrailRulesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.gavel, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Trail Rules',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRuleItem(context, 'Speed Limit', '15 mph maximum', Icons.speed),
            _buildRuleItem(context, 'Keep Right', 'Stay to the right, pass on the left', Icons.arrow_forward),
            _buildRuleItem(context, 'Dogs on Leash', 'Maximum 6-foot leash required', Icons.pets),
            _buildRuleItem(context, 'Helmet Law', 'Helmets required for cyclists under 18', Icons.sports_motorsports),
            _buildRuleItem(context, 'Yield to Pedestrians', 'Bicyclists must yield to walkers', Icons.directions_walk),
            _buildRuleItem(context, 'No Motorized Vehicles', 'Except authorized maintenance vehicles', Icons.block),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(BuildContext context, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentConditionsCard(BuildContext context, TrailCondition condition) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.thermostat, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Current Conditions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSafetyColor(condition.overallSafety).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    condition.overallSafety.toUpperCase(),
                    style: TextStyle(
                      color: _getSafetyColor(condition.overallSafety),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildConditionItem(
                    context,
                    'Temperature',
                    '${condition.temperature.toStringAsFixed(0)}°F',
                    Icons.thermostat,
                    _getTemperatureColor(condition.temperature),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConditionItem(
                    context,
                    'Air Quality',
                    'AQI ${condition.airQualityIndex}',
                    Icons.air,
                    _getAQIColor(condition.airQualityIndex),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildConditionItem(
                    context,
                    'Weather',
                    condition.weatherCondition,
                    Icons.wb_sunny,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConditionItem(
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
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Weather Alerts',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...condition.alerts.map((alert) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $alert',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtiquetteCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Trail Etiquette',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildEtiquetteItem(context, 'Announce when passing', 'Say "On your left" when overtaking', Icons.volume_up),
            _buildEtiquetteItem(context, 'Single file when busy', 'Ride single file during peak hours', Icons.view_headline),
            _buildEtiquetteItem(context, 'Clean up after pets', 'Always pick up and dispose of waste', Icons.cleaning_services),
            _buildEtiquetteItem(context, 'Respect wildlife', 'Keep distance from animals and birds', Icons.pets),
            _buildEtiquetteItem(context, 'Share the trail', 'Be courteous to all trail users', Icons.favorite),
          ],
        ),
      ),
    );
  }

  Widget _buildEtiquetteItem(BuildContext context, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesCard(BuildContext context, List<TrailAmenity> amenities) {
    final waterFountains = amenities.where((a) => a.type == 'water').length;
    final restrooms = amenities.where((a) => a.type == 'restroom').length;
    final emergencyCallboxes = amenities.where((a) => a.type == 'emergency_callbox').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Trail Amenities',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAmenityItem(context, 'Water Fountains', waterFountains.toString(), Icons.water_drop),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAmenityItem(context, 'Restrooms', restrooms.toString(), Icons.wc),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAmenityItem(context, 'Emergency Call Boxes', emergencyCallboxes.toString(), Icons.emergency),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityItem(BuildContext context, String label, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 24),
          const SizedBox(height: 4),
          Text(
            count,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrailMapCard(BuildContext context, TrailSafetyLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.map, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Interactive Trail Map',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
                                      child: TrailMapWidget(
                          amenities: state.amenities,
                          safetyAlerts: state.safetyAlerts,
                          incidents: state.incidents,
                          drowningIncidents: state.drowningIncidents,
                          showAmenities: true,
                          showSafetyAlerts: true,
                          showIncidents: true,
                          showDrowningIncidents: true,
                          showMileMarkers: true,
                          onAmenityTap: (amenity) => _showAmenityInfo(context, amenity),
                          onAlertTap: (alert) => _showAlertInfo(context, alert),
                          onIncidentTap: (incident) => _showIncidentInfo(context, incident),
                          onDrowningIncidentTap: (incident) => _showDrowningIncidentInfo(context, incident),
                        ),
            ),
            const SizedBox(height: 12),
            _buildMapLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLegend(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Map Legend',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildLegendItem(context, 'Mile Markers', Colors.blue, Icons.place),
            _buildLegendItem(context, 'Water Fountains', Colors.blue, Icons.water_drop),
            _buildLegendItem(context, 'Restrooms', Colors.green, Icons.wc),
            _buildLegendItem(context, 'Emergency Call Boxes', Colors.red, Icons.emergency),
            _buildLegendItem(context, 'Ranger Stations', Colors.orange, Icons.local_police),
            _buildLegendItem(context, 'Parking Areas', Colors.purple, Icons.local_parking),
            _buildLegendItem(context, 'Picnic Areas', Colors.teal, Icons.table_restaurant),
            _buildLegendItem(context, 'Safety Alerts', Colors.orange, Icons.warning),
            _buildLegendItem(context, 'Recent Incidents', Colors.red, Icons.report),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 10,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
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
            Row(
              children: [
                Icon(_getAmenityIcon(amenity.type), color: _getAmenityColor(amenity.type)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    amenity.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
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
                  size: 20,
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

  void _showAlertInfo(BuildContext context, SafetyAlert alert) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: _getAlertColor(alert.severity)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alert.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getAlertColor(alert.severity).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                alert.severity.toUpperCase(),
                style: TextStyle(
                  color: _getAlertColor(alert.severity),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(alert.description),
            if (alert.startTime != null) ...[
              const SizedBox(height: 16),
              Text(
                'Started: ${DateFormat('MMM d, y HH:mm').format(alert.startTime!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showIncidentInfo(BuildContext context, TrailIncident incident) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIncidentIcon(incident.type), color: _getIncidentColor(incident.severity)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    incident.type.replaceAll('-', ' ').toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getIncidentColor(incident.severity).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                incident.severity.toUpperCase(),
                style: TextStyle(
                  color: _getIncidentColor(incident.severity),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (incident.description != null) ...[
              Text(incident.description!),
              const SizedBox(height: 16),
            ],
            Text(
              'Date: ${DateFormat('MMM d, y').format(incident.date)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDrowningIncidentInfo(BuildContext context, DrowningIncident incident) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  color: incident.severityColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Drowning Incident - ${incident.severityText}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${incident.riverSectionName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('MMM d, y').format(incident.date)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (incident.age != null) ...[
              const SizedBox(height: 4),
              Text(
                'Age: ${incident.age} | Gender: ${incident.gender ?? 'Unknown'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (incident.activity != null) ...[
              const SizedBox(height: 4),
              Text(
                'Activity: ${incident.activity}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (incident.hadLifeJacket != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    incident.hadLifeJacket! ? Icons.check_circle : Icons.cancel,
                    color: incident.hadLifeJacket! ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Life Jacket: ${incident.hadLifeJacket! ? 'Yes' : 'No'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: incident.hadLifeJacket! ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
            if (incident.description != null) ...[
              const SizedBox(height: 8),
              Text(
                incident.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (incident.source != null) ...[
              const SizedBox(height: 8),
              Text(
                'Source: ${incident.source}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAmenityColor(String type) {
    switch (type) {
      case 'water':
        return Colors.blue;
      case 'restroom':
        return Colors.green;
      case 'emergency_callbox':
        return Colors.red;
      case 'ranger_station':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getAmenityIcon(String type) {
    switch (type) {
      case 'water':
        return Icons.water_drop;
      case 'restroom':
        return Icons.wc;
      case 'emergency_callbox':
        return Icons.emergency;
      case 'ranger_station':
        return Icons.local_police;
      default:
        return Icons.place;
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
      case 'parking':
        return 'Parking Area';
      case 'picnic':
        return 'Picnic Area';
      default:
        return 'Amenity';
    }
  }

  Color _getAlertColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  Color _getIncidentColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'injury':
      case 'medical':
        return Colors.red;
      case 'minor':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getIncidentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bike-ped collision':
        return Icons.directions_bike;
      case 'heat-related rescue':
        return Icons.thermostat;
      case 'dog incident':
        return Icons.pets;
      default:
        return Icons.warning;
    }
  }

  Widget _buildParkStatusCard(BuildContext context, List<ParkStatus> parkStatus) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.park, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Park Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  'Live from Sacramento County Regional Parks',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...parkStatus.map((status) => _buildParkStatusItem(context, status)),
          ],
        ),
      ),
    );
  }

  Widget _buildParkStatusItem(BuildContext context, ParkStatus status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status.statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: status.statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getParkStatusIcon(status.status),
                color: status.statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  status.parkName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status.statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.statusText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (status.description != null) ...[
            const SizedBox(height: 8),
            Text(
              status.description!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (status.affectedAreas != null && status.affectedAreas!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Affected Areas: ${status.affectedAreas!.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (status.lastUpdated != null) ...[
            const SizedBox(height: 8),
            Text(
              'Updated: ${DateFormat('MMM d, y HH:mm').format(status.lastUpdated!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getParkStatusIcon(ParkStatusType status) {
    switch (status) {
      case ParkStatusType.open:
        return Icons.check_circle;
      case ParkStatusType.closed:
        return Icons.cancel;
      case ParkStatusType.limited:
        return Icons.warning;
      case ParkStatusType.maintenance:
        return Icons.build;
      case ParkStatusType.emergency:
        return Icons.emergency;
      default:
        return Icons.help;
    }
  }

  Widget _buildIncidentsCard(BuildContext context, List<TrailIncident> incidents) {
    if (incidents.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No recent incidents reported',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.report, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Recent Incidents',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...incidents.take(3).map((incident) => _buildIncidentItem(context, incident)),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentItem(BuildContext context, TrailIncident incident) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getIncidentColor(incident.severity).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getIncidentColor(incident.severity).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIncidentIcon(incident.type),
                color: _getIncidentColor(incident.severity),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  incident.type.replaceAll('-', ' ').toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getIncidentColor(incident.severity),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getIncidentColor(incident.severity),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  incident.severity.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (incident.description != null) ...[
            Text(
              incident.description!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
          ],
          Text(
            DateFormat('MMM d, y').format(incident.date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEssentialsChecklist(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.checklist, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Essentials Checklist',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildChecklistItem(context, 'Water bottle', true),
            _buildChecklistItem(context, 'Helmet (for cyclists)', true),
            _buildChecklistItem(context, 'Phone with emergency contacts', true),
            _buildChecklistItem(context, 'ID and medical information', true),
            _buildChecklistItem(context, 'Weather-appropriate clothing', true),
            _buildChecklistItem(context, 'Lights (for evening rides)', false),
            _buildChecklistItem(context, 'First aid kit', false),
            _buildChecklistItem(context, 'Trail map or GPS', false),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, String item, bool isEssential) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isEssential ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isEssential ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isEssential ? Colors.black : AppTheme.textSecondary,
                fontWeight: isEssential ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          if (isEssential)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'ESSENTIAL',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emergency, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Emergency Contacts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactItem(context, 'Emergency', '911', Icons.phone),
            _buildContactItem(context, 'Park Rangers', '(916) 875-6961', Icons.local_police),
            _buildContactItem(context, 'Sacramento Metro Fire', '(916) 875-5500', Icons.local_fire_department),
            _buildContactItem(context, 'Report Trail Issues', '311', Icons.report),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, String label, String number, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Implement phone call functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Calling $label: $number')),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      number,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.call, color: Colors.red, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  Color _getSafetyColor(String safetyLevel) {
    switch (safetyLevel.toLowerCase()) {
      case 'danger':
        return Colors.red;
      case 'caution':
        return Colors.orange;
      case 'safe':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature >= 95) return Colors.red;
    if (temperature >= 85) return Colors.orange;
    return Colors.blue;
  }

  Color _getAQIColor(int aqi) {
    if (aqi >= 150) return Colors.red;
    if (aqi >= 100) return Colors.orange;
    if (aqi >= 50) return Colors.yellow;
    return Colors.green;
  }

} 