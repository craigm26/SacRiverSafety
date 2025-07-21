import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';

class SafetyAlertsPage extends StatefulWidget {
  const SafetyAlertsPage({super.key});

  @override
  State<SafetyAlertsPage> createState() => _SafetyAlertsPageState();
}

class _SafetyAlertsPageState extends State<SafetyAlertsPage> {
  List<SafetyAlert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    
    // Mock data for now - in real app this would come from a service
    await Future.delayed(const Duration(seconds: 1));
    
    _alerts = [
      SafetyAlert(
        id: '1',
        title: 'High Water Flow - American River',
        description: 'Water levels are elevated due to recent rainfall. Use extreme caution.',
        severity: 'high',
        latitude: 38.5816,
        longitude: -121.4944,
        radius: 5000.0,
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(days: 1)),
        alertType: 'water_condition',
      ),
      SafetyAlert(
        id: '2',
        title: 'Trail Closure - Jedediah Smith Memorial Trail',
        description: 'Trail closed between Discovery Park and Cal Expo due to flooding.',
        severity: 'medium',
        latitude: 38.5916,
        longitude: -121.5044,
        radius: 3000.0,
        startTime: DateTime.now().subtract(const Duration(hours: 4)),
        endTime: DateTime.now().add(const Duration(hours: 12)),
        alertType: 'trail_closure',
      ),
      SafetyAlert(
        id: '3',
        title: 'Strong Currents - Sacramento River',
        description: 'Strong currents detected near Freeport. Life jackets required.',
        severity: 'high',
        latitude: 38.4616,
        longitude: -121.4944,
        radius: 4000.0,
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(days: 2)),
        alertType: 'water_condition',
      ),
    ];
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAlerts,
              child: _alerts.isEmpty
                  ? _buildEmptyState()
                  : _buildAlertsList(),
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.green,
          ),
          SizedBox(height: 16),
          Text(
            'No Active Alerts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'All river and trail conditions are currently safe.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(SafetyAlert alert) {
    final severityColor = _getSeverityColor(alert.severity);
    final severityIcon = _getSeverityIcon(alert.severity);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: severityColor,
          child: Icon(severityIcon, color: Colors.white),
        ),
        title: Text(
          alert.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(alert.description),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatTimeRange(alert.startTime, alert.endTime),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showAlertDetails(alert),
        ),
        onTap: () => _showAlertDetails(alert),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
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

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'low':
        return Icons.notification_important;
      default:
        return Icons.info;
    }
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return 'Unknown start time';
    
    final now = DateTime.now();
    final startDiff = now.difference(start);
    
    if (startDiff.inHours < 1) {
      return 'Started ${startDiff.inMinutes} min ago';
    } else if (startDiff.inDays < 1) {
      return 'Started ${startDiff.inHours} hours ago';
    } else {
      return 'Started ${startDiff.inDays} days ago';
    }
  }

  void _showAlertDetails(SafetyAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.description),
            const SizedBox(height: 16),
            Text('Severity: ${alert.severity.toUpperCase()}'),
            const SizedBox(height: 8),
            Text('Start: ${alert.startTime != null ? _formatDateTime(alert.startTime!) : 'Unknown'}'),
            const SizedBox(height: 8),
            Text('End: ${alert.endTime != null ? _formatDateTime(alert.endTime!) : 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Radius: ${(alert.radius / 1000).toStringAsFixed(1)} km'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showOnMap(alert);
            },
            child: const Text('Show on Map'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showOnMap(SafetyAlert alert) {
    // TODO: Navigate to map with alert location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening map for ${alert.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 