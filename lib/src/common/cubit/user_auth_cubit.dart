import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';

import 'package:trailbrake/src/common/common.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  UserAuthCubit() : super(UserAuthInitial());

  final AuthenticationRepository authRepository = AuthenticationRepository();

  void signInWithEmailPass(String email, Digest hashedPassword) async {
    emit(UserAuthLoginInProgress());

    // Perform authentication
    String? token = await authRepository.login(email, hashedPassword);

    if (token != null) {
      emit(UserAuthLoginSuccess());
    } else {
      emit(UserAuthLoginFailed());
    }
  }

  void createWithEmailPass(String email, Digest hashedPassword) async {
    emit(UserAuthCreateInProgress());

    // Create user profile
    String? token = await authRepository.create(email, hashedPassword);

    if (token != null) {
      emit(UserAuthCreateSuccess());
    } else {
      emit(UserAuthCreateFailed());
    }
  }

  void logout() async {
    emit(UserAuthLogoutInProgress());

    // Create user profile
    await authRepository.logout();

    emit(UserAuthLogoutSuccess());
  }
}
