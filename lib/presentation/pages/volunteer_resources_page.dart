import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';
import 'package:sacriversafety/domain/entities/pdf_flyer.dart';
import 'package:sacriversafety/data/models/flyers_data.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class VolunteerResourcesPage extends StatefulWidget {
  const VolunteerResourcesPage({super.key});

  @override
  State<VolunteerResourcesPage> createState() => _VolunteerResourcesPageState();
}

class _VolunteerResourcesPageState extends State<VolunteerResourcesPage> {
  Map<String, bool> _expandedPreviews = {};
  Map<String, Uint8List?> _pdfData = {};

  @override
  Widget build(BuildContext context) {
    final trailheadFlyers = FlyersData.getTrailheadFlyers();
    final volunteerResources = FlyersData.getVolunteerResources();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.volunteer_activism, color: Colors.green, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Volunteer Resources',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Tools and materials for safety outreach and education',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Thank you for helping promote river safety! Download and print these materials to distribute at trailheads, access points, and safety stations.',
                            style: TextStyle(
                              color: Colors.green[700],
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
          ),
          const SizedBox(height: 16),

          // Trailhead Distribution Section
          _buildSection(
            context,
            'Trailhead & Signage Flyers',
            'Essential safety information for trailheads, access points, and park signage',
            Icons.location_on,
            Colors.blue,
            trailheadFlyers,
          ),
          const SizedBox(height: 16),

          // Volunteer Resources Section
          _buildSection(
            context,
            'Volunteer Materials',
            'Resources to help volunteers with safety outreach and education',
            Icons.volunteer_activism,
            Colors.green,
            volunteerResources,
          ),
          const SizedBox(height: 16),

          // Distribution Guidelines
          _buildDistributionGuidelines(context),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    List<PdfFlyer> flyers,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...flyers.map((flyer) => _buildFlyerItem(context, flyer)),
          ],
        ),
      ),
    );
  }

  Widget _buildFlyerItem(BuildContext context, PdfFlyer flyer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  flyer.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (flyer.isOfficial)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'OFFICIAL',
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
            flyer.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: flyer.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 10,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
          
          // Preview Toggle Button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _togglePreview(flyer.id),
                  icon: Icon(
                    (_expandedPreviews[flyer.id] ?? false) ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                  ),
                  label: Text((_expandedPreviews[flyer.id] ?? false) ? 'Hide Preview' : 'Show Preview'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          
          // PDF Preview
          if (_expandedPreviews[flyer.id] ?? false) ...[
            const SizedBox(height: 12),
            _buildPdfPreview(flyer),
            const SizedBox(height: 12),
          ],
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showPrintInstructions(context, flyer),
                  icon: const Icon(Icons.print, size: 16),
                  label: const Text('Print Guide'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _showFlyerDetails(context, flyer),
                icon: const Icon(Icons.info_outline),
                tooltip: 'View Details',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionGuidelines(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: Colors.orange, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Distribution Guidelines',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGuidelineItem(
              'Printing',
              [
                'Use standard 8.5" x 11" paper',
                'Print in color for best QR code readability',
                'Print multiple copies for distribution',
                'Consider laminating for outdoor use',
              ],
            ),
            const SizedBox(height: 16),
            _buildGuidelineItem(
              'Distribution Locations',
              [
                'Trailhead kiosks and bulletin boards',
                'Park signage and information boards',
                'River access points and boat launches',
                'Safety stations and emergency call boxes',
                'Visitor centers and ranger stations',
                'PFD loan stations and equipment areas',
              ],
            ),
            const SizedBox(height: 16),
            _buildGuidelineItem(
              'QR Code Benefits',
              [
                'Links to real-time safety information',
                'Provides current river conditions',
                'Access to emergency contacts',
                'Educational videos and content',
                'Interactive maps and resources',
              ],
            ),
            const SizedBox(height: 16),
            _buildGuidelineItem(
              'Volunteer Tips',
              [
                'Engage with visitors about safety',
                'Point out QR codes on flyers',
                'Share personal safety experiences',
                'Report safety concerns to authorities',
                'Stay updated on current conditions',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: Colors.grey[600])),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  void _showPrintInstructions(BuildContext context, PdfFlyer flyer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.print, color: Colors.blue),
            const SizedBox(width: 8),
            Text('Print Instructions'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Printing Guidelines for Volunteers:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('• Print on standard 8.5" x 11" paper'),
            Text('• Use color printing for best QR code readability'),
            Text('• Print multiple copies for distribution'),
            Text('• Laminating recommended for outdoor use'),
            const SizedBox(height: 12),
            Text(
              'Distribution Locations:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (flyer.tags.contains('trailhead'))
              Text('• Trailhead kiosks and bulletin boards'),
            if (flyer.tags.contains('signage'))
              Text('• Park signage and information boards'),
            if (flyer.tags.contains('access points'))
              Text('• River access points and boat launches'),
            if (flyer.tags.contains('safety stations'))
              Text('• Safety stations and emergency call boxes'),
            if (flyer.tags.contains('visitor centers'))
              Text('• Visitor centers and ranger stations'),
            if (flyer.tags.contains('stations'))
              Text('• PFD loan stations and safety equipment areas'),
            const SizedBox(height: 12),
            Text(
              'QR Code Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('• QR code links to real-time safety information'),
            Text('• Users can access current river conditions'),
            Text('• Provides emergency contact information'),
            Text('• Links to safety videos and educational content'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to PDF flyers page with this flyer selected
              Navigator.pushNamed(context, '/flyers');
            },
            icon: const Icon(Icons.download),
            label: const Text('Download for Printing'),
          ),
        ],
      ),
    );
  }

  void _togglePreview(String flyerId) {
    setState(() {
      _expandedPreviews[flyerId] = !(_expandedPreviews[flyerId] ?? false);
    });
  }

  Widget _buildPdfPreview(PdfFlyer flyer) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _pdfData[flyer.id] != null
            ? SfPdfViewer.memory(
                _pdfData[flyer.id]!,
                enableDoubleTapZooming: true,
                enableTextSelection: false,
                canShowScrollHead: false,
                canShowScrollStatus: false,
                canShowPaginationDialog: false,
                pageSpacing: 0,
                pageLayoutMode: PdfPageLayoutMode.single,
                initialZoomLevel: 0.8,
              )
            : FutureBuilder<Uint8List>(
                future: _loadPdfData(flyer.assetPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading preview...'),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading preview',
                            style: TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to download the full PDF',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // Cache the PDF data
                    _pdfData[flyer.id] = snapshot.data!;
                    return SfPdfViewer.memory(
                      snapshot.data!,
                      enableDoubleTapZooming: true,
                      enableTextSelection: false,
                      canShowScrollHead: false,
                      canShowScrollStatus: false,
                      canShowPaginationDialog: false,
                      pageSpacing: 0,
                      pageLayoutMode: PdfPageLayoutMode.single,
                      initialZoomLevel: 0.8,
                    );
                  } else {
                    return const Center(
                      child: Text('No preview available'),
                    );
                  }
                },
              ),
      ),
    );
  }

  Future<Uint8List> _loadPdfData(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (e) {
      throw Exception('Failed to load PDF: $e');
    }
  }

  void _showFlyerDetails(BuildContext context, PdfFlyer flyer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(flyer.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(flyer.description),
            const SizedBox(height: 16),
            if (flyer.author != null) ...[
              Text('Author: ${flyer.author}'),
              const SizedBox(height: 8),
            ],
            if (flyer.datePublished != null) ...[
              Text('Published: ${flyer.datePublished}'),
              const SizedBox(height: 8),
            ],
            if (flyer.version != null) ...[
              Text('Version: ${flyer.version}'),
              const SizedBox(height: 8),
            ],
            Text('Category: ${flyer.categoryName}'),
            const SizedBox(height: 8),
            if (flyer.tags.isNotEmpty) ...[
              Text('Tags: ${flyer.tags.join(', ')}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/flyers');
            },
            child: const Text('View in Flyers'),
          ),
        ],
      ),
    );
  }
} 