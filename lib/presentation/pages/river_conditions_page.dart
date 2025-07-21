import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:sacriversafety/presentation/cubits/river_conditions_cubit.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/river_condition.dart';

class RiverConditionsPage extends StatefulWidget {
  const RiverConditionsPage({super.key});

  @override
  State<RiverConditionsPage> createState() => _RiverConditionsPageState();
}

class _RiverConditionsPageState extends State<RiverConditionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RiverConditionsCubit>().loadRiverConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RiverConditionsCubit, RiverConditionsState>(
        builder: (context, state) {
          if (state is RiverConditionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RiverConditionsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading river conditions',
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
                    onPressed: () => context.read<RiverConditionsCubit>().retry(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is RiverConditionsLoaded) {
            return _buildLoadedContent(context, state);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, RiverConditionsLoaded state) {
    final selectedGauge = state.riverGauges.firstWhere(
      (gauge) => gauge.id == state.selectedGaugeId,
      orElse: () => state.riverGauges.first,
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('River Conditions'),
          floating: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<RiverConditionsCubit>().refresh(),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildGaugeSelector(context, state),
              const SizedBox(height: 16),
              _buildCurrentConditionsCard(context, selectedGauge),
              const SizedBox(height: 16),
              _buildSafetyAlertsSection(context, state.safetyAlerts),
              const SizedBox(height: 16),
              _buildHistoricalChart(context, state.historicalData),
              const SizedBox(height: 16),
              _buildSafetyInformation(context, selectedGauge),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildGaugeSelector(BuildContext context, RiverConditionsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select River Gauge',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: state.riverGauges.map((gauge) {
                final isSelected = gauge.id == state.selectedGaugeId;
                return FilterChip(
                  label: Text(gauge.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<RiverConditionsCubit>().selectGauge(gauge.id);
                    }
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryBlue,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentConditionsCard(BuildContext context, RiverGauge gauge) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getSafetyColor(gauge.safetyLevel),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    gauge.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSafetyColor(gauge.safetyLevel).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    gauge.safetyLevel.toUpperCase(),
                    style: TextStyle(
                      color: _getSafetyColor(gauge.safetyLevel),
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
                  child: _buildMetricCard(
                    context,
                    'Water Level',
                    '${gauge.waterLevel.toStringAsFixed(1)} ft',
                    Icons.water_drop,
                    _getWaterLevelColor(gauge.waterLevel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Flow Rate',
                    '${gauge.flowRate.toStringAsFixed(0)} cfs',
                    Icons.waves,
                    _getFlowRateColor(gauge.flowRate),
                  ),
                ),
              ],
            ),
            if (gauge.lastUpdated != null) ...[
              const SizedBox(height: 16),
              Text(
                'Last updated: ${_formatDateTime(gauge.lastUpdated!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
            if (gauge.alert != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        gauge.alert!,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyAlertsSection(BuildContext context, List<SafetyAlert> alerts) {
    final activeAlerts = alerts.where((alert) => alert.isActive).toList();
    
    if (activeAlerts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No active safety alerts',
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
                const Icon(Icons.warning, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Safety Alerts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...activeAlerts.map((alert) => _buildAlertItem(context, alert)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(BuildContext context, SafetyAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getAlertColor(alert.severity).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getAlertColor(alert.severity).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getAlertIcon(alert.alertType),
                color: _getAlertColor(alert.severity),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getAlertColor(alert.severity),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getAlertColor(alert.severity),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  alert.severity.toUpperCase(),
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
          Text(
            alert.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalChart(BuildContext context, List<RiverCondition> data) {
    if (data.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.bar_chart, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'No historical data available',
                style: Theme.of(context).textTheme.titleMedium,
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
            Text(
              '7-Day Water Level Trend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            final date = data[value.toInt()].timestamp;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('M/d').format(date),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()} ft',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  minX: 0,
                  maxX: (data.length - 1).toDouble(),
                  minY: 0,
                  maxY: data.map((d) => d.waterLevel).reduce((a, b) => a > b ? a : b) + 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.waterLevel);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.primaryBlue.withValues(alpha: 0.5),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.primaryBlue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryBlue.withValues(alpha: 0.3),
                            AppTheme.primaryBlue.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
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

  Widget _buildSafetyInformation(BuildContext context, RiverGauge gauge) {
    final recommendations = _getSafetyRecommendations(gauge);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.safety_divider, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Safety Information',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    recommendation.startsWith('⚠️') ? Icons.warning : Icons.check_circle,
                    color: recommendation.startsWith('⚠️') ? Colors.orange : Colors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation.replaceAll(RegExp(r'[⚠️✅]'), '').trim(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
          ],
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

  Color _getWaterLevelColor(double waterLevel) {
    if (waterLevel >= 8.0) return Colors.red;
    if (waterLevel >= 5.0) return Colors.orange;
    return Colors.blue;
  }

  Color _getFlowRateColor(double flowRate) {
    if (flowRate >= 5000) return Colors.red;
    if (flowRate >= 2000) return Colors.orange;
    return Colors.blue;
  }

  Color _getAlertColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow.shade700;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon(String alertType) {
    switch (alertType) {
      case 'weather':
        return Icons.cloud;
      case 'water_condition':
        return Icons.water_drop;
      case 'trail_closure':
        return Icons.block;
      case 'incident':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  List<String> _getSafetyRecommendations(RiverGauge gauge) {
    final recommendations = <String>[];
    
    switch (gauge.safetyLevel.toLowerCase()) {
      case 'danger':
        recommendations.addAll([
          '⚠️ Avoid all water activities',
          '⚠️ Strong currents present',
          '⚠️ High water levels dangerous',
          '⚠️ Wait for conditions to improve',
        ]);
        break;
      case 'caution':
        recommendations.addAll([
          '⚠️ Use extreme caution',
          '⚠️ Life jacket required',
          '⚠️ Stay close to shore',
          '⚠️ Avoid swimming in deep areas',
        ]);
        break;
      case 'safe':
        recommendations.addAll([
          '✅ Conditions suitable for activities',
          '✅ Always wear life jacket',
          '✅ Stay within designated areas',
          '✅ Supervise children closely',
        ]);
        break;
    }
    
    return recommendations;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y HH:mm').format(dateTime);
  }
} 