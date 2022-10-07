import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/app/cubit/cubit.dart';
import 'package:driverapp/src/history/history.dart';
import 'package:driverapp/src/ride/ride.dart';

class DriverAppNavigationBar extends StatelessWidget {
  const DriverAppNavigationBar({super.key});

  static List<Widget> screens = const [
    RideHistoryCatalog(),
    RideActivityHome(),
    Text('NOT YET IMPLEMENTED'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    int _selectedIndex(AppNavigationState state) {
      int index = 0;

      if (state is AppNavigationLoadHistorySuccess) {
        index = 0;
      } else if (state is AppNavigationStartNewRideSuccess) {
        index = 1;
      } else if (state is AppNavigationViewProfileSuccess) {
        index = 2;
      } else {
        index = 0;
      }

      return index;
    }

    return BlocBuilder<AppNavigationCubit, AppNavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.onSurface,
          unselectedItemColor: colorScheme.onBackground.withOpacity(.60),
          selectedLabelStyle: textTheme.caption,
          unselectedLabelStyle: textTheme.caption,
          onTap: (index) {
            if (index == 0) {
              context.read<AppNavigationCubit>().viewHistory();
            } else if (index == 1) {
              context.read<AppNavigationCubit>().startNewRide();
            } else if (index == 2) {
              context.read<AppNavigationCubit>().viewProfile();
            }
          },
          currentIndex: _selectedIndex(state),
          items: const [
            BottomNavigationBarItem(
              label: "Dashboard",
              icon: Icon(Icons.history),
            ),
            BottomNavigationBarItem(
              label: "Ride",
              icon: Icon(Icons.route),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person),
            ),
          ],
        );
      },
    );
  }
}
