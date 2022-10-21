import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trailbrake/src/ride/cubit/cubit.dart';
import 'package:trailbrake/src/common/common.dart';

class RideActivityStartButton extends StatelessWidget {
  const RideActivityStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<RideActivityCubit>().startRide();
      },
      child: const Text("Start ride!"),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
    );
  }
}

class RideActivityReadyScreen extends StatelessWidget {
  const RideActivityReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCanvas(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              color: Colors.grey,
              height: 40,
              child: const Text("Acquiring GPS..."),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Expanded(child: RideActivityStartButton()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
