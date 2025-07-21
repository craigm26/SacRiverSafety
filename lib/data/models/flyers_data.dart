import 'package:sacriversafety/domain/entities/pdf_flyer.dart';

class FlyersData {
  static const List<PdfFlyer> flyers = [
    PdfFlyer(
      id: '1',
      title: 'Water Safety Guidelines - Trailhead Flyer',
      description: 'Essential water safety guidelines for the American River. Includes life jacket requirements, swimming safety, emergency procedures, and QR code to access real-time safety information.',
      assetPath: 'assets/pdfs/safety/water-safety-guidelines.pdf',
      category: FlyerCategory.safety,
      author: 'Sac River Safety Team',
      datePublished: '2024-01-15',
      version: '2.1',
      tags: ['water safety', 'life jackets', 'swimming', 'guidelines', 'trailhead', 'qr code'],
      isOfficial: true,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '2',
      title: 'Trail Etiquette Guide - Park Signage',
      description: 'Complete guide to trail etiquette and safety for the American River Parkway. Covers biking, walking, and multi-use trail rules with QR code for interactive map.',
      assetPath: 'assets/pdfs/trails/trail-etiquette-guide.pdf',
      category: FlyerCategory.trails,
      author: 'American River Parkway Foundation',
      datePublished: '2024-01-10',
      version: '1.3',
      tags: ['trail safety', 'biking', 'walking', 'etiquette', 'parkway', 'signage', 'qr code'],
      isOfficial: true,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '3',
      title: 'Emergency Contact Information - Safety Stations',
      description: 'Emergency contact numbers and procedures for river-related incidents. Includes local emergency services, rescue contacts, and QR code for real-time alerts.',
      assetPath: 'assets/pdfs/emergency/emergency-contacts.pdf',
      category: FlyerCategory.emergency,
      author: 'Sacramento County Emergency Services',
      datePublished: '2024-01-20',
      version: '1.0',
      tags: ['emergency', 'contacts', 'rescue', '911', 'safety stations', 'qr code'],
      isOfficial: true,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '4',
      title: 'River Safety Education Brochure - Visitor Centers',
      description: 'Educational brochure about river safety, including understanding water conditions, weather awareness, preparation tips, and QR code to safety videos.',
      assetPath: 'assets/pdfs/education/river-safety-education.pdf',
      category: FlyerCategory.education,
      author: 'FOLFAN',
      datePublished: '2024-01-12',
      version: '1.2',
      tags: ['education', 'safety', 'weather', 'preparation', 'visitor centers', 'videos', 'qr code'],
      isOfficial: false,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '5',
      title: 'Life Jacket Program Information - PFD Stations',
      description: 'Information about the borrow-a-PFD program and life jacket locations throughout the Sacramento region. Includes QR code to find nearest PFD station.',
      assetPath: 'assets/pdfs/safety/life-jacket-program.pdf',
      category: FlyerCategory.safety,
      author: 'Sac River Safety Coalition',
      datePublished: '2024-01-18',
      version: '1.1',
      tags: ['life jackets', 'PFD', 'borrow program', 'locations', 'stations', 'qr code'],
      isOfficial: false,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '6',
      title: 'Summer Safety Tips - Seasonal Awareness',
      description: 'Seasonal safety tips for enjoying the river during summer months. Includes heat safety, hydration, sun protection, and QR code to current conditions.',
      assetPath: 'assets/pdfs/safety/summer-safety-tips.pdf',
      category: FlyerCategory.safety,
      author: 'Sac River Safety Team',
      datePublished: '2024-01-25',
      version: '1.0',
      tags: ['summer', 'heat safety', 'hydration', 'sun protection', 'seasonal', 'conditions', 'qr code'],
      isOfficial: true,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '7',
      title: 'Before You Go - Safety Checklist',
      description: 'Essential safety checklist for river activities. Includes pre-trip planning, equipment checklist, weather check, and QR code to real-time river conditions.',
      assetPath: 'assets/pdfs/safety/before-you-go-checklist.pdf',
      category: FlyerCategory.safety,
      author: 'Sac River Safety Team',
      datePublished: '2024-01-30',
      version: '1.0',
      tags: ['checklist', 'planning', 'equipment', 'weather', 'conditions', 'qr code', 'pre-trip'],
      isOfficial: true,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '8',
      title: 'River Conditions Guide - Access Points',
      description: 'Guide to understanding river conditions, water levels, and safety indicators. Includes QR code to live river gauge data and current conditions.',
      assetPath: 'assets/pdfs/education/river-conditions-guide.pdf',
      category: FlyerCategory.education,
      author: 'USGS & Sac River Safety',
      datePublished: '2024-02-01',
      version: '1.0',
      tags: ['river conditions', 'water levels', 'gauge data', 'access points', 'qr code'],
      isOfficial: true,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '9',
      title: 'Volunteer Safety Ambassador Guide',
      description: 'Guide for volunteers distributing safety information. Includes talking points, safety tips to share, and QR code to volunteer resources.',
      assetPath: 'assets/pdfs/education/volunteer-ambassador-guide.pdf',
      category: FlyerCategory.education,
      author: 'Sac River Safety Coalition',
      datePublished: '2024-02-05',
      version: '1.0',
      tags: ['volunteer', 'ambassador', 'outreach', 'talking points', 'qr code'],
      isOfficial: false,
      isPrintable: true,
    ),
    PdfFlyer(
      id: '10',
      title: 'Family Safety Guide - Kid-Friendly',
      description: 'Family-friendly safety guide with simple tips for children and parents. Includes fun activities, safety rules, and QR code to educational videos.',
      assetPath: 'assets/pdfs/education/family-safety-guide.pdf',
      category: FlyerCategory.education,
      author: 'Sac River Safety Team',
      datePublished: '2024-02-10',
      version: '1.0',
      tags: ['family', 'children', 'kid-friendly', 'activities', 'videos', 'qr code'],
      isOfficial: true,
      isPrintable: true,
    ),
  ];

  static List<PdfFlyer> getFlyersByCategory(FlyerCategory category) {
    return flyers.where((flyer) => flyer.category == category).toList();
  }

  static List<PdfFlyer> searchFlyers(String query) {
    final lowercaseQuery = query.toLowerCase();
    return flyers.where((flyer) {
      return flyer.title.toLowerCase().contains(lowercaseQuery) ||
             flyer.description.toLowerCase().contains(lowercaseQuery) ||
             flyer.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  static List<PdfFlyer> getOfficialFlyers() {
    return flyers.where((flyer) => flyer.isOfficial).toList();
  }

  static List<PdfFlyer> getPrintableFlyers() {
    return flyers.where((flyer) => flyer.isPrintable).toList();
  }

  static List<PdfFlyer> getTrailheadFlyers() {
    return flyers.where((flyer) => 
      flyer.tags.contains('trailhead') || 
      flyer.tags.contains('signage') || 
      flyer.tags.contains('access points')
    ).toList();
  }

  static List<PdfFlyer> getVolunteerResources() {
    return flyers.where((flyer) => 
      flyer.tags.contains('volunteer') || 
      flyer.tags.contains('ambassador') || 
      flyer.tags.contains('outreach')
    ).toList();
  }
} 