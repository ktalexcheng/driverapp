import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/ride/cubit/cubit.dart';
import 'package:driverapp/src/ride/view/view.dart';
import 'package:driverapp/src/analysis/analysis.dart';
// import 'package:driverapp/src/history/history.dart';

class RideActivityPage extends StatelessWidget {
  const RideActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RideActivityCubit(),
      child: BlocBuilder<RideActivityCubit, RideActivityState>(
        buildWhen: (previous, current) {
          if (previous.status != current.status) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state.status == RideActivityStatus.ready) {
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
          } else if (state.status == RideActivityStatus.running ||
              state.status == RideActivityStatus.paused ||
              state.status == RideActivityStatus.saving) {
            return Column(
              children: const [
                RideActivityControls(),
                RideActivityCharts(),
              ],
            );
          } else {
            return const Text(
                "ERROR: App is in an invalid state! Please re-open the app.");
          }
        },
      ),
    );
  }
}
