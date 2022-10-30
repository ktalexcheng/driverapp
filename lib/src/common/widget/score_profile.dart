import 'package:flutter/material.dart';

import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class ScoreProfile extends StatelessWidget {
  const ScoreProfile({super.key, required this.scores});

  final RideScore scores;

  Widget profileBar(String title, double score) {
    return Row(
      children: [
        ConstrainedBox(
          child: Text(title),
          constraints: const BoxConstraints(minWidth: 80),
        ),
        constants.columnSpacer,
        Expanded(
          child: LinearProgressIndicator(
            minHeight: 8,
            value: score / 100,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: constants.appDefaultPadding,
        child: Column(
          children: [
            profileBar("Speed", scores.speed),
            constants.rowSpacer,
            profileBar("Acceleration", scores.acceleration),
            constants.rowSpacer,
            profileBar("Braking", scores.braking),
            constants.rowSpacer,
            profileBar("Cornering", scores.cornering),
          ],
        ),
      ),
    );
  }
}
