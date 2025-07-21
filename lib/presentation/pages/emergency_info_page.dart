import 'package:flutter/material.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class EmergencyInfoPage extends StatelessWidget {
  const EmergencyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyHeader(context),
            const SizedBox(height: 24),
            _buildEmergencyContacts(context),
            const SizedBox(height: 24),
            _buildEmergencyProcedures(context),
            const SizedBox(height: 24),
            _buildSafetyTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emergency,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Emergency Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Know what to do in case of emergency',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Emergency Contacts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              'Emergency Services',
              '911',
              Icons.emergency,
              Colors.red,
              () => _makePhoneCall('911'),
            ),
            _buildContactItem(
              context,
              'Sacramento Fire Department',
              '(916) 808-1300',
              Icons.local_fire_department,
              Colors.orange,
              () => _makePhoneCall('9168081300'),
            ),
            _buildContactItem(
              context,
              'Sacramento Police Department',
              '(916) 264-5471',
              Icons.local_police,
              Colors.blue,
              () => _makePhoneCall('9162645471'),
            ),
            _buildContactItem(
              context,
              'Sacramento County Parks',
              '(916) 875-6961',
              Icons.park,
              Colors.green,
              () => _makePhoneCall('9168756961'),
            ),
            _buildContactItem(
              context,
              'US Coast Guard',
              '(510) 437-3701',
              Icons.anchor,
              Colors.indigo,
              () => _makePhoneCall('5104373701'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String title,
    String phone,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title),
      subtitle: Text(phone),
      trailing: IconButton(
        icon: const Icon(Icons.phone),
        onPressed: onTap,
        color: AppTheme.primaryBlue,
      ),
      onTap: onTap,
    );
  }

  Widget _buildEmergencyProcedures(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Emergency Procedures',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProcedureStep(
              context,
              '1',
              'Assess the Situation',
              'Check if the person is conscious and breathing. Look for any immediate dangers.',
            ),
            _buildProcedureStep(
              context,
              '2',
              'Call for Help',
              'Dial 911 immediately. Provide your exact location and describe the emergency.',
            ),
            _buildProcedureStep(
              context,
              '3',
              'Provide First Aid',
              'If trained, provide appropriate first aid while waiting for emergency services.',
            ),
            _buildProcedureStep(
              context,
              '4',
              'Stay Calm',
              'Remain calm and reassure the victim. Keep them warm and comfortable.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcedureStep(
    BuildContext context,
    String step,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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

  Widget _buildSafetyTips(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.safety_divider, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Safety Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSafetyTip(
              context,
              'Always wear a life jacket when on the water',
              Icons.safety_divider,
            ),
            _buildSafetyTip(
              context,
              'Never swim alone',
              Icons.people,
            ),
            _buildSafetyTip(
              context,
              'Check weather conditions before going out',
              Icons.cloud,
            ),
            _buildSafetyTip(
              context,
              'Know your limits and stay within them',
              Icons.warning,
            ),
            _buildSafetyTip(
              context,
              'Keep emergency contacts readily available',
              Icons.contact_phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTip(
    BuildContext context,
    String tip,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // In a real app, this would use url_launcher to make phone calls
    // For now, just show a snackbar
    // Note: This would need to be called from within a build context
    print('Calling $phoneNumber...');
  }
} 