import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/app/cubit/cubit.dart';
import 'package:trailbrake/src/dashboard/dashboard.dart';
import 'package:trailbrake/src/ride/ride.dart';
import 'package:trailbrake/src/profile/profile.dart';
import 'package:trailbrake/src/common/common.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/dashboard/rideDetails':
        var args = routeSettings.arguments as Map;
        var rideId = args['rideId'] as String;
        var context = args['context'] as BuildContext;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<DashboardBloc>()),
              BlocProvider(create: (context) => RideDetailsBloc()),
            ],
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
              BlocProvider.value(value: context.read<UserProfileCubit>()),
            ],
            child: const RideActivityScoreScreen(),
          ),
        );

      case '/profile/new/signup':
        var context = routeSettings.arguments as BuildContext;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<UserProfileCubit>()),
              BlocProvider.value(value: context.read<UserAuthCubit>()),
            ],
            child: const SignupScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
