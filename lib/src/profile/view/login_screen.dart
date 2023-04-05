import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto/crypto.dart';

import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;
import 'package:trailbrake/src/profile/cubit/user_profile_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailTextController = TextEditingController();
    final TextEditingController _passwordTextController =
        TextEditingController();

    return AppCanvas(
      child: BlocListener<UserAuthCubit, UserAuthState>(
        listener: (context, state) {
          if (state is UserAuthLoginFailed) {
            showDialogAndDismiss(
              context,
              constants.loginFailedDialogTitle,
              constants.loginFailedDialogMsg,
            );
          }
        },
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 40),
                const SizedBox(height: 80),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: constants.emailLabel,
                    isDense: true,
                  ),
                  controller: _emailTextController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                constants.rowSpacer,
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: constants.passwordLabel,
                    isDense: true,
                  ),
                  controller: _passwordTextController,
                  obscureText: true,
                ),
                constants.rowSpacer,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      var email = _emailTextController.text;
                      var bytes = utf8.encode(_passwordTextController.text);
                      var digest = sha256.convert(bytes);

                      context
                          .read<UserAuthCubit>()
                          .signInWithEmailPass(email, digest);
                    },
                    child: const Text(constants.loginLabel),
                  ),
                ),
                constants.rowSpacer,
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/profile/new/signup', arguments: context);
                    },
                    child: const Text(constants.signupLabel),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
