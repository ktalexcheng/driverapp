import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/app/cubit/cubit.dart';
import 'package:trailbrake/src/app/view/view.dart';
import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/dashboard/dashboard.dart';
import 'package:trailbrake/src/profile/view/view.dart';

class AppMainScreen extends StatelessWidget {
  const AppMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppNavigationCubit(),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('TrailBrake'),
        // ),
        bottomNavigationBar: const AppNavigationBar(),
        body: BlocBuilder<AppNavigationCubit, AppNavigationState>(
          buildWhen: (previous, current) {
            if (previous != current) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is AppNavigationInitial) {
              return const DashboardMainScreen();
            } else if (state is AppNavigationLoadDashboardSuccess) {
              return const DashboardMainScreen();
            } else if (state is AppNavigationStartRideSuccess) {
              return const RideActivityHome();
            } else if (state is AppNavigationLoadProfileSuccess) {
              return const UserProfileScreen();
            } else {
              return const Center(child: Text("Loading..."));
            }
          },
        ),
      ),
    );
  }
}
