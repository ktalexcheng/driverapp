import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

import 'package:trailbrake/src/common/constants.dart' as constants;

class LifetimeMetricCard extends StatelessWidget {
  const LifetimeMetricCard(
      {super.key,
      required this.type,
      required this.title,
      required this.value});

  final String type;
  final String title;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: constants.appDefaultPadding,
        child: Column(
          children: [
            Text(title),
            Text(value),
          ],
        ),
      ),
    );
  }
}
