import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto/crypto.dart';

import 'package:trailbrake/src/common/common.dart';
import 'package:trailbrake/src/common/constants.dart' as constants;
import 'package:trailbrake/src/common/widget/busy_indicator.dart';
import 'package:trailbrake/src/profile/cubit/user_profile_cubit.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailTextController = TextEditingController();
    final TextEditingController _passwordTextController =
        TextEditingController();
    final TextEditingController _confirmPasswordTextController =
        TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: AppCanvas(
        child: BlocConsumer<UserAuthCubit, UserAuthState>(
          listener: (context, state) {
            if (state is UserAuthCreateInProgress) {
            } else if (state is UserAuthCreateSuccess) {
              context.read<UserProfileCubit>().getUserProfileData();
              Navigator.of(context).pop();
            } else if (state is UserAuthCreateFailed) {
              showDialogAndDismiss(
                context,
                constants.signUpFailedDialogTitle,
                constants.signUpFailedDialogMsg,
              );
            }
          },
          builder: (context, state) {
            if (state is UserAuthCreateInProgress) {
              return const BusyIndicator(
                  indicatorLabel: constants.creatingProfileLabel);
            } else {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: constants.confirmPasswordLabel,
                        isDense: true,
                      ),
                      controller: _confirmPasswordTextController,
                      obscureText: true,
                      validator: (value) {
                        if (value != null &&
                            value != _passwordTextController.text) {
                          return constants.mismatchedPasswordLabel;
                        } else {
                          return null;
                        }
                      },
                      onEditingComplete: () =>
                          _formKey.currentState!.validate(),
                    ),
                    constants.rowSpacer,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var email = _emailTextController.text;
                              var bytes =
                                  utf8.encode(_passwordTextController.text);
                              var digest = sha256.convert(bytes);

                              context
                                  .read<UserAuthCubit>()
                                  .createWithEmailPass(email, digest);
                            }
                          },
                          child: const Text(constants.createProfileLabel)),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
