import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/app/cubit/cubit.dart';
import 'package:trailbrake/src/app/view/view.dart';
import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/dashboard/dashboard.dart';
// import 'package:trailbrake/src/profile/view/view.dart';
import 'package:trailbrake/src/profile/profile.dart';

class AppMainScreen extends StatelessWidget {
  const AppMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppNavigationCubit(),
        ),
        BlocProvider(
          create: (context) {
            final cubit = UserProfileCubit();
            cubit.getUserProfileData();
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: const AppNavigationBar(initialIndex: 2),
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
              return const UserProfileScreen();
            } else if (state is AppNavigationLoadDashboardSuccess) {
              return const DashboardMainScreen();
            } else if (state is AppNavigationLoadRideSuccess) {
              return const RideActivityMainScreen();
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
