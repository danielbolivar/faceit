import 'package:faceit/core/settings/settings.dart';
import 'package:get_it/get_it.dart';
import '../../app/cubit/app_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {

  // Register Settings
  getIt.registerSingleton<Settings>(Settings.instance);

  // Register App Cubit
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
}
