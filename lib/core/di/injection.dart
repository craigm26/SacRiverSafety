import 'package:get_it/get_it.dart';
import 'package:riversafe_sac/data/repositories/river_repository_impl.dart';
import 'package:riversafe_sac/data/repositories/trail_repository_impl.dart';
import 'package:riversafe_sac/data/services/river_service.dart';
import 'package:riversafe_sac/data/services/trail_service.dart';
import 'package:riversafe_sac/domain/repositories/river_repository.dart';
import 'package:riversafe_sac/domain/repositories/trail_repository.dart';
import 'package:riversafe_sac/presentation/cubits/home_cubit.dart';
import 'package:riversafe_sac/presentation/cubits/river_cubit.dart';
import 'package:riversafe_sac/presentation/cubits/trail_cubit.dart';

final GetIt getIt = GetIt.instance;

/// Initialize all dependencies for the application
Future<void> initializeDependencies() async {
  // Services
  getIt.registerLazySingleton<RiverService>(() => RiverService());
  getIt.registerLazySingleton<TrailService>(() => TrailService());
  
  // Repositories
  getIt.registerLazySingleton<RiverRepository>(
    () => RiverRepositoryImpl(riverService: getIt<RiverService>()),
  );
  getIt.registerLazySingleton<TrailRepository>(
    () => TrailRepositoryImpl(trailService: getIt<TrailService>()),
  );
  
  // Cubits
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
  getIt.registerFactory<RiverCubit>(() => RiverCubit(
    riverRepository: getIt<RiverRepository>(),
  ));
  getIt.registerFactory<TrailCubit>(() => TrailCubit(
    trailRepository: getIt<TrailRepository>(),
  ));
} 