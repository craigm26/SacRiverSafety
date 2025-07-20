import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = false,
    this.actions,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
        actions: widget.actions,
      ),
      drawer: _buildDrawer(context),
      body: widget.child,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: _buildDrawerBody(context),
          ),
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue,
            AppTheme.secondaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.water,
              size: 40,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SacRiverSafety',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Stay Safe on Our Rivers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildDrawerSection(
          context,
          'Main Navigation',
          [
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Home',
              subtitle: 'Map & Safety Overview',
              onTap: () {
                context.go('/');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.water_drop,
              title: 'River Conditions',
              subtitle: 'Live water levels & safety',
              onTap: () {
                context.go('/river-conditions');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.directions_bike,
              title: 'Trail Safety',
              subtitle: 'Trail conditions & rules',
              onTap: () {
                context.go('/trail-safety');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.map,
              title: 'Interactive Map',
              subtitle: 'Full-screen map view',
              onTap: () {
                context.go('/map');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        _buildDrawerSection(
          context,
          'Safety Resources',
          [
            _buildDrawerItem(
              context,
              icon: Icons.warning,
              title: 'Safety Alerts',
              subtitle: 'Active warnings & closures',
              onTap: () {
                context.go('/alerts');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.emergency,
              title: 'Emergency Info',
              subtitle: 'Emergency contacts & procedures',
              onTap: () {
                context.go('/emergency');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.safety_divider,
              title: 'Life Jacket Locations',
              subtitle: 'Borrow-a-PFD stations',
              onTap: () {
                context.go('/life-jackets');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.medical_services,
              title: 'First Aid',
              subtitle: 'First aid information',
              onTap: () {
                context.go('/first-aid');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        _buildDrawerSection(
          context,
          'Information',
          [
            _buildDrawerItem(
              context,
              icon: Icons.info,
              title: 'About',
              subtitle: 'About sacriversafety',
              onTap: () {
                context.go('/about');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.analytics,
              title: 'Statistics',
              subtitle: 'Drowning statistics & data',
              onTap: () {
                context.go('/statistics');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.history,
              title: 'Incident History',
              subtitle: 'Past incidents & reports',
              onTap: () {
                context.go('/incidents');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.school,
              title: 'Safety Education',
              subtitle: 'Learn about river safety',
              onTap: () {
                context.go('/education');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        _buildDrawerSection(
          context,
          'Community',
          [
            _buildDrawerItem(
              context,
              icon: Icons.volunteer_activism,
              title: 'Volunteer',
              subtitle: 'Get involved in safety',
              onTap: () {
                context.go('/volunteer');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.favorite,
              title: 'Donate',
              subtitle: 'Support river safety',
              onTap: () {
                context.go('/donate');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.report,
              title: 'Report Issue',
              subtitle: 'Report safety concerns',
              onTap: () {
                context.go('/report');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawerSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppTheme.primaryBlue,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                size: 20,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.help,
                size: 20,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Help & Support',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
} 