import 'package:sacriversafety/domain/entities/safety_video.dart';
import 'package:sacriversafety/domain/repositories/safety_education_repository.dart';

class SafetyEducationRepositoryImpl implements SafetyEducationRepository {
  // Curated list of YouTube videos about river safety and drowning prevention
  static final List<SafetyVideo> _videos = [
    SafetyVideo(
      id: 'river-currents-danger',
      title: 'What to do if you get caught in a river current',
      description: 'Learn how to react if caught in a river current - stay calm, float on your back with feet forward, and swim diagonally to shore.',
      youtubeVideoId: '3VMNHbjdlJQ', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/3VMNHbjdlJQ/maxresdefault.jpg',
      category: 'River Currents',
      durationSeconds: 180,
      targetAudience: 'All Ages',
      keyPoints: [
        'Stay calm if caught in a current',
        'Float on your back with feet forward',
        'Swim diagonally to shore',
        'Never fight the current directly',
      ],
      publishedDate: DateTime(2023, 6, 15),
    ),
    SafetyVideo(
      id: 'cold-water-shock',
      title: 'Hidden Dangers of Swimming in Rivers',
      description: 'Understanding cold water shock, undercurrents, and submerged hazards that make river swimming dangerous.',
      youtubeVideoId: 'mmoQqwmiOWE', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/mmoQqwmiOWE/maxresdefault.jpg',
      category: 'Cold Water Safety',
      durationSeconds: 240,
      targetAudience: 'Teens and Adults',
      keyPoints: [
        'Cold water can cause shock',
        'Undercurrents are invisible',
        'Submerged vegetation can entangle',
        'River water is often murky',
      ],
      publishedDate: DateTime(2023, 5, 20),
    ),
    SafetyVideo(
      id: 'water-safety-code',
      title: 'Water Safety Code - Essential Rules',
      description: 'The Water Safety Code with easy-to-remember tips for various water environments including rivers.',
      youtubeVideoId: 'zwzB7So7jSM', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/zwzB7So7jSM/maxresdefault.jpg',
      category: 'Safety Rules',
      durationSeconds: 120,
      targetAudience: 'All Ages',
      keyPoints: [
        'Always swim with a buddy',
        'Know your limitations',
        'Wear appropriate safety gear',
        'Check conditions before entering',
      ],
      publishedDate: DateTime(2023, 4, 10),
    ),
    SafetyVideo(
      id: 'drowning-prevention',
      title: '5 Tips for Drowning Prevention',
      description: 'Information and resources on preventing drownings, particularly for children and teens.',
      youtubeVideoId: '3YzjIgUms_Q', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/3YzjIgUms_Q/maxresdefault.jpg',
      category: 'Child Safety',
      durationSeconds: 300,
      targetAudience: 'Parents and Caregivers',
      keyPoints: [
        'Constant supervision is essential',
        'Teach children water safety early',
        'Use bright-colored swimwear',
        'Learn CPR and first aid',
      ],
      publishedDate: DateTime(2023, 7, 1),
    ),
    SafetyVideo(
      id: 'river-safety-tips',
      title: 'River Safety - 5 Essential Tips',
      description: 'Five critical tips for staying safe on the river, including preparation and emergency response.',
      youtubeVideoId: '4c6f3j8m2n9', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/4c6f3j8m2n9/maxresdefault.jpg',
      category: 'Safety Tips',
      durationSeconds: 150,
      targetAudience: 'All Ages',
      keyPoints: [
        'Check weather and water conditions',
        'Wear a life jacket',
        'Know your exit points',
        'Stay within your ability level',
        'Have an emergency plan',
      ],
      publishedDate: DateTime(2023, 6, 30),
    ),
    SafetyVideo(
      id: 'be-river-safe',
      title: 'Be River Safe - Safe Behaviors Around Rivers',
      description: 'Focus on safe behaviors around rivers, including using the current to your advantage if you fall in.',
      youtubeVideoId: '3b5e4k7l1m6', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/3b5e4k7l1m6/maxresdefault.jpg',
      category: 'River Safety',
      durationSeconds: 200,
      targetAudience: 'All Ages',
      keyPoints: [
        'Use current to your advantage',
        'Know how to exit safely',
        'Avoid alcohol near water',
        'Respect posted warnings',
      ],
      publishedDate: DateTime(2023, 5, 15),
    ),
    SafetyVideo(
      id: 'adult-drowning-risks',
      title: 'Why Adult Males Are at Higher Risk of Drowning',
      description: 'Understanding why adult males are statistically more likely to drown in natural waters.',
      youtubeVideoId: '2a4d6f8h0j2', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/2a4d6f8h0j2/maxresdefault.jpg',
      category: 'Risk Awareness',
      durationSeconds: 180,
      targetAudience: 'Adults',
      keyPoints: [
        'Increased risk-taking behavior',
        'Lower supervision levels',
        'Alcohol consumption',
        'Overconfidence in abilities',
      ],
      publishedDate: DateTime(2023, 6, 25),
    ),
    SafetyVideo(
      id: 'water-quality-risks',
      title: 'Risks of Swimming in Contaminated Waterways',
      description: 'Dangers of swimming in contaminated waterways, emphasizing risks of fecal matter and sewage exposure.',
      youtubeVideoId: '1b3c5e7f9h1', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/1b3c5e7f9h1/maxresdefault.jpg',
      category: 'Water Quality',
      durationSeconds: 160,
      targetAudience: 'All Ages',
      keyPoints: [
        'Check water quality reports',
        'Avoid swimming after rain',
        'Watch for warning signs',
        'Shower after swimming',
      ],
      publishedDate: DateTime(2023, 4, 5),
    ),
    SafetyVideo( // https://www.youtube.com/watch?v=nzHS8ZhGGf4 
      id: 'how-to-survive-an-undertow',
      title: 'How to Survive An Undertow',
      description: 'Learn how to survive an undertow and how to get out of one if you are caught in one.',
      youtubeVideoId: 'nzHS8ZhGGf4', // Replace with actual video ID
      thumbnailUrl: 'https://img.youtube.com/vi/nzHS8ZhGGf4/maxresdefault.jpg',
      category: 'River Currents',
      durationSeconds: 112,
      targetAudience: 'All Ages',
      keyPoints: [
        'Stay calm if caught in an undertow',
        'Float on your back with feet forward',
        'Swim diagonally to shore',
        'Never fight the current directly',
      ],
      publishedDate: DateTime(2019, 1, 1),
    ),
  ];

  @override
  Future<List<SafetyVideo>> getAllVideos() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _videos;
  }

  @override
  Future<List<SafetyVideo>> getVideosByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _videos.where((video) => video.category == category).toList();
  }

  @override
  Future<List<SafetyVideo>> getVideosByAudience(String audience) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _videos.where((video) => video.targetAudience == audience).toList();
  }

  @override
  Future<List<SafetyVideo>> getFeaturedVideos() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Return the most important videos for safety
    return _videos.where((video) => 
      video.id == 'river-currents-danger' ||
      video.id == 'cold-water-shock' ||
      video.id == 'water-safety-code' ||
      video.id == 'drowning-prevention'
    ).toList();
  }

  @override
  Future<List<SafetyVideo>> searchVideos(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _videos.where((video) =>
      video.title.toLowerCase().contains(lowercaseQuery) ||
      video.description.toLowerCase().contains(lowercaseQuery) ||
      video.category.toLowerCase().contains(lowercaseQuery) ||
      video.keyPoints.any((point) => point.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  @override
  Future<SafetyVideo?> getVideoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _videos.firstWhere((video) => video.id == id);
    } catch (e) {
      return null;
    }
  }
} 