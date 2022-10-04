import 'package:driverapp/src/ride/data/model/model.dart';

// class Ride extends RideMeta with RideDataMixin {
class Ride with RideMetaMixin, RideDataMixin {
  Ride({
    required id,
    required rideName,
    required rideDate,
    required rideData,
  }) {
    super.id = id;
    super.rideName = rideName;
    super.rideDate = rideDate;
    super.data = rideData;
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    List<SensorData> _data = <SensorData>[];
    if (json['rideData'].isNotEmpty) {
      for (var data in json['rideData']) {
        _data.add(SensorData.fromJson(data));
      }
    }

    return Ride(
      id: json['_id'],
      rideName: json['rideName'],
      rideDate: DateTime.parse(json['rideDate']),
      rideData: _data,
    );
  }

  // @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> _jsonList = [];

    for (var element in data) {
      _jsonList.add(element.toJson());
    }

    return {
      'rideName': super.rideName,
      'rideDate': super.rideDate.toIso8601String(),
      'rideData': _jsonList,
    };
  }
}
