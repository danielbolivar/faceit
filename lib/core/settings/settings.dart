import './onboarding_settings.dart';

class Settings {

  static Settings? _instance;
  static Settings get instance {
    if (_instance == null) {
      throw Exception(
        'Settings not initialized. Call Settings.init() first.',
      );
    }
    return _instance!;
  }

  late OnboardingSettings onboarding;

  Settings._();

  // Initialize all settings
  static Future<void> init() async {
    print('Initializing Settings...');
    _instance = Settings._();
    await _instance!._initSettings();
    print('Settings initialized.');
  }

  Future<void> _initSettings() async {
    onboarding = OnboardingSettings.instance;
  }

}
