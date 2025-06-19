import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

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
    log('Settings initialization started.');
    _instance = Settings._();
    await _instance!._initSettings();
    log('Settings initialized.');
  }

  Future<void> _initSettings() async {
    log('Initializing OnboardingSettings...');
    await OnboardingSettings.init();
    onboarding = OnboardingSettings.instance;
  }

  Map<String, dynamic> getAllSettingsInfo() {
    return {
      'onboarding': onboarding.getOnboardingInfo(),
    };
  }

  Future<void> resetAllSettings() async {
    await onboarding.resetOnboarding();
    log('All settings reset to default.');
  }

}
