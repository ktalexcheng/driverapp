import 'package:flutter/material.dart';

class RideHistoryMetric extends StatelessWidget {
  const RideHistoryMetric({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        children: [
          Text(title),
          Expanded(
            child: Center(
              child: Text(body),
            ),
          ),
        ],
      ),
    );
  }
}
