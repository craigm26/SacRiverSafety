import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sacriversafety/presentation/pages/home_page.dart';
import 'package:sacriversafety/presentation/widgets/app_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home page
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShell(
          title: 'sacriversafety',
          child: HomePage(),
        ),
      ),
      
      // River Conditions
      GoRoute(
        path: '/river-conditions',
        builder: (context, state) => const AppShell(
          title: 'River Conditions',
          showBackButton: true,
          child: RiverConditionsPage(),
        ),
      ),
      
      // Trail Safety
      GoRoute(
        path: '/trail-safety',
        builder: (context, state) => const AppShell(
          title: 'Trail Safety',
          showBackButton: true,
          child: TrailSafetyPage(),
        ),
      ),
      
      // Interactive Map
      GoRoute(
        path: '/map',
        builder: (context, state) => const AppShell(
          title: 'Interactive Map',
          showBackButton: true,
          child: InteractiveMapPage(),
        ),
      ),
      
      // Safety Alerts
      GoRoute(
        path: '/alerts',
        builder: (context, state) => const AppShell(
          title: 'Safety Alerts',
          showBackButton: true,
          child: SafetyAlertsPage(),
        ),
      ),
      
      // Emergency Info
      GoRoute(
        path: '/emergency',
        builder: (context, state) => const AppShell(
          title: 'Emergency Info',
          showBackButton: true,
          child: EmergencyInfoPage(),
        ),
      ),
      
      // Life Jacket Locations
      GoRoute(
        path: '/life-jackets',
        builder: (context, state) => const AppShell(
          title: 'Life Jacket Locations',
          showBackButton: true,
          child: LifeJacketsPage(),
        ),
      ),
      
      // First Aid
      GoRoute(
        path: '/first-aid',
        builder: (context, state) => const AppShell(
          title: 'First Aid',
          showBackButton: true,
          child: FirstAidPage(),
        ),
      ),
      
      // About
      GoRoute(
        path: '/about',
        builder: (context, state) => const AppShell(
          title: 'About',
          showBackButton: true,
          child: AboutPage(),
        ),
      ),
      
      // Statistics
      GoRoute(
        path: '/statistics',
        builder: (context, state) => const AppShell(
          title: 'Statistics',
          showBackButton: true,
          child: StatisticsPage(),
        ),
      ),
      
      // Incident History
      GoRoute(
        path: '/incidents',
        builder: (context, state) => const AppShell(
          title: 'Incident History',
          showBackButton: true,
          child: IncidentHistoryPage(),
        ),
      ),
      
      // Safety Education
      GoRoute(
        path: '/education',
        builder: (context, state) => const AppShell(
          title: 'Safety Education',
          showBackButton: true,
          child: SafetyEducationPage(),
        ),
      ),
      
      // Volunteer
      GoRoute(
        path: '/volunteer',
        builder: (context, state) => const AppShell(
          title: 'Volunteer',
          showBackButton: true,
          child: VolunteerPage(),
        ),
      ),
      
      // Donate
      GoRoute(
        path: '/donate',
        builder: (context, state) => const AppShell(
          title: 'Donate',
          showBackButton: true,
          child: DonatePage(),
        ),
      ),
      
      // Report Issue
      GoRoute(
        path: '/report',
        builder: (context, state) => const AppShell(
          title: 'Report Issue',
          showBackButton: true,
          child: ReportIssuePage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const AppShell(
      title: 'Page Not Found',
      showBackButton: true,
      child: ErrorPage(),
    ),
  );
}

// Placeholder pages - these will be implemented later
class RiverConditionsPage extends StatelessWidget {
  const RiverConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.water_drop, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text('River Conditions Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class TrailSafetyPage extends StatelessWidget {
  const TrailSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bike, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text('Trail Safety Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class InteractiveMapPage extends StatelessWidget {
  const InteractiveMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text('Interactive Map Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class SafetyAlertsPage extends StatelessWidget {
  const SafetyAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Safety Alerts Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class EmergencyInfoPage extends StatelessWidget {
  const EmergencyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emergency, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Emergency Info Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class LifeJacketsPage extends StatelessWidget {
  const LifeJacketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.safety_divider, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text('Life Jacket Locations Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class FirstAidPage extends StatelessWidget {
  const FirstAidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('First Aid Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text('About Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 64, color: Colors.purple),
          SizedBox(height: 16),
          Text('Statistics Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class IncidentHistoryPage extends StatelessWidget {
  const IncidentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text('Incident History Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class SafetyEducationPage extends StatelessWidget {
  const SafetyEducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text('Safety Education Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.volunteer_activism, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text('Volunteer Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Donate Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text('Report Issue Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon...'),
        ],
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Page Not Found', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('The page you are looking for does not exist.'),
        ],
      ),
    );
  }
} 