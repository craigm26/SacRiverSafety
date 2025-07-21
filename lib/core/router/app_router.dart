import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sacriversafety/presentation/pages/home_page.dart';
import 'package:sacriversafety/presentation/pages/river_conditions_page.dart';
import 'package:sacriversafety/presentation/pages/interactive_map_page.dart';
import 'package:sacriversafety/presentation/pages/safety_education_page.dart';
import 'package:sacriversafety/presentation/pages/trail_safety_page.dart';
import 'package:sacriversafety/presentation/pages/statistics_page.dart';
import 'package:sacriversafety/presentation/pages/safety_alerts_page.dart';
import 'package:sacriversafety/presentation/pages/emergency_info_page.dart';
import 'package:sacriversafety/presentation/pages/about_page.dart';
import 'package:sacriversafety/presentation/pages/placeholder_page.dart';
import 'package:sacriversafety/presentation/pages/resource_directory_page.dart';
import 'package:sacriversafety/presentation/pages/pdf_flyers_page.dart';
import 'package:sacriversafety/presentation/pages/volunteer_resources_page.dart';
import 'package:sacriversafety/presentation/widgets/app_shell.dart';
import 'package:sacriversafety/core/router/route_constants.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Home page
      GoRoute(
        path: RouteConstants.home,
        name: RouteConstants.homeName,
        builder: (context, state) => const AppShell(
          title: 'Sac River Safety',
          child: HomePage(),
        ),
      ),
      
      // River routes
      GoRoute(
        path: RouteConstants.river,
        name: RouteConstants.riverName,
        builder: (context, state) => const AppShell(
          title: 'River Conditions',
          showBackButton: true,
          child: RiverConditionsPage(),
        ),
      ),
      
      // Trail routes
      GoRoute(
        path: RouteConstants.trail,
        name: RouteConstants.trailName,
        builder: (context, state) => const AppShell(
          title: 'Trail Safety',
          showBackButton: true,
          child: TrailSafetyPage(),
        ),
      ),
      
      // Interactive Map
      GoRoute(
        path: RouteConstants.map,
        name: RouteConstants.mapName,
        builder: (context, state) => const AppShell(
          title: 'Interactive Map',
          showBackButton: true,
          child: InteractiveMapPage(),
        ),
      ),
      
      // Safety Education page
      GoRoute(
        path: RouteConstants.safetyEducation,
        name: RouteConstants.safetyEducationName,
        builder: (context, state) => const AppShell(
          title: 'Safety Education',
          showBackButton: true,
          child: SafetyEducationPage(),
        ),
      ),
      
      // Statistics page
      GoRoute(
        path: RouteConstants.statistics,
        name: RouteConstants.statisticsName,
        builder: (context, state) => const AppShell(
          title: 'Statistics',
          showBackButton: true,
          child: StatisticsPage(),
        ),
      ),
      
      // Safety Alerts page
      GoRoute(
        path: RouteConstants.alerts,
        name: RouteConstants.alertsName,
        builder: (context, state) => const AppShell(
          title: 'Safety Alerts',
          showBackButton: true,
          child: SafetyAlertsPage(),
        ),
      ),
      
      // Emergency Info page
      GoRoute(
        path: '/emergency',
        name: 'emergency',
        builder: (context, state) => const AppShell(
          title: 'Emergency Information',
          showBackButton: true,
          child: EmergencyInfoPage(),
        ),
      ),
      
      // About page
      GoRoute(
        path: RouteConstants.about,
        name: RouteConstants.aboutName,
        builder: (context, state) => const AppShell(
          title: 'About',
          showBackButton: true,
          child: AboutPage(),
        ),
      ),
      
      // Resource Directory page
      GoRoute(
        path: RouteConstants.resourceDirectory,
        name: RouteConstants.resourceDirectoryName,
        builder: (context, state) => const AppShell(
          title: 'Resource Directory',
          showBackButton: true,
          child: ResourceDirectoryPage(),
        ),
      ),
      
      // PDF Flyers page
      GoRoute(
        path: RouteConstants.pdfFlyers,
        name: RouteConstants.pdfFlyersName,
        builder: (context, state) => const AppShell(
          title: 'Safety Flyers',
          showBackButton: true,
          child: PdfFlyersPage(),
        ),
      ),
      
      // Volunteer Resources page
      GoRoute(
        path: RouteConstants.volunteerResources,
        name: RouteConstants.volunteerResourcesName,
        builder: (context, state) => const AppShell(
          title: 'Volunteer Resources',
          showBackButton: true,
          child: VolunteerResourcesPage(),
        ),
      ),
      
      // Life Jacket Locations page
      GoRoute(
        path: '/life-jackets',
        name: 'life-jackets',
        builder: (context, state) => const AppShell(
          title: 'Life Jacket Locations',
          showBackButton: true,
          child: PlaceholderPage(
            title: 'Life Jacket Locations',
            description: 'Find borrow-a-PFD stations and life jacket rental locations throughout the Sacramento region.',
            icon: Icons.safety_divider,
            iconColor: Colors.blue,
          ),
        ),
      ),
      
      // First Aid page
      GoRoute(
        path: '/first-aid',
        name: 'first-aid',
        builder: (context, state) => const AppShell(
          title: 'First Aid',
          showBackButton: true,
          child: PlaceholderPage(
            title: 'First Aid Information',
            description: 'Learn essential first aid procedures for water-related emergencies and injuries.',
            icon: Icons.medical_services,
            iconColor: Colors.red,
          ),
        ),
      ),
      
      // Incident History page
      GoRoute(
        path: '/incidents',
        name: 'incidents',
        builder: (context, state) => const AppShell(
          title: 'Incident History',
          showBackButton: true,
          child: PlaceholderPage(
            title: 'Incident History',
            description: 'View historical incident reports and safety data for the Sacramento region.',
            icon: Icons.history,
            iconColor: Colors.orange,
          ),
        ),
      ),
      
      // Volunteer page
      GoRoute(
        path: '/volunteer',
        name: 'volunteer',
        builder: (context, state) => const AppShell(
          title: 'Volunteer',
          showBackButton: true,
          child: PlaceholderPage(
            title: 'Get Involved',
            description: 'Join our volunteer program and help promote water safety in the Sacramento community.',
            icon: Icons.volunteer_activism,
            iconColor: Colors.green,
          ),
        ),
      ),
      
      // Donate page
      GoRoute(
        path: '/donate',
        name: 'donate',
        builder: (context, state) => const AppShell(
          title: 'Donate',
          showBackButton: true,
          child: PlaceholderPage(
            title: 'Support River Safety',
            description: 'Help us continue our mission by making a donation to support water safety programs.',
            icon: Icons.favorite,
            iconColor: Colors.pink,
          ),
        ),
      ),
      
      // Report Issue page
      GoRoute(
        path: '/report',
        name: 'report',
        builder: (context, state) => const AppShell(
          title: 'Report Issue',
          showBackButton: true,
          child: PlaceholderPage(
            title: 'Report Safety Concerns',
            description: 'Report safety issues, hazards, or incidents to help keep our community safe.',
            icon: Icons.report,
            iconColor: Colors.red,
          ),
        ),
      ),
    ],
  );
} 