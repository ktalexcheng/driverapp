import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:trailbrake/src/dashboard/bloc/bloc.dart';
// import 'package:trailbrake/src/dashboard/view/screen/screen.dart';
// import 'package:trailbrake/src/dashboard/view/widget/widget.dart';

class PreviewCardMetrics extends StatelessWidget {
  const PreviewCardMetrics({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}

class RidePreviewCard extends StatelessWidget {
  const RidePreviewCard({
    super.key,
    required this.rideId,
    required this.rideName,
    required this.rideDate,
  });

  final String rideId;
  final String rideName;
  final DateTime rideDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.of(context)
            .pushNamed('/dashboard/rideDetails', arguments: rideId);
      }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          rideName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat.yMMMMd().add_Hm().format(rideDate),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16)),
                    const PreviewCardMetrics(text: "Distance: 10.2 km"),
                    const PreviewCardMetrics(text: "Duration: 32:15"),
                    const PreviewCardMetrics(text: "Max acceleration: 1.1 g"),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "85",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
