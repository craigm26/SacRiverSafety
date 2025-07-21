import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum ResourceCategory {
  safety,
  data,
  education,
  emergency,
  recreation,
  government,
  nonprofit,
}

enum ResourceType {
  website,
  api,
  report,
  contact,
  program,
}

class ResourceDirectory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String url;
  final ResourceCategory category;
  final ResourceType type;
  final String? contactInfo;
  final String? dataSource;
  final List<String> tags;
  final bool isOfficial;
  final String? lastUpdated;

  const ResourceDirectory({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    required this.type,
    this.contactInfo,
    this.dataSource,
    this.tags = const [],
    this.isOfficial = false,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    url,
    category,
    type,
    contactInfo,
    dataSource,
    tags,
    isOfficial,
    lastUpdated,
  ];

  String get categoryName {
    switch (category) {
      case ResourceCategory.safety:
        return 'Safety';
      case ResourceCategory.data:
        return 'Data & Statistics';
      case ResourceCategory.education:
        return 'Education & Outreach';
      case ResourceCategory.emergency:
        return 'Emergency Services';
      case ResourceCategory.recreation:
        return 'Recreation';
      case ResourceCategory.government:
        return 'Government';
      case ResourceCategory.nonprofit:
        return 'Non-Profit Organizations';
    }
  }

  String get typeName {
    switch (type) {
      case ResourceType.website:
        return 'Website';
      case ResourceType.api:
        return 'API/Data Source';
      case ResourceType.report:
        return 'Report/Documentation';
      case ResourceType.contact:
        return 'Contact Information';
      case ResourceType.program:
        return 'Program/Service';
    }
  }

  Color get categoryColor {
    switch (category) {
      case ResourceCategory.safety:
        return Colors.red;
      case ResourceCategory.data:
        return Colors.blue;
      case ResourceCategory.education:
        return Colors.green;
      case ResourceCategory.emergency:
        return Colors.orange;
      case ResourceCategory.recreation:
        return Colors.purple;
      case ResourceCategory.government:
        return Colors.indigo;
      case ResourceCategory.nonprofit:
        return Colors.teal;
    }
  }
} 