import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

import 'package:trailbrake/src/ride/data/provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SensorAPI test (sensors unavailable)', () {
    const channelName = ['dev.fluttercommunity.plus/sensors/user_accel'];
    const sensorData = [<double>[]];

    setUp(() {
      for (var i = 0; i < channelName.length; i++) {
        _setFakeSensorChannel(channelName[i], sensorData[i]);
      }
    });

    tearDown(() {
      for (var i = 0; i < channelName.length; i++) {
        _resetFakeSensorChannel(channelName[i]);
      }
    });

    test('Accelerometer sensor unavailable', () async {
      AccelerometerSensor sensor = AccelerometerSensor();
      bool status = await sensor.checkSensor();
      expect(status, false);
    });
  });

  group('SensorAPI test (sensors available)', () {
    const channelName = ['dev.fluttercommunity.plus/sensors/user_accel'];
    const sensorData = [
      <double>[1.0, 2.0, 3.0]
    ];

    setUp(() {
      for (var i = 0; i < channelName.length; i++) {
        _setFakeSensorChannel(channelName[i], sensorData[i]);
      }
    });

    tearDown(() {
      for (var i = 0; i < channelName.length; i++) {
        _resetFakeSensorChannel(channelName[i]);
      }
    });

    test('Accelerometer sensor available', () async {
      AccelerometerSensor sensor = AccelerometerSensor();
      bool status = await sensor.checkSensor();
      expect(status, true);
    });
  });
}

/// Based on unit tests from sensors_plus package
/// https://github.com/fluttercommunity/plus_plugins/blob/main/packages/sensors_plus/sensors_plus/test/sensors_test.dart
void _setFakeSensorChannel(String channelName, List<double> sensorData) {
  const standardMethod = StandardMethodCodec();

  void emitEvent(ByteData? event) {
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channelName,
      event,
      (ByteData? reply) {},
    );
  }

  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (ByteData? message) async {
    final methodCall = standardMethod.decodeMethodCall(message);

    if (methodCall.method == 'listen') {
      emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
      // emitEvent(null);

      return standardMethod.encodeSuccessEnvelope(null);
    } else if (methodCall.method == 'cancel') {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected listen or cancel');
    }
  });
}

void _resetFakeSensorChannel(String channelName) {
  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
      .setMockMessageHandler(channelName, null);
}
