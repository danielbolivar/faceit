import 'package:flutter/material.dart';
import 'app/view/app.dart';
import 'core/di/injection.dart';

void main() {
  // Setup dependency injection
  setupDependencies();

  runApp(const App());
}
