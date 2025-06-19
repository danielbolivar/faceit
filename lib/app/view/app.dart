import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/theme.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../../core/routing/app_router.dart';
import '../../core/di/injection_simple.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) => getIt<AppCubit>()..initialize(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'FaceIt',
            theme: FThemes.zinc.dark.toApproximateMaterialTheme(),
            routerConfig: AppRouter.createRouter(),
          );
        },
      ),
    );
  }
}
