import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:trailbrake/src/ride/data/data.dart';

part 'ride_details_event.dart';
part 'ride_details_state.dart';

class RideDetailsBloc extends Bloc<RideDetailsEvent, RideDetailsState> {
  RideDetailsBloc() : super(RideDetailsInitial()) {
    rideDataClient = RideDataAPI();

    on<RideDetailsGetRequested>(_onRideGetRequested);
    on<RideDetailsDeleteRequested>(_onRideDeleteRequested);
  }

  late RideDataAPI rideDataClient;

  Future<void> _onRideGetRequested(
      RideDetailsGetRequested event, Emitter<RideDetailsState> emit) async {
    emit(RideDetailsGetInProgress());

    RideDataAPIResponse response =
        await rideDataClient.getRideData(event.rideId);

    if (response.httpCode == 200) {
      emit(RideDetailsGetSuccess(savedRide: response.responseBody));
    } else {
      emit(RideDetailsGetFailure());
    }
  }

  Future<void> _onRideDeleteRequested(
      RideDetailsDeleteRequested event, Emitter<RideDetailsState> emit) async {
    emit(RideDetailsDeleteInProgress());

    RideDataAPIResponse response =
        await rideDataClient.deleteRideData(event.rideId);

    if (response.httpCode == 200) {
      emit(RideDetailsDeleteSuccess());
    } else {
      emit(RideDetailsDeleteFailure());
    }
  }
}
