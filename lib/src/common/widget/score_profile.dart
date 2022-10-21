import 'package:flutter/material.dart';

import 'package:trailbrake/src/common/constants.dart' as constants;

class ScoreProfile extends StatelessWidget {
  const ScoreProfile({super.key});

  Widget profileBar(String title, int score) {
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
            profileBar("Speed", 69),
            constants.rowSpacer,
            profileBar("Acceleration", 34),
            constants.rowSpacer,
            profileBar("Breaking", 89),
            constants.rowSpacer,
            profileBar("Cornering", 95),
          ],
        ),
      ),
    );
  }
}
