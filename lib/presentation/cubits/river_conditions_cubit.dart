import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/river_condition.dart';
import 'package:sacriversafety/domain/repositories/river_repository.dart';

// States
abstract class RiverConditionsState extends Equatable {
  const RiverConditionsState();

  @override
  List<Object?> get props => [];
}

class RiverConditionsInitial extends RiverConditionsState {}

class RiverConditionsLoading extends RiverConditionsState {}

class RiverConditionsLoaded extends RiverConditionsState {
  final List<RiverGauge> riverGauges;
  final List<SafetyAlert> safetyAlerts;
  final String selectedGaugeId;
  final List<RiverCondition> historicalData;

  const RiverConditionsLoaded({
    required this.riverGauges,
    required this.safetyAlerts,
    required this.selectedGaugeId,
    required this.historicalData,
  });

  @override
  List<Object?> get props => [riverGauges, safetyAlerts, selectedGaugeId, historicalData];

  RiverConditionsLoaded copyWith({
    List<RiverGauge>? riverGauges,
    List<SafetyAlert>? safetyAlerts,
    String? selectedGaugeId,
    List<RiverCondition>? historicalData,
  }) {
    return RiverConditionsLoaded(
      riverGauges: riverGauges ?? this.riverGauges,
      safetyAlerts: safetyAlerts ?? this.safetyAlerts,
      selectedGaugeId: selectedGaugeId ?? this.selectedGaugeId,
      historicalData: historicalData ?? this.historicalData,
    );
  }
}

class RiverConditionsError extends RiverConditionsState {
  final String message;

  const RiverConditionsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class RiverConditionsCubit extends Cubit<RiverConditionsState> {
  final RiverRepository _riverRepository;
  
  RiverConditionsCubit({required RiverRepository riverRepository})
      : _riverRepository = riverRepository,
        super(RiverConditionsInitial());
  
  Future<void> loadRiverConditions() async {
    emit(RiverConditionsLoading());
    
    try {
      final riverGauges = await _riverRepository.getRiverGauges();
      final safetyAlerts = await _riverRepository.getSafetyAlerts();
      
      // Get historical data for the first gauge (7 days)
      final historicalData = await _riverRepository.getHistoricalData(
        riverGauges.first.id,
        DateTime.now().subtract(const Duration(days: 7)),
        DateTime.now(),
      );
      
      emit(RiverConditionsLoaded(
        riverGauges: riverGauges,
        safetyAlerts: safetyAlerts,
        selectedGaugeId: riverGauges.first.id,
        historicalData: historicalData,
      ));
    } catch (e) {
      emit(RiverConditionsError(e.toString()));
    }
  }

  Future<void> selectGauge(String gaugeId) async {
    final currentState = state;
    if (currentState is RiverConditionsLoaded) {
      try {
        // Get historical data for the selected gauge
        final historicalData = await _riverRepository.getHistoricalData(
          gaugeId,
          DateTime.now().subtract(const Duration(days: 7)),
          DateTime.now(),
        );
        
        emit(currentState.copyWith(
          selectedGaugeId: gaugeId,
          historicalData: historicalData,
        ));
      } catch (e) {
        emit(RiverConditionsError(e.toString()));
      }
    }
  }

  Future<void> refresh() async {
    await loadRiverConditions();
  }

  Future<void> retry() async {
    await loadRiverConditions();
  }
} 