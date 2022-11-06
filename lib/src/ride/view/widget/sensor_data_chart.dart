import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:trailbrake/src/ride/ride.dart';

class ChartDatum {
  ChartDatum({
    required this.timestamp,
    required this.value,
  });

  final DateTime timestamp;
  final double value;
}

mixin SensorDataLiveChartMixin on StatelessWidget {
  final List<ChartDatum> chartData = <ChartDatum>[];
  late final ChartSeriesController? _chartSeriesController;
  static final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
  );

  static const int dataWindow = 300;

  void _refreshChartData(ChartDatum newData) {
    chartData.add(newData);
    if (chartData.length > dataWindow) {
      chartData.removeAt(0);

      _chartSeriesController?.updateDataSource(
        addedDataIndex: chartData.length - 1,
        removedDataIndex: 0,
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndex: chartData.length - 1,
      );
    }
  }

  SfCartesianChart _buildChart() {
    FastLineSeries<ChartDatum, dynamic> dataSeries =
        FastLineSeries<ChartDatum, dynamic>(
      onRendererCreated: (ChartSeriesController controller) {
        _chartSeriesController = controller;
      },
      dataSource: chartData,
      xValueMapper: (datum, index) => datum.timestamp,
      yValueMapper: (datum, index) => datum.value,
      animationDuration: 0,
    );

    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      primaryXAxis:
          DateTimeAxis(), // TODO: Debug why chart does not display properly with NumericAxis()
      series: <FastLineSeries<ChartDatum, dynamic>>[dataSeries],
    );
  }
}

class AccelerometerXLiveChart extends StatelessWidget
    with SensorDataLiveChartMixin {
  AccelerometerXLiveChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideActivityCubit, RideActivityState>(
      listener: (context, state) {
        if (state is RideActivityNewRideInProgress) {
          ChartDatum newData = ChartDatum(
            timestamp: state.newSensorData.timestamp,
            value: state.newSensorData.accelerometerX ?? 0,
          );

          _refreshChartData(newData);
        }
      },
      child: _buildChart(),
    );
  }
}
