import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppInitial());

  void initialize() {
    emit(const AppLoading());

    // Simular inicialización de la app
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(const AppReady());
    });
  }

  void showError(String message) {
    emit(AppError(message));
  }

  void reset() {
    emit(const AppInitial());
  }
}
