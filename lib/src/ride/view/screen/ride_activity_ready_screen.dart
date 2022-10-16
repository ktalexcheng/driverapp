import 'package:flutter/material.dart';

import 'package:trailbrake/src/ride/view/widget/widgets.dart';
import 'package:trailbrake/src/common/common.dart';

class RideActivityReadyScreen extends StatelessWidget {
  const RideActivityReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCanvas(
      child: Column(
        children: const [
          Text(
            "Start a ride now!",
            textAlign: TextAlign.center,
          ),
          RideActivityControls(),
          // Padding(padding: EdgeInsets.only(top: 16.0)),
          // Text(
          //   "Evaluation and data from your last ride:",
          //   textAlign: TextAlign.center,
          // ),
          // Padding(padding: EdgeInsets.only(top: 16.0)),
          // RideAnalysisResults(),
        ],
      ),
    );
  }
}
