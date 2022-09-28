import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/ride/data/data.dart';

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
      DriverAppDBAPI driverAppDBClient = DriverAppDBAPI();

      Ride ride = Ride(
        id: null,
        rideName: rideName,
        rideDate: DateTime.now(),
        rideData: rideDataRepository.rideData.rideData,
      );

      await driverAppDBClient.saveRideData(ride);

      emit(RideActivityState(
          status: RideActivityStatus.ready,
          rideData: rideDataRepository.rideData));
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
