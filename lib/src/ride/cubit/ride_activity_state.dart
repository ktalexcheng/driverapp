part of 'ride_activity_cubit.dart';

enum RideActivityStatus { ready, running, paused, saving, saved, error }

class RideActivityState {
  RideActivityState({
    required this.status,
    newSensorData,
    elapsedSeconds,
    this.rideScore,
  }) {
    this.newSensorData = newSensorData ?? SensorData();
    this.elapsedSeconds = elapsedSeconds ?? const Duration();
  }

  RideActivityStatus status;
  late SensorData newSensorData;
  late Duration elapsedSeconds;
  RideScore? rideScore;
}
