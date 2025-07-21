import 'package:flutter/material.dart';
import 'package:sacriversafety/domain/entities/trail_data.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class TrailSegmentsWidget extends StatefulWidget {
  final List<TrailSegment> trailSegments;

  const TrailSegmentsWidget({
    super.key,
    required this.trailSegments,
  });

  @override
  State<TrailSegmentsWidget> createState() => _TrailSegmentsWidgetState();
}

class _TrailSegmentsWidgetState extends State<TrailSegmentsWidget> {
  String _selectedArea = 'All Areas';
  String _selectedType = 'All Types';
  String _searchQuery = '';

  List<String> get areas {
    final areas = widget.trailSegments.map((segment) => segment.area).toSet().toList();
    areas.sort();
    return ['All Areas', ...areas];
  }

  List<String> get types {
    final types = widget.trailSegments.map((segment) => segment.typeText).toSet().toList();
    types.sort();
    return ['All Types', ...types];
  }

  List<TrailSegment> get filteredSegments {
    return widget.trailSegments.where((segment) {
      final matchesArea = _selectedArea == 'All Areas' || segment.area == _selectedArea;
      final matchesType = _selectedType == 'All Types' || segment.typeText == _selectedType;
      final matchesSearch = _searchQuery.isEmpty ||
          segment.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          segment.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesArea && matchesType && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.directions_bike, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FOLFAN Trail Network',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.trailSegments.length} trails across 100+ miles',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search and Filters
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search trails...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              
              // Filter Chips
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedArea,
                      decoration: InputDecoration(
                        labelText: 'Area',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: areas.map((area) => DropdownMenuItem(
                        value: area,
                        child: Text(area),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedArea = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: types.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedType = value!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Trail Segments List
        Expanded(
          child: filteredSegments.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No trails found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'Try adjusting your search or filters',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredSegments.length,
                  itemBuilder: (context, index) {
                    final segment = filteredSegments[index];
                    return _buildTrailSegmentCard(context, segment);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTrailSegmentCard(BuildContext context, TrailSegment segment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: segment.typeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            segment.typeIcon,
            color: segment.typeColor,
            size: 20,
          ),
        ),
        title: Text(
          segment.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              segment.area,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: segment.typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    segment.typeText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: segment.typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (segment.isAccessible) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Accessible',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                
                // Trail Details
                _buildDetailRow('Start Point', segment.startPoint, Icons.trip_origin),
                _buildDetailRow('End Point', segment.endPoint, Icons.place),
                _buildDetailRow('Access', segment.accessText, Icons.people),
                
                if (segment.notes != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow('Notes', segment.notes!, Icons.info_outline),
                ],
                
                const SizedBox(height: 12),
                
                // Trail Coordinates (simplified)
                if (segment.coordinates.isNotEmpty) ...[
                  Text(
                    'Trail Coordinates',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        '${segment.coordinates.length} waypoints',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 