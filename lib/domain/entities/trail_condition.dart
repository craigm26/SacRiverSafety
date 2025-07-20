import 'package:equatable/equatable.dart';

/// Entity representing trail conditions
class TrailCondition extends Equatable {
  final double temperature;
  final int airQualityIndex;
  final String weatherCondition;
  final DateTime? sunrise;
  final DateTime? sunset;
  final List<String> alerts;
  final String overallSafety; // 'safe', 'caution', 'danger'

  const TrailCondition({
    required this.temperature,
    required this.airQualityIndex,
    required this.weatherCondition,
    required this.sunrise,
    required this.sunset,
    required this.alerts,
    required this.overallSafety,
  });

  @override
  List<Object?> get props => [
    temperature,
    airQualityIndex,
    weatherCondition,
    sunrise,
    sunset,
    alerts,
    overallSafety,
  ];
} 