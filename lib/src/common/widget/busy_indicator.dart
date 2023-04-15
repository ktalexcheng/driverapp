import 'package:flutter/material.dart';

import 'package:trailbrake/src/common/constants.dart' as constants;

class BusyIndicator extends StatelessWidget {
  const BusyIndicator({super.key, required this.indicatorLabel});

  final String indicatorLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: constants.widgetSpacing),
          Text(indicatorLabel),
        ],
      ),
    );
  }
}
