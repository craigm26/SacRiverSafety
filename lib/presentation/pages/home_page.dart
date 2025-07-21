import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/presentation/cubits/home_cubit.dart';
import 'package:sacriversafety/core/router/navigation_utils.dart';
import 'package:sacriversafety/data/services/drowning_statistics_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Logger _logger = Logger();
  late Future<YearlyStatistics> _currentYearStats;

  @override
  void initState() {
    super.initState();
    _logger.i('HomePage: initState called');
    _loadCurrentYearStats();
  }

  void _loadCurrentYearStats() {
    final service = DrowningStatisticsService();
    _currentYearStats = service.getCurrentYearStatistics();
  }

  @override
  Widget build(BuildContext context) {
    // Remove debug logging to reduce console spam
    // _logger.d('HomePage: build method called');
    
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Remove debug logging to reduce console spam
        // _logger.d('HomePage: BlocBuilder called with state: ${state.runtimeType}');
        
        if (state is HomeInitial || state is HomeLoading) {
          _logger.i('HomePage: Showing loading state');
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading safety data...'),
              ],
            ),
          );
        }
        
        if (state is HomeError) {
          _logger.e('HomePage: Showing error state: ${state.message}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<HomeCubit>().loadHomeData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is HomeLoaded) {
          return _buildDashboard(context, state);
        }
        
        _logger.w('HomePage: Unknown state type: ${state.runtimeType}');
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Unknown state...'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboard(BuildContext context, HomeLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, state),
          const SizedBox(height: 12),
          
          // Quick Actions Grid
          _buildQuickActionsGrid(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sac River Safety',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your safety companion for the American Rivers and Sacramento River in the Sacramento Region',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Live 2025 statistics
              _buildLive2025Stats(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLive2025Stats(BuildContext context) {
    return FutureBuilder<YearlyStatistics>(
      future: _currentYearStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Expanded(
            child: _buildStatCard(
              context, 
              'N/A', 
              '2025 Deaths', 
              onTap: () => NavigationUtils.goToStatistics(context),
            ),
          );
        }

        final stats = snapshot.data!;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  '${stats.fatalIncidents}',
                  '2025 Deaths',
                  onTap: () => _showStatDetails(context, 'Fatal Incidents', stats.fatalIncidents, stats.source),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  '${stats.totalIncidents}',
                  'Total Incidents',
                  onTap: () => _showStatDetails(context, 'Total Incidents', stats.totalIncidents, stats.source),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  '${stats.rescues}',
                  'Rescues',
                  onTap: () => _showStatDetails(context, 'Rescues', stats.rescues, stats.source),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatDetails(BuildContext context, String statType, int value, String source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(statType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Value: $value'),
            const SizedBox(height: 8),
            Text('Source: $source'),
            const SizedBox(height: 16),
            _buildStatDefinition(statType),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                NavigationUtils.goToStatistics(context);
              },
              child: const Text('View Full Statistics'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDefinition(String statType) {
    switch (statType) {
      case 'Fatal Incidents':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Definition:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Drowning incidents resulting in death within the Sacramento region (American River, Sacramento River, and tributaries).'),
            SizedBox(height: 8),
            Text('Sources:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• California Department of Public Health EPICenter\n• Sacramento County Regional Parks\n• Sacramento Metropolitan Fire District\n• USACE Public Recreation Fatalities'),
          ],
        );
      case 'Total Incidents':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Definition:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('All water-related incidents requiring emergency response, including fatal drownings, non-fatal incidents, and near-misses.'),
            SizedBox(height: 8),
            Text('Sources:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Emergency response agencies\n• Park ranger reports\n• 911 call data\n• Public incident reports'),
          ],
        );
      case 'Rescues':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Definition:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Successful emergency interventions that prevented drowning or serious injury, including water rescues and medical assistance.'),
            SizedBox(height: 8),
            Text('Sources:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Fire department rescue logs\n• Emergency medical services\n• Park ranger interventions\n• Good Samaritan reports'),
          ],
        );
      default:
        return const Text('Definition not available');
    }
  }

  Widget _buildStatCard(BuildContext context, String value, String label, {VoidCallback? onTap}) {
    Widget cardContent = Column(
      children: [
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: cardContent,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: cardContent,
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              context,
              'Interactive Map',
              Icons.map,
              Colors.blue,
              () => NavigationUtils.goToMap(context),
            ),
            _buildActionCard(
              context,
              'River Conditions',
              Icons.water_drop,
              Colors.cyan,
              () => NavigationUtils.goToRiverConditions(context),
            ),
            _buildActionCard(
              context,
              'Trail Safety',
              Icons.directions_bike,
              Colors.green,
              () => NavigationUtils.goToTrailSafety(context),
            ),
            _buildActionCard(
              context,
              'Safety Education',
              Icons.school,
              Colors.purple,
              () => NavigationUtils.goToSafetyEducation(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(height: 2),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 