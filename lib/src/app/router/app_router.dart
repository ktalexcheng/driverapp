import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/app/cubit/cubit.dart';
import 'package:trailbrake/src/dashboard/dashboard.dart';
import 'package:trailbrake/src/ride/ride.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/dashboard/rideDetails':
        var args = routeSettings.arguments as Map;
        var rideId = args['rideId'] as String;
        var context = args['context'] as BuildContext;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<DashboardBloc>(),
            child: RideDetailsScreen(rideId: rideId),
          ),
        );

      case '/ride/rideScore':
        var context = routeSettings.arguments as BuildContext;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<AppNavigationCubit>()),
              BlocProvider.value(value: context.read<RideActivityCubit>()),
            ],
            child: const RideActivityScoreScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
