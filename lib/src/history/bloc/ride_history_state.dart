part of 'ride_history_bloc.dart';

// Following naming convention outlined here:
// https://bloclibrary.dev/#/blocnamingconventions?id=state-conventions
@immutable
abstract class RideHistoryState {
  List<RideMeta> get rideCatalog;
  Ride get fetchedRide;
}

class RideHistoryInitial extends RideHistoryState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideHistoryGetCatalogSuccess extends RideHistoryState {
  RideHistoryGetCatalogSuccess({
    required this.rideCatalog,
  }) {
    _sortRideCatalog;
  }

  @override
  final List<RideMeta> rideCatalog;

  void _sortRideCatalog([int Function(dynamic, dynamic)? compare]) {
    if (compare != null) {
      rideCatalog.sort(compare);
    } else {
      rideCatalog.sort((a, b) => a.rideDate.compareTo(b.rideDate));
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideHistoryGetLastRideSuccess extends RideHistoryState {
  RideHistoryGetLastRideSuccess({
    required this.fetchedRide,
  });

  @override
  final Ride fetchedRide;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RideHistoryGetLastRideFailure extends RideHistoryState {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// enum RideHistoryStatus { initial, loading, success, failure }

// class RideHistoryState {
//   RideHistoryState({
//     this.status = RideHistoryStatus.initial,
//     rideCatalog,
//     fetchedRide,
//   }) {
//     if (rideCatalog != null) {
//       rideCatalogFetched = true;
//       this.rideCatalog = rideCatalog;
//       _sortRideCatalog();
//     }

//     if (fetchedRide != null) {
//       rideDataFetched = true;
//       this.fetchedRide = fetchedRide;
//     }
//   }

//   final RideHistoryStatus status;

//   bool rideCatalogFetched = false;
//   List<RideMeta> rideCatalog = <RideMeta>[];

//   bool rideDataFetched = false;
//   Ride? fetchedRide;

//   void _sortRideCatalog([int Function(dynamic, dynamic)? compare]) {
//     if (compare != null) {
//       rideCatalog.sort(compare);
//     } else {
//       rideCatalog.sort((a, b) => a.rideDate.compareTo(b.rideDate));
//     }
//   }
// }
