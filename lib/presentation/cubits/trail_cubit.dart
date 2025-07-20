import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';
import 'package:sacriversafety/domain/repositories/trail_repository.dart';

/// State for trail conditions
abstract class TrailState extends Equatable {
  const TrailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TrailInitial extends TrailState {}

/// Loading state
class TrailLoading extends TrailState {}

/// Loaded state with trail data
class TrailLoaded extends TrailState {
  final TrailCondition trailCondition;
  final List<String> safetyAlerts;
  final List<TrailAmenity> amenities;

  const TrailLoaded({
    required this.trailCondition,
    required this.safetyAlerts,
    required this.amenities,
  });

  @override
  List<Object?> get props => [trailCondition, safetyAlerts, amenities];
}

/// Error state
class TrailError extends TrailState {
  final String message;

  const TrailError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Cubit for managing trail conditions state
class TrailCubit extends Cubit<TrailState> {
  final TrailRepository _trailRepository;

  TrailCubit({required TrailRepository trailRepository})
      : _trailRepository = trailRepository,
        super(TrailInitial());

  /// Load trail conditions and amenities
  Future<void> loadTrailData() async {
    emit(TrailLoading());
    
    try {
      final trailCondition = await _trailRepository.getTrailConditions();
      final safetyAlerts = await _trailRepository.getSafetyAlerts();
      final amenities = await _trailRepository.getAmenities();
      
      emit(TrailLoaded(
        trailCondition: trailCondition,
        safetyAlerts: safetyAlerts,
        amenities: amenities,
      ));
    } catch (e) {
      emit(TrailError(e.toString()));
    }
  }
} 