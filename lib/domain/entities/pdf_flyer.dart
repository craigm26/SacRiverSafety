import 'package:flutter/material.dart';

enum FlyerCategory {
  safety,
  education,
  emergency,
  trails,
  general,
}

class PdfFlyer {
  final String id;
  final String title;
  final String description;
  final String assetPath;
  final FlyerCategory category;
  final String? author;
  final String? datePublished;
  final String? version;
  final List<String> tags;
  final bool isOfficial;
  final bool isPrintable;
  final String? thumbnailPath;

  const PdfFlyer({
    required this.id,
    required this.title,
    required this.description,
    required this.assetPath,
    required this.category,
    this.author,
    this.datePublished,
    this.version,
    this.tags = const [],
    this.isOfficial = false,
    this.isPrintable = false,
    this.thumbnailPath,
  });

  String get categoryName {
    switch (category) {
      case FlyerCategory.safety:
        return 'Safety';
      case FlyerCategory.education:
        return 'Education';
      case FlyerCategory.emergency:
        return 'Emergency';
      case FlyerCategory.trails:
        return 'Trails';
      case FlyerCategory.general:
        return 'General';
    }
  }

  Color get categoryColor {
    switch (category) {
      case FlyerCategory.safety:
        return Colors.red;
      case FlyerCategory.education:
        return Colors.green;
      case FlyerCategory.emergency:
        return Colors.orange;
      case FlyerCategory.trails:
        return Colors.blue;
      case FlyerCategory.general:
        return Colors.grey;
    }
  }
} 