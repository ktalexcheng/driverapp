part of 'app_navigation_cubit.dart';

// Following naming convention outlined here:
// https://bloclibrary.dev/#/blocnamingconventions?id=event-conventions
@immutable
abstract class AppNavigationState {}

class AppNavigationInitial extends AppNavigationState {}

class AppNavigationLoadHistoryInProgress extends AppNavigationState {}

class AppNavigationLoadHistorySuccess extends AppNavigationState {}

class AppNavigationLoadHistoryFailure extends AppNavigationState {}

class AppNavigationStartNewRideInProgress extends AppNavigationState {}

class AppNavigationStartNewRideSuccess extends AppNavigationState {}

class AppNavigationStartNewRideFailure extends AppNavigationState {}
