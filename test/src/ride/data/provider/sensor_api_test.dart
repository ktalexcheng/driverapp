import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:trailbrake/src/ride/ride.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(('Testing SensorAPI'), () {
    SensorAPI sensorController = SensorAPI();

    test('Get location data from GPS sensor', () async {
      await sensorController.initSensors();

      Position nowLocation = await sensorController.getCurrentLocation();

      expect(nowLocation, isA<Position>());
    });
  });
}
