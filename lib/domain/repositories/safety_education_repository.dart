import 'package:sacriversafety/domain/entities/safety_video.dart';

abstract class SafetyEducationRepository {
  /// Get all safety videos
  Future<List<SafetyVideo>> getAllVideos();
  
  /// Get videos by category
  Future<List<SafetyVideo>> getVideosByCategory(String category);
  
  /// Get videos by target audience
  Future<List<SafetyVideo>> getVideosByAudience(String audience);
  
  /// Get featured videos (most important for safety)
  Future<List<SafetyVideo>> getFeaturedVideos();
  
  /// Search videos by title or description
  Future<List<SafetyVideo>> searchVideos(String query);
  
  /// Get video by ID
  Future<SafetyVideo?> getVideoById(String id);
} 