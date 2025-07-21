import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacriversafety/domain/entities/safety_video.dart';
import 'package:sacriversafety/domain/repositories/safety_education_repository.dart';

// Events
abstract class SafetyEducationEvent {}

class LoadAllVideos extends SafetyEducationEvent {}

class LoadFeaturedVideos extends SafetyEducationEvent {}

class LoadVideosByCategory extends SafetyEducationEvent {
  final String category;
  LoadVideosByCategory(this.category);
}

class LoadVideosByAudience extends SafetyEducationEvent {
  final String audience;
  LoadVideosByAudience(this.audience);
}

class SearchVideos extends SafetyEducationEvent {
  final String query;
  SearchVideos(this.query);
}

class LoadVideoById extends SafetyEducationEvent {
  final String id;
  LoadVideoById(this.id);
}

// States
abstract class SafetyEducationState {}

class SafetyEducationInitial extends SafetyEducationState {}

class SafetyEducationLoading extends SafetyEducationState {}

class SafetyEducationLoaded extends SafetyEducationState {
  final List<SafetyVideo> videos;
  final String? category;
  final String? audience;
  final String? searchQuery;
  
  SafetyEducationLoaded({
    required this.videos,
    this.category,
    this.audience,
    this.searchQuery,
  });
}

class SafetyEducationError extends SafetyEducationState {
  final String message;
  SafetyEducationError(this.message);
}

class VideoDetailLoaded extends SafetyEducationState {
  final SafetyVideo video;
  VideoDetailLoaded(this.video);
}

// Cubit
class SafetyEducationCubit extends Cubit<SafetyEducationState> {
  final SafetyEducationRepository _repository;

  SafetyEducationCubit(this._repository) : super(SafetyEducationInitial());

  void loadAllVideos() async {
    emit(SafetyEducationLoading());
    try {
      final videos = await _repository.getAllVideos();
      emit(SafetyEducationLoaded(videos: videos));
    } catch (e) {
      emit(SafetyEducationError('Failed to load videos: ${e.toString()}'));
    }
  }

  void loadFeaturedVideos() async {
    emit(SafetyEducationLoading());
    try {
      final videos = await _repository.getFeaturedVideos();
      emit(SafetyEducationLoaded(videos: videos));
    } catch (e) {
      emit(SafetyEducationError('Failed to load featured videos: ${e.toString()}'));
    }
  }

  void loadVideosByCategory(String category) async {
    emit(SafetyEducationLoading());
    try {
      final videos = await _repository.getVideosByCategory(category);
      emit(SafetyEducationLoaded(
        videos: videos,
        category: category,
      ));
    } catch (e) {
      emit(SafetyEducationError('Failed to load videos by category: ${e.toString()}'));
    }
  }

  void loadVideosByAudience(String audience) async {
    emit(SafetyEducationLoading());
    try {
      final videos = await _repository.getVideosByAudience(audience);
      emit(SafetyEducationLoaded(
        videos: videos,
        audience: audience,
      ));
    } catch (e) {
      emit(SafetyEducationError('Failed to load videos by audience: ${e.toString()}'));
    }
  }

  void searchVideos(String query) async {
    if (query.trim().isEmpty) {
      loadAllVideos();
      return;
    }
    
    emit(SafetyEducationLoading());
    try {
      final videos = await _repository.searchVideos(query);
      emit(SafetyEducationLoaded(
        videos: videos,
        searchQuery: query,
      ));
    } catch (e) {
      emit(SafetyEducationError('Failed to search videos: ${e.toString()}'));
    }
  }

  void loadVideoById(String id) async {
    emit(SafetyEducationLoading());
    try {
      final video = await _repository.getVideoById(id);
      if (video != null) {
        emit(VideoDetailLoaded(video));
      } else {
        emit(SafetyEducationError('Video not found'));
      }
    } catch (e) {
      emit(SafetyEducationError('Failed to load video: ${e.toString()}'));
    }
  }

  List<String> getAvailableCategories() {
    if (state is SafetyEducationLoaded) {
      final videos = (state as SafetyEducationLoaded).videos;
      return videos.map((v) => v.category).toSet().toList()..sort();
    }
    return [];
  }

  List<String> getAvailableAudiences() {
    if (state is SafetyEducationLoaded) {
      final videos = (state as SafetyEducationLoaded).videos;
      return videos.map((v) => v.targetAudience).toSet().toList()..sort();
    }
    return [];
  }
} 