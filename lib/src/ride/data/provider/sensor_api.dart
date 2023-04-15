import 'dart:async';

// import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:sensors_plus/sensors_plus.dart' as sp;
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
    accelAvailable = await accelSensor.checkSensor();
    gyroAvailable = await gyroSensor.checkSensor();
    locationAvailable = await locationSensor.checkLocationStatus();

    return accelAvailable && gyroAvailable && locationAvailable;
  }

  Future<void> initSensors() async {
    if (accelAvailable) {
      accelStream = accelSensor.sensorStream;
      accelRunning = true;
    }
    if (gyroAvailable) {
      gyroStream = gyroSensor.sensorStream;
      gyroRunning = true;
    }
    if (locationAvailable) {
      locationStream = await locationSensor.getLocationStream();
      locationRunning = true;
    }
  }

  Future<Position> getCurrentLocation() => locationSensor.getCurrentLocation();
  Future<Position?> getLastLocation() => locationSensor.getLastLocation();
}

// Accelerometer utilities
// class AccelerometerSensor {
//   AccelerometerSensor() : sensorStatus = Future.value(false) {
//     sensorStatus = checkAccelerometerStatus();
//   }

//   Future<bool> sensorStatus;
//   Stream? accelStream;

//   Future<bool> checkAccelerometerStatus() async {
//     return await SensorManager().isSensorAvailable(Sensors.LINEAR_ACCELERATION);
//   }

//   Future<Stream?> getAccelerometerStream() async {
//     if (await sensorStatus) {
//       Stream accelStream = await SensorManager().sensorUpdates(
//         sensorId: Sensors.LINEAR_ACCELERATION,
//         interval: Sensors.SENSOR_DELAY_FASTEST,
//       );

//       return accelStream;
//     } else {
//       return null;
//     }
//   }
// }

class AccelerometerSensor {
  AccelerometerSensor() : sensorAvailable = false;

  bool sensorAvailable;
  Stream? sensorStream;

  Future<bool> checkSensor() async {
    try {
      sensorAvailable = !(await sp.userAccelerometerEvents.isEmpty);
    } on Error {
      // Catch error when sensor stream is empty (not available)
      sensorAvailable = false;
    }

    if (sensorAvailable) {
      sensorStream = sp.userAccelerometerEvents;
    }

    return sensorAvailable;
  }
}

// Gyroscope utilities
// class GyroscopeSensor {
//   GyroscopeSensor() : sensorStatus = Future.value(false) {
//     sensorStatus = checkGyroscopeStatus();
//   }

//   Future<bool> sensorStatus;
//   Stream? gyroStream;

//   Future<bool> checkGyroscopeStatus() async {
//     return await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);
//   }

//   Future<Stream?> getGyroscopeStream() async {
//     if (await sensorStatus) {
//       Stream gyroStream = await SensorManager().sensorUpdates(
//         sensorId: Sensors.GYROSCOPE,
//         interval: Sensors.SENSOR_DELAY_FASTEST,
//       );

//       return gyroStream;
//     } else {
//       return null;
//     }
//   }
// }

class GyroscopeSensor {
  GyroscopeSensor() : sensorAvailable = false;

  bool sensorAvailable;
  Stream? sensorStream;

  Future<bool> checkSensor() async {
    try {
      sensorAvailable = !(await sp.gyroscopeEvents.isEmpty);
    } on Error {
      // Catch error when sensor stream is empty (not available)
      sensorAvailable = false;
    }

    if (sensorAvailable) {
      sensorStream = sp.gyroscopeEvents;
    }

    return sensorAvailable;
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

  static LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );

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
      Stream locationStream =
          Geolocator.getPositionStream(locationSettings: locationSettings);

      return locationStream;
    } else {
      return null;
    }
  }

  Future<Position> getCurrentLocation() async {
    Position nowLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    return nowLocation;
  }

  Future<Position?> getLastLocation() async {
    Position? lastLocation = await Geolocator.getLastKnownPosition();

    return lastLocation;
  }
}
