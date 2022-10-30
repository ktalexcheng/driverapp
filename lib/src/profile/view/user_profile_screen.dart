import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/profile/cubit/cubit.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileGetInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserProfileGetSuccess) {
          return AppCanvas(
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(backgroundColor: Colors.white),
                    constants.columnSpacer,
                    Text(state.user.username),
                  ],
                ),
                Scorecard(
                    title: "Driver score", score: state.user.scores.overall),
                const SectionTitle(title: "Score breakdown"),
                ScoreProfile(scores: state.user.scores),
              ],
            ),
          );
        } else {
          return const Text(constants.invalidStateMessage);
        }
      },
    );
  }
}
