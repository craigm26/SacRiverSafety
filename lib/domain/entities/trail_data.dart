import 'package:flutter/material.dart';

enum TrailType {
  paved,
  dirt,
  mixed,
}

enum TrailAccess {
  pedestrians,
  bikers,
  equestrians,
  all,
}

class TrailSegment {
  final String id;
  final String name;
  final String description;
  final TrailType type;
  final List<TrailAccess> access;
  final String startPoint;
  final String endPoint;
  final String area;
  final List<LatLng> coordinates;
  final bool isAccessible;
  final String? notes;

  const TrailSegment({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.access,
    required this.startPoint,
    required this.endPoint,
    required this.area,
    required this.coordinates,
    this.isAccessible = false,
    this.notes,
  });

  String get typeText {
    switch (type) {
      case TrailType.paved:
        return 'Paved Trail';
      case TrailType.dirt:
        return 'Dirt Trail';
      case TrailType.mixed:
        return 'Mixed Surface';
    }
  }

  String get accessText {
    final accessList = access.map((a) {
      switch (a) {
        case TrailAccess.pedestrians:
          return 'Pedestrians';
        case TrailAccess.bikers:
          return 'Bikers';
        case TrailAccess.equestrians:
          return 'Equestrians';
        case TrailAccess.all:
          return 'All Users';
      }
    }).toList();
    
    return accessList.join(', ');
  }

  Color get typeColor {
    switch (type) {
      case TrailType.paved:
        return Colors.blue;
      case TrailType.dirt:
        return Colors.brown;
      case TrailType.mixed:
        return Colors.purple;
    }
  }

  IconData get typeIcon {
    switch (type) {
      case TrailType.paved:
        return Icons.directions_bike;
      case TrailType.dirt:
        return Icons.terrain;
      case TrailType.mixed:
        return Icons.swap_horiz;
    }
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
} 