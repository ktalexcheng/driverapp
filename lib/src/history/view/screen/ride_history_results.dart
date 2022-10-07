import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:driverapp/src/history/view/widget/widget.dart';
import 'package:driverapp/src/history/bloc/bloc.dart';
import 'package:driverapp/src/utilities/utilities.dart';

class RideHistoryResults extends StatelessWidget {
  const RideHistoryResults({super.key, required this.rideId});

  final String rideId;

  @override
  Widget build(BuildContext context) {
    context.read<RideHistoryBloc>().add(RideHistoryRideDataRequested(rideId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: BlocBuilder<RideHistoryBloc, RideHistoryState>(
        builder: (context, state) {
          if (state is RideHistoryInitial ||
              state is RideHistoryGetRideInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is RideHistoryGetRideSuccess) {
            return Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  state.fetchedRide.rideName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(DateFormat.yMMMd()
                    .add_jms()
                    .format(state.fetchedRide.rideDate)),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    RideHistoryMetric(
                      title: "Observations:",
                      body: state.fetchedRide.observations.toString(),
                    ),
                    RideHistoryMetric(
                      title: "Duration:",
                      body: formatDuration(state.fetchedRide.duration),
                    ),
                    RideHistoryMetric(
                      title: "Distance (km):",
                      body: state.fetchedRide.distance.toStringAsFixed(1),
                    ),
                    RideHistoryMetric(
                      title: "Average speed (km/h):",
                      body: state.fetchedRide.avgSpeed.toStringAsFixed(1),
                    ),
                    RideHistoryMetric(
                      title: "Average moving speed (km/h):",
                      body: state.fetchedRide.avgMovingSpeed.toStringAsFixed(1),
                    ),
                    RideHistoryMetric(
                      title: "Average acceleration (g):",
                      body: state.fetchedRide.avgAbsAcceleration
                          .toStringAsFixed(3),
                    ),
                    RideHistoryMetric(
                      title: "Max acceleration (g):",
                      body: state.fetchedRide.maxAbsAcceleration
                          .toStringAsFixed(3),
                    ),
                    RideHistoryMetric(
                      title: "Std dev acceleration (g):",
                      body: state.fetchedRide.stdDevAcceleration
                          .toStringAsFixed(3),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
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
