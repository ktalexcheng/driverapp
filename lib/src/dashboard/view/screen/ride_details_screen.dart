import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/dashboard/bloc/bloc.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

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

class TelemetryChart extends StatelessWidget {
  const TelemetryChart(
      {super.key, required this.rideData, required this.valueName});

  final List<SensorData> rideData;
  final String valueName;

  num? seriesValueMapper(datum, index) {
    switch (valueName) {
      case 'accelerometerX':
        return datum.accelerometerX;
      case 'accelerometerY':
        return datum.accelerometerY;
      case 'accelerometerZ':
        return datum.accelerometerZ;
      case 'gyroscopeX':
        return datum.gyroscopeX;
      case 'gyroscopeY':
        return datum.gyroscopeY;
      case 'gyroscopeZ':
        return datum.gyroscopeZ;
      default:
        return -99;
    }
  }

  @override
  Widget build(BuildContext context) {
    LineSeries<dynamic, dynamic> dataSeries = LineSeries<dynamic, dynamic>(
      dataSource: rideData,
      xValueMapper: (datum, index) => datum.timestamp,
      yValueMapper: seriesValueMapper,
      animationDuration: 0,
    );

    return SizedBox(
      height: 150,
      child: SfCartesianChart(
        // zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: DateTimeAxis(),
        series: <LineSeries<dynamic, dynamic>>[dataSeries],
      ),
    );
  }
}

class DeleteRideConfirmationDialog extends StatelessWidget {
  const DeleteRideConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Widget deleteButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );

    return AlertDialog(
      title: const Text("Delete this ride?"),
      content: const Text("Are you sure you want to delete this ride?"),
      actions: [
        deleteButton,
        cancelButton,
      ],
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
            return Padding(
              padding: constants.appDefaultPadding,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        state.fetchedRide.rideName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat.yMMMd()
                          .add_jms()
                          .format(state.fetchedRide.rideDate)),
                      const SizedBox(height: 16),
                      const Text("Ride score"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Text("85", style: TextStyle(fontSize: 50)),
                      Text("/100"),
                    ],
                  ),
                  const SectionTitle(title: "Telemetry"),
                  TelemetryChart(
                    rideData: state.fetchedRide.data,
                    valueName: 'accelerometerX',
                  ),
                  TelemetryChart(
                    rideData: state.fetchedRide.data,
                    valueName: 'accelerometerY',
                  ),
                  TelemetryChart(
                    rideData: state.fetchedRide.data,
                    valueName: 'accelerometerZ',
                  ),
                  TelemetryChart(
                    rideData: state.fetchedRide.data,
                    valueName: 'gyroscopeX',
                  ),
                  TelemetryChart(
                    rideData: state.fetchedRide.data,
                    valueName: 'gyroscopeY',
                  ),
                  TelemetryChart(
                    rideData: state.fetchedRide.data,
                    valueName: 'gyroscopeZ',
                  ),
                  TextButton(
                    child: const Text("Delete this ride"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const DeleteRideConfirmationDialog(),
                      ).then((ifDelete) {
                        if (ifDelete) {
                          context
                              .read<DashboardBloc>()
                              .add(DashboardDeleteRideRequested(rideId));

                          context
                              .read<DashboardBloc>()
                              .add(DashboardCatalogRequested());

                          Navigator.of(context).pop();
                        }
                      });
                    },
                  ),
                  // const SectionTitle(title: "Other metrics"),
                  // GridView.count(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   crossAxisCount: 3,
                  //   shrinkWrap: true,
                  //   padding: const EdgeInsets.all(8),
                  //   mainAxisSpacing: 8,
                  //   crossAxisSpacing: 8,
                  //   children: [
                  //     RideDetailsMetric(
                  //       title: "Observations:",
                  //       body: state.fetchedRide.observations.toString(),
                  //     ),
                  //     RideDetailsMetric(
                  //       title: "Duration:",
                  //       body: formatDuration(state.fetchedRide.duration),
                  //     ),
                  //     RideDetailsMetric(
                  //       title: "Distance (km):",
                  //       body: state.fetchedRide.distance.toStringAsFixed(1),
                  //     ),
                  //     RideDetailsMetric(
                  //       title: "Average speed (km/h):",
                  //       body: state.fetchedRide.avgSpeed.toStringAsFixed(1),
                  //     ),
                  //     RideDetailsMetric(
                  //       title: "Average moving speed (km/h):",
                  //       body: state.fetchedRide.avgMovingSpeed
                  //           .toStringAsFixed(1),
                  //     ),
                  //     RideDetailsMetric(
                  //       title: "Average acceleration (g):",
                  //       body: state.fetchedRide.avgAbsAcceleration
                  //           .toStringAsFixed(3),
                  //     ),
                  //     RideDetailsMetric(
                  //       title: "Max acceleration (g):",
                  //       body: state.fetchedRide.maxAbsAcceleration
                  //           .toStringAsFixed(3),
                  //     ),
                  //     RideDetailsMetric(
                  //       title: "Std dev acceleration (g):",
                  //       body: state.fetchedRide.stdDevAcceleration
                  //           .toStringAsFixed(3),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            );
          }
          if (state is DashboardGetRideFailure) {
            return const Center(child: Text("This ride has been deleted."));
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
