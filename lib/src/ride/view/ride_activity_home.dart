import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideActivityHome extends StatelessWidget {
  const RideActivityHome({super.key});

  void _showSaveSuccessfulNotification(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(builder: (context) {
      // Overlay is not part of the app screen scaffold
      // so a DefaultTextStyle needs to be provided for proper styling
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1!,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle_outline_rounded),
              Text("Saved"),
            ],
          ),
        ),
      );
    });

    overlayState?.insert(overlayEntry);
    await Future.delayed(const Duration(seconds: 3));
    overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RideActivityCubit(),
      child: BlocConsumer<RideActivityCubit, RideActivityState>(
        listener: (context, state) {
          if (state.status == RideActivityStatus.saved) {
            _showSaveSuccessfulNotification(context);
          }
        },
        buildWhen: (previous, current) {
          if (previous.status != current.status) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state.status == RideActivityStatus.ready ||
              state.status == RideActivityStatus.saved) {
            return const RideActivityReadyScreen();
          } else if (state.status == RideActivityStatus.running ||
              state.status == RideActivityStatus.paused) {
            return const RideActivityOngoingScreen();
          } else if (state.status == RideActivityStatus.saving) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: constants.widgetSpacing),
                  Text("Saving ride..."),
                ],
              ),
            );
          } else {
            return const Text(
                "ERROR: App is in an invalid state! Please re-open the app.");
          }
        },
      ),
    );
  }
}
