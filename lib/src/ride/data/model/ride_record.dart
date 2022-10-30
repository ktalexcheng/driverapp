import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideRecord with RideRecordMixin {
  RideRecord({
    id,
    required rideName,
    required rideDate,
    rideScore,
    rideMeta,
  }) {
    super.id = id;
    super.rideName = rideName;
    super.rideDate = rideDate;
    super.rideScore = rideScore;
    super.rideMeta = rideMeta;
  }

  factory RideRecord.fromJson(Map<String, dynamic> json) {
    return RideRecord(
      id: json['_id'],
      rideName: json['rideName'],
      rideDate: DateTime.parse(json['rideDate']),
      rideScore: RideScore.fromJson(json['rideScore']),
      rideMeta: RideMeta.fromJson(json['rideMeta']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'rideName': rideName,
  //     'rideDate': rideDate.toIso8601String(),
  //   };
  // }
}

mixin RideRecordMixin {
  late final String? id;
  late final String rideName;
  late final DateTime rideDate;
  late final RideScore rideScore;
  late final RideMeta rideMeta;
}

class RideMeta {
  RideMeta({
    required this.duration,
    required this.distance,
    required this.maxAcceleration,
  });

  RideMeta.fromJson(Map<String, dynamic> json)
      : duration = Duration(seconds: json['duration'].toInt()),
        distance = json['distance'].toDouble(),
        maxAcceleration = json['maxAcceleration'].toDouble();
  // {
  //   duration = Duration(seconds: json['duration'].toInt());
  //   distance = json['distance'].toDouble();
  //   maxAcceleration = json['maxAcceleration'].toDouble();
  // }

  final Duration duration;
  final double distance;
  final double maxAcceleration;

  String get distanceKm {
    return (distance / 1000).toStringAsFixed(1);
  }

  String get durationFormatted {
    return formatDuration(duration);
  }

  String get maxAccelerationG {
    return (maxAcceleration / constants.gravity).toStringAsFixed(1);
  }
}
