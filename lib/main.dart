import 'package:wakelock/wakelock.dart'; // FOR DEVELOPMENT ONLY
import 'package:flutter/material.dart';

import 'package:driverapp/src/app/app.dart';

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Wakelock.enable(); // FOR DEVELOPMENT ONLY

    return MaterialApp(
      title: 'Rate My Ride',
      theme: ThemeData.dark(),
      home: const DriverAppHomePage(),
    );
  }
}
