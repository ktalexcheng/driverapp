part of 'ride_history_bloc.dart';

// Following naming convention outlined here:
// https://bloclibrary.dev/#/blocnamingconventions?id=event-conventions
@immutable
abstract class RideHistoryEvent {}

class RideHistoryStarted extends RideHistoryEvent {}

class RideHistoryCatalogRequested extends RideHistoryEvent {}

class RideHistoryLastRideDataRequested extends RideHistoryEvent {}
