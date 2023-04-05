import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/profile/cubit/cubit.dart';
import 'package:trailbrake/src/profile/view/view.dart';
import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileInitial ||
            state is UserProfileUnauthenticated) {
          return const LoginScreen();
        } else if (state is UserProfileGetInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserProfileGetSuccess) {
          return AppCanvas(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer),
                    constants.columnSpacer,
                    Text(state.user.username),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.read<UserAuthCubit>().logout();
                      },
                      child: const Text(constants.userLogout),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Scorecard(
                    title: constants.userScoreSectionTitle,
                    score: state.user.scores.overall,
                  ),
                ),
                const SectionTitle(
                    title: constants.userScoreProfileSectionTitle),
                ScoreProfile(scores: state.user.scores),
                Expanded(
                  child: Align(
                    child: Text(
                      constants.userScoreDefinition,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          );
        }
        // else if (state is UserProfileUnauthenticated) {
        //   return const Center(
        //     child: Text(constants.guestModeProfile),
        //   );
        // }
        else {
          return const Text(constants.invalidStateMessage);
        }
      },
    );
  }
}
