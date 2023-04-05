import 'dart:math';

import 'package:geolocator/geolocator.dart';

import 'package:trailbrake/src/ride/data/model/sensor_data.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideData with RideDataMixin {
  RideData({rideData}) {
    if (rideData is List<SensorData>) {
      super.data = rideData;
    } else {
      super.data = <SensorData>[];
    }
  }

  // RideData.fromJson(List<dynamic> jsonList) {
  //   List<SensorData> _data = <SensorData>[];
  //   if (jsonList.isNotEmpty) {
  //     for (var data in jsonList) {
  //       _data.add(SensorData.fromJson(data));
  //     }
  //   }

  //   super.data = _data;
  // }

  // List<Map<String, dynamic>> toJson() {
  //   List<Map<String, dynamic>> _rideDataJson = [];

  //   for (var element in data) {
  //     _rideDataJson.add(element.toJson());
  //   }

  //   return _rideDataJson;
  // }
}

mixin RideDataMixin {
  late List<SensorData> data;

  void addData(SensorData datum) {
    data.add(datum);
  }

  // Metrics calculation
  int get observations => _calcObservations();
  Duration get duration => _calcDuration();
  double get distance => _calcDistance();
  double get avgSpeed => _calcAvgSpeed();
  double get avgMovingSpeed => _calcAvgMovingSpeed();
  double get avgAbsAcceleration => _calcAvgAbsAcceleration();
  double get maxAbsAcceleration => _calcMaxAbsAcceleration();
  double get stdDevAcceleration => _calcStdDevAcceleration();
  int get length => data.length;
  SensorData get first => data.first;
  SensorData get last => data.last;
  Duration get elapsedSeconds => _calcElapsedSeconds();

  int _calcObservations() {
    int obs = 0;

    if (data.isNotEmpty) {
      obs = data.length;
    }

    return obs;
  }

  Duration _calcDuration() {
    Duration duration = const Duration();

    if (data.isNotEmpty) {
      DateTime startTime = data.first.timestamp;
      DateTime endTime = data.last.timestamp;

      duration = endTime.difference(startTime);
    }

    return duration;
  }

  double _calcDistance() {
    double distance = 0;

    if (data.isNotEmpty) {
      data.asMap().forEach((idx, obs) {
        if (idx > 0) {
          double startLat = data[idx - 1].locationLat ?? 0;
          double startLong = data[idx - 1].locationLong ?? 0;
          double endLat = data[idx].locationLat ?? 0;
          double endLong = data[idx].locationLong ?? 0;

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
      speed = distanceKm / (durationSeconds / 3600);
    }

    return speed;
  }

  double _calcAvgMovingSpeed() {
    double movingSpeed = 0;
    double distance = 0;
    Duration duration = const Duration();

    if (data.isNotEmpty) {
      double? lastLat = data.first.locationLat;
      double? lastLong = data.first.locationLong;
      DateTime lastTimestamp = data.first.timestamp;

      data.asMap().forEach((idx, obs) {
        if (idx > 0) {
          double? newLat = data[idx].locationLat;
          double? newLong = data[idx].locationLong;
          DateTime newTimestamp = data[idx].timestamp;

          if (newLat != null && newLong != null) {
            if (lastLat != null && lastLong != null) {
              double _distanceMoved = Geolocator.distanceBetween(
                  lastLat!, lastLong!, newLat, newLong);
              Duration _duration = newTimestamp.difference(lastTimestamp);

              if (_distanceMoved > 1) {
                // Only consider data when movement occurs (> 1 meter)
                distance += _distanceMoved;
                duration += _duration;

                lastLat = newLat;
                lastLong = newLong;
                lastTimestamp = newTimestamp;
              } else if (_duration.inSeconds > 3) {
                // Under no movement, still update timestamp every 3 seconds
                // as GPS data only updates when movement occurs
                lastTimestamp = data[idx].timestamp;
              }
            } else {
              lastLat = newLat;
              lastLong = newLong;
              lastTimestamp = newTimestamp;
            }
          }
        }
      });

      movingSpeed = (distance / 1000) / (duration.inSeconds / 3600);
    }

    return movingSpeed;
  }

  double _calcAbsAcceleration(obs) {
    return sqrt(pow(obs.accelerometerX ?? 0, 2) +
        pow(obs.accelerometerY ?? 0, 2) +
        pow(obs.accelerometerZ ?? 0, 2));
  }

  double _calcAvgAbsAcceleration() {
    double avgAbsAcc = 0;
    List<double> absAcc = <double>[];

    if (data.isNotEmpty) {
      data.asMap().forEach((idx, obs) {
        absAcc.add(_calcAbsAcceleration(obs));
      });

      avgAbsAcc =
          absAcc.reduce((value, element) => value + element) / absAcc.length;
    }

    return (avgAbsAcc / constants.gravity);
  }

  double _calcMaxAbsAcceleration() {
    double maxAbsAcc = 0;

    if (data.isNotEmpty) {
      data.asMap().forEach((idx, obs) {
        maxAbsAcc = max(maxAbsAcc, _calcAbsAcceleration(obs));
      });
    }

    return (maxAbsAcc / constants.gravity);
  }

  double _calcStdDevAcceleration() {
    double stdDevAcc = 0;
    List<double> absAcc = <double>[];

    if (data.isNotEmpty) {
      data.asMap().forEach((idx, obs) {
        absAcc.add(_calcAbsAcceleration(obs));
      });

      // Calculate standard deviation
      double mean = _calcAvgAbsAcceleration();
      double sqDiff =
          absAcc.reduce((value, element) => value + pow((element - mean), 2));
      stdDevAcc = sqrt(sqDiff / absAcc.length);
    }

    return (stdDevAcc / constants.gravity);
  }

  Duration _calcElapsedSeconds() {
    Duration _elapsedSeconds = const Duration();

    if (_calcObservations() > 0) {
      _elapsedSeconds = last.timestamp.difference(first.timestamp);
    }

    return _elapsedSeconds;
  }
}
