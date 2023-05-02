import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:csv/csv.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:trailbrake/src/ride/data/model/model.dart';
import 'package:trailbrake/src/ride/data/provider/provider.dart';

class _SensorDataBuffer extends SensorData {
  _SensorDataBuffer()
      : accelDataReceived = false,
        gyroDataReceived = false,
        rotationDataReceived = false;

  late bool accelDataReceived;
  late bool gyroDataReceived;
  late bool rotationDataReceived;

  bool ifBufferFull() {
    if (accelDataReceived && gyroDataReceived && rotationDataReceived) {
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

  set rotationData(List<double> sensorData) {
    if (!rotationDataReceived) {
      super.rotationX = sensorData[0];
      super.rotationY = sensorData[1];
      super.rotationZ = sensorData[2];
      super.rotationW = sensorData[3];

      rotationDataReceived = true;
    }
  }

  set locationData(dynamic sensorData) {
    super.locationLat = sensorData.latitude;
    super.locationLong = sensorData.longitude;
  }
}

class ActiveRideRepository {
  ActiveRideRepository(this.sensorController);

  // ActiveRideRepository.fromJson(Map<String, dynamic> json) {
  //   json.forEach(
  //     (key, value) {
  //       rideData.addData(SensorData.fromJson(value));
  //     },
  //   );
  // }

  StreamController<SensorData> rideDataStreamController =
      StreamController<SensorData>();
  _SensorDataBuffer _dataBuffer = _SensorDataBuffer();
  RideData rideData = RideData();

  // SensorAPI sensorController = SensorAPI();
  SensorAPI sensorController;
  StreamSubscription? accelSubscription;
  StreamSubscription? gyroSubscription;
  StreamSubscription? rotationSubscription;
  StreamSubscription? locationSubscription;

  double lastLocationLat = 0;
  double lastLocationLong = 0;
  // Duration elapsedSeconds = const Duration();
  bool locationUpdated = false;
  LatLng initialLatLng = const LatLng(0, 0);

  Future<bool> initRide() async {
    // TODO: DEBUG ONLY
    var extStoragePermission = await Permission.storage.status;
    while (true) {
      if (!extStoragePermission.isGranted) {
        await Permission.storage.request();
      } else {
        break;
      }
    }
    // TODO: DEBUG ONLY

    // Sensors must be fully initialized before proceeding
    bool sensorsReady = await sensorController.checkSensors();
    if (sensorsReady) {
      await sensorController.initSensors();

      // Get current location
      Position nowLocation = await sensorController.getCurrentLocation();
      initialLatLng = LatLng(nowLocation.latitude, nowLocation.longitude);
      lastLocationLat = nowLocation.latitude;
      lastLocationLong = nowLocation.longitude;

      return Future.value(true);
    }

    return Future.value(false);
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
        rotationX: _dataBuffer.rotationX,
        rotationY: _dataBuffer.rotationY,
        rotationZ: _dataBuffer.rotationZ,
        rotationW: _dataBuffer.rotationW,
        locationLat: lastLocationLat,
        locationLong: lastLocationLong,
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

    rotationSubscription = sensorController.rotationStream?.listen(
      (event) {
        _addRotDataToBuffer(event);
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

    if (rotationSubscription != null) {
      rotationSubscription?.cancel();
      rotationSubscription = null;
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

  void dumpToLocalStorage(String rideName) async {
    final rideDataList = [
      [
        "timestamp",
        "gyroscopeX",
        "gyroscopeY",
        "gyroscopeZ",
        "accelerometerX",
        "accelerometerY",
        "accelerometerZ",
        "rotationX",
        "rotationY",
        "rotationZ",
        "rotationW",
        "locationLat",
        "locationLong",
      ],
      ...rideData.data.map((r) => [
            r.timestamp.toUtc().toIso8601String(),
            r.gyroscopeX,
            r.gyroscopeY,
            r.gyroscopeZ,
            r.accelerometerX,
            r.accelerometerY,
            r.accelerometerZ,
            r.rotationX,
            r.rotationY,
            r.rotationZ,
            r.rotationW,
            r.locationLat,
            r.locationLong,
          ])
    ];
    String csvData = const ListToCsvConverter().convert(rideDataList);

    // final saveDir = (await getApplicationDocumentsDirectory()).path;
    final saveDir = Directory('/storage/emulated/0/Download')
        .path; // TODO: This only works on Android
    final savePath =
        "$saveDir/tb_${DateTime.now().millisecondsSinceEpoch}_$rideName.csv";
    final saveFile = File(savePath);
    await saveFile.writeAsString(csvData);
  }

  // void _addAccelDataToBuffer(sensorEvent) {
  //   _dataBuffer.accelerometerData = sensorEvent.data;
  // }

  // void _addGyroDataToBuffer(sensorEvent) {
  //   _dataBuffer.gyroscopeData = sensorEvent.data;
  // }

  void _addAccelDataToBuffer(sensorEvent) {
    _dataBuffer.accelerometerData = [
      sensorEvent.x,
      sensorEvent.y,
      sensorEvent.z,
    ];
  }

  void _addGyroDataToBuffer(sensorEvent) {
    _dataBuffer.gyroscopeData = [
      sensorEvent.x,
      sensorEvent.y,
      sensorEvent.z,
    ];
  }

  void _addRotDataToBuffer(sensorEvent) {
    _dataBuffer.rotationData = [
      sensorEvent.data[0],
      sensorEvent.data[1],
      sensorEvent.data[2],
      sensorEvent.data[3],
    ];
  }

  void _addLocDataToBuffer(sensorEvent) {
    lastLocationLat = sensorEvent.latitude;
    lastLocationLong = sensorEvent.longitude;
    _dataBuffer.locationData = sensorEvent;
  }
}
