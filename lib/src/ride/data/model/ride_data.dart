import 'dart:math';

import 'package:geolocator/geolocator.dart';

import 'package:driverapp/src/ride/data/model/model.dart';

class RideData with RideDataMixin {
  RideData({rideData}) {
    if (rideData is List<SensorData>) {
      super.rideData = rideData;
    } else {
      super.rideData = <SensorData>[];
    }
  }

  factory RideData.fromJson(List<dynamic> jsonList) {
    List<SensorData> _data = <SensorData>[];
    if (jsonList.isNotEmpty) {
      for (var data in jsonList) {
        _data.add(SensorData.fromJson(data));
      }
    }

    return RideData(rideData: _data);
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> _jsonList = [];

    for (var element in rideData) {
      _jsonList.add(element.toJson());
    }

    return _jsonList;
  }
}

mixin RideDataMixin {
  late List<SensorData> rideData;

  void addData(SensorData datum) {
    rideData.add(datum);
  }

  // Metrics calculation
  int get observations => _calcObservations();
  Duration get duration => _calcDuration();
  double get distance => _calcDistance();
  double get avgSpeed => _calcAvgSpeed();
  double get avgAbsAcceleration => _calcAvgAbsAcceleration();
  double get maxAbsAcceleration => _calcMaxAbsAcceleration();
  double get stdDevAcceleration => _calcStdDevAcceleration();

  static double gravity = 9.8;

  int _calcObservations() {
    int obs = 0;

    if (rideData.isNotEmpty) {
      obs = rideData.length;
    }

    return obs;
  }

  Duration _calcDuration() {
    Duration duration = const Duration();

    if (rideData.isNotEmpty) {
      DateTime startTime = rideData.first.timestamp;
      DateTime endTime = rideData.last.timestamp;

      duration = endTime.difference(startTime);
    }

    return duration;
  }

  double _calcDistance() {
    double distance = 0;

    if (rideData.isNotEmpty) {
      rideData.asMap().forEach((idx, obs) {
        if (idx > 0) {
          double startLat = rideData[idx - 1].locationLat ?? 0;
          double startLong = rideData[idx - 1].locationLong ?? 0;
          double endLat = rideData[idx].locationLat ?? 0;
          double endLong = rideData[idx].locationLong ?? 0;

          if (startLat != 0 && startLong != 0 && endLat != 0 && endLong != 0) {
            distance += Geolocator.distanceBetween(
                    startLat, startLong, endLat, endLong) /
                1000;
          }
        }
      });
    }

    return distance;
  }

  double _calcAvgSpeed() {
    double speed = 0;
    int durationSeconds = _calcDuration().inSeconds;
    double distanceKm = _calcDistance();

    if (durationSeconds > 0) {
      speed = distanceKm / (durationSeconds / 60);
    }

    return speed;
  }

  double calcAbsAcceleration(obs) {
    return sqrt(pow(obs.accelerometerX ?? 0, 2) +
        pow(obs.accelerometerY ?? 0, 2) +
        pow(obs.accelerometerZ ?? 0, 2));
  }

  double _calcAvgAbsAcceleration() {
    double avgAbsAcc = 0;
    List<double> absAcc = <double>[];

    if (rideData.isNotEmpty) {
      rideData.asMap().forEach((idx, obs) {
        absAcc.add(calcAbsAcceleration(obs));
      });

      avgAbsAcc =
          absAcc.reduce((value, element) => value + element) / absAcc.length;
    }

    return (avgAbsAcc / gravity);
  }

  double _calcMaxAbsAcceleration() {
    double maxAbsAcc = 0;

    if (rideData.isNotEmpty) {
      rideData.asMap().forEach((idx, obs) {
        maxAbsAcc = max(maxAbsAcc, calcAbsAcceleration(obs));
      });
    }

    return (maxAbsAcc / gravity);
  }

  double _calcStdDevAcceleration() {
    double stdDevAcc = 0;
    List<double> absAcc = <double>[];

    if (rideData.isNotEmpty) {
      rideData.asMap().forEach((idx, obs) {
        absAcc.add(calcAbsAcceleration(obs));
      });

      // Calculate standard deviation
      double mean = _calcAvgAbsAcceleration();
      double sqDiff =
          absAcc.reduce((value, element) => value + pow((element - mean), 2));
      stdDevAcc = sqrt(sqDiff / absAcc.length);
    }

    return (stdDevAcc / gravity);
  }
}
