import 'package:flutter/material.dart';

import 'package:driverapp/src/ride/view/widget/widgets.dart';
import 'package:driverapp/src/ride/data/data.dart';

class RideActivityOngoingPage extends StatelessWidget {
  const RideActivityOngoingPage({super.key});

  Duration calcRideDuration(RideData currentRideData) {
    DateTime startTime = currentRideData.first.timestamp;
    DateTime endTime = currentRideData.last.timestamp;

    return endTime.difference(startTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RideActivityControls(),
        const Padding(padding: EdgeInsets.only(top: 16.0)),
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
    );
  }
}
