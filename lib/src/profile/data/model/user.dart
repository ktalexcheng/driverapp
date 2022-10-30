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
    required this.totalDuration,
    required this.totalDistance,
    required this.maxAcceleration,
  });

  UserLifetimeStats.fromJson(Map<String, dynamic> json)
      : totalDuration = Duration(seconds: json['totalDuration'].round()),
        totalDistance = json['totalDistance'] + 0.0,
        maxAcceleration = json['maxAcceleration'] + 0.0;

  final Duration totalDuration;
  final double totalDistance;
  final double maxAcceleration;

  dynamic getMetric(String metricName) {
    switch (metricName) {
      case 'totalDuration':
        return totalDuration;

      case 'totalDistance':
        return totalDistance;

      case 'maxAcceleration':
        return maxAcceleration;

      default:
        return null;
    }
  }
}
