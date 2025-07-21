import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacriversafety/domain/entities/trail_condition.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/trail_incident.dart';
import 'package:sacriversafety/domain/entities/park_status.dart';
import 'package:sacriversafety/domain/entities/drowning_incident.dart';
import 'package:sacriversafety/domain/repositories/trail_repository.dart';

/// State for the trail safety page
abstract class TrailSafetyState extends Equatable {
  const TrailSafetyState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TrailSafetyInitial extends TrailSafetyState {}

/// Loading state
class TrailSafetyLoading extends TrailSafetyState {}

/// Loaded state with data
class TrailSafetyLoaded extends TrailSafetyState {
  final TrailCondition trailCondition;
  final List<TrailAmenity> amenities;
  final List<SafetyAlert> safetyAlerts;
  final List<TrailIncident> incidents;
  final List<ParkStatus> parkStatus;
  final List<DrowningIncident> drowningIncidents;

  const TrailSafetyLoaded({
    required this.trailCondition,
    required this.amenities,
    required this.safetyAlerts,
    required this.incidents,
    required this.parkStatus,
    required this.drowningIncidents,
  });

  bool get hasActiveAlerts {
    return safetyAlerts.isNotEmpty || 
           trailCondition.alerts.isNotEmpty ||
           _hasWeatherAlerts(trailCondition);
  }

  bool _hasWeatherAlerts(TrailCondition condition) {
    return condition.airQualityIndex > 100 || 
           condition.temperature > 95 ||
           condition.overallSafety == 'danger';
  }

  @override
  List<Object?> get props => [
    trailCondition,
    amenities,
    safetyAlerts,
    incidents,
    parkStatus,
    drowningIncidents,
  ];
}

/// Error state
class TrailSafetyError extends TrailSafetyState {
  final String message;

  const TrailSafetyError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Cubit for managing trail safety page state
class TrailSafetyCubit extends Cubit<TrailSafetyState> {
  final TrailRepository _trailRepository;

  TrailSafetyCubit({required TrailRepository trailRepository})
      : _trailRepository = trailRepository,
        super(TrailSafetyInitial());

  /// Load trail safety data
  Future<void> loadTrailSafetyData() async {
    emit(TrailSafetyLoading());
    
    try {
      final trailCondition = await _trailRepository.getTrailCondition();
      final amenities = await _trailRepository.getTrailAmenities();
      final safetyAlerts = await _trailRepository.getSafetyAlerts();
      final incidents = await _trailRepository.getTrailIncidents();
      final parkStatus = await _trailRepository.getParkStatus();
      final drowningIncidents = await _trailRepository.getDrowningIncidents();
      
      emit(TrailSafetyLoaded(
        trailCondition: trailCondition,
        amenities: amenities,
        safetyAlerts: safetyAlerts,
        incidents: incidents,
        parkStatus: parkStatus,
        drowningIncidents: drowningIncidents,
      ));
    } catch (e) {
      emit(TrailSafetyError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadTrailSafetyData();
  }

  Future<void> retry() async {
    await loadTrailSafetyData();
  }
} 