import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sacriversafety/app.dart';
import 'package:sacriversafety/core/di/injection.dart';

void main() {
  final logger = Logger();
  logger.i('SacRiverSafety app starting...');
  
  setupInjection();
  logger.i('Dependency injection completed, running app...');
  
  runApp(const SacRiverSafetyApp());
} 