import 'dart:async';
// import 'dart:convert';

import 'package:driverapp/src/ride/data/model/model.dart';
import 'package:driverapp/src/ride/data/provider/provider.dart';

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
      super.accelerometerX = sensorData[0];
      super.accelerometerY = sensorData[1];
      super.accelerometerZ = sensorData[2];

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

  double? lastLocationLat;
  double? lastLocationLong;
  Duration elapsedSeconds = const Duration();

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
      );
      elapsedSeconds = DateTime.now().difference(sensorData.timestamp);
      rideDataStreamController.add(sensorData);
      rideData.addData(sensorData);
      _dataBuffer = _SensorDataBuffer();
    }
  }

  void startRide() async {
    // A StreamController can only be listened once in a lifecycle (even after the subscription is cancelled)
    // This ensures rideDataStreamController is never listened to initially
    rideDataStreamController = StreamController<SensorData>();

    // Sensors must be fully initialized before proceeding
    await sensorController.initSensors();

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

    // Location data only updates on position change
    locationSubscription = sensorController.locationStream?.listen(
      (event) {
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
