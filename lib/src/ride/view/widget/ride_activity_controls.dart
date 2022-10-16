import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/view/view.dart';
import 'package:trailbrake/src/ride/cubit/cubit.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;

class RideActivityControls extends StatelessWidget {
  const RideActivityControls({super.key});

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: <Widget>[
    return BlocBuilder<RideActivityCubit, RideActivityState>(
      builder: (context, state) {
        // var controls
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: const Text("Start"),
              color: Colors.green,
              onPressed: () => context.read<RideActivityCubit>().startRide(),
            ),
            constants.columnSpacer,
            MaterialButton(
              child: const Text("Stop"),
              color: Colors.red,
              onPressed: () => context.read<RideActivityCubit>().stopRide(),
            ),
            constants.columnSpacer,
            MaterialButton(
              child: const Text("Reset"),
              color: Colors.blue,
              onPressed: () {
                context.read<RideActivityCubit>().resetRide();
                showDialog(
                  context: context,
                  // Note: Parent context is not shared with showDialog
                  // See: https://api.flutter.dev/flutter/material/showDialog.html
                  builder: (_) => const RideActivitySaveDialog(),
                ).then((ifSave) {
                  if (ifSave) {
                    showDialog(
                      context: context,
                      builder: (_) => const RideActivitySaveNamePrompt(),
                    ).then((rideName) {
                      context.read<RideActivityCubit>().saveRide(rideName);
                    });
                  } else {
                    context.read<RideActivityCubit>().discardRide();
                  }
                });
              },
            ),
          ],
        );
      },
    );
    //   ],
    // );
  }
}
