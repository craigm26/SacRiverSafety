import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/core/di/injection.dart';
import 'package:sacriversafety/core/router/app_router.dart';
import 'package:sacriversafety/presentation/cubits/home_cubit.dart';
import 'package:sacriversafety/presentation/cubits/river_cubit.dart';
import 'package:sacriversafety/presentation/cubits/trail_cubit.dart';

class sacriversafetyApp extends StatelessWidget {
  const sacriversafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => getIt<HomeCubit>()..loadHomeData(),
        ),
        BlocProvider<RiverCubit>(
          create: (context) => getIt<RiverCubit>(),
        ),
        BlocProvider<TrailCubit>(
          create: (context) => getIt<TrailCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'SacRiverSafety',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 