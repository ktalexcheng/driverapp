class SensorData {
  SensorData({
    timestamp,
    this.gyroscopeX,
    this.gyroscopeY,
    this.gyroscopeZ,
    this.accelerometerX,
    this.accelerometerY,
    this.accelerometerZ,
    this.locationLat,
    this.locationLong,
    this.locationUpdated,
    this.elapsedSeconds,
  }) {
    this.timestamp = timestamp ?? DateTime.now();
  }

  late DateTime timestamp;
  late double? gyroscopeX;
  late double? gyroscopeY;
  late double? gyroscopeZ;
  late double? accelerometerX;
  late double? accelerometerY;
  late double? accelerometerZ;
  late double? locationLat;
  late double? locationLong;
  late bool? locationUpdated;
  late Duration? elapsedSeconds;

  SensorData.fromJson(Map<String, dynamic> json) {
    timestamp = DateTime.parse(json['timestamp']);
    locationLat = _jsonValueToDouble(json['locationLat']);
    locationLong = _jsonValueToDouble(json['locationLong']);
    accelerometerX = _jsonValueToDouble(json['accelerometerX']);
    accelerometerY = _jsonValueToDouble(json['accelerometerY']);
    accelerometerZ = _jsonValueToDouble(json['accelerometerZ']);
    gyroscopeX = _jsonValueToDouble(json['gyroscopeX']);
    gyroscopeY = _jsonValueToDouble(json['gyroscopeY']);
    gyroscopeZ = _jsonValueToDouble(json['gyroscopeZ']);
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'gyroscopeX': gyroscopeX,
      'gyroscopeY': gyroscopeY,
      'gyroscopeZ': gyroscopeZ,
      'accelerometerX': accelerometerX,
      'accelerometerY': accelerometerY,
      'accelerometerZ': accelerometerZ,
      'locationLat': locationLat,
      'locationLong': locationLong
    };
  }

  double? _jsonValueToDouble(var x) {
    if (x is num) {
      return x.toDouble();
    }
    if (x is String) {
      return double.parse(x);
    } else {
      return null;
    }
  }
}
