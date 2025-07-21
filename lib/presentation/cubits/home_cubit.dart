import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';

/// State for the home page
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {}

/// Loading state
class HomeLoading extends HomeState {}

/// Loaded state with data
class HomeLoaded extends HomeState {
  final List<RiverGauge> riverGauges;
  final List<TrailAmenity> amenities;
  final List<SafetyAlert> safetyAlerts;
  final dynamic trailCondition;

  const HomeLoaded({
    this.riverGauges = const [],
    this.amenities = const [],
    this.safetyAlerts = const [],
    this.trailCondition,
  });

  @override
  List<Object?> get props => [
    riverGauges,
    amenities,
    safetyAlerts,
    trailCondition,
  ];
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Cubit for managing home page state
class HomeCubit extends Cubit<HomeState> {
  final Logger _logger = Logger();
  
  HomeCubit() : super(HomeInitial()) {
    _logger.i('HomeCubit created, loading initial data...');
    loadHomeData();
  }

  /// Load home page data
  Future<void> loadHomeData() async {
    _logger.i('HomeCubit: Starting to load home data...');
    emit(HomeLoading());
    
    try {
      // TODO: Load actual data from repositories
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      

      

      emit(const HomeLoaded(
  
      ));
    } catch (e) {
      _logger.e('HomeCubit: Error loading home data: $e');
      emit(HomeError(e.toString()));
    }
  }
} 