import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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

  const HomeLoaded({
    required this.safetyAlerts,
    required this.hasActiveAlerts,
  });

  @override
  List<Object?> get props => [safetyAlerts, hasActiveAlerts];
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
      
      emit(const HomeLoaded(
        safetyAlerts: safetyAlerts,
        hasActiveAlerts: hasActiveAlerts,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
} 