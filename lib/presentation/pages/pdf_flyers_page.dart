import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:sacriversafety/domain/entities/pdf_flyer.dart';
import 'package:sacriversafety/data/models/flyers_data.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class PdfFlyersPage extends StatefulWidget {
  const PdfFlyersPage({super.key});

  @override
  State<PdfFlyersPage> createState() => _PdfFlyersPageState();
}

class _PdfFlyersPageState extends State<PdfFlyersPage> {
  FlyerCategory? _selectedCategory;
  String _searchQuery = '';
  bool _showOnlyOfficial = false;
  bool _showOnlyPrintable = false;
  bool _showTrailheadFlyers = false;
  Map<String, bool> _expandedPreviews = {};
  Map<String, Uint8List?> _pdfData = {};

  List<PdfFlyer> get _filteredFlyers {
    List<PdfFlyer> flyers = FlyersData.flyers;

    // Filter by category
    if (_selectedCategory != null) {
      flyers = flyers.where((flyer) => flyer.category == _selectedCategory).toList();
    }

    // Filter by official status
    if (_showOnlyOfficial) {
      flyers = flyers.where((flyer) => flyer.isOfficial).toList();
    }

    // Filter by printable status
    if (_showOnlyPrintable) {
      flyers = flyers.where((flyer) => flyer.isPrintable).toList();
    }

    // Filter by trailhead flyers
    if (_showTrailheadFlyers) {
      flyers = flyers.where((flyer) => 
        flyer.tags.contains('trailhead') || 
        flyer.tags.contains('signage') || 
        flyer.tags.contains('access points')
      ).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      flyers = flyers.where((flyer) {
        return flyer.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               flyer.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               flyer.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    return flyers;
  }

  @override
  Widget build(BuildContext context) {
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
                      Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safety Flyers & Documents',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Download and print safety flyers with QR codes for trailhead distribution',
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
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'All flyers include QR codes linking to the app for real-time safety information. Perfect for volunteers to print and distribute at trailheads and safety stations.',
                            style: TextStyle(
                              color: Colors.red[700],
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

          // Search and Filter
          _buildSearchAndFilter(),
          const SizedBox(height: 16),

          // Flyers List
          ..._filteredFlyers.map((flyer) => _buildFlyerCard(context, flyer)),
          
          // Empty state
          if (_filteredFlyers.isEmpty) _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search flyers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // Category Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip(null, 'All'),
                  const SizedBox(width: 8),
                  ...FlyerCategory.values.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildCategoryChip(category, category.name),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Filter Toggles
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _showOnlyOfficial,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyOfficial = value ?? false;
                          });
                        },
                      ),
                      const Text('Official only'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _showOnlyPrintable,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyPrintable = value ?? false;
                          });
                        },
                      ),
                      const Text('Printable only'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _showTrailheadFlyers,
                  onChanged: (value) {
                    setState(() {
                      _showTrailheadFlyers = value ?? false;
                    });
                  },
                ),
                const Text('Trailhead & signage flyers only'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(FlyerCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: category != null ? _getCategoryColor(category!).withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
      checkmarkColor: category != null ? _getCategoryColor(category!) : Colors.red,
    );
  }

  Color _getCategoryColor(FlyerCategory category) {
    switch (category) {
      case FlyerCategory.safety:
        return Colors.red;
      case FlyerCategory.education:
        return Colors.green;
      case FlyerCategory.emergency:
        return Colors.orange;
      case FlyerCategory.trails:
        return Colors.blue;
      case FlyerCategory.general:
        return Colors.grey;
    }
  }

    Widget _buildFlyerCard(BuildContext context, PdfFlyer flyer) {
    final isExpanded = _expandedPreviews[flyer.id] ?? false;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: flyer.isOfficial ? Colors.green : Colors.grey.shade300,
            width: flyer.isOfficial ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                flyer.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                            if (flyer.isPrintable)
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PRINT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          flyer.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Category and metadata
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: flyer.categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      flyer.categoryName,
                      style: TextStyle(
                        color: flyer.categoryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (flyer.author != null) ...[
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      flyer.author!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (flyer.datePublished != null) ...[
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      flyer.datePublished!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              
              // Tags
              if (flyer.tags.isNotEmpty) ...[
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
              ],
              
              // Preview Toggle Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _togglePreview(flyer.id),
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 16,
                      ),
                      label: Text(isExpanded ? 'Hide Preview' : 'Show Preview'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              
              // PDF Preview
              if (isExpanded) ...[
                const SizedBox(height: 12),
                _buildPdfPreview(flyer),
                const SizedBox(height: 12),
              ],
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadAndOpenPdf(flyer),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Download & Open'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (flyer.isPrintable)
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
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No flyers found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAndOpenPdf(PdfFlyer flyer) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = flyer.assetPath.split('/').last;
      final filePath = '${directory.path}/$fileName';

      // Check if file already exists
      final file = File(filePath);
      if (await file.exists()) {
        Navigator.pop(context); // Close loading dialog
        await _openPdfFile(filePath);
        return;
      }

      // Load the PDF from assets
      final ByteData data = await rootBundle.load(flyer.assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      // Write to file
      await file.writeAsBytes(bytes);

      Navigator.pop(context); // Close loading dialog

      // Open the PDF
      await _openPdfFile(filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${flyer.title} downloaded and opened successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading ${flyer.title}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openPdfFile(String filePath) async {
    try {
      await OpenFile.open(filePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
            Text('File: ${flyer.assetPath.split('/').last}'),
            if (flyer.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
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
              _downloadAndOpenPdf(flyer);
            },
            child: const Text('Download'),
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
              _downloadAndOpenPdf(flyer);
            },
            icon: const Icon(Icons.download),
            label: const Text('Download for Printing'),
          ),
        ],
      ),
    );
  }
} 