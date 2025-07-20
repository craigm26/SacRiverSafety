import 'package:get_it/get_it.dart';
import 'package:sacriversafety/data/repositories/river_repository_impl.dart';
import 'package:sacriversafety/data/repositories/trail_repository_impl.dart';
import 'package:sacriversafety/data/services/river_service.dart';
import 'package:sacriversafety/data/services/trail_service.dart';
import 'package:sacriversafety/domain/repositories/river_repository.dart';
import 'package:sacriversafety/domain/repositories/trail_repository.dart';
import 'package:sacriversafety/presentation/cubits/home_cubit.dart';
import 'package:sacriversafety/presentation/cubits/river_cubit.dart';
import 'package:sacriversafety/presentation/cubits/trail_cubit.dart';

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