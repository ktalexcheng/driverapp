import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/dashboard/bloc/bloc.dart';
import 'package:trailbrake/src/dashboard/view/widget/widget.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class DashboardMainScreen extends StatelessWidget {
  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCanvas(
      child: BlocListener<UserAuthCubit, UserAuthState>(
        listener: (context, state) {
          if (state is UserAuthLoginSuccess) {
            context.read<DashboardBloc>().add(DashboardCatalogRequested());
          }
        },
        child:
            // BlocProvider(
            //   create: (_) => DashboardBloc()..add(DashboardCatalogRequested()),
            //   child:
            BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardGetCatalogSuccess) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 100,
                    collapsedHeight: 75,
                    pinned: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    flexibleSpace: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: FlexibleSpaceBar(
                        titlePadding: const EdgeInsetsDirectional.only(
                            start: 0, bottom: 24),
                        title: Text(
                          constants.dashboardScreenTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SectionTitle(
                        title: constants.lifetimeMetricsSectionTitle),
                  ),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          LifetimeMetricCard(type: 'totalDistance'),
                          LifetimeMetricCard(type: 'totalRideTime'),
                          LifetimeMetricCard(type: 'maxAcceleration'),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: SectionTitle(
                          title: constants.rideCatalogSectionTitle),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return RidePreviewCard(
                        rideRecord: state.rideCatalog[index],
                      );
                    }, childCount: state.rideCatalog.length),
                  )
                ],
              );
            } else if (state is DashboardUnauthenticated) {
              return const Center(
                child: Text(constants.guestModeDashbaord),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        // ),
      ),
    );
  }
}
