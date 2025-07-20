import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riversafe_sac/presentation/pages/home_page.dart';
import 'package:riversafe_sac/presentation/themes/app_theme.dart';
import 'package:riversafe_sac/core/di/injection.dart';
import 'package:riversafe_sac/presentation/cubits/home_cubit.dart';
import 'package:riversafe_sac/presentation/cubits/river_cubit.dart';
import 'package:riversafe_sac/presentation/cubits/trail_cubit.dart';

class RiverSafeSacApp extends StatelessWidget {
  const RiverSafeSacApp({super.key});

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
      child: MaterialApp(
        title: 'RiverSafeSac',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 