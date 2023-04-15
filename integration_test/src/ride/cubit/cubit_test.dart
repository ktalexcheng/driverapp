import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:trailbrake/src/ride/cubit/cubit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('RideActivityCubit test', () {
    late RideActivityCubit rideActivityCubit;

    blocTest<RideActivityCubit, RideActivityState>(
      'Initial state',
      setUp: () {
        TestWidgetsFlutterBinding.ensureInitialized();
        rideActivityCubit = RideActivityCubit();
      },
      tearDown: () {
        rideActivityCubit.close();
      },
      build: () => rideActivityCubit,
      wait: const Duration(seconds: 5),
      expect: () => [isA<RideActivityPrepareSuccess>()],
    );
  });
}
