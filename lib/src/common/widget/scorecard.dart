import 'package:flutter/material.dart';

import 'package:trailbrake/src/common/constants.dart' as constants;

class Scorecard extends StatelessWidget {
  const Scorecard({super.key, required this.title, required this.score});

  final String title;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(score.toStringAsFixed(1),
                style: Theme.of(context).textTheme.displayLarge),
            const Text(constants.rideScoreDenominator),
          ],
        ),
      ],
    );
  }
}
