import 'package:wakelock/wakelock.dart'; // FOR DEVELOPMENT ONLY
import 'package:flutter/material.dart';

import 'package:trailbrake/src/app/app.dart';
import 'package:trailbrake/theme/theme.dart';

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
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.dark,
      home: const AppMainScreen(),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
