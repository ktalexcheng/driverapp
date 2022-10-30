part of 'ride_details_bloc.dart';

@immutable
abstract class RideDetailsState {
  SavedRide get savedRide;
}

class RideDetailsInitial extends RideDetailsState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideDetailsGetInProgress extends RideDetailsState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideDetailsGetSuccess extends RideDetailsState {
  RideDetailsGetSuccess({required this.savedRide});

  @override
  final SavedRide savedRide;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideDetailsGetFailure extends RideDetailsState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideDetailsDeleteInProgress extends RideDetailsState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideDetailsDeleteSuccess extends RideDetailsState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideDetailsDeleteFailure extends RideDetailsState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
