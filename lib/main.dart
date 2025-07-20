import 'package:flutter/material.dart';
import 'package:sacriversafety/app.dart';
import 'package:sacriversafety/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await initializeDependencies();
  
  runApp(const sacriversafetyApp());
} 