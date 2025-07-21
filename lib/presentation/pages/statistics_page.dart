import 'package:flutter/material.dart';
import 'package:sacriversafety/presentation/widgets/drowning_statistics_widget.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildDrowningStatistics(context),
          const SizedBox(height: 24),
          _buildDataSources(context),
          const SizedBox(height: 24),
          _buildSafetyTips(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              const Icon(Icons.analytics, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'River Safety Statistics',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Comprehensive drowning and safety data for the Sacramento region',
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
          Text(
            'This data is compiled from multiple authoritative sources including California Department of Public Health, Sacramento County Regional Parks, and emergency response agencies.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrowningStatistics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drowning Statistics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const DrowningStatisticsWidget(),
      ],
    );
  }

  Widget _buildDataSources(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.source, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Data Sources',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDataSourceItem(
              context,
              'California EPICenter (CDPH)',
              'Official California Department of Public Health drowning statistics for Sacramento County',
              'epicenter@cdph.ca.gov',
            ),
            const Divider(),
            _buildDataSourceItem(
              context,
              'Sacramento County Regional Parks',
              'Park incident reports and safety statistics',
              '(916) 875-6961',
            ),
            const Divider(),
            _buildDataSourceItem(
              context,
              'Sacramento Metropolitan Fire District',
              'River rescue statistics and incident reports',
              '(916) 859-4300',
            ),
            const Divider(),
            _buildDataSourceItem(
              context,
              'USACE Public Recreation Fatalities',
              'Federal recreation fatality statistics',
              'Public data',
            ),
            const Divider(),
            _buildDataSourceItem(
              context,
              'American Whitewater Accident Database',
              'Whitewater accidents and incidents on California rivers',
              'info@americanwhitewater.org',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSourceItem(BuildContext context, String title, String description, String contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Contact: $contact',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTips(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Safety Insights',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSafetyTipItem(
              context,
              'Life Jackets Save Lives',
              'Statistics show that wearing a life jacket significantly reduces the risk of drowning. Always wear a properly fitted life jacket when near or in the water.',
              Icons.safety_divider,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildSafetyTipItem(
              context,
              'Know Your Limits',
              'Most incidents occur when people overestimate their swimming abilities or underestimate river conditions. Stay within your comfort zone.',
              Icons.warning,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildSafetyTipItem(
              context,
              'Never Swim Alone',
              'Always have a buddy when swimming or engaging in water activities. Many rescues are successful because someone was there to help.',
              Icons.people,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildSafetyTipItem(
              context,
              'Check Conditions First',
              'Always check current river conditions, weather, and water levels before heading out. Conditions can change rapidly.',
              Icons.info,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTipItem(BuildContext context, String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 