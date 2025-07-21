import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sacriversafety/domain/entities/life_jacket_program.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class LifeJacketProgramsWidget extends StatelessWidget {
  final List<LifeJacketProgram> programs;

  const LifeJacketProgramsWidget({
    super.key,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    final activePrograms = programs.where((p) => p.status == ProgramStatus.active).toList();
    final folfanPrograms = programs.where((p) => p.source == 'FOLFAN').toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.safety_divider, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Life Jacket Programs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${activePrograms.length} Active',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // FOLFAN Highlight
            if (folfanPrograms.isNotEmpty) ...[
              _buildFolfanHighlight(context, folfanPrograms),
              const SizedBox(height: 16),
            ],

            // Programs List
            ...programs.map((program) => _buildProgramCard(context, program)),
          ],
        ),
      ),
    );
  }

  Widget _buildFolfanHighlight(BuildContext context, List<LifeJacketProgram> folfanPrograms) {
    final totalJackets = folfanPrograms.fold<int>(0, (sum, program) => sum + (program.totalJackets ?? 0));
    final availableJackets = folfanPrograms.fold<int>(0, (sum, program) => sum + (program.availableJackets ?? 0));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.volunteer_activism, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'FOLFAN Life Jacket Program',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'FREE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Friends of Lake Folsom and American River provides free life jacket loans at ${folfanPrograms.length} locations throughout the American River Parkway. No deposit required.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total Jackets', totalJackets.toString(), Icons.safety_divider),
              ),
              Expanded(
                child: _buildStatItem('Available', availableJackets.toString(), Icons.check_circle),
              ),
              Expanded(
                child: _buildStatItem('Locations', folfanPrograms.length.toString(), Icons.location_on),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchUrl('https://folfan.org/life-jackets-save-lives/'),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Learn More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.blue.shade600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildProgramCard(BuildContext context, LifeJacketProgram program) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: program.statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    program.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: program.statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    program.statusText,
                    style: TextStyle(
                      color: program.statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              program.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    program.location,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  program.hours ?? 'Hours not specified',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Sizes: ${program.sizeText}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (program.hasAvailability)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${program.availableJackets} Available',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: program.website != null ? () => _launchUrl(program.website!) : null,
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Website'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                if (program.contactInfo != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showContactInfo(context, program),
                      icon: const Icon(Icons.contact_phone, size: 16),
                      label: const Text('Contact'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle error silently for now
    }
  }

  void _showContactInfo(BuildContext context, LifeJacketProgram program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Program: ${program.name}'),
            const SizedBox(height: 8),
            Text('Organization: ${program.organization}'),
            const SizedBox(height: 8),
            Text('Contact: ${program.contactInfo}'),
            const SizedBox(height: 8),
            Text('Hours: ${program.hours}'),
            if (program.requirements != null) ...[
              const SizedBox(height: 8),
              Text('Requirements: ${program.requirements}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 