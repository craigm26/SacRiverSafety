import 'package:equatable/equatable.dart';

/// Entity representing safety alerts with location data
class SafetyAlert extends Equatable {
  final String id;
  final String title;
  final String description;
  final String severity; // 'low', 'medium', 'high', 'critical'
  final double latitude;
  final double longitude;
  final double radius; // Alert radius in meters
  final DateTime? startTime;
  final DateTime? endTime;
  final String alertType; // 'weather', 'water_condition', 'trail_closure', 'incident'

  const SafetyAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.startTime,
    this.endTime,
    required this.alertType,
  });

  bool get isActive => endTime == null || DateTime.now().isBefore(endTime!);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    severity,
    latitude,
    longitude,
    radius,
    startTime,
    endTime,
    alertType,
  ];
} 