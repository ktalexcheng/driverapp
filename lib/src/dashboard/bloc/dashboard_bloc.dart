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
    on<DashboardDeleteRideRequested>(_onDeleteRideRequested);
  }

  late RideDataAPI rideDataClient;
  // late List<RideMeta> allRides;

  Future<void> _onRideCatalogRequested(
      DashboardCatalogRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardGetCatalogInProgress());

    APIResponse response = await rideDataClient.fetchRideCatalog();

    if (response.httpCode == 200) {
      emit(DashboardGetCatalogSuccess(rideCatalog: response.responseBody));
    } else {
      emit(DashboardGetCatalogFailure());
    }
  }

  Future<void> _onRideDataRequested(
      DashboardDataRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardGetRideInProgress());

    APIResponse response = await rideDataClient.fetchRideData(event.rideId);

    if (response.httpCode == 200) {
      emit(DashboardGetRideSuccess(fetchedRide: response.responseBody));
    } else {
      emit(DashboardGetRideFailure());
    }
  }

  Future<void> _onDeleteRideRequested(
      DashboardDeleteRideRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardDeleteRideInProgress());

    APIResponse response = await rideDataClient.deleteRideData(event.rideId);

    if (response.httpCode == 200) {
      emit(DashboardDeleteRideSuccess());
    } else {
      emit(DashboardDeleteRideFailure());
    }
  }
}
