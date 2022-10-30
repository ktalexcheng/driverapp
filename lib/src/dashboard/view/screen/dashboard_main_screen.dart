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
    return BlocProvider(
      create: (_) => DashboardBloc()..add(DashboardCatalogRequested()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardGetCatalogSuccess) {
            return AppCanvas(
              child: Column(
                children: [
                  const ScreenTitle(title: constants.dashboardScreenTitle),
                  const SectionTitle(
                      title: constants.lifetimeMetricsSectionTitle),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        LifetimeMetricCard(type: 'totalDistance'),
                        LifetimeMetricCard(type: 'totalDuration'),
                        LifetimeMetricCard(type: 'maxAcceleration'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 1,
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                TabBar(
                                  isScrollable: true,
                                  labelPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  tabs: [
                                    Tab(height: 30, text: "Best Rides"),
                                    Tab(height: 30, text: "All Rides"),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  const Text("NOT YET IMPLEMENTED"),
                                  RefreshIndicator(
                                    onRefresh: () async => context
                                        .read<DashboardBloc>()
                                        .add(DashboardCatalogRequested()),
                                    child: ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(), // To enable RefreshIndicator
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.rideCatalog.length,
                                      itemBuilder: (context, index) {
                                        return RidePreviewCard(
                                          rideRecord: state.rideCatalog[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
