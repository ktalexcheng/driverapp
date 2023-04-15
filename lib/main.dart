import 'package:wakelock/wakelock.dart'; // FOR DEVELOPMENT ONLY
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:trailbrake/src/app/app.dart';
import 'package:trailbrake/theme/app_theme.dart' as app_theme;
import 'package:trailbrake/src/common/common.dart';

void main() {
  runApp(TrailbrakeApp());
}

class TrailbrakeApp extends StatelessWidget {
  TrailbrakeApp({Key? key}) : super(key: key);

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    if (foundation.kDebugMode) {
      Wakelock.enable();
      AuthenticationRepository authRepository = AuthenticationRepository();
      authRepository.clearPreferences();
      Bloc.observer = DebugBlocObserver();
    }

    return MaterialApp(
      title: 'Trailbrake',
      theme: app_theme.lightTheme,
      darkTheme: app_theme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AppMainScreen(),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
