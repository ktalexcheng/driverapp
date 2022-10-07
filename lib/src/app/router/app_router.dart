import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/history/history.dart';
import 'package:driverapp/src/app/cubit/cubit.dart';
import 'package:driverapp/src/app/view/view.dart';
import 'package:driverapp/src/ride/ride.dart';

class AppRouter {
  final AppNavigationCubit _appNavigationCubit = AppNavigationCubit();
  final RideHistoryBloc _rideHistoryBloc = RideHistoryBloc();

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _appNavigationCubit,
              ),
              BlocProvider.value(
                value: _rideHistoryBloc,
              ),
            ],
            child: const RideHistoryCatalog(),
          ),
        );

      case '/rideHistoryCatalog':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _appNavigationCubit,
              ),
              BlocProvider.value(
                value: _rideHistoryBloc,
              ),
            ],
            child: const RideHistoryCatalog(),
          ),
        );

      case '/rideHistoryDetail':
        var rideId = routeSettings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RideHistoryBloc(),
            child: RideHistoryResults(rideId: rideId),
          ),
        );

      case '/startNewRide':
        return MaterialPageRoute(builder: (_) => const RideActivityHome());

      default:
        return null;
    }
  }
}
