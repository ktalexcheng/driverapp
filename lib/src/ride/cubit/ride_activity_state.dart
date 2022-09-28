part of 'ride_activity_cubit.dart';

enum RideActivityStatus { ready, running, paused, saving }

class RideActivityState {
  RideActivityState({
    required this.status,
    rideData,
  }) {
    this.rideData = rideData ?? RideData();
  }

  RideActivityStatus status;
  late RideData rideData;
}
