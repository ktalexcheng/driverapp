import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:trailbrake/src/dashboard/bloc/bloc.dart';
import 'package:trailbrake/src/common/common.dart';

class RideDetailsMetric extends StatelessWidget {
  const RideDetailsMetric({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        children: [
          Text(title),
          Expanded(
            child: Center(
              child: Text(body),
            ),
          ),
        ],
      ),
    );
  }
}

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key, required this.rideId});

  final String rideId;

  @override
  Widget build(BuildContext context) {
    context.read<DashboardBloc>().add(DashboardDataRequested(rideId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardGetRideSuccess) {
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
                    RideDetailsMetric(
                      title: "Observations:",
                      body: state.fetchedRide.observations.toString(),
                    ),
                    RideDetailsMetric(
                      title: "Duration:",
                      body: formatDuration(state.fetchedRide.duration),
                    ),
                    RideDetailsMetric(
                      title: "Distance (km):",
                      body: state.fetchedRide.distance.toStringAsFixed(1),
                    ),
                    RideDetailsMetric(
                      title: "Average speed (km/h):",
                      body: state.fetchedRide.avgSpeed.toStringAsFixed(1),
                    ),
                    RideDetailsMetric(
                      title: "Average moving speed (km/h):",
                      body: state.fetchedRide.avgMovingSpeed.toStringAsFixed(1),
                    ),
                    RideDetailsMetric(
                      title: "Average acceleration (g):",
                      body: state.fetchedRide.avgAbsAcceleration
                          .toStringAsFixed(3),
                    ),
                    RideDetailsMetric(
                      title: "Max acceleration (g):",
                      body: state.fetchedRide.maxAbsAcceleration
                          .toStringAsFixed(3),
                    ),
                    RideDetailsMetric(
                      title: "Std dev acceleration (g):",
                      body: state.fetchedRide.stdDevAcceleration
                          .toStringAsFixed(3),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
