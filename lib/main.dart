import 'package:faceit/core/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/view/app.dart';
import 'core/di/injection.dart';

void main() async {
  // Ensure Flutter is fully initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize settings with retry logic
    await _initializeWithRetry();

    // Setup dependency injection
    setupDependencies();

    runApp(const App());
  } catch (e) {
    print('Failed to initialize app after all retries: $e');
    // Run app in fallback mode without settings
    runApp(const AppFallback());
  }
}

Future<void> _initializeWithRetry() async {
  int maxRetries = 3;
  int retryDelay = 1000; // Start with 1 second

  for (int i = 0; i < maxRetries; i++) {
    try {
      print('Attempting to initialize settings (attempt ${i + 1}/$maxRetries)');
      await Settings.init();
      print('Settings initialized successfully');
      return;
    } catch (e) {
      print('Initialization attempt ${i + 1} failed: $e');

      if (i < maxRetries - 1) {
        print('Waiting ${retryDelay}ms before retry...');
        await Future.delayed(Duration(milliseconds: retryDelay));
        retryDelay *= 2; // Exponential backoff
      } else {
        throw e; // Re-throw on final attempt
      }
    }
  }
}

// Fallback app that doesn't require SharedPreferences
class AppFallback extends StatelessWidget {
  const AppFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaceIt',
      home: Scaffold(
        appBar: AppBar(title: const Text('FaceIt - Initialization Error')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Failed to initialize app storage.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Please restart the app or check your device storage permissions.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
