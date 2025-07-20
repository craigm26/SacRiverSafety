import 'package:equatable/equatable.dart';

/// Entity representing river conditions at a specific gauge
class RiverCondition extends Equatable {
  final String gaugeId;
  final String gaugeName;
  final double waterLevel;
  final double flowRate;
  final DateTime timestamp;
  final String safetyLevel; // 'safe', 'caution', 'danger'
  final String? alert;

  const RiverCondition({
    required this.gaugeId,
    required this.gaugeName,
    required this.waterLevel,
    required this.flowRate,
    required this.timestamp,
    required this.safetyLevel,
    this.alert,
  });

  @override
  List<Object?> get props => [
    gaugeId,
    gaugeName,
    waterLevel,
    flowRate,
    timestamp,
    safetyLevel,
    alert,
  ];
} 