part of 'app_navigation_cubit.dart';

// Following naming convention outlined here:
// https://bloclibrary.dev/#/blocnamingconventions?id=event-conventions
@immutable
abstract class AppNavigationState {}

class AppNavigationInitial extends AppNavigationState {}

// class AppNavigationLoadDashboardInProgress extends AppNavigationState {}

class AppNavigationLoadDashboardSuccess extends AppNavigationState {}

// class AppNavigationLoadDashboardFailure extends AppNavigationState {}

// class AppNavigationStartRideInProgress extends AppNavigationState {}

class AppNavigationLoadRideSuccess extends AppNavigationState {}

// class AppNavigationStartRideFailure extends AppNavigationState {}

// class AppNavigationLoadProfileInProgress extends AppNavigationState {}

class AppNavigationLoadProfileSuccess extends AppNavigationState {}

// class AppNavigationLoadProfileFailure extends AppNavigationState {}
