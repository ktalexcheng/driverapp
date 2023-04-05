class RideScore {
  RideScore({
    required this.overall,
    required this.acceleration,
    required this.braking,
    required this.cornering,
    required this.speed,
  });

  RideScore.fromJson(Map<String, dynamic> json)
      : overall = json['overall'] + 0.0,
        acceleration = json['acceleration'] + 0.0,
        braking = json['braking'] + 0.0,
        cornering = json['cornering'] + 0.0,
        speed = json['speed'] + 0.0;
  // {
  //   overall = json['overall'];
  //   acceleration = json['acceleration'];
  //   braking = json['braking'];
  //   cornering = json['cornering'];
  //   speed = json['speed'];
  // }

  final double overall;
  final double acceleration;
  final double braking;
  final double cornering;
  final double speed;
}
