import 'package:flutter/material.dart';
import 'package:sacriversafety/domain/entities/resource_directory.dart';
import 'package:sacriversafety/presentation/widgets/resource_directory_widget.dart';

class ResourceDirectoryPage extends StatelessWidget {
  const ResourceDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample resource data - in a real app, this would come from a repository
    final List<ResourceDirectory> sampleResources = [
      ResourceDirectory(
        id: '1',
        name: 'Sacramento County Parks',
        description: 'Official county parks information, trail maps, and safety guidelines for the American River Parkway.',
        url: 'https://www.sacparks.net',
        category: ResourceCategory.government,
        type: ResourceType.website,
        tags: ['parks', 'trails', 'safety', 'official'],
        isOfficial: true,
        contactInfo: '916-875-6961',
        dataSource: 'Sacramento County Parks Department',
        lastUpdated: '2024-01-15',
      ),
      ResourceDirectory(
        id: '2',
        name: 'USGS Water Data',
        description: 'Real-time water level and flow data for the American River and other waterways in the Sacramento region.',
        url: 'https://waterdata.usgs.gov',
        category: ResourceCategory.data,
        type: ResourceType.api,
        tags: ['water levels', 'flow data', 'real-time', 'official'],
        isOfficial: true,
        contactInfo: '1-888-275-8747',
        dataSource: 'United States Geological Survey',
        lastUpdated: '2024-01-20',
      ),
      ResourceDirectory(
        id: '3',
        name: 'American River Safety Coalition',
        description: 'Non-profit organization dedicated to promoting water safety and education along the American River.',
        url: 'https://www.americanriversafety.org',
        category: ResourceCategory.nonprofit,
        type: ResourceType.website,
        tags: ['safety education', 'non-profit', 'community'],
        isOfficial: false,
        contactInfo: 'info@americanriversafety.org',
        dataSource: 'American River Safety Coalition',
        lastUpdated: '2024-01-10',
      ),
      ResourceDirectory(
        id: '4',
        name: 'Sacramento Fire Department',
        description: 'Emergency services and water rescue information for the Sacramento region.',
        url: 'https://www.sacfire.org',
        category: ResourceCategory.emergency,
        type: ResourceType.website,
        tags: ['emergency', 'fire department', 'rescue', 'official'],
        isOfficial: true,
        contactInfo: '916-808-1300',
        dataSource: 'Sacramento Fire Department',
        lastUpdated: '2024-01-18',
      ),
      ResourceDirectory(
        id: '5',
        name: 'River Safety Education Center',
        description: 'Comprehensive water safety education resources, videos, and training materials.',
        url: 'https://www.riversafetyedu.org',
        category: ResourceCategory.education,
        type: ResourceType.website,
        tags: ['education', 'training', 'videos', 'safety'],
        isOfficial: false,
        contactInfo: 'contact@riversafetyedu.org',
        dataSource: 'River Safety Education Center',
        lastUpdated: '2024-01-12',
      ),
      ResourceDirectory(
        id: '6',
        name: 'American River Recreation Guide',
        description: 'Complete guide to recreational activities, access points, and safety tips for the American River.',
        url: 'https://www.americanriverrec.com',
        category: ResourceCategory.recreation,
        type: ResourceType.website,
        tags: ['recreation', 'activities', 'access points', 'guide'],
        isOfficial: false,
        contactInfo: 'info@americanriverrec.com',
        dataSource: 'American River Recreation Guide',
        lastUpdated: '2024-01-08',
      ),
      ResourceDirectory(
        id: '7',
        name: 'FOLFAN - Friends of Lake Folsom and American River',
        description: 'Non-profit organization dedicated to preserving and enhancing the American River Parkway and Lake Folsom State Recreation Area. Offers life jacket programs, education, guided activities, and park stewardship.',
        url: 'https://folfan.org/',
        category: ResourceCategory.nonprofit,
        type: ResourceType.website,
        tags: ['life jackets', 'education', 'park stewardship', 'guided activities', 'volunteer', 'parkway'],
        isOfficial: false,
        contactInfo: 'info@folfan.org',
        dataSource: 'FOLFAN - Friends of Lake Folsom and American River',
        lastUpdated: '2024-01-22',
      ),
      ResourceDirectory(
        id: '8',
        name: 'American River Parkway Foundation (ARPF)',
        description: 'Sacramento 501(c)(3) nonprofit dedicated to conserving and nurturing the 23-mile American River Parkway. Offers volunteer programs, education, clean-ups, trail maintenance, and community engagement.',
        url: 'https://arpf.org/',
        category: ResourceCategory.nonprofit,
        type: ResourceType.website,
        tags: ['parkway', 'volunteer', 'conservation', 'trail maintenance', 'clean-ups', 'education', 'community'],
        isOfficial: false,
        contactInfo: '916-486-2773 | info@arpf.org',
        dataSource: 'American River Parkway Foundation',
        lastUpdated: '2024-01-23',
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.library_books, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resource Directory',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              'Find official resources, data sources, and community organizations',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This directory contains official government sources, non-profit organizations, and community resources related to river safety and recreation in the Sacramento region.',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Resource Directory Widget
          ResourceDirectoryWidget(resources: sampleResources),
        ],
      ),
    );
  }
} 