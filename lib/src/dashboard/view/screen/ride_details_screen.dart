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
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardDeleteRideSuccess) {
            context.read<DashboardBloc>().add(DashboardCatalogRequested());

            Navigator.of(context).pop();
          }
        },
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
                    ],
                  ),
                  constants.rowSpacer,
                  const Scorecard(
                    title: "Ride score",
                    score: 85,
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
                        }
                      });
                    },
                  ),
                ],
              ),
            );
          } else if (state is DashboardGetRideFailure) {
            return const Center(child: Text(constants.missingRideMessage));
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
