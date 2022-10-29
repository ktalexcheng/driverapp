import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/app/app.dart';
import 'package:trailbrake/src/ride/cubit/cubit.dart';
import 'package:trailbrake/src/common/common.dart';

class RideActivityGoToDashboardButton extends StatelessWidget {
  const RideActivityGoToDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<RideActivityCubit>().initRide();
        context.read<AppNavigationCubit>().viewDashboard();
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
    return Scaffold(
      body: AppCanvas(
        child: Stack(
          children: [
            Column(
              children: const [
                ScreenTitle(title: "Ride completed!"),
                Scorecard(title: "Ride score", score: 69),
                SectionTitle(title: "Score breakdown"),
                ScoreProfile(),
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
  }
}
