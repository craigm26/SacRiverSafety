import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum ParkStatusType {
  open,
  closed,
  limited,
  maintenance,
  emergency,
}

class ParkStatus extends Equatable {
  final String parkName;
  final ParkStatusType status;
  final String? description;
  final DateTime? lastUpdated;
  final List<String>? affectedAreas;
  final String? contactInfo;

  const ParkStatus({
    required this.parkName,
    required this.status,
    this.description,
    this.lastUpdated,
    this.affectedAreas,
    this.contactInfo,
  });

  @override
  List<Object?> get props => [
    parkName,
    status,
    description,
    lastUpdated,
    affectedAreas,
    contactInfo,
  ];

  String get statusText {
    switch (status) {
      case ParkStatusType.open:
        return 'Open';
      case ParkStatusType.closed:
        return 'Closed';
      case ParkStatusType.limited:
        return 'Limited Access';
      case ParkStatusType.maintenance:
        return 'Under Maintenance';
      case ParkStatusType.emergency:
        return 'Emergency Closure';
    }
  }

  Color get statusColor {
    switch (status) {
      case ParkStatusType.open:
        return Colors.green;
      case ParkStatusType.closed:
        return Colors.red;
      case ParkStatusType.limited:
        return Colors.orange;
      case ParkStatusType.maintenance:
        return Colors.yellow;
      case ParkStatusType.emergency:
        return Colors.red;
    }
  }
} 