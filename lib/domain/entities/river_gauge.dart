import 'package:equatable/equatable.dart';

/// Entity representing a river gauge with location data
class RiverGauge extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double waterLevel;
  final double flowRate;
  final String safetyLevel; // 'safe', 'caution', 'danger'
  final DateTime? lastUpdated;
  final String? alert;

  const RiverGauge({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.waterLevel,
    required this.flowRate,
    required this.safetyLevel,
    required this.lastUpdated,
    this.alert,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    latitude,
    longitude,
    waterLevel,
    flowRate,
    safetyLevel,
    lastUpdated,
    alert,
  ];
} 