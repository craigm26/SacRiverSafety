import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum LifeJacketSize {
  infant,
  child,
  youth,
  adult,
  universal,
}

enum ProgramStatus {
  active,
  seasonal,
  inactive,
  limited,
}

class LifeJacketProgram extends Equatable {
  final String id;
  final String name;
  final String description;
  final String organization;
  final String location;
  final double latitude;
  final double longitude;
  final ProgramStatus status;
  final List<LifeJacketSize> availableSizes;
  final int? totalJackets;
  final int? availableJackets;
  final String? contactInfo;
  final String? hours;
  final String? requirements;
  final String? website;
  final String? source;
  final DateTime? lastUpdated;

  const LifeJacketProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.organization,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.availableSizes,
    this.totalJackets,
    this.availableJackets,
    this.contactInfo,
    this.hours,
    this.requirements,
    this.website,
    this.source,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    organization,
    location,
    latitude,
    longitude,
    status,
    availableSizes,
    totalJackets,
    availableJackets,
    contactInfo,
    hours,
    requirements,
    website,
    source,
    lastUpdated,
  ];

  String get statusText {
    switch (status) {
      case ProgramStatus.active:
        return 'Active';
      case ProgramStatus.seasonal:
        return 'Seasonal';
      case ProgramStatus.inactive:
        return 'Inactive';
      case ProgramStatus.limited:
        return 'Limited Availability';
    }
  }

  Color get statusColor {
    switch (status) {
      case ProgramStatus.active:
        return Colors.green;
      case ProgramStatus.seasonal:
        return Colors.orange;
      case ProgramStatus.inactive:
        return Colors.red;
      case ProgramStatus.limited:
        return Colors.yellow;
    }
  }

  String get sizeText {
    return availableSizes.map((size) {
      switch (size) {
        case LifeJacketSize.infant:
          return 'Infant';
        case LifeJacketSize.child:
          return 'Child';
        case LifeJacketSize.youth:
          return 'Youth';
        case LifeJacketSize.adult:
          return 'Adult';
        case LifeJacketSize.universal:
          return 'Universal';
      }
    }).join(', ');
  }

  bool get hasAvailability => availableJackets != null && availableJackets! > 0;
} 