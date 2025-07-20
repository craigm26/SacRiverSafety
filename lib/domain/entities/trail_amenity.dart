import 'package:equatable/equatable.dart';

/// Entity representing trail amenities with location data
class TrailAmenity extends Equatable {
  final String id;
  final String name;
  final String type; // 'water', 'restroom', 'emergency_callbox', 'ranger_station'
  final double latitude;
  final double longitude;
  final String? description;
  final bool isOperational;

  const TrailAmenity({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.isOperational,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    latitude,
    longitude,
    description,
    isOperational,
  ];
} 