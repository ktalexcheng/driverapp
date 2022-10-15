import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:trailbrake/src/ride/data/data.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    rideDataClient = RideDataAPI();

    on<DashboardCatalogRequested>(_onRideCatalogRequested);
    on<DashboardDataRequested>(_onRideDataRequested);
  }

  late RideDataAPI rideDataClient;
  late List<RideMeta> allRides;

  Future<void> _onRideCatalogRequested(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardGetCatalogInProgress());

    allRides = await rideDataClient.fetchRideCatalog();

    emit(DashboardGetCatalogSuccess(rideCatalog: allRides));
  }

  Future<void> _onRideDataRequested(
      DashboardDataRequested event, Emitter<DashboardState> emit) async {
    Ride ride = await rideDataClient.fetchRideData(event.rideId);

    emit(DashboardGetRideSuccess(fetchedRide: ride));
  }
}
