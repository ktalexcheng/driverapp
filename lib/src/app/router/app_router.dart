import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:trailbrake/src/app/cubit/cubit.dart';
import 'package:trailbrake/src/dashboard/dashboard.dart';
// import 'package:trailbrake/src/ride/ride.dart';
// import 'package:trailbrake/src/app/view/view.dart';

class AppRouter {
  // final AppNavigationCubit _appNavigationCubit = AppNavigationCubit();
  // final DashboardBloc _dashboardBloc = DashboardBloc();

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //     builder: (_) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider.value(
      //           value: _appNavigationCubit,
      //         ),
      //         BlocProvider.value(
      //           value: _rideHistoryBloc,
      //         ),
      //       ],
      //       child: const RideHistoryCatalog(),
      //     ),
      //   );

      // case '/dashboard/rideHistoryCatalog':
      //   return MaterialPageRoute(
      //     builder: (_) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider.value(
      //           value: _appNavigationCubit,
      //         ),
      //         BlocProvider.value(
      //           value: _rideHistoryBloc,
      //         ),
      //       ],
      //       child: const RideHistoryCatalog(),
      //     ),
      //   );

      case '/dashboard/rideDetails':
        var rideId = routeSettings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => DashboardBloc(),
            child: RideDetailsScreen(rideId: rideId),
          ),
        );

      // case '/startNewRide':
      //   return MaterialPageRoute(builder: (_) => const RideActivityHome());

      default:
        return null;
    }
  }
}
