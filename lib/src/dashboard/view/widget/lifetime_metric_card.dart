import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:trailbrake/src/dashboard/bloc/bloc.dart';
// import 'package:trailbrake/src/dashboard/view/screen/screen.dart';
// import 'package:trailbrake/src/dashboard/view/widget/widget.dart';

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
        padding: const EdgeInsets.all(16),
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
