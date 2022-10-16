import 'package:flutter/material.dart';

import 'package:trailbrake/src/ride/view/widget/widgets.dart';
import 'package:trailbrake/src/ride/data/data.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideActivityOngoingScreen extends StatelessWidget {
  const RideActivityOngoingScreen({super.key});

  Duration calcRideDuration(RideData currentRideData) {
    DateTime startTime = currentRideData.first.timestamp;
    DateTime endTime = currentRideData.last.timestamp;

    return endTime.difference(startTime);
  }

  @override
  Widget build(BuildContext context) {
    return AppCanvas(
      child: Column(
        children: [
          const RideActivityControls(),
          constants.rowSpacer,
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const Text("Accelerometer data:"),
                  AccelerometerXLiveChart(),
                  // SizedBox(
                  //   height: 150,
                  //   width: double.infinity,
                  //   child: AccelerometerYLiveChart(),
                  // ),
                  // SizedBox(
                  //   height: 150,
                  //   width: double.infinity,
                  //   child: AccelerometerZLiveChart(),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
