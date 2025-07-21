import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/presentation/widgets/language_selector.dart';
import 'package:sacriversafety/core/services/language_service.dart';

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
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await LanguageService.getCurrentLanguage();
    setState(() {
      _currentLanguage = language;
    });
  }

  void _onLanguageChanged(String languageCode) async {
    try {
      await LanguageService.setLanguage(languageCode);
      setState(() {
        _currentLanguage = languageCode;
      });
      // TODO: Implement actual language change logic
      // This would typically involve:
      // 1. Updating the app's locale
      // 2. Reloading the UI with new translations
      print('Language changed to: $languageCode');
    } catch (e) {
      print('Error changing language: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.showBackButton) {
          // If we're on a page with back button, handle navigation
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.go('/');
          }
          return false; // Prevent default back behavior
        }
        return true; // Allow default back behavior for home page
      },
      child: Scaffold(
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
                onPressed: () {
                  // Try to pop first, if not possible, go to home
                  try {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      context.go('/');
                    }
                  } catch (e) {
                    // Fallback to home if navigation fails
                    context.go('/');
                  }
                },
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
        actions: [
          // Language selector
          LanguageSelector(
            currentLanguage: _currentLanguage,
            onLanguageChanged: _onLanguageChanged,
          ),
          // Additional actions
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
      drawer: _buildDrawer(context),
        body: widget.child,
      ),
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
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'Sac River Safety',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Stay Safe on Our Rivers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryBlue,
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
                context.go('/trail');
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
              subtitle: 'About SacRiverSafety',
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
              icon: Icons.library_books,
              title: 'Resource Directory',
              subtitle: 'Official resources & data sources',
              onTap: () {
                context.go('/resources');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.picture_as_pdf,
              title: 'Safety Flyers',
              subtitle: 'Download safety documents & guides',
              onTap: () {
                context.go('/flyers');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.volunteer_activism,
              title: 'Volunteer Resources',
              subtitle: 'Tools for safety outreach & distribution',
              onTap: () {
                context.go('/volunteer-resources');
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
                context.go('/safety-education');
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
        // Language selector in drawer
        DrawerLanguageSelector(
          currentLanguage: _currentLanguage,
          onLanguageChanged: _onLanguageChanged,
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