import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:driverapp/src/ride/data/data.dart';

part 'ride_history_event.dart';
part 'ride_history_state.dart';

class RideHistoryBloc extends Bloc<RideHistoryEvent, RideHistoryState> {
  RideHistoryBloc() : super(RideHistoryInitial()) {
    driverAppDBClient = DriverAppDBAPI();

    on<RideHistoryCatalogRequested>(_onRideCatalogRequested);
    on<RideHistoryLastRideDataRequested>(_onLastRideDataRequested);
  }

  late DriverAppDBAPI driverAppDBClient;
  late List<RideMeta> allRides;

  Future<void> _onRideCatalogRequested(
      RideHistoryEvent event, Emitter<RideHistoryState> emit) async {
    emit(RideHistoryGetCatalogInProgress());

    allRides = await driverAppDBClient.fetchRideCatalog();

    emit(RideHistoryGetCatalogSuccess(rideCatalog: allRides));
  }

  Future<void> _onLastRideDataRequested(
      RideHistoryEvent event, Emitter<RideHistoryState> emit) async {
    List<RideMeta> allRides = await driverAppDBClient.fetchRideCatalog();
    emit(RideHistoryGetLastRideInProgress());

    bool historyFound = allRides.isNotEmpty ? true : false;

    if (historyFound) {
      Ride ride = await driverAppDBClient.fetchRideData(allRides.first.id!);

      emit(RideHistoryGetLastRideSuccess(fetchedRide: ride));
    } else {
      emit(RideHistoryGetLastRideFailure());
    }
  }
}
