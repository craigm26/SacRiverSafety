import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacriversafety/domain/entities/river_condition.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/repositories/river_repository.dart';

/// State for river conditions
abstract class RiverState extends Equatable {
  const RiverState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RiverInitial extends RiverState {}

/// Loading state
class RiverLoading extends RiverState {}

/// Loaded state with river data
class RiverLoaded extends RiverState {
  final RiverCondition riverCondition;
  final List<SafetyAlert> safetyAlerts;

  const RiverLoaded({
    required this.riverCondition,
    required this.safetyAlerts,
  });

  @override
  List<Object?> get props => [riverCondition, safetyAlerts];
}

/// Error state
class RiverError extends RiverState {
  final String message;

  const RiverError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Cubit for managing river conditions state
class RiverCubit extends Cubit<RiverState> {
  final RiverRepository _riverRepository;

  RiverCubit({required RiverRepository riverRepository})
      : _riverRepository = riverRepository,
        super(RiverInitial());

  /// Load river conditions for a specific gauge
  Future<void> loadRiverConditions(String gaugeId) async {
    emit(RiverLoading());
    
    try {
      final riverCondition = await _riverRepository.getRiverConditions(gaugeId);
      final safetyAlerts = await _riverRepository.getSafetyAlerts();
      
      emit(RiverLoaded(
        riverCondition: riverCondition,
        safetyAlerts: safetyAlerts,
      ));
    } catch (e) {
      emit(RiverError(e.toString()));
    }
  }
} 