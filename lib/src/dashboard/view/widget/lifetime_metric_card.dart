import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/profile/profile.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class LifetimeMetricCard extends StatelessWidget {
  const LifetimeMetricCard({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    String title;
    switch (type) {
      case 'totalDistance':
        title = 'Distance Driven';
        break;

      case 'totalRideTime':
        title = 'Time Driven';
        break;

      case 'maxAcceleration':
        title = 'Max Acceleration';
        break;

      default:
        title = 'ERROR';
        break;
    }

    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileGetSuccess) {
          dynamic value = state.user.stats.getMetric(type);
          String display;
          switch (type) {
            case 'totalDistance':
              display = '${(value / 1000).toStringAsFixed(3)} km';
              break;

            case 'totalRideTime':
              display = formatDuration(value);
              break;

            case 'maxAcceleration':
              display = '${(value / constants.gravity).toStringAsFixed(3)} G';
              break;

            default:
              display = 'N/A';
              break;
          }

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: constants.appDefaultPadding,
              child: Column(
                children: [
                  Text(title),
                  Text(display),
                ],
              ),
            ),
          );
        } else {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(),
          );
        }
      },
    );
  }
}
