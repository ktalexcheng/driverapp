import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/ride/cubit/cubit.dart';
import 'package:driverapp/src/ride/view/page/page.dart';

class RideActivityHome extends StatelessWidget {
  const RideActivityHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RideActivityCubit(),
      child: BlocBuilder<RideActivityCubit, RideActivityState>(
        buildWhen: (previous, current) {
          if (previous.status != current.status) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state.status == RideActivityStatus.ready) {
            return const RideActivityReadyPage();
          } else if (state.status == RideActivityStatus.running ||
              state.status == RideActivityStatus.paused ||
              state.status == RideActivityStatus.saving) {
            return const RideActivityOngoingPage();
          } else {
            return const Text(
                "ERROR: App is in an invalid state! Please re-open the app.");
          }
        },
      ),
    );
  }
}
