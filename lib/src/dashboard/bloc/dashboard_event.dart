part of 'dashboard_bloc.dart';

// Following naming convention outlined here:
// https://bloclibrary.dev/#/blocnamingconventions?id=event-conventions
@immutable
abstract class DashboardEvent {}

class DashboardStarted extends DashboardEvent {}

class DashboardCatalogRequested extends DashboardEvent {}

class DashboardUserLogout extends DashboardEvent {}
