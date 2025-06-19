import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSettings {
  static OnboardingSettings? _instance;
  static OnboardingSettings get instance {
    if (_instance == null) {
      throw Exception(
        'OnboardingSettings not initialized. Call OnboardingSettings.init() first.',
      );
    }

    return _instance!;
  }

  late SharedPreferences _preferences;
  static const String _keyPrefix = 'onboarding_';
  static const String _currentVersion = '1.0.0';

  OnboardingSettings._();

  // Initialize SharedPreferences and load existing settings
  static Future<void> init() async {
    log('Initializing OnboardingSettings...');
    _instance = OnboardingSettings._();
    await _instance!._initPrefs();
    log('OnboardingSettings initialized.');
  }

  Future<void> _initPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    log('SharedPreferences initialized.');
  }

  // Onboarding Methods

  bool get isOnboardingComplete {
    final completed = _preferences.getBool('${_keyPrefix}completed') ?? false;
    log('Onboarding completed: $completed');
    return completed;
  }

  Future<void> completeOnboarding() async {
    await _preferences.setBool('${_keyPrefix}completed', true);
    await _preferences.setString('${_keyPrefix}version', _currentVersion);
    await _preferences.setString(
      '${_keyPrefix}completed_at',
      DateTime.now().toIso8601String(),
    );
    log('Onboarding marked as completed - version: $_currentVersion');
  }

  DateTime? get onboardingCompletedAt {
    final completedAtString = _preferences.getString(
      '${_keyPrefix}completed_at',
    );
    if (completedAtString != null) {
      final completedAt = DateTime.tryParse(completedAtString);
      log('Onboarding completed at: $completedAt');
      return completedAt;
    }
    log('Onboarding not completed yet.');
    return null;
  }

  String? get onboardingVersion {
    final version = _preferences.getString('${_keyPrefix}version');
    log('Onboarding version: $version');
    return version;
  }

  Future<void> resetOnboarding() async {
    await _preferences.remove('${_keyPrefix}completed');
    await _preferences.remove('${_keyPrefix}version');
    await _preferences.remove('${_keyPrefix}completed_at');
    log('Onboarding settings reset.');
  }

  bool shouldShowOnBoarding([String? currentVersion]) {
    final version = currentVersion ?? _currentVersion;
    final lastVersion = _preferences.getString('${_keyPrefix}version');
    final shouldShow = lastVersion != version || !isOnboardingComplete;
    log('Should show onboarding for version $version: $shouldShow');
    return shouldShow;
  }

  Future<void> setOnboardingVersion(String version) async {
    await _preferences.setString('${_keyPrefix}version', version);
    log('Onboarding version set to: $version');
  }

  Map<String, dynamic> getOnboardingInfo() {
    final info = {
      'completed': isOnboardingComplete,
      'version': onboardingVersion,
      'current_version': _currentVersion,
      'completed_at': onboardingCompletedAt?.toIso8601String(),
      'should_show': shouldShowOnBoarding(),
    };

    log('Onboarding Info: $info');
    return info;
  }

  List<String> getAllOnboardingKeys() {
    final keys = _preferences.getKeys()
        .where((key) => key.startsWith(_keyPrefix))
        .toList();
    return keys;
  }

  Future<void> clearAllOnboardingData() async {
    final keys = getAllOnboardingKeys();
    for (final key in keys) {
      await _preferences.remove(key);
    }
    log('All onboarding data cleared.');
  }

}
