import 'package:flutter/material.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildMissionSection(context),
            const SizedBox(height: 24),
            _buildFeaturesSection(context),
            const SizedBox(height: 24),
            _buildTeamSection(context),
            const SizedBox(height: 24),
            _buildGitHubContributionsSection(context),
            const SizedBox(height: 24),
            _buildContactSection(context),
          ],
        ),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.water_drop,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'About Sac River Safety',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your safety companion for the Sacramento region',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Our Mission',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Sac River Safety is dedicated to promoting water safety and preventing drowning incidents in the Sacramento region. We provide real-time information about river conditions, safety alerts, and educational resources to help keep our community safe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Key Features',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              'Real-time River Conditions',
              'Live water levels and flow rates from USGS monitoring stations',
              Icons.water_drop,
            ),
            _buildFeatureItem(
              context,
              'Safety Alerts',
              'Instant notifications about dangerous conditions and closures',
              Icons.warning,
            ),
            _buildFeatureItem(
              context,
              'Interactive Maps',
              'Detailed maps showing river access points and safety information',
              Icons.map,
            ),
            _buildFeatureItem(
              context,
              'Safety Education',
              'Comprehensive resources for water safety and first aid',
              Icons.school,
            ),
            _buildFeatureItem(
              context,
              'Emergency Information',
              'Quick access to emergency contacts and procedures',
              Icons.emergency,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Our Team',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Sac River Safety is developed and maintained by Craig Merry and a growing community of GitHub contributors who are committed to water safety in the Sacramento region.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'We work closely with local emergency services, park rangers, and safety organizations to ensure accurate and timely information. Our open-source approach allows the community to actively participate in improving water safety for everyone.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGitHubContributionsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'GitHub Contributions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Sac River Safety is an open-source project hosted on GitHub. We welcome contributions from developers, safety experts, and community members who share our mission of promoting water safety.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildContributionItem(
              context,
              'Report Issues',
              'Found a bug or have a feature request? Open an issue on GitHub to help us improve the app.',
              Icons.bug_report,
              'https://github.com/craigm26/SacRiverSafety/issues',
            ),
            _buildContributionItem(
              context,
              'Join Discussions',
              'Participate in community discussions about new features, safety improvements, and project direction.',
              Icons.forum,
              'https://github.com/craigm26/SacRiverSafety/discussions',
            ),
            _buildContributionItem(
              context,
              'Code Contributions',
              'Submit pull requests to add new features, fix bugs, or improve existing functionality.',
              Icons.merge,
              'https://github.com/craigm26/SacRiverSafety/pulls',
            ),
            _buildContributionItem(
              context,
              'Documentation',
              'Help improve our documentation, guides, and educational resources.',
              Icons.description,
              'https://github.com/craigm26/SacRiverSafety',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: AppTheme.primaryBlue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Visit our GitHub repository to get started with contributing!',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildContributionItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String url,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.primaryBlue, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.open_in_new,
                          color: AppTheme.primaryBlue,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_mail, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              'Email',
              'craig@craigmerry.com',
              Icons.email,
              'mailto:craig@craigmerry.com',
            ),
            _buildContactItem(
              context,
              'Website',
              'www.sacriversafety.org',
              Icons.language,
              'https://www.sacriversafety.org',
            ),
            _buildContactItem(
              context,
              'GitHub',
              'github.com/craigm26/SacRiverSafety',
              Icons.code,
              'https://github.com/craigm26/SacRiverSafety',
            ),
            _buildContactItem(
              context,
              'Emergency',
              '911',
              Icons.emergency,
              'tel:911',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    String? url,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: url != null ? () => _launchURL(url) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (url != null) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.open_in_new,
                            color: AppTheme.primaryBlue,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 