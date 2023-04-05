part of 'ride_activity_cubit.dart';

@immutable
abstract class RideActivityState {}

class RideActivityInitial extends RideActivityState {}

class RideActivityPrepareSuccess extends RideActivityState {
  RideActivityPrepareSuccess({required this.initialLocation});

  final LatLng initialLocation;
}

class RideActivityNewRideInProgress extends RideActivityState {
  RideActivityNewRideInProgress(
      {required this.newSensorData, required this.rideData});

  final SensorData newSensorData;
  final RideData rideData;
}

class RideActivityPaused extends RideActivityState {}

class RideActivitySaveInProgress extends RideActivityState {}

class RideActivitySaveSuccess extends RideActivityState {
  RideActivitySaveSuccess({required this.rideScore});

  final RideScore rideScore;
}

class RideActivitySaveFailure extends RideActivityState {}

// enum RideActivityStatus {
//   initial,
//   ready,
//   running,
//   paused,
//   saving,
//   saved,
//   error,
// }

// class RideActivityState {
//   RideActivityState({
//     required this.status,
//     newSensorData,
//     elapsedSeconds,
//     nowLocation,
//     locationUpdate,
//     this.rideScore,
//   }) {
//     this.newSensorData = newSensorData ?? SensorData();
//     this.elapsedSeconds = elapsedSeconds ?? const Duration();
//     this.nowLocation = nowLocation ?? const LatLng(0, 0);
//   }

//   RideActivityStatus status;
//   late SensorData newSensorData;
//   late Duration elapsedSeconds;
//   late LatLng nowLocation;
//   late bool locationUpdated;
//   RideScore? rideScore;
// }
