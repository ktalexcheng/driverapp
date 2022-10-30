part of 'ride_details_bloc.dart';

@immutable
abstract class RideDetailsEvent {}

class RideDetailsGetRequested extends RideDetailsEvent {
  RideDetailsGetRequested(this.rideId);

  final String rideId;
}

class RideDetailsDeleteRequested extends RideDetailsEvent {
  RideDetailsDeleteRequested(this.rideId);

  final String rideId;
}
