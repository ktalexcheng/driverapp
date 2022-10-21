import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/app/cubit/cubit.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    int _selectedIndex(AppNavigationState state) {
      int index = initialIndex; // Show "Profile" page on initial landing

      if (state is AppNavigationLoadDashboardSuccess) {
        index = 0;
      } else if (state is AppNavigationStartRideSuccess) {
        index = 1;
      } else if (state is AppNavigationLoadProfileSuccess) {
        index = 2;
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
              context.read<AppNavigationCubit>().viewDashboard();
            } else if (index == 1) {
              context.read<AppNavigationCubit>().startRide();
            } else if (index == 2) {
              context.read<AppNavigationCubit>().viewProfile();
            }
          },
          currentIndex: _selectedIndex(state),
          items: const [
            BottomNavigationBarItem(
              label: "Dashboard",
              icon: Icon(Icons.speed),
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
