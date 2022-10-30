import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:trailbrake/src/ride/data/data.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    // rideDataClient = RideDataAPI();

    on<DashboardCatalogRequested>(_onRideCatalogRequested);
  }

  RideDataAPI rideDataClient = RideDataAPI();

  Future<void> _onRideCatalogRequested(
      DashboardCatalogRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardGetCatalogInProgress());

    RideDataAPIResponse response = await rideDataClient.getRideCatalog();

    if (response.httpCode == 200) {
      emit(DashboardGetCatalogSuccess(rideCatalog: response.responseBody));
    } else {
      emit(DashboardGetCatalogFailure());
    }
  }
}
