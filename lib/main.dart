import 'package:wakelock/wakelock.dart'; // FOR DEVELOPMENT ONLY
import 'package:flutter/material.dart';

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
    // TODO: BEGIN SETUP FOR DEVELOPMENT ONLY
    Wakelock.enable();
    AuthenticationRepository authRepository = AuthenticationRepository();
    authRepository.clearPreferences();
    // END OF SETUP FOR DEVELOPMENT ONLY

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
