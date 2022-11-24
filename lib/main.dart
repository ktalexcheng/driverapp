import 'package:wakelock/wakelock.dart'; // FOR DEVELOPMENT ONLY
import 'package:flutter/material.dart';

import 'package:trailbrake/src/app/app.dart';
import 'package:trailbrake/theme/app_theme.dart' as app_theme;

void main() {
  runApp(TrailBrakeApp());
}

class TrailBrakeApp extends StatelessWidget {
  TrailBrakeApp({Key? key}) : super(key: key);

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    Wakelock.enable(); // FOR DEVELOPMENT ONLY

    return MaterialApp(
      title: 'Rate My Ride',
      theme: app_theme.lightTheme,
      darkTheme: app_theme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AppMainScreen(),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
