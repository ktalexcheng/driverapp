class RideMeta with RideMetaMixin {
  RideMeta({
    id,
    required rideName,
    required rideDate,
  }) {
    super.id = id;
    super.rideName = rideName;
    super.rideDate = rideDate;
  }

  factory RideMeta.fromJson(Map<String, dynamic> json) {
    return RideMeta(
      id: json['_id'],
      rideName: json['rideName'],
      rideDate: DateTime.parse(json['rideDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideName': rideName,
      'rideDate': rideDate.toIso8601String(),
    };
  }
}

mixin RideMetaMixin {
  late final String? id;
  late final String rideName;
  late final DateTime rideDate;
}
