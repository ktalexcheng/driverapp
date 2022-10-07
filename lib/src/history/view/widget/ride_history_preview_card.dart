import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:driverapp/src/history/bloc/bloc.dart';
// import 'package:driverapp/src/history/view/screen/screen.dart';
import 'package:driverapp/src/history/view/widget/widget.dart';

class RideHistoryPreviewCard extends StatelessWidget {
  const RideHistoryPreviewCard({
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
            .pushNamed('/rideHistoryDetail', arguments: rideId);
      }),
      child: Card(
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
                      child: RideHistoryMetric(
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
                      child: RideHistoryMetric(
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
                      child: RideHistoryMetric(
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
      ),
    );
  }
}
