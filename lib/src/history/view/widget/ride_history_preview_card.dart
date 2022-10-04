import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:driverapp/src/analysis/view/view.dart';

class RideHistoryPreviewCard extends StatelessWidget {
  const RideHistoryPreviewCard({
    super.key,
    required this.rideName,
    required this.rideDate,
  });

  final String rideName;
  final DateTime rideDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                rideName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat.yMMMMd().add_Hms().format(rideDate),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Row(
                children: const [
                  Expanded(
                    child: RideAnalysisMetric(
                      title: "Distance",
                      body: "42.0",
                    ),
                  ),
                  VerticalDivider(
                    // width: 20,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    // color: Colors.white,
                  ),
                  Expanded(
                    child: RideAnalysisMetric(
                      title: "Duration",
                      body: "42:00",
                    ),
                  ),
                  VerticalDivider(
                    // width: 20,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    // color: Colors.white,
                  ),
                  Expanded(
                    child: RideAnalysisMetric(
                      title: "Quality Score",
                      body: "8.5",
                    ),
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
