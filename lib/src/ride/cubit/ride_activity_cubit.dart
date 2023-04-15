import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/ride/data/data.dart';

part 'ride_activity_state.dart';

class RideActivityCubit extends Cubit<RideActivityState> {
  RideActivityCubit() : super(RideActivityInitial());

  ActiveRideRepository rideDataRepository = ActiveRideRepository(SensorAPI());
  StreamSubscription? rideDataSubscription;
  final AuthenticationRepository authRepository = AuthenticationRepository();

  void guestMode() async {
    emit(RideActivityUnauthenticated());
  }

  void prepareRide() async {
    bool tokenValid = await authRepository.validateToken();

    if (tokenValid) {
      bool initSuccess = await rideDataRepository.initRide();

      if (initSuccess) {
        emit(RideActivityPrepareSuccess(
            initialLocation: rideDataRepository.initialLatLng));
      } else {
        emit(RideActivityPrepareFailure());
      }
    } else {
      emit(RideActivityUnauthenticated());
    }
  }

  void startRide() {
    rideDataRepository.startRide();
    _listenToRideDataStream();
  }

  void stopRide() {
    _cancelSubscription();
    rideDataRepository.stopRide();

    emit(RideActivityPaused());
  }

  void resetRide() {
    _cancelSubscription();
    rideDataRepository.stopRide();
    rideDataRepository.clearRideData();
    rideDataRepository.initRide();

    emit(RideActivityPrepareSuccess(
        initialLocation: rideDataRepository.initialLatLng));
  }

  void saveRide(String rideName) async {
    if (state is RideActivityPaused) {
      emit(RideActivitySaveInProgress());

      RideDataAPI rideDataClient = RideDataAPI();

      NewRide ride = NewRide(
        rideName: rideName,
        rideDate: DateTime.now(),
        rideData: rideDataRepository.rideData.data,
      );

      RideDataAPIResponse response = await rideDataClient.saveRideData(ride);

      if (response.httpCode == 201) {
        emit(RideActivitySaveSuccess(
            rideScore: response.responseBody.rideScore));
      } else {
        emit(RideActivitySaveFailure());
      }
    }
  }

  void discardRide() async {
    rideDataRepository.clearRideData();
    rideDataRepository.initRide();

    emit(RideActivityPrepareSuccess(
        initialLocation: rideDataRepository.initialLatLng));
  }

  void _cancelSubscription() {
    if (rideDataSubscription == null) return;
    rideDataSubscription?.cancel();
    rideDataSubscription = null;
  }

  void _listenToRideDataStream() {
    rideDataSubscription ??=
        rideDataRepository.rideDataStreamController.stream.listen(
      (event) {
        emit(RideActivityNewRideInProgress(
          newSensorData: event,
          rideData: rideDataRepository.rideData,
        ));
      },
    );
  }

  @override
  Future<void> close() async {
    _cancelSubscription();
    super.close();
  }
}
