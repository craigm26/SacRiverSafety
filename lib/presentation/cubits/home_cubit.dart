import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';

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
  final List<String> safetyAlerts;
  final bool hasActiveAlerts;
  final List<RiverGauge> riverGauges;
  final List<TrailAmenity> amenities;
  final List<SafetyAlert> mapAlerts;
  final TrailCondition? trailCondition;

  const HomeLoaded({
    required this.safetyAlerts,
    required this.hasActiveAlerts,
    required this.riverGauges,
    required this.amenities,
    required this.mapAlerts,
    this.trailCondition,
  });

  @override
  List<Object?> get props => [
    safetyAlerts, 
    hasActiveAlerts, 
    riverGauges, 
    amenities, 
    mapAlerts, 
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
  HomeCubit() : super(HomeInitial());

  /// Load home page data
  Future<void> loadHomeData() async {
    emit(HomeLoading());
    
    try {
      // TODO: Load actual data from repositories
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      
      const safetyAlerts = ['High water flow warning'];
      const hasActiveAlerts = true;
      
      // Mock data for demonstration
      final riverGauges = [
        RiverGauge(
          id: '11446500',
          name: 'American River at Fair Oaks',
          latitude: 38.5901,
          longitude: -121.3442,
          waterLevel: 12.5,
          flowRate: 850,
          safetyLevel: 'caution',
          lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
          alert: 'High flow conditions',
        ),
        RiverGauge(
          id: '11447650',
          name: 'Sacramento River at Downtown',
          latitude: 38.5816,
          longitude: -121.4944,
          waterLevel: 8.2,
          flowRate: 1200,
          safetyLevel: 'safe',
          lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ];
      
      final amenities = [
        const TrailAmenity(
          id: 'water_1',
          name: 'Water Fountain - Mile 2',
          type: 'water',
          latitude: 38.5901,
          longitude: -121.3442,
          isOperational: true,
        ),
        const TrailAmenity(
          id: 'restroom_1',
          name: 'Restroom - Mile 5',
          type: 'restroom',
          latitude: 38.5950,
          longitude: -121.3500,
          isOperational: true,
        ),
        const TrailAmenity(
          id: 'emergency_1',
          name: 'Emergency Call Box - Mile 8',
          type: 'emergency_callbox',
          latitude: 38.6000,
          longitude: -121.3550,
          isOperational: true,
        ),
      ];
      
      final mapAlerts = [
        SafetyAlert(
          id: 'alert_1',
          title: 'High Water Flow',
          description: 'Dangerous water conditions in American River',
          severity: 'high',
          latitude: 38.5901,
          longitude: -121.3442,
          radius: 500,
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          alertType: 'water_condition',
        ),
      ];
      
      final trailCondition = TrailCondition(
        temperature: 85.0,
        airQualityIndex: 75,
        weatherCondition: 'Sunny',
        sunrise: DateTime.now().copyWith(hour: 6, minute: 30),
        sunset: DateTime.now().copyWith(hour: 20, minute: 15),
        alerts: ['High temperature warning'],
        overallSafety: 'caution',
      );
      
      emit(HomeLoaded(
        safetyAlerts: safetyAlerts,
        hasActiveAlerts: hasActiveAlerts,
        riverGauges: riverGauges,
        amenities: amenities,
        mapAlerts: mapAlerts,
        trailCondition: trailCondition,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
} 