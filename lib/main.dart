import 'package:flutter/material.dart';
import 'package:riversafe_sac/app.dart';
import 'package:riversafe_sac/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await initializeDependencies();
  
  runApp(const RiverSafeSacApp());
} 