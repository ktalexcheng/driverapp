import 'package:trailbrake/src/common/common.dart';

class RegisteredUser extends User {
  RegisteredUser({
    required this.userId,
    required this.username,
    required super.scores,
    required super.stats,
  });

  final String userId;
  final String username;
}

abstract class User {
  User({
    required this.scores,
    required this.stats,
  });

  final RideScore scores;
  final UserLifetimeStats stats;
}

class UserLifetimeStats {
  UserLifetimeStats({
    required this.totalRideTime,
    required this.totalDistance,
    required this.maxAcceleration,
  });

  UserLifetimeStats.fromJson(Map<String, dynamic> json)
      : totalRideTime = Duration(seconds: json['totalRideTime'].round()),
        totalDistance = json['totalDistance'] + 0.0,
        maxAcceleration = json['maxAcceleration'] + 0.0;

  final Duration totalRideTime;
  final double totalDistance;
  final double maxAcceleration;

  dynamic getMetric(String metricName) {
    switch (metricName) {
      case 'totalRideTime':
        return totalRideTime;

      case 'totalDistance':
        return totalDistance;

      case 'maxAcceleration':
        return maxAcceleration;

      default:
        return null;
    }
  }
}
