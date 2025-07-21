import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacriversafety/presentation/cubits/safety_education_cubit.dart';
import 'package:sacriversafety/presentation/widgets/youtube_video_player.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class SafetyEducationPage extends StatefulWidget {
  const SafetyEducationPage({super.key});

  @override
  State<SafetyEducationPage> createState() => _SafetyEducationPageState();
}

class _SafetyEducationPageState extends State<SafetyEducationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedAudience = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<SafetyEducationCubit>().loadFeaturedVideos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilters(),
          _buildTabBar(),
          Expanded(
            child: _buildTabBarView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safety Education',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Learn about river safety and drowning prevention',
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Watch these videos to understand river dangers and stay safe',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search safety videos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<SafetyEducationCubit>().loadAllVideos();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onSubmitted: (query) {
              if (query.trim().isNotEmpty) {
                context.read<SafetyEducationCubit>().searchVideos(query);
              }
            },
          ),
          const SizedBox(height: 12),
          // Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'Category',
                  _selectedCategory,
                  ['All', 'River Currents', 'Cold Water Safety', 'Safety Rules', 'Child Safety', 'Safety Tips', 'River Safety', 'Risk Awareness', 'Water Quality'],
                  (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                    if (value == 'All') {
                      context.read<SafetyEducationCubit>().loadAllVideos();
                    } else {
                      context.read<SafetyEducationCubit>().loadVideosByCategory(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  'Audience',
                  _selectedAudience,
                  ['All', 'All Ages', 'Teens and Adults', 'Parents and Caregivers', 'Adults'],
                  (value) {
                    setState(() {
                      _selectedAudience = value;
                    });
                    if (value == 'All') {
                      context.read<SafetyEducationCubit>().loadAllVideos();
                    } else {
                      context.read<SafetyEducationCubit>().loadVideosByAudience(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryBlue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppTheme.primaryBlue,
        tabs: const [
          Tab(text: 'Featured'),
          Tab(text: 'All Videos'),
          Tab(text: 'Categories'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildFeaturedVideos(),
        _buildAllVideos(),
        _buildCategoriesView(),
      ],
    );
  }

  Widget _buildFeaturedVideos() {
    return BlocBuilder<SafetyEducationCubit, SafetyEducationState>(
      builder: (context, state) {
        if (state is SafetyEducationLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SafetyEducationError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<SafetyEducationCubit>().loadFeaturedVideos(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is SafetyEducationLoaded) {
          return _buildVideoList(state.videos, 'Featured Safety Videos');
        }
        
        return const Center(child: Text('No videos available'));
      },
    );
  }

  Widget _buildAllVideos() {
    return BlocBuilder<SafetyEducationCubit, SafetyEducationState>(
      builder: (context, state) {
        if (state is SafetyEducationLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SafetyEducationError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<SafetyEducationCubit>().loadAllVideos(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is SafetyEducationLoaded) {
          return _buildVideoList(state.videos, 'All Safety Videos');
        }
        
        return const Center(child: Text('No videos available'));
      },
    );
  }

  Widget _buildCategoriesView() {
    return BlocBuilder<SafetyEducationCubit, SafetyEducationState>(
      builder: (context, state) {
        if (state is SafetyEducationLoaded) {
          final categories = context.read<SafetyEducationCubit>().getAvailableCategories();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    _getCategoryIcon(category),
                    color: _getCategoryColor(category),
                    size: 32,
                  ),
                  title: Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Tap to view videos in this category'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.read<SafetyEducationCubit>().loadVideosByCategory(category);
                    _tabController.animateTo(1); // Switch to All Videos tab
                  },
                ),
              );
            },
          );
        }
        
        return const Center(child: Text('No categories available'));
      },
    );
  }

  Widget _buildVideoList(List videos, String title) {
    if (videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_library, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No videos found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return YouTubeVideoCard(
                video: video,
                enableInAppPlayback: true,
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'river currents':
        return Icons.water;
      case 'cold water safety':
        return Icons.ac_unit;
      case 'safety rules':
        return Icons.rule;
      case 'child safety':
        return Icons.child_care;
      case 'safety tips':
        return Icons.lightbulb;
      case 'river safety':
        return Icons.safety_divider;
      case 'risk awareness':
        return Icons.warning;
      case 'water quality':
        return Icons.water_drop;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'river currents':
        return Colors.blue;
      case 'cold water safety':
        return Colors.cyan;
      case 'safety rules':
        return Colors.green;
      case 'child safety':
        return Colors.orange;
      case 'safety tips':
        return Colors.purple;
      case 'river safety':
        return Colors.indigo;
      case 'risk awareness':
        return Colors.red;
      case 'water quality':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }




} 