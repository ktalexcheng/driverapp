import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:trailbrake/src/ride/data/data.dart';
import 'package:trailbrake/src/common/common.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardCatalogRequested>(_onRideCatalogRequested);
    on<DashboardUserLogout>(_guestMode);
  }

  final RideDataAPI _rideDataClient = RideDataAPI();
  final AuthenticationRepository authRepository = AuthenticationRepository();

  Future<void> _onRideCatalogRequested(
      DashboardCatalogRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardGetCatalogInProgress());

    if (!await authRepository.isAuthenticated()) {
      emit(DashboardUnauthenticated());
      return;
    }

    RideDataAPIResponse response = await _rideDataClient.getRideCatalog();
    List<RideRecord> rideCatalog = response.responseBody;
    rideCatalog.sort((a, b) => b.rideDate.compareTo(a.rideDate));

    if (response.httpCode == 200) {
      emit(DashboardGetCatalogSuccess(rideCatalog: response.responseBody));
    } else {
      emit(DashboardGetCatalogFailure());
    }
  }

  Future<void> _guestMode(
      DashboardUserLogout event, Emitter<DashboardState> emit) async {
    emit(DashboardUnauthenticated());
  }
}
