import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacriversafety/core/di/injection.dart';
import 'package:sacriversafety/core/router/app_router.dart';
import 'package:sacriversafety/presentation/cubits/home_cubit.dart';
import 'package:sacriversafety/presentation/cubits/river_conditions_cubit.dart';
import 'package:sacriversafety/presentation/cubits/river_cubit.dart';
import 'package:sacriversafety/presentation/cubits/trail_cubit.dart';
import 'package:sacriversafety/presentation/cubits/trail_safety_cubit.dart';
import 'package:sacriversafety/presentation/cubits/safety_education_cubit.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class SacRiverSafetyApp extends StatelessWidget {
  const SacRiverSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (context) => getIt<HomeCubit>()),
        BlocProvider<RiverCubit>(create: (context) => getIt<RiverCubit>()),
        BlocProvider<RiverConditionsCubit>(create: (context) => getIt<RiverConditionsCubit>()),
        BlocProvider<TrailCubit>(create: (context) => getIt<TrailCubit>()),
        BlocProvider<TrailSafetyCubit>(create: (context) => getIt<TrailSafetyCubit>()),
        BlocProvider<SafetyEducationCubit>(create: (context) => getIt<SafetyEducationCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Sac River Safety',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'sac_river_safety_app',
      ),
    );
  }
} 