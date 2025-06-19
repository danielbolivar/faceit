import 'dart:developer';

import 'package:faceit/app/view/app.dart';
import 'package:faceit/core/di/injection.dart';
import 'package:faceit/core/settings/onboarding_settings.dart';
import 'package:faceit/core/settings/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final OnboardingSettings _onboardingSettings = getIt<OnboardingSettings>();

  AppCubit() : super(const AppInitial());

  void initialize() {
    emit(const AppLoading());

    // Verify onboarding status
    final shouldShowOnboarding = _onboardingSettings.shouldShowOnBoarding();

    if (shouldShowOnboarding) {
      emit(AppNeedsOnboarding());
      return;
    } else {
      emit(const AppReady());
    }
  }

  void showError(String message) {
    emit(AppError(message));
  }

  void reset() {
    emit(const AppInitial());
  }


  Future<void> completeOnboarding() async {
    await _onboardingSettings.completeOnboarding();
    log('Onboarding completed, emitting AppReady state');
    emit(const AppReady());
  }

  Future<void> resetOnboarding() async {
    await _onboardingSettings.resetOnboarding();
    log('Onboarding reset, emitting AppNeedsOnboarding state');
    emit(const AppNeedsOnboarding());
  }

}

