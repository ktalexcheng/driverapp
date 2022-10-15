import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/data/data.dart';

part 'ride_activity_state.dart';

class RideActivityCubit extends Cubit<RideActivityState> {
  RideActivityCubit()
      : super(RideActivityState(status: RideActivityStatus.ready));

  ActiveRideRepository rideDataRepository = ActiveRideRepository();
  StreamSubscription? rideDataSubscription;

  void startRide() {
    if (state.status != RideActivityStatus.running) {
      rideDataRepository.startRide();
      _listenToRideDataStream();
    }
  }

  void stopRide() {
    if (state.status == RideActivityStatus.running) {
      _cancelSubscription();
      rideDataRepository.stopRide();
      emit(RideActivityState(status: RideActivityStatus.paused));
    }
  }

  void resetRide() {
    if (state.status != RideActivityStatus.ready) {
      _cancelSubscription();
      rideDataRepository.stopRide();
      emit(RideActivityState(status: RideActivityStatus.saving));
    }
  }

  void saveRide(String rideName) async {
    if (state.status == RideActivityStatus.saving) {
      RideDataAPI rideDataClient = RideDataAPI();

      Ride ride = Ride(
        id: null,
        rideName: rideName,
        rideDate: DateTime.now(),
        rideData: rideDataRepository.rideData.data,
      );

      await rideDataClient.saveRideData(ride);

      emit(RideActivityState(
        status: RideActivityStatus.ready,
        newSensorData: rideDataRepository.rideData.last,
      ));
    }
  }

  void discardRide() async {
    if (state.status == RideActivityStatus.saving) {
      rideDataRepository.clearRideData();
      emit(RideActivityState(status: RideActivityStatus.ready));
    }
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
        emit(RideActivityState(
          status: RideActivityStatus.running,
          newSensorData: rideDataRepository.rideData.last,
          elapsedSeconds: rideDataRepository.elapsedSeconds,
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
