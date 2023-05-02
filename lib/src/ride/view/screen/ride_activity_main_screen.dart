import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/dashboard/dashboard.dart';
import 'package:trailbrake/src/profile/profile.dart';
import 'package:trailbrake/src/common/common.dart';
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
        const MapBackground(),
        SafeArea(
          child: BlocConsumer<RideActivityCubit, RideActivityState>(
            listener: (context, state) {
              if (state is RideActivitySaveSuccess) {
                _showSaveSuccessfulNotification(context);
                Navigator.of(context)
                    .pushNamed('/ride/rideScore', arguments: context);
                context.read<DashboardBloc>().add(DashboardCatalogRequested());
                context.read<UserProfileCubit>().getUserProfileData();
              }
            },
            // child: BlocBuilder<RideActivityCubit, RideActivityState>(
            buildWhen: (previous, current) {
              if (previous != current) {
                return true;
              } else {
                return false;
              }
            },
            builder: (context, state) {
              if (state is RideActivityInitial) {
                return Container();
              }
              if (state is RideActivityUnauthenticated) {
                return Container(
                  padding: constants.appDefaultPadding,
                  child: const Center(
                    child: Text(constants.guestModeActivity),
                  ),
                  color: Theme.of(context)
                      .colorScheme
                      .tertiaryContainer
                      .withOpacity(constants.overlayOpacity),
                );
              } else if (state is RideActivityPrepareSuccess) {
                return const RideActivityReadyScreen();
              } else if (state is RideActivityNewRideInProgress ||
                  state is RideActivityPaused) {
                return const RideActivityOngoingScreen();
              } else if (state is RideActivitySaveInProgress) {
                return const BusyIndicator(
                    indicatorLabel: constants.savingInProgressMessage);
              } else if (state is RideActivitySaveSuccess) {
                return Container();
              } else if (state is RideActivitySaveFailure) {
                return const Center(
                  child: Text(constants.saveFailureMessage),
                );
              } else {
                return const Center(
                  child: Text(constants.invalidStateMessage),
                );
              }
            },
            // ),
          ),
        ),
      ],
    );
  }
}
