import 'dart:async';

import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:geolocator/geolocator.dart';

class SensorAPI {
  AccelerometerSensor accelSensor = AccelerometerSensor();
  Stream? accelStream;

  GyroscopeSensor gyroSensor = GyroscopeSensor();
  Stream? gyroStream;

  LocationSensor locationSensor = LocationSensor();
  Stream? locationStream;

  late bool accelAvailable;
  late bool gyroAvailable;
  late bool locationAvailable;

  late bool accelRunning;
  late bool gyroRunning;
  late bool locationRunning;

  Future<bool> checkSensors() async {
    accelAvailable = await accelSensor.checkAccelerometerStatus();
    gyroAvailable = await gyroSensor.checkGyroscopeStatus();
    locationAvailable = await locationSensor.checkLocationStatus();

    return accelAvailable && gyroAvailable && locationAvailable;
  }

  Future<void> initSensors() async {
    if (await checkSensors()) {
      accelStream = await accelSensor.getAccelerometerStream();
      gyroStream = await gyroSensor.getGyroscopeStream();
      locationStream = await locationSensor.getLocationStream();

      accelRunning = true;
      gyroRunning = true;
      locationRunning = true;
    }
  }
}

// Accelerometer utilities
class AccelerometerSensor {
  AccelerometerSensor() : sensorStatus = Future.value(false) {
    sensorStatus = checkAccelerometerStatus();
  }

  Future<bool> sensorStatus;
  Stream? accelStream;

  Future<bool> checkAccelerometerStatus() async {
    return await SensorManager().isSensorAvailable(Sensors.LINEAR_ACCELERATION);
  }

  Future<Stream?> getAccelerometerStream() async {
    if (await sensorStatus) {
      Stream accelStream = await SensorManager().sensorUpdates(
        sensorId: Sensors.LINEAR_ACCELERATION,
        interval: Sensors.SENSOR_DELAY_FASTEST,
      );

      return accelStream;
    } else {
      return null;
    }
  }
}

// Gyroscope utilities
class GyroscopeSensor {
  GyroscopeSensor() : sensorStatus = Future.value(false) {
    sensorStatus = checkGyroscopeStatus();
  }

  Future<bool> sensorStatus;
  Stream? gyroStream;

  Future<bool> checkGyroscopeStatus() async {
    return await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);
  }

  Future<Stream?> getGyroscopeStream() async {
    if (await sensorStatus) {
      Stream gyroStream = await SensorManager().sensorUpdates(
        sensorId: Sensors.GYROSCOPE,
        interval: Sensors.SENSOR_DELAY_FASTEST,
      );

      return gyroStream;
    } else {
      return null;
    }
  }
}

// Location utilities
class LocationSensor {
  LocationSensor() : sensorStatus = Future.value(false) {
    sensorStatus = checkLocationStatus();
  }

  bool locationEnabled = false;
  Future<bool> sensorStatus;
  Stream? locationStream;

  Future<bool> checkLocationStatus() async {
    locationEnabled = await Geolocator.isLocationServiceEnabled();

    if (locationEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return false;
        }
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      }
    }

    return false;
  }

  Future<Stream?> getLocationStream() async {
    if (await sensorStatus) {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );

      Stream locationStream =
          Geolocator.getPositionStream(locationSettings: locationSettings);

      return locationStream;
    } else {
      return null;
    }
  }
}
