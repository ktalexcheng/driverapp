import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';

import 'package:driverapp/src/ride/cubit/cubit.dart';

void main() {
  group('RideActivityCubit', () {
    RideActivityCubit rideActivityCubit = RideActivityCubit();

    setUp(() {
      rideActivityCubit = RideActivityCubit();
    });

    tearDown(() {
      rideActivityCubit.close();
    });

    test(
      'Initial state test',
      () {
        expect(rideActivityCubit.state,
            RideActivityState(status: RideActivityStatus.ready));
      },
    );

    // blocTest<RideActivityCubit, RideActivityState>(
    //   'emits [MyState] when MyEvent is added.',
    //   build: () => RideActivityCubit(),
    //   act: (cubit) => cubit.init(),
    //   expect: (state) => const <RideActivityState>[MyState],
    // );
  });
}
