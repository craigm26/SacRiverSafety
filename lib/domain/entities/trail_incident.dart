import 'package:equatable/equatable.dart';

class TrailIncident extends Equatable {
  final String id;
  final DateTime date;
  final double latitude;
  final double longitude;
  final String type;
  final String severity;
  final String? description;
  final String? source;

  const TrailIncident({
    required this.id,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.severity,
    this.description,
    this.source,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    latitude,
    longitude,
    type,
    severity,
    description,
    source,
  ];
} 