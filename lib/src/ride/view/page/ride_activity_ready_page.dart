import 'package:flutter/material.dart';

import 'package:driverapp/src/ride/view/widget/widgets.dart';
import 'package:driverapp/src/analysis/analysis.dart';

class RideActivityReadyPage extends StatelessWidget {
  const RideActivityReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(padding: EdgeInsets.only(top: 16.0)),
        Text(
          "Start a ride now!",
          textAlign: TextAlign.center,
        ),
        RideActivityControls(),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        Text(
          "Evaluation and data from your last ride:",
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        RideAnalysisResults(),
      ],
    );
  }
}
