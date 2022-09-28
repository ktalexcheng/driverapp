import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:driverapp/src/ride/data/data.dart';

void main() {
  group('RideHistory', () {
    Ride rideHistory = Ride(
      id: null,
      rideName: 'testRide',
      rideDate: DateTime.now(),
      rideData: RideData(),
    );

    test(
      'Test JSON encode',
      () {
        expect(jsonEncode(rideHistory), isA<String>());
      },
    );
  });
}
