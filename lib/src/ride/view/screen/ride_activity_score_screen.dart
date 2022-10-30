import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/app/app.dart';
import 'package:trailbrake/src/ride/cubit/cubit.dart';
import 'package:trailbrake/src/profile/profile.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideActivityGoToDashboardButton extends StatelessWidget {
  const RideActivityGoToDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<RideActivityCubit>().initRide();
        context.read<AppNavigationCubit>().viewDashboard();
        context.read<UserProfileCubit>().getUserProfileData();
        Navigator.of(context).pop();
      },
      child: const Text("Go to dashboard"),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
    );
  }
}

class RideActivityScoreScreen extends StatelessWidget {
  const RideActivityScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideActivityCubit, RideActivityState>(
      builder: (context, state) {
        if (state.status == RideActivityStatus.saved) {
          return Scaffold(
            body: AppCanvas(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const ScreenTitle(title: "Ride completed!"),
                      Scorecard(
                          title: "Ride score", score: state.rideScore!.overall),
                      const SectionTitle(title: "Score breakdown"),
                      ScoreProfile(scores: state.rideScore!),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: const [
                            Expanded(child: RideActivityGoToDashboardButton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text(constants.invalidStateMessage);
        }
      },
    );
  }
}
