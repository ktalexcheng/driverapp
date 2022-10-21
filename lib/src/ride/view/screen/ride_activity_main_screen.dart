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
        style: Theme.of(context).textTheme.bodyText1!,
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
        // TODO: Replace background with Google map
        Container(
          color: Colors.white70.withOpacity(0.1),
          child: const Center(child: Text("<Map placeholder>")),
        ),
        SizedBox.expand(
          child: BlocProvider(
            create: (context) => RideActivityCubit(),
            child: BlocConsumer<RideActivityCubit, RideActivityState>(
              listener: (context, state) {
                if (state.status == RideActivityStatus.saved) {
                  _showSaveSuccessfulNotification(context);
                  Navigator.of(context)
                      .pushNamed('/ride/rideScore', arguments: context);
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
                if (state.status == RideActivityStatus.ready) {
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
                        Text(constants.savingInProgressMessage),
                      ],
                    ),
                  );
                } else if (state.status == RideActivityStatus.saved) {
                  return Container();
                } else {
                  return const Text(constants.invalidStateMessage);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
