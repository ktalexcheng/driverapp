import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:driverapp/src/ride/data/data.dart';

void main() {
  group('RideDataAPI', () {
    final DriverAppDBAPI rideDataAPI = DriverAppDBAPI();

    test(
      'Fetch all ride history from RideDataAPI',
      () async {
        rideDataAPI.client = MockClient((request) async {
          final mockJson = [
            {
              "_id": "632f9fa937da9d6a3a99cc05",
              "rideName": "001",
              "rideDate": "2022-09-24T00:00:00.000Z",
              "rideData": [
                {
                  "timestamp": "2022-09-24T00:00:00.000Z",
                  "locationLat": 12.12341234,
                  "locationLong": 1234.123412341,
                  "accelerometerX": 1.2341,
                  "accelerometerY": -6.2345,
                  "accelerometerZ": 1.412,
                  "gyroscopeX": 6.262346,
                  "gyroscopeY": 0.00001,
                  "gyroscopeZ": -1.1234121,
                  "_id": "632f9fa937da9d6a3a99cc06"
                },
                {
                  "timestamp": "2022-09-24T00:00:00.000Z",
                  "locationLat": 12.12341234,
                  "locationLong": 1234.123412341,
                  "accelerometerX": 1.2341,
                  "accelerometerY": -6.2345,
                  "accelerometerZ": 1.412,
                  "gyroscopeX": 6.262346,
                  "gyroscopeY": 0.00001,
                  "gyroscopeZ": -1.1234121,
                  "_id": "632f9fa937da9d6a3a99cc07"
                }
              ],
              "__v": 0
            },
            {
              "_id": "632fcc77d7a03f16461fc673",
              "rideName": "002",
              "rideDate": "2022-09-24T00:00:00.000Z",
              "rideData": [
                {
                  "timestamp": "2022-09-24T00:00:00.000Z",
                  "locationLat": 12.12341234,
                  "locationLong": 1234.123412341,
                  "accelerometerX": 1.2341,
                  "accelerometerY": -6.2345,
                  "accelerometerZ": 1.412,
                  "gyroscopeX": 6.262346,
                  "gyroscopeY": 0.00001,
                  "gyroscopeZ": -1.1234121,
                  "_id": "632fcc77d7a03f16461fc674"
                },
                {
                  "timestamp": "2022-09-24T00:00:00.000Z",
                  "locationLat": 12.12341234,
                  "locationLong": 1234.123412341,
                  "accelerometerX": 1.2341,
                  "accelerometerY": -6.2345,
                  "accelerometerZ": 1.412,
                  "gyroscopeX": 6.262346,
                  "gyroscopeY": 0.00001,
                  "gyroscopeZ": -1.1234121,
                  "_id": "632fcc77d7a03f16461fc675"
                }
              ],
              "__v": 0
            }
          ];

          return Response(jsonEncode(mockJson), 200);
        });

        List<RideMeta> allRideHistory = await rideDataAPI.fetchRideCatalog();
        expect(allRideHistory, isNotEmpty);
        expect(rideDataAPI.fetchRideCatalog(), isA<Future<List<RideMeta>>>());
      },
    );
  });
}
