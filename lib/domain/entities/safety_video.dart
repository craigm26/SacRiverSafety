class SafetyVideo {
  final String id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String thumbnailUrl;
  final String category;
  final int durationSeconds;
  final String targetAudience;
  final List<String> keyPoints;
  final DateTime publishedDate;

  const SafetyVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    required this.thumbnailUrl,
    required this.category,
    required this.durationSeconds,
    required this.targetAudience,
    required this.keyPoints,
    required this.publishedDate,
  });

  String get durationFormatted {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$youtubeVideoId';
  String get embedUrl => 'https://www.youtube.com/embed/$youtubeVideoId';

  factory SafetyVideo.fromJson(Map<String, dynamic> json) {
    return SafetyVideo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      category: json['category'] as String,
      durationSeconds: json['durationSeconds'] as int,
      targetAudience: json['targetAudience'] as String,
      keyPoints: List<String>.from(json['keyPoints'] as List),
      publishedDate: DateTime.parse(json['publishedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'youtubeVideoId': youtubeVideoId,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'durationSeconds': durationSeconds,
      'targetAudience': targetAudience,
      'keyPoints': keyPoints,
      'publishedDate': publishedDate.toIso8601String(),
    };
  }
} 