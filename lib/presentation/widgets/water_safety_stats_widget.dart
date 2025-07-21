import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sacriversafety/domain/entities/drowning_incident.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class WaterSafetyStatsWidget extends StatelessWidget {
  final List<DrowningIncident> drowningIncidents;

  const WaterSafetyStatsWidget({
    super.key,
    required this.drowningIncidents,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final currentYearIncidents = drowningIncidents
        .where((incident) => incident.date.year == currentYear)
        .toList();
    
    final fatalIncidents = drowningIncidents
        .where((incident) => incident.severity == DrowningSeverity.fatal)
        .toList();
    
    final incidentsWithLifeJackets = drowningIncidents
        .where((incident) => incident.hadLifeJacket == true)
        .toList();
    
    final incidentsWithoutLifeJackets = drowningIncidents
        .where((incident) => incident.hadLifeJacket == false)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Water Safety Statistics',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Data from Sacramento County',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Key Statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    '2024 Incidents',
                    currentYearIncidents.length.toString(),
                    Colors.orange,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Fatal Incidents',
                    fatalIncidents.length.toString(),
                    Colors.red,
                    Icons.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'With Life Jackets',
                    incidentsWithLifeJackets.length.toString(),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Without Life Jackets',
                    incidentsWithoutLifeJackets.length.toString(),
                    Colors.red,
                    Icons.cancel,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Safety Message
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
                      const Icon(Icons.safety_divider, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Critical Safety Alert',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on Sacramento County data: ${incidentsWithoutLifeJackets.length} out of ${drowningIncidents.length} incidents involved victims not wearing life jackets. Always wear a properly fitted life jacket when near water.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Recent Incidents
            Text(
              'Recent Incidents',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...drowningIncidents
                .take(3)
                .map((incident) => _buildIncidentItem(context, incident)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentItem(BuildContext context, DrowningIncident incident) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: incident.severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: incident.severityColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: incident.severityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${incident.riverSectionName} - ${incident.severityText}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM d, y').format(incident.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (incident.hadLifeJacket != null)
            Icon(
              incident.hadLifeJacket! ? Icons.check_circle : Icons.cancel,
              color: incident.hadLifeJacket! ? Colors.green : Colors.red,
              size: 16,
            ),
        ],
      ),
    );
  }
} 