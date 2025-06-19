import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {
  const AppInitial();
}

class AppLoading extends AppState {
  const AppLoading();
}

class AppReady extends AppState {
  const AppReady();
}

class AppError extends AppState {
  final String message;

  const AppError(this.message);

  @override
  List<Object> get props => [message];
}
