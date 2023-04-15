import 'package:flutter/material.dart';

import 'package:trailbrake/src/common/constants.dart' as constants;

class AppCanvas extends StatelessWidget {
  const AppCanvas({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: constants.appDefaultPadding,
        child: child,
      ),
    );
  }
}
