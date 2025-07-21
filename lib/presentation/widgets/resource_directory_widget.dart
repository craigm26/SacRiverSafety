import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sacriversafety/domain/entities/resource_directory.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class ResourceDirectoryWidget extends StatefulWidget {
  final List<ResourceDirectory> resources;

  const ResourceDirectoryWidget({
    super.key,
    required this.resources,
  });

  @override
  State<ResourceDirectoryWidget> createState() => _ResourceDirectoryWidgetState();
}

class _ResourceDirectoryWidgetState extends State<ResourceDirectoryWidget> {
  ResourceCategory? _selectedCategory;
  String _searchQuery = '';

  List<ResourceDirectory> get _filteredResources {
    return widget.resources.where((resource) {
      final matchesCategory = _selectedCategory == null || resource.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          resource.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resource.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resource.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.library_books, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Resource Directory',
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
                    '${widget.resources.length} Sources',
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

            // Search and Filter
            _buildSearchAndFilter(),
            const SizedBox(height: 16),

            // Resources List
            ..._filteredResources.map((resource) => _buildResourceCard(context, resource)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        // Search Bar
        TextField(
          decoration: InputDecoration(
            hintText: 'Search resources...',
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
              ...ResourceCategory.values.map((category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryChip(category, category.name),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(ResourceCategory? category, String label) {
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
      selectedColor: category != null ? _getCategoryColor(category!).withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
      checkmarkColor: category != null ? _getCategoryColor(category!) : Colors.blue,
    );
  }

  Color _getCategoryColor(ResourceCategory category) {
    switch (category) {
      case ResourceCategory.safety:
        return Colors.red;
      case ResourceCategory.data:
        return Colors.blue;
      case ResourceCategory.education:
        return Colors.green;
      case ResourceCategory.emergency:
        return Colors.orange;
      case ResourceCategory.recreation:
        return Colors.purple;
      case ResourceCategory.government:
        return Colors.indigo;
      case ResourceCategory.nonprofit:
        return Colors.teal;
    }
  }

  Widget _buildResourceCard(BuildContext context, ResourceDirectory resource) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: resource.isOfficial ? Colors.green : Colors.grey.shade300,
          width: resource.isOfficial ? 2 : 1,
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
                    resource.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (resource.isOfficial)
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
            const SizedBox(height: 4),
            Text(
              resource.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: resource.categoryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    resource.categoryName,
                    style: TextStyle(
                      color: resource.categoryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    resource.typeName,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: resource.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _launchUrl(resource.url),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Visit Website'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                if (resource.contactInfo != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showContactInfo(context, resource),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  void _showContactInfo(BuildContext context, ResourceDirectory resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resource: ${resource.name}'),
            const SizedBox(height: 8),
            Text('Contact: ${resource.contactInfo}'),
            if (resource.dataSource != null) ...[
              const SizedBox(height: 8),
              Text('Data Source: ${resource.dataSource}'),
            ],
            if (resource.lastUpdated != null) ...[
              const SizedBox(height: 8),
              Text('Last Updated: ${resource.lastUpdated}'),
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