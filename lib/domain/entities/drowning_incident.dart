import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum DrowningSeverity {
  fatal,
  nonFatal,
  rescue,
  nearMiss,
}

enum RiverSection {
  americanRiver,
  sacramentoRiver,
  confluence,
  auburnSection,
  discoveryPark,
  williamBPond,
  clayBanks,
  tiscorniaBeach,
}

class DrowningIncident extends Equatable {
  final String id;
  final DateTime date;
  final double latitude;
  final double longitude;
  final RiverSection riverSection;
  final DrowningSeverity severity;
  final String? description;
  final String? source;
  final int? age;
  final String? gender;
  final bool? hadLifeJacket;
  final String? activity; // swimming, rafting, fishing, etc.
  final String? equipment; // type of equipment used

  const DrowningIncident({
    required this.id,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.riverSection,
    required this.severity,
    this.description,
    this.source,
    this.age,
    this.gender,
    this.hadLifeJacket,
    this.activity,
    this.equipment,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    latitude,
    longitude,
    riverSection,
    severity,
    description,
    source,
    age,
    gender,
    hadLifeJacket,
    activity,
    equipment,
  ];

  String get severityText {
    switch (severity) {
      case DrowningSeverity.fatal:
        return 'Fatal';
      case DrowningSeverity.nonFatal:
        return 'Non-Fatal';
      case DrowningSeverity.rescue:
        return 'Rescue';
      case DrowningSeverity.nearMiss:
        return 'Near Miss';
    }
  }

  String get riverSectionName {
    switch (riverSection) {
      case RiverSection.americanRiver:
        return 'American River';
      case RiverSection.sacramentoRiver:
        return 'Sacramento River';
      case RiverSection.confluence:
        return 'River Confluence';
      case RiverSection.auburnSection:
        return 'Auburn Section';
      case RiverSection.discoveryPark:
        return 'Discovery Park';
      case RiverSection.williamBPond:
        return 'William B Pond Park';
      case RiverSection.clayBanks:
        return 'Clay Banks';
      case RiverSection.tiscorniaBeach:
        return 'Tiscornia Beach';
    }
  }

  Color get severityColor {
    switch (severity) {
      case DrowningSeverity.fatal:
        return Colors.red;
      case DrowningSeverity.nonFatal:
        return Colors.orange;
      case DrowningSeverity.rescue:
        return Colors.yellow;
      case DrowningSeverity.nearMiss:
        return Colors.blue;
    }
  }
} 