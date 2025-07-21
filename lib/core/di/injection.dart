import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:sacriversafety/data/repositories/river_repository_impl.dart';
import 'package:sacriversafety/data/repositories/trail_repository_impl.dart';
import 'package:sacriversafety/data/repositories/safety_education_repository_impl.dart';
import 'package:sacriversafety/data/repositories/drowning_statistics_repository_impl.dart';
import 'package:sacriversafety/data/services/river_service.dart';
import 'package:sacriversafety/data/services/trail_service.dart';
import 'package:sacriversafety/data/services/weather_service.dart';
import 'package:sacriversafety/data/services/air_quality_service.dart';
import 'package:sacriversafety/data/services/drowning_statistics_service.dart';
import 'package:sacriversafety/domain/repositories/river_repository.dart';
import 'package:sacriversafety/domain/repositories/trail_repository.dart';
import 'package:sacriversafety/domain/repositories/safety_education_repository.dart';
import 'package:sacriversafety/domain/repositories/drowning_statistics_repository.dart';
import 'package:sacriversafety/presentation/cubits/home_cubit.dart';
import 'package:sacriversafety/presentation/cubits/river_conditions_cubit.dart';
import 'package:sacriversafety/presentation/cubits/river_cubit.dart';
import 'package:sacriversafety/presentation/cubits/trail_cubit.dart';
import 'package:sacriversafety/presentation/cubits/trail_safety_cubit.dart';
import 'package:sacriversafety/presentation/cubits/safety_education_cubit.dart';

final getIt = GetIt.instance;
final Logger _logger = Logger();

/// Dependency injection setup
void setupInjection() {
  _logger.i('Setting up dependency injection...');
  
  // Services
  getIt.registerLazySingleton<RiverService>(() {
    _logger.d('Creating RiverService');
    return RiverService();
  });
  getIt.registerLazySingleton<TrailService>(() {
    _logger.d('Creating TrailService');
    return TrailService();
  });
  getIt.registerLazySingleton<WeatherService>(() {
    _logger.d('Creating WeatherService');
    return WeatherService();
  });
  getIt.registerLazySingleton<AirQualityService>(() {
    _logger.d('Creating AirQualityService');
    return AirQualityService();
  });
  getIt.registerLazySingleton<DrowningStatisticsService>(() {
    _logger.d('Creating DrowningStatisticsService');
    return DrowningStatisticsService();
  });

  // Repositories
  getIt.registerLazySingleton<RiverRepository>(() {
    _logger.d('Creating RiverRepository');
    return RiverRepositoryImpl(riverService: getIt<RiverService>());
  });
  getIt.registerLazySingleton<TrailRepository>(() {
    _logger.d('Creating TrailRepository');
    return TrailRepositoryImpl(
      trailService: getIt<TrailService>(),
      weatherService: getIt<WeatherService>(),
      airQualityService: getIt<AirQualityService>(),
    );
  });
  getIt.registerLazySingleton<SafetyEducationRepository>(() {
    _logger.d('Creating SafetyEducationRepository');
    return SafetyEducationRepositoryImpl();
  });
  getIt.registerLazySingleton<DrowningStatisticsRepository>(() {
    _logger.d('Creating DrowningStatisticsRepository');
    return DrowningStatisticsRepositoryImpl(
      drowningStatisticsService: getIt<DrowningStatisticsService>(),
    );
  });

  // Cubits
  getIt.registerFactory<HomeCubit>(() {
    _logger.i('Creating HomeCubit');
    return HomeCubit();
  });
  getIt.registerFactory<RiverCubit>(() {
    _logger.d('Creating RiverCubit');
    return RiverCubit(riverRepository: getIt<RiverRepository>());
  });
  getIt.registerFactory<RiverConditionsCubit>(() {
    _logger.d('Creating RiverConditionsCubit');
    return RiverConditionsCubit(riverRepository: getIt<RiverRepository>());
  });
  getIt.registerFactory<TrailCubit>(() {
    _logger.d('Creating TrailCubit');
    return TrailCubit(trailRepository: getIt<TrailRepository>());
  });
  getIt.registerFactory<TrailSafetyCubit>(() {
    _logger.d('Creating TrailSafetyCubit');
    return TrailSafetyCubit(trailRepository: getIt<TrailRepository>());
  });
  getIt.registerFactory<SafetyEducationCubit>(() {
    _logger.d('Creating SafetyEducationCubit');
    return SafetyEducationCubit(getIt<SafetyEducationRepository>());
  });
  
  _logger.i('Dependency injection setup complete');
} 