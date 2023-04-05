import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/cubit/cubit.dart';
import 'package:trailbrake/src/ride/view/widget/widgets.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class ActiveRideMetrics extends StatelessWidget {
  const ActiveRideMetrics({super.key, required this.metric});

  final constants.RideActivityMetrics metric;

  @override
  Widget build(BuildContext context) {
    String metricName = constants.rideActivityMetricsName[metric];
    String metricValue;
    String? metricUnit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(
              metricName,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            BlocBuilder<RideActivityCubit, RideActivityState>(
              builder: (context, state) {
                if (state is RideActivityNewRideInProgress) {
                  switch (metric) {
                    case constants.RideActivityMetrics.accelerometerX:
                      metricValue = state.newSensorData.accelerometerX
                              ?.toStringAsFixed(3) ??
                          "0";
                      metricUnit = 'm/s2';
                      break;

                    case constants.RideActivityMetrics.timeElapsed:
                      metricValue = formatDuration(
                          state.newSensorData.elapsedSeconds ??
                              const Duration());
                      break;

                    case constants.RideActivityMetrics.avgSpeed:
                      metricValue = state.rideData.avgSpeed.toStringAsFixed(1);
                      metricUnit = 'km/hr';
                      break;

                    case constants.RideActivityMetrics.avgMovingSpeed:
                      metricValue =
                          state.rideData.avgMovingSpeed.toStringAsFixed(1);
                      metricUnit = 'km/hr';
                      break;

                    case constants.RideActivityMetrics.distance:
                      metricValue = state.rideData.distance.toStringAsFixed(2);
                      metricUnit = 'km';
                      break;

                    default:
                      metricValue = DateFormat.Hms()
                          .format(state.newSensorData.timestamp);
                      break;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('$metricValue ${metricUnit ?? ''}'),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RideActivityExitButton extends StatelessWidget {
  const RideActivityExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<RideActivityCubit>().stopRide();
        showDialog(
          context: context,
          // Note: Parent context is not shared with showDialog
          // See: https://api.flutter.dev/flutter/material/showDialog.html
          builder: (_) => const RideActivitySaveDialog(),
        ).then((ifSave) {
          if (ifSave) {
            showDialog(
              context: context,
              builder: (_) => const RideActivitySaveNamePrompt(),
            ).then((rideName) {
              context.read<RideActivityCubit>().saveRide(rideName);
            });
          } else {
            context.read<RideActivityCubit>().discardRide();
          }
        });
      },
      child: const Text(constants.exitRideButtonLabel),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
    );
  }
}

class RideActivityOngoingScreen extends StatelessWidget {
  const RideActivityOngoingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCanvas(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: ActiveRideMetrics(
                        metric: constants.RideActivityMetrics.timeElapsed,
                      ),
                    ),
                    constants.columnSpacer,
                    Expanded(
                      child: ActiveRideMetrics(
                        metric: constants.RideActivityMetrics.distance,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Expanded(child: RideActivityExitButton()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
