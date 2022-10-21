import 'package:flutter/material.dart';

import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCanvas(
      child: Column(
        children: [
          Row(
            children: const [
              CircleAvatar(backgroundColor: Colors.white),
              constants.columnSpacer,
              Text("Alex Cheng"),
            ],
          ),
          const Scorecard(title: "Driver score", score: 69),
          const SectionTitle(title: "Score breakdown"),
          const ScoreProfile(),
        ],
      ),
    );
  }
}
