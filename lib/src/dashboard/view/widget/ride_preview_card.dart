import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

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
    required this.rideRecord,
  });

  final RideRecord rideRecord;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Map args = {
          'rideId': rideRecord.id,
          'context': context,
        };
        Navigator.of(context)
            .pushNamed('/dashboard/rideDetails', arguments: args);
      }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: constants.appDefaultPadding,
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          rideRecord.rideName,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat.yMMMMd()
                                  .add_Hm()
                                  .format(rideRecord.rideDate),
                            ),
                          ),
                        ),
                      ],
                    ),
                    constants.rowSpacer,
                    PreviewCardMetrics(
                        text: "Distance: ${rideRecord.rideMeta.distanceKm} km"),
                    PreviewCardMetrics(
                        text:
                            "Duration: ${rideRecord.rideMeta.durationFormatted}"),
                    PreviewCardMetrics(
                        text:
                            "Max acceleration: ${rideRecord.rideMeta.maxAccelerationG} g"),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    rideRecord.rideScore.overall.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
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
