import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/cubit/cubit.dart';
import 'package:trailbrake/src/ride/view/widget/widgets.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class ActiveRideMetrics extends StatelessWidget {
  const ActiveRideMetrics({super.key, required this.metricName});

  final String metricName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [Text(metricName)],
      ),
    );
  }
}

class RideActivityExitButton extends StatelessWidget {
  const RideActivityExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
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
      child: const Text("Exit"),
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
                    Expanded(child: ActiveRideMetrics(metricName: "Metric 1")),
                    constants.columnSpacer,
                    Expanded(child: ActiveRideMetrics(metricName: "Metric 2")),
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
