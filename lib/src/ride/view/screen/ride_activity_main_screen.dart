import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideActivityMainScreen extends StatelessWidget {
  const RideActivityMainScreen({super.key});

  void _showSaveSuccessfulNotification(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(builder: (context) {
      // Overlay is not part of the app screen scaffold
      // so a DefaultTextStyle needs to be provided for proper styling
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle_outline_rounded),
              Text(constants.saveSuccessfulMessage),
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
    return Stack(
      children: [
        MapBackground(),
        SizedBox.expand(
          child: BlocConsumer<RideActivityCubit, RideActivityState>(
            listener: (context, state) {
              if (state is RideActivitySaveSuccess) {
                _showSaveSuccessfulNotification(context);
                Navigator.of(context)
                    .pushNamed('/ride/rideScore', arguments: context);
              }
            },
            buildWhen: (previous, current) {
              if (previous != current) {
                return true;
              } else {
                return false;
              }
            },
            builder: (context, state) {
              if (state is RideActivityInitial ||
                  state is RideActivityPrepareSuccess) {
                return const RideActivityReadyScreen();
              } else if (state is RideActivityNewRideInProgress ||
                  state is RideActivityPaused) {
                return const RideActivityOngoingScreen();
              } else if (state is RideActivitySaveInProgress) {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: constants.widgetSpacing),
                      Text(constants.savingInProgressMessage),
                    ],
                  ),
                );
              } else if (state is RideActivitySaveSuccess) {
                return Container();
              } else {
                return const Text(constants.invalidStateMessage);
              }
            },
          ),
        ),
      ],
    );
  }
}
