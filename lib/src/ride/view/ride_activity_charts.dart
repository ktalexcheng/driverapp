import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:driverapp/src/ride/cubit/cubit.dart';
import 'package:driverapp/src/ride/data/data.dart';
import 'package:driverapp/src/utilities/utilities.dart';

class RideActivityCharts extends StatefulWidget {
  const RideActivityCharts({super.key});

  @override
  State<RideActivityCharts> createState() => _RideActivityChartsState();
}

class _RideActivityChartsState extends State<RideActivityCharts> {
  // var locationSeries = <charts.Series<dynamic, num>>[];
  // var accelerometerSeries = <charts.Series<dynamic, DateTime>>[];
  // var gyroscopeSeries = <charts.Series<dynamic, DateTime>>[];

  // static int chartDataWindow = 0;

  dynamic getListLastN(List list, int n) {
    if (n > list.length) {
      return list;
    } else if (n == 0) {
      return list;
    } else if (n == 1) {
      return list[list.length - 1];
    } else {
      return list.sublist(list.length - n, list.length - 1);
    }
  }

  Duration calcRideDuration(RideData currentRideData) {
    DateTime startTime = currentRideData.rideData[0].timestamp;
    DateTime endTime = currentRideData.rideData.last.timestamp;

    return endTime.difference(startTime);
  }

  void updateAccelerometerSeries(RideData rideData, int window) {
    // accelerometerSeries = [
    //   charts.Series(
    //     id: "Accelerometer X",
    //     data: getListLastN(rideData, window),
    //     domainFn: (series, _) => series.timestamp,
    //     measureFn: (series, _) => series.accelerometerX,
    //   ),
    //   charts.Series(
    //     id: "Accelerometer Y",
    //     data: getListLastN(rideData, window),
    //     domainFn: (series, _) => series.timestamp,
    //     measureFn: (series, _) => series.accelerometerY,
    //   ),
    //   charts.Series(
    //     id: "Accelerometer Z",
    //     data: getListLastN(rideData, window),
    //     domainFn: (series, _) => series.timestamp,
    //     measureFn: (series, _) => series.accelerometerZ,
    //   ),
    // ];
  }

  void updateGyroscopeSeries(RideData rideData, int window) {
    // List<charts.Series<dynamic, DateTime>> series = [
    //   charts.Series(
    //     id: "Gyroscope X",
    //     data: getListLastN(rideData, window),
    //     domainFn: (series, _) => series.timestamp,
    //     measureFn: (series, _) => series.gyroscopeX,
    //   ),
    //   charts.Series(
    //     id: "Gyroscope Y",
    //     data: getListLastN(rideData, window),
    //     domainFn: (series, _) => series.timestamp,
    //     measureFn: (series, _) => series.gyroscopeY,
    //   ),
    //   charts.Series(
    //     id: "Gyroscope Z",
    //     data: getListLastN(rideData, window),
    //     domainFn: (series, _) => series.timestamp,
    //     measureFn: (series, _) => series.gyroscopeZ,
    //   ),
    // ];

    // return series;
  }

  void updateLocationSeries(RideData rideData, int window) {
    // List<charts.Series<dynamic, double>> series = [
    //   charts.Series(
    //     id: "GPS Coordinates",
    //     data: getListLastN(rideData, window)
    //         .where((x) => x.locationLat != 0 && x.locationLong != 0)
    //         .toList(),
    //     domainFn: (series, _) => series.locationLong,
    //     measureFn: (series, _) => series.locationLong,
    //   ),
    // ];

    // return series;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocBuilder<RideActivityCubit, RideActivityState>(
          buildWhen: (previous, current) {
            if (current.status == RideActivityStatus.running) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            // Still check state here even with buildWhen: as state could have changed
            if (state.status == RideActivityStatus.running) {
              // Update data
              // updateLocationSeries(state.rideData, chartDataWindow);
              // updateAccelerometerSeries(state.rideData, chartDataWindow);
              // updateGyroscopeSeries(state.rideData, chartDataWindow);

              return Column(
                children: [
                  const Text("Ride time:"),
                  Text(formatDuration(calcRideDuration(state.rideData))),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  const Text("Location data:"),
                  Text("Latitude: " +
                      state.rideData.rideData.last.locationLat.toString()),
                  Text("Longitude: " +
                      state.rideData.rideData.last.locationLong.toString()),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //       height: 200,
                  //       width: 350,
                  //       child: charts.ScatterPlotChart(
                  //         locationSeries,
                  //         animate: false,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  const Text("Accelerometer sensor data:"),
                  Text("X: " +
                      state.rideData.rideData.last.accelerometerX.toString()),
                  Text("Y: " +
                      state.rideData.rideData.last.accelerometerY.toString()),
                  Text("Z: " +
                      state.rideData.rideData.last.accelerometerZ.toString()),
                  // Row(
                  //   children: [
                  //     SfCartesianChart(
                  //       primaryXAxis: DateTimeAxis(),
                  //       series: <LineSeries<SensorData, DateTime>>[
                  //         LineSeries<SensorData, DateTime>(
                  //           dataSource: state.rideData.data,
                  //           xValueMapper: (datum, index) => datum.timestamp,
                  //           yValueMapper: (datum, index) =>
                  //               datum.accelerometerX,
                  //           animationDuration: 0,
                  //           animationDelay: 0,
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     SizedBox(
                  //       height: 200,
                  //       width: 350,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(5),
                  //         child: charts.TimeSeriesChart(
                  //           accelerometerSeries,
                  //           animate: false,
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  const Text("Gyroscope sensor data:"),
                  Text("X: " +
                      state.rideData.rideData.last.gyroscopeX.toString()),
                  Text("Y: " +
                      state.rideData.rideData.last.gyroscopeY.toString()),
                  Text("Z: " +
                      state.rideData.rideData.last.gyroscopeZ.toString()),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     SizedBox(
                  //       height: 200,
                  //       width: 350,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(5),
                  //         child: charts.TimeSeriesChart(
                  //           gyroscopeSeries,
                  //           animate: false,
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
