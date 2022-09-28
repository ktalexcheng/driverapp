import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/analysis/view/view.dart';
import 'package:driverapp/src/history/history.dart';
import 'package:driverapp/src/utilities/utilities.dart';

class RideAnalysisResults extends StatelessWidget {
  const RideAnalysisResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryBloc, RideHistoryState>(
      builder: (context, state) {
        if (state is RideHistoryGetLastRideSuccess) {
          return Column(
            children: [
              Text('Ride name: ${state.fetchedRide.rideName}'),
              Text('Ride date: ${state.fetchedRide.rideDate.toString()}'),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  RideAnalysisMetric(
                    title: "Observations:",
                    body: state.fetchedRide.observations.toString(),
                  ),
                  RideAnalysisMetric(
                    title: "Duration:",
                    body: formatDuration(state.fetchedRide.duration),
                  ),
                  RideAnalysisMetric(
                    title: "Distance (km):",
                    body: state.fetchedRide.distance.toStringAsFixed(1),
                  ),
                  RideAnalysisMetric(
                    title: "Average speed (km/h):",
                    body: state.fetchedRide.avgSpeed.toStringAsFixed(1),
                  ),
                  RideAnalysisMetric(
                    title: "Average acceleration (g):",
                    body:
                        state.fetchedRide.avgAbsAcceleration.toStringAsFixed(3),
                  ),
                  RideAnalysisMetric(
                    title: "Max acceleration (g):",
                    body:
                        state.fetchedRide.maxAbsAcceleration.toStringAsFixed(3),
                  ),
                  RideAnalysisMetric(
                    title: "Std dev acceleration (g):",
                    body:
                        state.fetchedRide.stdDevAcceleration.toStringAsFixed(3),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );

    // return GridView.count(
    //   crossAxisCount: 3,
    //   shrinkWrap: true,
    //   padding: const EdgeInsets.all(8),
    //   mainAxisSpacing: 8,
    //   crossAxisSpacing: 8,
    //   children: [
    //     BlocBuilder<RideHistoryBloc, RideHistoryState>(
    //       builder: (context, state) {
    //         return RideAnalysisMetric(
    //           title: "Observations:",
    //           body: state.fetchedRide.observations.toString(),
    //         );
    //       },
    //     ),
    //     BlocBuilder<RideHistoryBloc, RideHistoryState>(
    //       builder: (context, state) {
    //         return RideAnalysisMetric(
    //           title: "Duration:",
    //           body: formatDuration(state.fetchedRide.duration),
    //         );
    //       },
    //     ),
    //     BlocBuilder<RideHistoryBloc, RideHistoryState>(
    //       builder: (context, state) {
    //         return RideAnalysisMetric(
    //           title: "Distance (km):",
    //           body: state.fetchedRide.distance.toStringAsFixed(1),
    //         );
    //       },
    //     ),
    //     BlocBuilder<RideHistoryBloc, RideHistoryState>(
    //       builder: (context, state) {
    //         return RideAnalysisMetric(
    //           title: "Average speed (km/h):",
    //           body: state.fetchedRide.avgSpeed.toStringAsFixed(1),
    //         );
    //       },
    //     ),
    //     BlocBuilder<RideHistoryBloc, RideHistoryState>(
    //       builder: (context, state) {
    //         return RideAnalysisMetric(
    //           title: "Average acceleration (g):",
    //           body: state.fetchedRide.avgAbsAcceleration.toStringAsFixed(3),
    //         );
    //       },
    //     ),
    //     BlocBuilder<RideHistoryBloc, RideHistoryState>(
    //       builder: (context, state) {
    //         return RideAnalysisMetric(
    //           title: "Max acceleration (g):",
    //           body: state.fetchedRide.maxAbsAcceleration.toStringAsFixed(3),
    //         );
    //       },
    //     ),
    //     BlocBuilder<RideHistoryBloc, RideHistoryState>(
    //       builder: (context, state) {
    //         return RideAnalysisMetric(
    //           title: "Std dev acceleration (g):",
    //           body: state.fetchedRide.stdDevAcceleration.toStringAsFixed(3),
    //         );
    //       },
    //     ),
    //   ],
    // );
  }
}
