import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/app/cubit/cubit.dart';
import 'package:driverapp/src/app/view/view.dart';
import 'package:driverapp/src/ride/ride.dart';
import 'package:driverapp/src/history/history.dart';

class DriverAppHomePage extends StatelessWidget {
  const DriverAppHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppNavigationCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => RideHistoryBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DriverApp'),
        ),
        body: BlocBuilder<AppNavigationCubit, AppNavigationState>(
          buildWhen: (previous, current) {
            if (previous != current) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is AppNavigationInitial ||
                state is AppNavigationLoadHistorySuccess) {
              context
                  .read<RideHistoryBloc>()
                  .add(RideHistoryCatalogRequested());

              return const RideHistoryCatalog();
            } else if (state is AppNavigationStartNewRideSuccess) {
              context
                  .read<RideHistoryBloc>()
                  .add(RideHistoryLastRideDataRequested());

              return const RideActivityHome();
            } else {
              return const RideHistoryCatalog();
            }
          },
        ),
        bottomNavigationBar: const DriverAppNavigationBar(),
      ),
    );
  }
}
