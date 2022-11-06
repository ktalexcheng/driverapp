import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trailbrake/src/ride/data/model/model.dart';
import 'package:trailbrake/src/ride/data/provider/provider.dart';

class _SensorDataBuffer extends SensorData {
  _SensorDataBuffer()
      : accelDataReceived = false,
        gyroDataReceived = false;

  late bool accelDataReceived;
  late bool gyroDataReceived;

  bool ifBufferFull() {
    if (accelDataReceived && gyroDataReceived) {
      timestamp = DateTime.now();
      return true;
    } else {
      return false;
    }
  }

  set accelerometerData(List<double> sensorData) {
    if (!accelDataReceived) {
      super.accelerometerX = sensorData[2];
      super.accelerometerY = sensorData[0];
      super.accelerometerZ = sensorData[1];

      accelDataReceived = true;
    }
  }

  set gyroscopeData(List<double> sensorData) {
    if (!gyroDataReceived) {
      super.gyroscopeX = sensorData[0];
      super.gyroscopeY = sensorData[1];
      super.gyroscopeZ = sensorData[2];

      gyroDataReceived = true;
    }
  }

  set locationData(dynamic sensorData) {
    super.locationLat = sensorData.latitude;
    super.locationLong = sensorData.longitude;
  }
}

class ActiveRideRepository {
  ActiveRideRepository();

  ActiveRideRepository.fromJson(Map<String, dynamic> json) {
    json.forEach(
      (key, value) {
        rideData.addData(SensorData.fromJson(value));
      },
    );
  }

  StreamController<SensorData> rideDataStreamController =
      StreamController<SensorData>();
  _SensorDataBuffer _dataBuffer = _SensorDataBuffer();
  RideData rideData = RideData();

  SensorAPI sensorController = SensorAPI();
  StreamSubscription? accelSubscription;
  StreamSubscription? gyroSubscription;
  StreamSubscription? locationSubscription;

  // double lastLocationLat = 0;
  // double lastLocationLong = 0;
  // Duration elapsedSeconds = const Duration();
  bool locationUpdated = false;
  LatLng initialLatLng = const LatLng(0, 0);

  Future<void> initRide() async {
    // Sensors must be fully initialized before proceeding
    await sensorController.initSensors();

    // Get current location
    Position nowLocation = await sensorController.getCurrentLocation();
    initialLatLng = LatLng(nowLocation.latitude, nowLocation.longitude);
  }

  void addDataToRide() {
    if (_dataBuffer.ifBufferFull()) {
      SensorData sensorData = SensorData(
        timestamp: _dataBuffer.timestamp,
        accelerometerX: _dataBuffer.accelerometerX,
        accelerometerY: _dataBuffer.accelerometerY,
        accelerometerZ: _dataBuffer.accelerometerZ,
        gyroscopeX: _dataBuffer.gyroscopeX,
        gyroscopeY: _dataBuffer.gyroscopeY,
        gyroscopeZ: _dataBuffer.gyroscopeZ,
        locationLat: _dataBuffer.locationLat,
        locationLong: _dataBuffer.locationLong,
        locationUpdated: locationUpdated,
      );

      rideData.addData(sensorData);
      sensorData.elapsedSeconds = rideData.elapsedSeconds;

      // if (rideData.observations > 0) {
      //   elapsedSeconds =
      //       sensorData.timestamp.difference(rideData.first.timestamp);
      // }

      rideDataStreamController.add(sensorData);

      _dataBuffer = _SensorDataBuffer();
      locationUpdated = false;
    }
  }

  void startRide() async {
    // A StreamController can only be listened once in a lifecycle (even after the subscription is cancelled)
    // This ensures rideDataStreamController is never listened to initially
    rideDataStreamController = StreamController<SensorData>();

    accelSubscription = sensorController.accelStream?.listen(
      (event) {
        _addAccelDataToBuffer(event);
        addDataToRide();
      },
    );

    gyroSubscription = sensorController.gyroStream?.listen(
      (event) {
        _addGyroDataToBuffer(event);
        addDataToRide();
      },
    );

    // Location data only updates on location change
    locationSubscription = sensorController.locationStream?.listen(
      (event) {
        locationUpdated = true;
        _addLocDataToBuffer(event);
        addDataToRide();
      },
    );
  }

  void stopRide() {
    if (accelSubscription != null) {
      accelSubscription?.cancel();
      accelSubscription = null;
    }

    if (gyroSubscription != null) {
      gyroSubscription?.cancel();
      gyroSubscription = null;
    }

    if (locationSubscription != null) {
      locationSubscription?.cancel();
      locationSubscription = null;
    }

    rideDataStreamController.close();
  }

  void clearRideData() {
    _dataBuffer = _SensorDataBuffer();
    rideData = RideData();
  }

  void _addAccelDataToBuffer(sensorEvent) {
    _dataBuffer.accelerometerData = sensorEvent.data;
  }

  void _addGyroDataToBuffer(sensorEvent) {
    _dataBuffer.gyroscopeData = sensorEvent.data;
  }

  void _addLocDataToBuffer(sensorEvent) {
    _dataBuffer.locationData = sensorEvent;
  }
}
