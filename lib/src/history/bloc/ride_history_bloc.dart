import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:driverapp/src/ride/data/data.dart';

part 'ride_history_event.dart';
part 'ride_history_state.dart';

class RideHistoryBloc extends Bloc<RideHistoryEvent, RideHistoryState> {
  RideHistoryBloc() : super(RideHistoryInitial()) {
    driverAppDBClient = DriverAppDBAPI();

    on<RideHistoryCatalogRequested>(_onRideCatalogRequested);
    // on<RideHistoryLastRideDataRequested>(_onLastRideDataRequested);
    on<RideHistoryRideDataRequested>(_onRideDataRequested);
  }

  late DriverAppDBAPI driverAppDBClient;
  late List<RideMeta> allRides;

  Future<void> _onRideCatalogRequested(
      RideHistoryEvent event, Emitter<RideHistoryState> emit) async {
    emit(RideHistoryGetCatalogInProgress());

    allRides = await driverAppDBClient.fetchRideCatalog();

    emit(RideHistoryGetCatalogSuccess(rideCatalog: allRides));
  }

  // Future<void> _onLastRideDataRequested(
  //     RideHistoryEvent event, Emitter<RideHistoryState> emit) async {
  //   List<RideMeta> allRides = await driverAppDBClient.fetchRideCatalog();
  //   emit(RideHistoryGetRideInProgress());

  //   // bool historyFound = allRides.isNotEmpty ? true : false;

  //   if (allRides.isNotEmpty) {
  //     Ride ride = await driverAppDBClient.fetchRideData(allRides.first.id!);

  //     emit(RideHistoryGetRideSuccess(fetchedRide: ride));
  //   } else {
  //     emit(RideHistoryGetRideFailure());
  //   }
  // }

  Future<void> _onRideDataRequested(RideHistoryRideDataRequested event,
      Emitter<RideHistoryState> emit) async {
    Ride ride = await driverAppDBClient.fetchRideData(event.rideId);

    emit(RideHistoryGetRideSuccess(fetchedRide: ride));
  }
}
